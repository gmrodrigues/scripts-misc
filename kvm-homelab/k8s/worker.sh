#!/bin/bash
# Worker node bootstrap for kubeadm (root-only, no editor)
# Compatible with CP script using control-plane-endpoint hostname.

# k8s-wr-01 k8s-wr-02
# /opt/img/noble-base.img
# 40GB disco, 4GB RAM, 2 CPUs
#
# Public Key
# ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILwNn4IjgiDDp1BMFXZ+s+t1PwEroXdT5Ri3/9LZeRXV glaubermrodrigues@gmail.com


set -xeuo pipefail

WORKER_ID="${1:-01}"
HOSTNAME_="k8s-wr-${WORKER_ID}"

IFACE="${IFACE:-enp1s0}"
GW="${GW:-192.168.15.1}"
DNS1="${DNS1:-1.1.1.1}"
DNS2="${DNS2:-8.8.8.8}"
K8S_MINOR="${K8S_MINOR:-v1.29}"

CONTROL_PLANE_IP="${CONTROL_PLANE_IP:-192.168.15.251}"
CONTROL_PLANE_HOSTNAME="${CONTROL_PLANE_HOSTNAME:-k8s-api.lab.local}"

# Se quiser fixar IP do worker:
# export WORKER_IP=192.168.15.252
WORKER_IP="${WORKER_IP:-}"

# JOIN_CMD você pode setar por env ou hardcode
JOIN_CMD="${JOIN_CMD:-kubeadm join k8s-api.lab.local:6443 --token gwfktz.rqkn6gw4tgolxnob --discovery-token-ca-cert-hash sha256:ccce41445a6e8e34cad7af2fdb1d2b39e9f3d383b31d89fc880083e421e676b5}"

echo "[0/9] Hostname..."
hostnamectl set-hostname "$HOSTNAME_"
hostname

echo "[1/9] Cloud-init: disable network config..."
mkdir -p /etc/cloud/cloud.cfg.d
cat > /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg <<EOF
network: {config: disabled}
EOF

echo "[2/9] Netplan: ensure a config exists (DHCP or static)..."
rm -f /etc/netplan/*.yaml

if [ -n "${WORKER_IP}" ]; then
  cat > /etc/netplan/01-static.yaml <<EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    ${IFACE}:
      dhcp4: no
      addresses:
        - ${WORKER_IP}/24
      routes:
        - to: default
          via: ${GW}
      nameservers:
        addresses:
          - ${DNS1}
          - ${DNS2}
EOF
else
  cat > /etc/netplan/01-dhcp.yaml <<EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    ${IFACE}:
      dhcp4: true
EOF
fi

netplan apply

echo "[2/9] Validate NIC + route..."
ip a | grep -q "${IFACE}"
ip route | grep -q "default" || true
ping -c 1 "${GW}" || true

echo "[3/9] /etc/hosts: control-plane name..."
grep -qE "^${CONTROL_PLANE_IP}\s+${CONTROL_PLANE_HOSTNAME}(\s|$)" /etc/hosts || \
  echo "${CONTROL_PLANE_IP} ${CONTROL_PLANE_HOSTNAME}" >> /etc/hosts

echo "[4/9] Swap + kernel prereqs..."
swapoff -a || true
sed -i '/\sswap\s/s/^/#/' /etc/fstab || true

cat > /etc/modules-load.d/k8s.conf <<EOF
overlay
br_netfilter
EOF
modprobe overlay
modprobe br_netfilter

cat > /etc/sysctl.d/k8s.conf <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
sysctl --system >/dev/null

echo "[5/9] Containerd..."
apt-get update
apt-get install -y containerd
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
systemctl enable --now containerd
systemctl restart containerd
containerd --version

echo "[6/9] Kubernetes packages ${K8S_MINOR}..."
apt-get install -y apt-transport-https ca-certificates curl gpg
mkdir -p /etc/apt/keyrings
curl -fsSL "https://pkgs.k8s.io/core:/stable:/${K8S_MINOR}/deb/Release.key" \
  | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

cat > /etc/apt/sources.list.d/kubernetes.list <<EOF
deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${K8S_MINOR}/deb/ /
EOF

apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
kubeadm version

echo "[7/9] Join..."
echo "${JOIN_CMD}" | grep -q "${CONTROL_PLANE_HOSTNAME}:6443" || \
  echo "WARN: JOIN_CMD not pointing to ${CONTROL_PLANE_HOSTNAME}:6443"

bash -lc "${JOIN_CMD}"

echo "[8/9] Done."
