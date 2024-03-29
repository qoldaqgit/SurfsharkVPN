#!/bin/bash
# Flush
iptables -t nat -F
iptables -t mangle -F
iptables -F
iptables -X


# Block All
iptables -P OUTPUT DROP
iptables -P INPUT DROP
iptables -P FORWARD DROP


# allow Localhost
iptables -A INPUT -i lo -m comment --comment "Allow Localhost IN" -j ACCEPT
iptables -A OUTPUT -o lo -m comment --comment "Allow Localhost Out" -j ACCEPT


# Make sure you can communicate with Surfshark DHCP server
iptables -A OUTPUT -d 162.252.172.57 -m comment --comment "Allow DNS Out"  -j ACCEPT
iptables -A INPUT -s 162.252.172.57 -m comment --comment "Allow DNS In"  -j ACCEPT


# Make sure that you can communicate within your own network
iptables -A INPUT -s networkIP/24 -d networkIP/24 -m comment --comment "Allow LAN In" -j ACCEPT
iptables -A OUTPUT -s networkIP/24 -d networkIP/24 -m comment --comment "Allow LAN Out" -j ACCEPT

# Allow established sessions to receive traffic:
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow TUN
iptables -A INPUT -i tun+ -j ACCEPT
iptables -A FORWARD -i tun+ -j ACCEPT
iptables -A FORWARD -o tun+ -j ACCEPT
iptables -t nat -A POSTROUTING -o tun+ -j MASQUERADE
iptables -A OUTPUT -o tun+ -j ACCEPT


# allow VPN connection
iptables -I OUTPUT 1 -p udp --destination-port 1194 -m comment --comment "Allow VPN connection" -j ACCEPT

# Make sure you can SSH in from management network(not required if on same local network)
#iptables -I INPUT -s managementIP/24 -p tcp --dport 22 -j ACCEPT
#iptables -I OUTPUT -d managementIP/24 -p tcp --sport 22 -j ACCEPT

# Block All
iptables -A OUTPUT -j DROP
iptables -A INPUT -j DROP
iptables -A FORWARD -j DROP


# Log all dropped packages, debug only.


iptables -N logging
iptables -A INPUT -j logging
iptables -A OUTPUT -j logging
iptables -A logging -m limit --limit 2/min -j LOG --log-prefix "IPTables general: " --log-level 7
iptables -A logging -j DROP


echo "saving"
iptables-save > /etc/iptables.rules
echo "done"
#echo 'openVPN - Rules successfully applied, we start "watch" to verify IPtables in realtime (you can cancel it as usual CTRL + c)'
