#!/bin/bash
# A script to install munin master server.
# wrfly 2016-3

function addserver(){
	choice='server_name'
	until [[ "$choice" == "exit" ]]; do
		read -p "Please tell the node server's nickname: " nick
		read -p "And IP address? " ip
		echo "[$nick]" >> /etc/munin/munin.conf
		echo "    address $ip" >> /etc/munin/munin.conf
    	echo "    use_node_name yes" >> /etc/munin/munin.conf
    	read -p "If you want to exit, just type 'exit' or type 'Enter' to continue" choice
	done
}

if [[ -e '/etc/munin/munin.conf' ]]; then
	echo "It looks like you have already installed munin."
	read -p "Do you want to add a node server?" choice
	if [[ "$choice" == [Y/y] ]]; then
		addserver
	else
		echo "Now exit."
		exit
	fi
else
	sudo apt-get update
	sudo apt-get install munin
	echo '
dbdir	/var/lib/munin
htmldir /var/cache/munin/www
logdir /var/log/munin
rundir  /var/run/munin' >> /etc/munin/munin.conf
fi

function install_nginx(){
if [[ -e "/etc/nginx/nginx.conf" ]]; then
	read -p "You have install Nginx and please tell me the server name." $SERVER_NAME
	if [[ -z $SERVER_NAME ]]; then
			echo '
server {
	listen 80 ;
	listen [::]:80;

	root /var/cache/munin/www;
	index index.html index.htm;

	server_name status.xyv6.com;

}' > /etc/nginx/sites-available/$SERVER_NAME
	
	else
		echo "The server name is empty. Exit now."
		exit
	fi
	else
		apt-get install nginx
		install_nginx
fi
}

install_html