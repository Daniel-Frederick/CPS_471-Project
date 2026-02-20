#!/usr/bin/expect -f
set timeout -1
spawn $env(SHELL)
match_max 100000
send "rlogin -l msfadmin 172.16.30.60\r"
expect "*Password:"
send "msfadmin\r"
expect "\$ "
send "uname -a\r"
sleep 1
expect "\$ "
send "exit\r"

