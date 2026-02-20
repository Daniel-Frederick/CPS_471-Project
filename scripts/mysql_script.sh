#!/usr/bin/expect -f
set timeout 30
spawn mysql -u student -p -h 172.16.30.60
expect "password:"
send "student\r"
expect "mysql>"
send "show databases;\r"
expect "mysql>"
send "use tikiwiki;\r"
expect "mysql>"
send "show tables;\r"
expect "mysql>"
send "exit\r"
expect eof
