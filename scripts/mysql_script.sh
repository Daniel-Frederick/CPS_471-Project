#!/usr/bin/expect -f
set timeout -1
spawn $env(SHELL)
match_max 100000
send "mysql -u root -p -h 172.16.30.60 --ssl-mode=DISABLED\r"
expect "*password:"
send "\r" 
expect "MySQL*"
send "show databases;\r"
sleep 1
expect "MySQL*"
send "use tikiwiki;\r"
expect "MySQL*"
send "show tables;\r"
sleep 1
expect "MySQL*"
send "exit;\r"

