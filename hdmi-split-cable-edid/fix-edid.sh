#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOCAL_EDID="$SCRIPT_DIR/edid.bin"
EDID_SRC_CONNECTOR="/sys/class/drm/card1-HDMI-A-1/edid"
EDID_DST="/lib/firmware/edid/monitor.bin"
CMDLINE_FILE="/etc/kernel/cmdline"
MKINITCPIO_CONF="/etc/mkinitcpio.conf"

echo "=== Origem do EDID ==="
if [ -f "$LOCAL_EDID" ]; then
    EDID_SRC="$LOCAL_EDID"
    echo "Usando EDID local: $LOCAL_EDID ($(wc -c < "$LOCAL_EDID") bytes)"
else
    if [ ! -r "$EDID_SRC_CONNECTOR" ]; then
        echo "ERRO: $EDID_SRC_CONNECTOR não encontrado ou sem permissão" >&2
        echo "Conecte o monitor ou copie um edid.bin para $SCRIPT_DIR" >&2
        exit 1
    fi
    EDID_SRC="$EDID_SRC_CONNECTOR"
    echo "Capturando EDID do conector: $EDID_SRC_CONNECTOR"
    sudo cp "$EDID_SRC" "$LOCAL_EDID"
    sudo chown "$USER:$USER" "$LOCAL_EDID"
    echo "Cópia local salva em $LOCAL_EDID ($(wc -c < "$EDID_SRC") bytes)"
fi

echo ""
echo "=== Instalando EDID no sistema ==="
sudo mkdir -p "$(dirname "$EDID_DST")"
sudo cp "$EDID_SRC" "$EDID_DST"
echo "EDID salvo em $EDID_DST ($(wc -c < "$EDID_SRC") bytes)"

echo ""
echo "=== Verificando parâmetro no kernel cmdline ==="
if grep -q 'drm.edid_firmware' "$CMDLINE_FILE"; then
    echo "Parâmetro drm.edid_firmware já presente"
else
    echo "Adicionando drm.edid_firmware=HDMI-A-1:edid/monitor.bin"
    sudo sed -i "s/$/ drm.edid_firmware=HDMI-A-1:edid\/monitor.bin/" "$CMDLINE_FILE"
fi

echo ""
echo "=== Garantindo EDID no mkinitcpio.conf ==="
if grep -q "$EDID_DST" "$MKINITCPIO_CONF"; then
    echo "EDID já incluído no FILES"
elif grep -q '^FILES=()$' "$MKINITCPIO_CONF"; then
    echo "Adicionando EDID ao FILES em $MKINITCPIO_CONF"
    sudo sed -i 's|^FILES=()$|FILES=(/lib/firmware/edid/monitor.bin)|' "$MKINITCPIO_CONF"
else
    echo "AVISO: FILES já possui conteúdo. Adicione manualmente:" >&2
    echo "  /lib/firmware/edid/monitor.bin" >&2
fi

echo ""
echo "=== Conteúdo do ${CMDLINE_FILE} ==="
cat "$CMDLINE_FILE"

echo ""
echo "=== Reconstruindo UKI com mkinitcpio ==="
sudo mkinitcpio -p linux

echo ""
echo "=== Script concluído! Reinicie o sistema ==="
echo "Comando: sudo reboot"
