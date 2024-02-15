#!/bin/bash
rm iptables.sh2
cp iptables.sh iptables.sh2

h=`hostname -I`

f=`echo ${h} | cut -d '.' -f 1`
s=`echo ${h} | cut -d '.' -f 2`
t=`echo ${h} | cut -d '.' -f 3`

l=$(echo  $f.$s.$t.0)

sed  -i "s/networkIP/"$l"/" iptables.sh2 

if [[ $# -gt 0 ]]
then
sed  -i "s/#iptables/iptables/" iptables.sh2
sed  -i "s/managementIP/"$1"/" iptables.sh2
fi

rm /etc/openvpn/iptables.sh
cp iptables.sh2 /etc/openvpn/iptables.sh

echo done
