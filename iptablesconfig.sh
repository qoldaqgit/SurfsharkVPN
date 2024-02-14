#!/bin/bash
h=`hostname -I`

f=`echo ${h} | cut -d '.' -f 1`
s=`echo ${h} | cut -d '.' -f 2`
t=`echo ${h} | cut -d '.' -f 3`

l=$(echo  $f.$s.$t.0)

sed  -e "s/networkIP/"$l"/" iptables.sh >> iptables.sh2

if [[ $# -gt 0 ]]
then
sed  -e "s/#iptables/iptables/" iptables.sh2 >> iptables.sh2
sed  -e "s/managementIP/"$1"/" iptables.sh2 >> iptables.sh2
fi

cp iptables.sh2 /etc/openvpn/iptables.sh
