#!/usr/bin/expect -f
#
set timeout -1
spawn $env(SHELL)
match max 100000
send "rlogin -1 msfadmin REPLACE-W/METASPLOITABLE-IMAGE-IP-ADDRESS \r"
expect "*password:"
send "msfadmin\r"
expect "\$ "
send "uname -a\r"
sleep 1
expect "\$ "
send "exit\r"

