#!/usr/bin/expect -f
set timeout 30
spawn mysql -u student -p -h 172.16.30.60 --ssl=0
expect "password:"
send "student\r"
expect "MySQL*>"
send "show databases;\r"
expect "MySQL*>"
send "use tikiwiki;\r"
expect "MySQL*>"
send "show tables;\r"
expect "MySQL*>"
send "exit\r"
expect eof
