#!/bin/bash
h=`hostname -I`

f=`echo ${h} | cut -d '.' -f 1`
s=`echo ${h} | cut -d '.' -f 2`
t=`echo ${h} | cut -d '.' -f 3`

l=$(echo  $f.$s.$t.0)

sed  -e "s/networkIP/"$l"/g" ~/iptables.sh >> ~/iptables.sh

if [[ $# -gt 0 ]]
then
sed  -e "s/#iptables/iptables/g" ~/iptables.sh >> ~/iptables.sh
sed  -e "s/managementIP/"$1"/g" ~/iptables.sh >> ~/iptables.sh
fi

mv ~/iptables.sh /etc/openvpn/iptables.sh

