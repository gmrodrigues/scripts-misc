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

# ======= CONFIG =======
WORKER_ID="${1:-01}"
HOSTNAME_="k8s-wr-${WORKER_ID}"
IFACE="${IFACE:-enp1s0}"              # adjust if needed (env override)
GW="${GW:-192.168.15.1}"
DNS1="${DNS1:-1.1.1.1}"
DNS2="${DNS2:-8.8.8.8}"
K8S_MINOR="${K8S_MINOR:-v1.29}"
CONTROL_PLANE_IP="${CONTROL_PLANE_IP:-192.168.15.251}"
CONTROL_PLANE_HOSTNAME="${CONTROL_PLANE_HOSTNAME:-k8s-api.lab.local}"

# Optional static IP for worker:
# Example: export WORKER_IP=192.168.15.252 (or leave empty to keep DHCP)
WORKER_IP="${WORKER_IP:-}"

# Join command must be provided as env var JOIN_CMD
# Example:
#   export JOIN_CMD='kubeadm join k8s-api.lab.local:6443 --token ... --discovery-token-ca-cert-hash sha256:...'
JOIN_CMD="kubeadm join k8s-api.lab.local:6443 --token gwfktz.rqkn6gw4tgolxnob --discovery-token-ca-cert-hash sha256:ccce41445a6e8e34cad7af2fdb1d2b39e9f3d383b31d89fc880083e421e676b5"



echo "[0/8] Hostname check..."
hostnamectl set-hostname "$HOSTNAME_"

hostnamectl status || true

echo "[1/8] Ensuring control-plane hostname resolves on this node..."
grep -qE "^${CONTROL_PLANE_IP}\s+${CONTROL_PLANE_HOSTNAME}(\s|$)" /etc/hosts || \
  echo "${CONTROL_PLANE_IP} ${CONTROL_PLANE_HOSTNAME}" >> /etc/hosts

echo "[2/8] (Optional) Network config..."
if [ -n "${WORKER_IP}" ]; then
  echo "[2/8] Fixing static IP for worker: ${WORKER_IP}"
  rm -f /etc/netplan/*.yaml
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
  netplan apply
else
  echo "[2/8] Keeping DHCP (no static IP requested)."
fi

echo "[2/8] Validating basic connectivity..."
ip a | grep -q "${IFACE}"
ip route | grep -q "default"
ping -c 1 "${GW}" >/dev/null || true

echo "[3/8] Disabling cloud-init network management (avoid future surprises)..."
mkdir -p /etc/cloud/cloud.cfg.d
cat > /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg <<EOF
network: {config: disabled}
EOF
rm -f /etc/netplan/50-cloud-init.yaml || true

echo "[4/8] Disabling swap + kernel prereqs..."
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

echo "[5/8] Installing containerd..."
apt-get update
apt-get install -y containerd

mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

systemctl enable --now containerd
systemctl restart containerd

echo "[5/8] Validating containerd..."
containerd --version
grep -n "SystemdCgroup" /etc/containerd/config.toml | head -n 3

echo "[6/8] Installing kubeadm/kubelet/kubectl ${K8S_MINOR}..."
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

echo "[6/8] Validating kube tools..."
kubeadm version
kubelet --version
kubectl version --client

echo "[7/8] Joining the cluster..."
if [ -z "${JOIN_CMD}" ]; then
  echo "ERROR: JOIN_CMD env var is empty."
  echo "Provide it like:"
  echo "  JOIN_CMD='kubeadm join ${CONTROL_PLANE_HOSTNAME}:6443 --token ... --discovery-token-ca-cert-hash sha256:...' bash $0"
  exit 1
fi

# Safety: ensure join points to hostname (as intended)
echo "${JOIN_CMD}" | grep -q "${CONTROL_PLANE_HOSTNAME}:6443" || \
  echo "WARN: JOIN_CMD does not contain ${CONTROL_PLANE_HOSTNAME}:6443 (continuing anyway)."

# Execute join
bash -lc "${JOIN_CMD}"

echo "[8/8] Done. Worker joined."
