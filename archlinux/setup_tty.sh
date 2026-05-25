#!/bin/bash

# Aborta o script se qualquer comando falhar
set -e

# Verificação de segurança: Não rodar como root
if [ "$EUID" -eq 0 ]; then
  echo "⚠️ ERRO: Não execute este script como root."
  echo "Execute com o seu usuário normal. O script chamará o 'sudo' quando necessário."
  exit 1
fi

echo "🚀 Iniciando configuração do ambiente TTY..."

# 1. Atualização do sistema e dependências de compilação
echo "📦 Instalando dependências base (git, base-devel)..."
sudo pacman -Syu --needed git base-devel --noconfirm

# 2. Instalação do Yay (AUR Helper)
if ! command -v yay &> /dev/null; then
    echo "🏗️ Compilando e instalando o yay..."
    # Usa um diretório temporário para não sujar a home
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
else
    echo "✅ yay já está instalado. Pulando etapa."
fi

# 3. Dependências específicas do KMSCON (identificadas anteriormente)
echo "🧩 Instalando dependências do kmscon (seatd, check)..."
sudo pacman -S --needed seatd check --noconfirm

# 4. Instalação do KMSCON e Carbonyl via AUR
# Usamos o carbonyl-bin para evitar a compilação do motor do Chromium do zero, o que levaria horas.
echo "🌐 Instalando kmscon-git e carbonyl via AUR..."
yay -S --needed kmscon-git carbonyl-bin --noconfirm

# 5. Suporte a Mouse no TTY (GPM)
# O GPM (General Purpose Mouse) é o daemon que desenha e gerencia o cursor do mouse no console puro.
echo "🖱️ Instalando e ativando o suporte a mouse (GPM)..."
sudo pacman -S --needed gpm --noconfirm
sudo systemctl enable --now gpm.service

# 6. Configuração do systemd para o KMSCON
echo "⚙️ Substituindo o getty padrão pelo kmscon no TTY1..."
sudo systemctl disable getty@tty1.service
sudo systemctl enable kmsconvt@tty1.service

echo "=========================================================="
echo "🎉 Instalação concluída com sucesso!"
echo ""
echo "O que acontece agora:"
echo "1. O mouse já deve estar funcional no seu TTY atual."
echo "2. Na próxima vez que reiniciar, o TTY1 usará o kmscon como mestre de vídeo."
echo "3. Para testar a navegação web gráfica, digite: carbonyl https://google.com"
echo "=========================================================="

sudo ln -sf /usr/lib/systemd/system/kmsconvt@.service /etc/systemd/system/autovt@.service
sudo systemctl disable getty@.service
sudo systemctl daemon-reload
