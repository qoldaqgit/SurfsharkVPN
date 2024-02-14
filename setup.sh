#!/bin/bash

#to install 
# sudo wget https://raw.githubusercontent.com/qoldaqgit/SurfsharkVPN/main/setup.sh && sudo bash setup.sh

#update and install requirements
sudo apt update &&
sudo apt upgrade -y  &&
sudo apt-get install openvpn -y &&
sudo apt-get install unzip -y &&
sudo apt install iptables -y &&
sudo apt install resolvconf -y &&

#cd /etc/openvpn/ &&
sudo wget https://my.surfshark.com/vpn/api/v1/server/configurations -O /etc/openvpn/configurations &&
sudo unzip /etc/openvpn/configurations -d /etc/openvpn/ &&

#Configure the desired location to connect to
sudo touch /etc/openvpn/connect.sh
sudo touch /etc/openvpn/auth.txt
echo sudo openvpn --config "/etc/openvpn/us-mia.prod.surfshark.com_udp.ovpn" --auth-user-pass /etc/openvpn/auth.txt >> /etc/openvpn/connect.sh &&
echo [username] >> /etc/openvpn/auth.txt &&
echo [password] >> /etc/openvpn/auth.txt &&

#Enable IP Forwarding
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward" &&

#Get the iptables config
sudo wget https://raw.githubusercontent.com/qoldaqgit/SurfsharkVPN/main/iptables.sh  &&
sudo wget https://raw.githubusercontent.com/qoldaqgit/SurfsharkVPN/main/iptablesconfig.sh  &&
sudo wget https://raw.githubusercontent.com/qoldaqgit/SurfsharkVPN/main/reset-tables.sh  &&


#Point DNS to Surfshark's
sudo echo nameserver 162.252.172.57 >> /etc/resolvconf/resolv.conf.d/head &&
sudo echo nameserver 149.154.159.92 >> /etc/resolvconf/resolv.conf.d/head &&
sudo resolvconf --enable-updates &&
sudo resolvconf -u &&
sudo systemctl restart resolvconf.service &&
sudo systemctl restart systemd-resolved.service &&


sudo bash iptablesconfig.sh &&
sudo nano /etc/openvpn/auth.txt

#echo "###########################################" &&
#echo "### Run sudo nano /etc/openvpn/auth.txt ###" &&
#echo "###########################################" &&
#echo "###     and insert your credentials     ###" &&
#echo "###########################################"

#Run the following to test
#sudo bash /etc/openvpn/iptables.sh && sleep 10 && sudo bash /etc/openvpn/connect.sh
