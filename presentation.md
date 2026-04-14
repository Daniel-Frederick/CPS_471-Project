# Presentation

## 1. Weak Account Passwords

CMD:
- `passwd -l user`
- `passwd -l postgres`
- `passwd -l sys`
- `passwd -l klog`
- `passwd -l service`

Verification:
- `cat /etc/shadow`

## 2. Firewall

CMD:
- `iptables -L`

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

## 1. vsftpd Backdoor

- `apt-get purge vsftpd`

Verification:
- `netstat -tlnp | grep 1524`

## 2. Samba Backdoor

- `apt-get purge samba`

Verification:
- `netstat -tlnp | grep -E "139|445"`

## 3. IRC Backdoor

- `apt-get purge unrealircd`
- `rm -rf /opt/Unreal3.2`

Verification:
- `netstat -tlnp | grep 6667`

## 4. distcc Exploit

- `apt-get purge distcc`

Verification:
- `netstat -tlnp | grep 3632`

## 5. MySQL Hardening

- `CREATE USER 'student'@'%' IDENTIFIED BY 'password';`

## 6. PHP CGI Exploit

- `apt-get install libapache2-mod-php5`

Verification:
- `netstat -tlnp`


