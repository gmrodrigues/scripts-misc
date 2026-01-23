## 📌 CONTEXTO RESUMIDO – LAB KVM + KUBERNETES + GITOPS

### Host

* **Ubuntu Server** (sem X11), rodando **KVM/libvirt**
* Bridge de rede configurada (`br0`) → VMs recebem IP da LAN (192.168.15.0/24)
* Gerenciamento via **Cockpit + cockpit-machines**
* Acesso majoritariamente por **SSH**

---

### Base de VMs

* Uso de **Ubuntu Cloud Image (24.04 Noble)**:

  * `noble-server-cloudimg-amd64.img`
* VM criada via **virt-install --import**
* Disco:

  * `noble-base.img` como backing
  * `ubuntu-base.qcow2` como overlay
* Cloud-init via **NoCloud (seed.iso)**:

  * Usuário criado (`glauber`)
  * SSH habilitado
  * qemu-guest-agent habilitado
* Rede: virtio + bridge
* VM funcional, IP obtido corretamente
* Acesso confirmado via `qemu-agent-command`
* SSH inicialmente falhou por chave → resolvido via cloud-init / authorized_keys

---

### Automação

* Scripts criados:

  * download da cloud image
  * criação de overlay qcow2
  * criação da VM via `virt-install --import`
* Tentativa de script para **injeção de chave via qemu-guest-agent** (guest-exec), ainda em ajuste

---

### Interface Web

* Cockpit Machines usado com sucesso
* Console serial funcional
* Gestão básica (start/stop, console, recursos)

---

## 🎯 OBJETIVO DO LAB

Criar um **lab Kubernetes completo**, com foco em:

* **GitOps**
* **Terraform**
* **ArgoCD**
* Simular **serviços de cloud** localmente

---

## 🧠 DECISÕES ARQUITETURAIS

### Kubernetes

* **kubeadm (vanilla)** em VMs (não k3s / kind)
* CNI: **Calico**
* LoadBalancer local: **MetalLB (L2)**
* Ingress: **NGINX Ingress Controller**

### GitOps / IaC

* **ArgoCD** como centro do GitOps
* Terraform:

  * Inicialmente rodando fora (CI / Atlantis)
  * Possível evolução para **Crossplane** (cloud-like real)

---

### Serviços “cloud-like” planejados

* **MinIO** → S3-like
* **Keycloak** → IAM / OIDC
* **Vault** ou External Secrets → Secrets/KMS
* **Observabilidade**:

  * Prometheus
  * Grafana
  * (opcional) Loki

---

### Topologia sugerida

* 1 control-plane
* 2 workers
* (opcional) 1 VM infra
* IPs via **DHCP reservado** ou **static via cloud-init** (decisão pendente)

---

## 🔜 PRÓXIMO PASSO NO NOVO PROMPT

Definir:

* Estratégia de IP (DHCP reservado vs static)
* Cloud-init padrão dos nós Kubernetes
* Ordem exata:

  1. kubeadm
  2. Calico
  3. MetalLB
  4. Ingress
  5. ArgoCD

---

Se quiser, no próximo prompt você pode começar assim:

> “Quero montar do zero um lab Kubernetes em KVM no Ubuntu Server, usando cloud-init, kubeadm, Calico, MetalLB e ArgoCD, com foco em GitOps e simulação de cloud.”

E a gente segue limpo, direto e sem ruído 😄