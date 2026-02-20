#!/usr/bin/expect -f
set timeout -1
spawn $env(SHELL)
match_max 100000

send "mysql -u script_user -p -h 172.16.30.60\r"

expect "*password:"
send "student\r" 

expect "MySQL*"
send "show databases;\r"

expect "MySQL*"
send "use tikiwiki;\r"

expect "MySQL*"
send "show tables;\r"

expect "MySQL*"
send "exit;\r"

expect eof
