#!/usr/bin/expect -f
# https://hadler.me/files/forticlient-sslvpn_4.4.2333-1_amd64.deb

set SRV	[lindex $argv 0] # server
set PRT	[lindex $argv 1] # port
set USR	[lindex $argv 2] # user
set SEC	[lindex $argv 3] # password

set timeout -1

spawn /opt/forticlient-sslvpn/64bit/forticlientsslvpn_cli --server "$SRV:$PRT" --vpnuser "$USR" --keepalive

expect "Password for VPN"

send -- "$SEC\r"

expect "(Y/N)"

send -- "Y\r"

expect eof
