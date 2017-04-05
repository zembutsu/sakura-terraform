#!/bin/sh
#
# @sacloud-once

# template_fileリソースの"vars"属性からvip変数を受け取る
VIP="${vip}"

# VIPに対するARP応答の無効化
echo "net.ipv4.conf.all.arp_ignore = 1" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.arp_announce = 2" >> /etc/sysctl.conf
sysctl -p 1>/dev/null

# VIPをループバックのエイリアスに設定
touch /etc/sysconfig/network-scripts/ifcfg-lo:0
echo "DEVICE=lo:0" > /etc/sysconfig/network-scripts/ifcfg-lo:0
echo "IPADDR=$VIP" >> /etc/sysconfig/network-scripts/ifcfg-lo:0
echo "NETMASK=255.255.255.255" >> /etc/sysconfig/network-scripts/ifcfg-lo:0

ifup lo:0 || exit 1

exit 0

