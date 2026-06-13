#!/bin/bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

PASS=0
FAIL=0
WARN=0

check_pass() { echo -e "  ${GREEN}✓${NC} $1"; PASS=$((PASS+1)); }
check_fail() { echo -e "  ${RED}✗${NC} $1"; FAIL=$((FAIL+1)); }
check_warn() { echo -e "  ${YELLOW}⚠${NC} $1"; WARN=$((WARN+1)); }

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONNECTOR="card1-HDMI-A-1"
EDID_INSTALLED="/lib/firmware/edid/monitor.bin"
EDID_LOCAL="$SCRIPT_DIR/edid.bin"
UKI_PATH="/boot/EFI/Linux/arch-linux.efi"

echo "=== Verificação do Fix EDID ==="
echo ""

echo "--- Kernel cmdline ---"
if grep -q 'drm.edid_firmware=HDMI-A-1:edid/monitor.bin' /proc/cmdline; then
    check_pass "Parâmetro drm.edid_firmware ativo no kernel"
else
    check_fail "Parâmetro drm.edid_firmware NÃO encontrado em /proc/cmdline"
fi

echo ""
echo "--- Arquivo EDID instalado ---"
if [ -f "$EDID_INSTALLED" ]; then
    size=$(stat -c%s "$EDID_INSTALLED")
    if [ "$size" = "256" ]; then
        check_pass "$EDID_INSTALLED existe (256 bytes)"
    else
        check_warn "$EDID_INSTALLED existe mas tem $size bytes (esperado 256)"
    fi
    header=$(hexdump -n 8 -e '8/1 "%02x "' "$EDID_INSTALLED" 2>/dev/null)
    if [ "$header" = "00 ff ff ff ff ff ff 00" ]; then
        check_pass "Header EDID válido"
    else
        check_fail "Header EDID inválido: $header"
    fi
else
    check_fail "$EDID_INSTALLED não encontrado"
fi

echo ""
echo "--- Resolução atual ---"
current_mode=$(cat "/sys/class/drm/$CONNECTOR/modes" 2>/dev/null | head -1)
if [ -n "$current_mode" ]; then
    width=$(echo "$current_mode" | cut -dx -f1)
    if [ "$width" -gt 640 ]; then
        check_pass "Resolução atual: $current_mode"
    else
        check_warn "Resolução baixa: $current_mode (pode indicar EDID não carregado)"
    fi
else
    check_fail "Não foi possível ler resolução do conector $CONNECTOR"
fi

echo ""
echo "--- Status do conector ---"
status=$(cat "/sys/class/drm/$CONNECTOR/status" 2>/dev/null || echo "not found")
if [ "$status" = "connected" ]; then
    check_pass "Conector $CONNECTOR: $status"
else
    check_warn "Conector $CONNECTOR: $status (pode estar desconectado)"
fi

echo ""
echo "--- mkinitcpio.conf ---"
if grep -qF "$EDID_INSTALLED" /etc/mkinitcpio.conf 2>/dev/null; then
    check_pass "EDID incluído no FILES do mkinitcpio.conf"
else
    check_warn "EDID NÃO está no FILES do mkinitcpio.conf (UKI pode não conter o firmware)"
fi

echo ""
echo "--- UKI ---"
if [ -f "$UKI_PATH" ]; then
    uki_size=$(stat -c%s "$UKI_PATH")
    uki_mtime=$(stat -c%Y "$UKI_PATH")
    uki_date=$(date -d "@$uki_mtime" '+%Y-%m-%d %H:%M')
    check_pass "UKI encontrada: $UKI_PATH ($(numfmt --to=iec "$uki_size"), $uki_date)"
    if strings "$UKI_PATH" 2>/dev/null | grep -q 'edid/monitor.bin'; then
        check_pass "UKI contém referência ao EDID"
    else
        check_warn "UKI pode não conter o EDID (não encontrado via strings)"
    fi
else
    check_warn "UKI não encontrada em $UKI_PATH"
fi

echo ""
echo "--- Consistência EDID ---"
if [ -f "$EDID_LOCAL" ] && [ -f "$EDID_INSTALLED" ]; then
    if cmp -s "$EDID_LOCAL" "$EDID_INSTALLED"; then
        check_pass "EDID local e instalado são idênticos"
    else
        check_warn "EDID local e instalado DIFEREM (edid.bin local pode estar desatualizado)"
    fi
elif [ -f "$EDID_INSTALLED" ]; then
    check_warn "EDID local ($EDID_LOCAL) não encontrado para comparação"
fi

echo ""
echo "--- Cmdline config vs running ---"
if [ -f /etc/kernel/cmdline ]; then
    if grep -q 'drm.edid_firmware' /etc/kernel/cmdline; then
        check_pass "Parâmetro presente em /etc/kernel/cmdline"
    else
        check_warn "Parâmetro NÃO está em /etc/kernel/cmdline (não sobrevive a rebuild da UKI)"
    fi
else
    check_warn "/etc/kernel/cmdline não encontrado"
fi

echo ""
echo "=== Resumo ==="
echo "  Passou: $PASS | Falhou: $FAIL | Alertas: $WARN"
if [ "$FAIL" -gt 0 ]; then
    echo "  Status: ❌ TESTES CRÍTICOS FALHARAM"
    exit 1
elif [ "$WARN" -gt 0 ]; then
    echo "  Status: ⚠️  FUNCIONANDO COM RESSALVAS"
    exit 0
else
    echo "  Status: ✅ TUDO OK"
    exit 0
fi
