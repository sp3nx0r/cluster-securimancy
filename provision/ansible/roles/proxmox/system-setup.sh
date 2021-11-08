#! /bin/bash

# Enable IP forwarding and exclude container IP rules from iptables
echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
echo 'net.bridge.bridge-nf-call-iptables=11' >> /etc/sysctl.conf
sysctl --system

# Disable swap on host
sysctl vm.swappiness=0
swapoff -a
