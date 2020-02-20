#!/bin/bash -e

# Clear iptables rules
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -t nat -F
iptables -t mangle -F
iptables -F
iptables -X

# Set iptables rules
iptables -N TCP
iptables -N UDP
iptables -N fw-interfaces

iptables -P OUTPUT ACCEPT

iptables -P INPUT DROP
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
iptables -A INPUT -p icmp --icmp-type 8 -m conntrack --ctstate NEW -j ACCEPT
iptables -A INPUT -p udp -m conntrack --ctstate NEW -j UDP
iptables -A INPUT -p tcp --syn -m conntrack --ctstate NEW -j TCP
iptables -A INPUT -p udp -j REJECT --reject-with icmp-port-unreachable
iptables -A INPUT -p tcp -j REJECT --reject-with tcp-reset
iptables -A INPUT -j REJECT --reject-with icmp-proto-unreachable

iptables -A TCP -p tcp --dport 22 -j ACCEPT
iptables -A TCP -s 10.200.200.0/24 -p tcp --dport 53 -j ACCEPT
iptables -A UDP -s 10.200.200.0/24 -p udp --dport 53 -j ACCEPT
iptables -A UDP -p udp --dport 51820 -j ACCEPT

iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -j fw-interfaces
iptables -A FORWARD -j REJECT --reject-with icmp-host-unreachable
iptables -P FORWARD DROP

iptables -A fw-interfaces -i wg0 -j ACCEPT
iptables -t nat -A POSTROUTING -s 10.200.200.0/24 -o eth0 -j MASQUERADE

# Enable IP forwarding
sysctl -w net.ipv4.ip_forward=1

# Restart DNS server
systemctl restart unbound
