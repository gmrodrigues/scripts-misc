#!/bin/bash
# O Pritunl empurra uma rota host pro 8.8.8.8 (e outros IPs de infra dele)
# passando pelo tun0. Pra maioria dos casos isso e inofensivo, mas o 8.8.8.8
# e um DNS publico e nao precisa ir pelo tunel da empresa.
#
# Esse script remove a(s) rota(s) de 8.8.8.8 que passam por tun*/tap*,
# deixando o trafego cair na rota local que ja existia antes da VPN subir
# (rota do DHCP/gateway, ou a rota default). Nao usa "ip route replace":
# jah tentamos isso e o kernel deixou rotas duplicadas/conflitantes pro
# mesmo destino (uma via tun0 e outra via wlan0 com a mesma metrica),
# o que so piora a ambiguidade. Deletar a rota da VPN e suficiente.
#
# Rode DEPOIS de conectar a VPN. Precisa de sudo (altera tabela de rotas).
#
# Uso:
#   ./fix-8888-route.sh            # remove a(s) rota(s) de 8.8.8.8 via tun/tap
#   ./fix-8888-route.sh --revert   # restaura a(s) rota(s) removidas (se houver)

set -uo pipefail

TARGET="8.8.8.8"
STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/pritunl-8888-route.saved"

BEFORE=$(mktemp)
AFTER=$(mktemp)
trap 'rm -f "$BEFORE" "$AFTER"' EXIT

ip route show table all > "$BEFORE"

show_diff() {
    ip route show table all > "$AFTER"
    echo
    echo "=== O que mudou na tabela de rotas (antes -> depois) ==="
    if diff -u --label "antes" --label "depois" "$BEFORE" "$AFTER" | grep -qE '^[+-][^+-]'; then
        diff -u --label "antes" --label "depois" "$BEFORE" "$AFTER" || true
    else
        echo "(nenhuma mudanca na tabela de rotas)"
    fi
}

if [[ "${1:-}" == "--revert" ]]; then
    if [[ ! -s "$STATE_FILE" ]]; then
        echo "Nao ha rota salva pra restaurar (rode o script sem --revert primeiro)."
        exit 0
    fi
    echo "Restaurando rota(s) removida(s) anteriormente:"
    while IFS= read -r ROUTE_LINE; do
        [[ -z "$ROUTE_LINE" ]] && continue
        echo "  + $ROUTE_LINE"
        sudo ip route add $ROUTE_LINE
    done < "$STATE_FILE"
    rm -f "$STATE_FILE"
    show_diff
    echo
    echo "Rota atual para $TARGET:"
    ip route get "$TARGET"
    exit 0
fi

# pega todas as rotas de $TARGET que passam por tun*/tap* (a(s) empurrada(s) pelo Pritunl)
mapfile -t TUN_ROUTES < <(ip route show "$TARGET" 2>/dev/null | grep -E 'dev (tun|tap)[0-9]*')

if [[ ${#TUN_ROUTES[@]} -eq 0 ]]; then
    echo "Nenhuma rota de $TARGET passando por tun/tap. Nada a fazer."
    echo
    echo "Rota atual para $TARGET:"
    ip route get "$TARGET"
    exit 0
fi

echo "Removendo rota(s) de $TARGET que passam pelo tunel:"
: > "$STATE_FILE"
for ROUTE_LINE in "${TUN_ROUTES[@]}"; do
    echo "  - $ROUTE_LINE"
    echo "$ROUTE_LINE" >> "$STATE_FILE"
    sudo ip route del $ROUTE_LINE
done

show_diff

echo
echo "Rota atual para $TARGET:"
ip route get "$TARGET"
