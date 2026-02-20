#!/bin/bash
#
# Metasploitable Account & Network Hardening Script
# Covers:
#   1. Lock weak password accounts
#   2. Set iptables firewall rules
#   3. Remove hosts.equiv and .rhosts files
# Run as root on the Metasploitable server

echo "================================================"
echo " Metasploitable Account & Network Hardening"
echo "================================================"
echo ""

# ------------------------------------------------
# 1. LOCK WEAK PASSWORD ACCOUNTS
# ------------------------------------------------
echo "[*] Locking weak password accounts..."

for ACCOUNT in user postgres sys klog service; do
  # Check if account exists
  if id "$ACCOUNT" &>/dev/null; then
    passwd -l $ACCOUNT
    echo "[+] Locked account: $ACCOUNT"
  else
    echo "[-] Account not found, skipping: $ACCOUNT"
  fi
done

echo ""
echo "[*] Verifying account status (L = Locked)..."
for ACCOUNT in user postgres sys klog service; do
  if id "$ACCOUNT" &>/dev/null; then
    STATUS=$(passwd -S $ACCOUNT | awk '{print $2}')
    echo "    $ACCOUNT: $STATUS"
  fi
done
echo ""

# ------------------------------------------------
# 2. IPTABLES FIREWALL RULES
# ------------------------------------------------
echo "[*] Setting up iptables firewall rules..."

IPT="iptables"

# Flush existing rules
$IPT -F
echo "[+] Flushed existing rules"

# Allow established connections
$IPT -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow loopback
$IPT -A INPUT -i lo -j ACCEPT

# Allow only required ports
$IPT -A INPUT -j ACCEPT -p tcp --dport 22   # ssh
$IPT -A INPUT -j ACCEPT -p tcp --dport 80   # http
$IPT -A INPUT -j ACCEPT -p tcp --dport 443  # https
$IPT -A INPUT -j ACCEPT -p tcp --dport 513  # rlogin
$IPT -A INPUT -j ACCEPT -p tcp --dport 3306 # mysql

# Drop everything else
$IPT -A INPUT -j DROP

echo "[+] Firewall rules applied"
echo ""
echo "[*] Current iptables rules:"
$IPT -L --line-numbers
echo ""

# ------------------------------------------------
# 3. REMOVE HOSTS.EQUIV AND .RHOSTS
# ------------------------------------------------
echo "[*] Removing hosts.equiv and .rhosts files..."

# Find and remove all hosts.equiv files
find / -name "hosts.equiv" 2>/dev/null | while read FILE; do
  rm -f "$FILE"
  echo "[+] Removed: $FILE"
done

# Find and remove all .rhosts files
find / -name ".rhosts" 2>/dev/null | while read FILE; do
  rm -f "$FILE"
  echo "[+] Removed: $FILE"
done

echo ""
echo "[*] Verifying removal (should return nothing)..."
FOUND=$(find / -name "hosts.equiv" -o -name ".rhosts" 2>/dev/null)
if [ -z "$FOUND" ]; then
  echo "[+] All hosts.equiv and .rhosts files removed - GOOD"
else
  echo "[-] WARNING - Files still found:"
  echo "$FOUND"
fi
echo ""

echo "================================================"
echo " Hardening Complete!"
echo " Remember to test your 3 required services:"
echo "   ./rlogin_script"
echo "   ./mysql_script"
echo "   ./web_script"
echo "================================================"
