#!/usr/bin/expect -f
#
set timeout -1
spawn $env(SHELL)
match max 100000
# CHANGE THE SCRIPT AS SHOWN BELOW
send "mysql -u REPLACE-THIS-WITH-VALID-MYSQL-USERNAME -p -h REPLACE-W/METASPLOITABLE-IMAGE-IP-ADDRESS \r"
expect "*password:"
send "REPLACE-THIS-WITH-USERNAME'S-PASSWORD\r"
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

