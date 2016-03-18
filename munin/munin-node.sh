#!/bin/bash
# Auto install munin-node Ubuntu
# wrfly 21016-3

sudo apt-get update
sudo apt-get -y install munin-node

# get master IP address
read -p "Tell me the master's IP address: " master_ip
ip=$(echo $master_ip | sed 's/\./\\./g')
echo  "allow ^$ip\$" >> /etc/munin/munin-node.conf

# change running user
sed -i 's/root/munin/g' /etc/munin/munin-node.conf

service munin-node restart

echo "The plugins of this server are as follows:"
ls /etc/munin/plugins

echo "If you want do disable some plugins, you can change your directory to \"/etc/munin/plugins\" and remove some link files.(It's OK to delete them because you can link them again from \"/usr/share/munin/plugins\" to enable them.)"
