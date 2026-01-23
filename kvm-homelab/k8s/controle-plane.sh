#!/bin/bash

### Control Plane

# k8s-cp-01
# /opt/img/noble-base.img
# 40GB disco, 4GB RAM, 2 CPUs
#
# Public Key
# ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILwNn4IjgiDDp1BMFXZ+s+t1PwEroXdT5Ri3/9LZeRXV glaubermrodrigues@gmail.com

set -xeuo pipefail

# ======= CONFIG =======
IFACE="enp1s0"
IP="192.168.15.251"
GW="192.168.15.1"
DNS1="1.1.1.1"
DNS2="8.8.8.8"
POD_CIDR="192.168.0.0/16"
K8S_MINOR="v1.29"
CALICO_VER="v3.27.0"

# (Opcional) Se quiser join por hostname:
# Defina um nome e garanta resolução em TODOS os nós (hosts/VMs) via /etc/hosts ou DNS.
CONTROL_PLANE_HOSTNAME="k8s-api.lab.local"
CONTROL_PLANE_ENDPOINT="$CONTROL_PLANE_HOSTNAME:6443"
USE_ENDPOINT_HOSTNAME="true"  # mude para "true" se você for usar control-plane-endpoint por hostname

echo "$IP $CONTROL_PLANE_HOSTNAME" >> /etc/hosts

hostnamectl set-hostname k8s-cp-01


echo "[1/9] Fixando IP no netplan..."
rm -f /etc/netplan/*.yaml
cat > /etc/netplan/01-static.yaml <<EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    ${IFACE}:
      dhcp4: no
      addresses:
        - ${IP}/24
      routes:
        - to: default
          via: ${GW}
      nameservers:
        addresses:
          - ${DNS1}
          - ${DNS2}
EOF

netplan apply

echo "[1/9] Validando IP e rota..."
ip -4 a show dev "${IFACE}" | grep -q "${IP}/24"
ip route | grep -q "default via ${GW}"
ping -c 1 "${GW}" >/dev/null

echo "[2/9] Desabilitando cloud-init para rede (evitar que volte DHCP)..."
mkdir -p /etc/cloud/cloud.cfg.d
cat > /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg <<EOF
network: {config: disabled}
EOF
rm -f /etc/netplan/50-cloud-init.yaml || true

echo "[3/9] Desabilitando swap e aplicando ajustes de kernel..."
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

echo "[4/9] Instalando containerd..."
apt-get update
apt-get install -y containerd

mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

systemctl enable --now containerd
systemctl restart containerd

echo "[4/9] Validando containerd..."
containerd --version
grep -n "SystemdCgroup" /etc/containerd/config.toml | head -n 3

echo "[5/9] Instalando kubeadm/kubelet/kubectl ${K8S_MINOR}..."
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

echo "[5/9] Validando Kubernetes tools..."
kubeadm version
kubelet --version
kubectl version --client

echo "[6/9] kubeadm init (control-plane)..."
if [ "${USE_ENDPOINT_HOSTNAME}" = "true" ]; then
  echo "[6/9] Usando controlPlaneEndpoint por hostname: ${CONTROL_PLANE_ENDPOINT}"
  # GARANTA que k8s-api.lab.local resolve para ${IP} em todos os nós (ex: /etc/hosts)
  kubeadm init \
    --control-plane-endpoint "${CONTROL_PLANE_ENDPOINT}" \
    --apiserver-advertise-address "${IP}" \
    --pod-network-cidr "${POD_CIDR}" \
    --cri-socket=unix:///run/containerd/containerd.sock
else
  kubeadm init \
    --apiserver-advertise-address "${IP}" \
    --pod-network-cidr "${POD_CIDR}" \
    --cri-socket=unix:///run/containerd/containerd.sock
fi

echo "[7/9] Configurando KUBECONFIG para root..."
export KUBECONFIG=/etc/kubernetes/admin.conf
grep -q 'export KUBECONFIG=/etc/kubernetes/admin.conf' /root/.bashrc || \
  echo 'export KUBECONFIG=/etc/kubernetes/admin.conf' >> /root/.bashrc

echo "[7/9] Teste: nó deve estar NotReady (CNI ainda não aplicado)..."
kubectl get nodes -o wide

echo "[8/9] Instalando Calico (${CALICO_VER})..."
kubectl apply -f "https://raw.githubusercontent.com/projectcalico/calico/${CALICO_VER}/manifests/calico.yaml"

echo "[8/9] Aguardando pods kube-system subirem (Ctrl+C para sair quando quiser)..."
kubectl get pods -n kube-system -w || true

echo "[9/9] Teste final: nodes..."
kubectl get nodes -o wide

echo
echo "✅ Control-plane pronto."
echo "➡️ Join command para os workers:"
kubeadm token create --print-join-command
