#!/bin/bash
#
# Metasploitable Security Hardening Script
# Removes services vulnerable to exploitation
# Run as root on the Metasploitable server

echo "================================================"
echo " Metasploitable Security Hardening Script"
echo "================================================"
echo ""

# ------------------------------------------------
# 1. VSFTPD - Backdoor vulnerability (port 21/6200)
# ------------------------------------------------
echo "[*] Removing vsftpd..."
/etc/init.d/vsftpd stop 2>/dev/null
update-rc.d vsftpd disable 2>/dev/null
apt-get remove -y vsftpd 2>/dev/null
apt-get purge -y vsftpd 2>/dev/null
echo "[+] vsftpd removed."
echo ""

# ------------------------------------------------
# 2. SAMBA - Backdoor vulnerability (port 139/445)
# ------------------------------------------------
echo "[*] Removing Samba..."
/etc/init.d/samba stop 2>/dev/null
update-rc.d samba disable 2>/dev/null
apt-get remove -y samba 2>/dev/null
apt-get purge -y samba 2>/dev/null
echo "[+] Samba removed."
echo ""

# ------------------------------------------------
# 3. UnrealIRCd - Backdoor vulnerability (port 6667)
# ------------------------------------------------
echo "[*] Removing UnrealIRCd..."
/etc/init.d/unrealircd stop 2>/dev/null
apt-get remove -y unrealircd 2>/dev/null
apt-get purge -y unrealircd 2>/dev/null
# Also remove manual installation
if [ -d "/opt/Unreal3.2" ]; then
  rm -rf /opt/Unreal3.2
  echo "[+] Removed /opt/Unreal3.2"
fi
echo "[+] UnrealIRCd removed."
echo ""

# ------------------------------------------------
# 4. distcc - Remote code execution (port 3632)
# ------------------------------------------------
echo "[*] Removing distcc..."
/etc/init.d/distcc stop 2>/dev/null
update-rc.d distcc disable 2>/dev/null
apt-get remove -y distcc 2>/dev/null
apt-get purge -y distcc 2>/dev/null
echo "[+] distcc removed."
echo ""

# ------------------------------------------------
# 5. MySQL - Secure root account (no blank password)
# ------------------------------------------------
echo "[*] Securing MySQL root account..."
# Set a strong password for root to prevent blank password exploit
mysqladmin -u root password 'SecureR00t!Pass' 2>/dev/null
# Alternatively, restrict root to localhost only
mysql -u root -e "DELETE FROM mysql.user WHERE User='root' AND Host!='localhost';" 2>/dev/null
mysql -u root -e "DELETE FROM mysql.user WHERE User='';" 2>/dev/null
mysql -u root -e "FLUSH PRIVILEGES;" 2>/dev/null
echo "[+] MySQL root account secured."
echo ""

# ------------------------------------------------
# 6. PHP CGI - Argument injection vulnerability
# ------------------------------------------------
echo "[*] Mitigating PHP CGI arg injection..."
# Disable PHP CGI if not needed (Apache mod_php is safer)
a2disconf php* 2>/dev/null
# Fix php.ini to disable cgi.fix_pathinfo
if [ -f /etc/php5/cgi/php.ini ]; then
  sed -i 's/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php5/cgi/php.ini
  echo "[+] Set cgi.fix_pathinfo=0 in php.ini"
fi
# Disable CGI handler in Apache
if [ -f /etc/apache2/conf.d/php5.conf ]; then
  sed -i 's/^AddHandler/#AddHandler/' /etc/apache2/conf.d/php5.conf
fi
/etc/init.d/apache2 restart 2>/dev/null
echo "[+] PHP CGI arg injection mitigated."
echo ""

# ------------------------------------------------
# 7. Ingreslock backdoor - Port 1524
# ------------------------------------------------
echo "[*] Removing ingreslock backdoor (port 1524)..."
# Check if anything is listening on 1524
PID=$(lsof -i :1524 -t 2>/dev/null)
if [ ! -z "$PID" ]; then
  kill -9 $PID
  echo "[+] Killed process on port 1524"
fi
# Remove from inetd if present
if [ -f /etc/inetd.conf ]; then
  sed -i '/1524/d' /etc/inetd.conf
  /etc/init.d/inetd restart 2>/dev/null
fi
echo "[+] Ingreslock backdoor removed."
echo ""

# ------------------------------------------------
# Verify - Check ports are no longer listening
# ------------------------------------------------
echo "================================================"
echo " Verification - Checking vulnerable ports"
echo "================================================"
echo "The following should all be empty/closed:"
echo ""
echo "[*] Port 21 (FTP/vsftpd):"
netstat -tlnp 2>/dev/null | grep ":21 " || echo "    Not listening - GOOD"

echo "[*] Port 139/445 (Samba):"
netstat -tlnp 2>/dev/null | grep -E ":139 |:445 " || echo "    Not listening - GOOD"

echo "[*] Port 6667 (IRC):"
netstat -tlnp 2>/dev/null | grep ":6667 " || echo "    Not listening - GOOD"

echo "[*] Port 3632 (distcc):"
netstat -tlnp 2>/dev/null | grep ":3632 " || echo "    Not listening - GOOD"

echo "[*] Port 1524 (ingreslock backdoor):"
netstat -tlnp 2>/dev/null | grep ":1524 " || echo "    Not listening - GOOD"

echo "[*] Port 6200 (vsftpd backdoor shell):"
netstat -tlnp 2>/dev/null | grep ":6200 " || echo "    Not listening - GOOD"

echo ""
echo "================================================"
echo " Hardening Complete!"
echo " Remember to run your firewall_setup.sh script"
echo " and test your 3 required services still work!"
echo "================================================"
