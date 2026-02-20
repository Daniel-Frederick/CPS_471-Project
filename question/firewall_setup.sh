#!/bin/bash
# Firewall setup script for Metasploitable
# Sets up iptables rules to only allow required services

IPT="iptables"

echo "Flushing existing rules..."
$IPT -F

echo "Setting up firewall rules..."

# Allow already established connections
$IPT -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow loopback (localhost traffic)
$IPT -A INPUT -i lo -j ACCEPT

# Allow only the required ports
$IPT -A INPUT -j ACCEPT -p tcp --dport 22   # ssh
$IPT -A INPUT -j ACCEPT -p tcp --dport 80   # http
$IPT -A INPUT -j ACCEPT -p tcp --dport 443  # https
$IPT -A INPUT -j ACCEPT -p tcp --dport 513  # rlogin
$IPT -A INPUT -j ACCEPT -p tcp --dport 3306 # mysql

# Drop everything else
$IPT -A INPUT -j DROP

echo "Firewall rules applied. Current rules:"
$IPT -L --line-numbers
