#!/bin/bash
# Diagnostico de rede para rodar logo apos conectar a VPN do Pritunl,
# quando a conexao "derruba" o acesso a internet.
#
# Uso:
#   ./diag-pritunl-network.sh              # mostra na tela
#   ./diag-pritunl-network.sh --save       # tambem salva em arquivo .log no diretorio atual
#
# Dica: rode uma vez ANTES de ligar a VPN (--save) e outra vez DEPOIS,
# depois compare os dois arquivos com `diff` pra ver exatamente o que mudou.

set -uo pipefail

SAVE=0
[[ "${1:-}" == "--save" ]] && SAVE=1

if [[ $SAVE -eq 1 ]]; then
    OUT="pritunl-diag_$(date +%Y%m%d_%H%M%S).log"
    exec > >(tee "$OUT") 2>&1
    echo "# Salvando saida em: $OUT"
fi

hr() { printf '\n=== %s ===\n' "$1"; }

run() {
    # roda um comando mostrando o que foi executado; nao aborta o script se falhar
    printf '\n$ %s\n' "$*"
    if ! "$@" 2>&1; then
        echo "(comando falhou ou nao disponivel: $*)"
    fi
}

have() { command -v "$1" >/dev/null 2>&1; }

echo "Diagnostico de rede - $(date)"
echo "Host: $(cat /proc/sys/kernel/hostname 2>/dev/null || hostnamectl hostname 2>/dev/null)"

hr "Interfaces de rede"
if have ip; then
    run ip -br link
    run ip -br addr
else
    run ifconfig -a
fi

hr "Processo do cliente Pritunl"
run pgrep -a -f pritunl

hr "Rotas (tabela principal)"
run ip route show

hr "Todas as tabelas de rota (default, main, local, tun, etc.)"
run ip route show table all

hr "Regras de roteamento (ip rule)"
run ip rule show

hr "Gateway padrao"
GW=$(ip route show default 2>/dev/null | awk '/default/ {print $3; exit}')
echo "Gateway padrao detectado: ${GW:-<nenhum>}"

hr "Interface(s) tun/tap (VPN)"
run bash -c "ip -br addr | grep -E 'tun|tap' || echo '(nenhuma interface tun/tap encontrada)'"

hr "Resolucao de DNS"
run cat /etc/resolv.conf
if have resolvectl; then
    run resolvectl status
elif have systemd-resolve; then
    run systemd-resolve --status
fi
if have nmcli; then
    run nmcli device show
fi

hr "Teste de conectividade - ping por IP (sem depender de DNS)"
run ping -c 3 -W 2 1.1.1.1
run ping -c 3 -W 2 8.8.8.8
if [[ -n "${GW:-}" ]]; then
    echo
    echo "-- ping no gateway padrao ($GW) --"
    run ping -c 3 -W 2 "$GW"
fi

hr "Teste de resolucao de DNS (nome -> IP)"
if have dig; then
    run dig +time=2 +tries=1 google.com
elif have nslookup; then
    run nslookup google.com
else
    run getent hosts google.com
fi

hr "Teste HTTP/HTTPS de fato"
if have curl; then
    run curl -sS -o /dev/null -w 'HTTP %{http_code} em %{time_total}s\n' --max-time 5 https://www.google.com
else
    run wget -q --timeout=5 -O /dev/null https://www.google.com && echo OK
fi

hr "Traceroute ate 1.1.1.1 (mostra por onde o trafego esta saindo)"
if have traceroute; then
    run traceroute -n -w 1 -m 15 1.1.1.1
elif have tracepath; then
    run tracepath -n 1.1.1.1
fi

hr "MTU das interfaces (VPN com MTU errado costuma travar HTTPS)"
run bash -c "ip -br link | awk '{print \$1}' | while read -r i; do ip link show \"\$i\" | grep -o 'mtu [0-9]*'; done"

hr "Regras de firewall (pode exigir sudo)"
if have nft; then
    run sudo -n nft list ruleset
elif have iptables; then
    run sudo -n iptables -L -n -v
fi

hr "Fim do diagnostico"
if [[ $SAVE -eq 1 ]]; then
    echo "Log salvo em: $OUT"
fi
