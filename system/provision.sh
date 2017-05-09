#!/bin/bash

apache_config_file="/etc/apache2/envvars"
apache_vhost_file="/etc/apache2/sites-available/vagrant_vhost.conf"
php_config_file="/etc/php5/apache2/php.ini"
xdebug_config_file="/etc/php5/mods-available/xdebug.ini"
mysql_config_file="/etc/mysql/my.cnf"
default_apache_index="/var/www/html/index.html"
project_web_root="src"

# This function is called at the very bottom of the file
main() {
	repositories_go
	update_go
	network_go
	tools_go
	node_go
##	apache_go
	mysql_go
	nginx_go
	#php_go
	autoremove_go
}

repositories_go() {
	echo "NOOP"
}

nginx_go() {
	# Install Nginx
	apt-get install -y nginx

	# Create backup copy of existing config files (nginx.conf and mime.types)
	cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
	cp /etc/nginx/mime.types /etc/nginx/mime.types.bak

	# Create symlink to Nginx H5BP configuration files
	mkdir /etc/nginx/conf
	ln -sf /vagrant/system/nginx/nginx.conf /etc/nginx/nginx.conf
	ln -sf /vagrant/system/nginx/mime.types /etc/nginx/mime.types
	ln -s /vagrant/system/nginx/h5bp.conf /etc/nginx/conf/h5bp.conf
	ln -s /vagrant/system/nginx/x-ua-compatible.conf /etc/nginx/conf/x-ua-compatible.conf
	ln -s /vagrant/system/nginx/expires.conf /etc/nginx/conf/expires.conf
	ln -s /vagrant/system/nginx/cross-domain-fonts.conf /etc/nginx/conf/cross-domain-fonts.conf
	ln -s /vagrant/system/nginx/protect-system-files.conf /etc/nginx/conf/protect-system-files.conf

	# Symlink to the proper log directory
	ln -s /var/log/nginx /usr/share/nginx/logs

	# Configure default site using server.conf
	mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
	ln -s /vagrant/system/nginx/server.conf /etc/nginx/sites-available/default

	# Create upstart job for Node.js app and Nginx
	cp /vagrant/system/upstart/app.conf /etc/init/app.conf
	cp /vagrant/system/upstart/nginx.conf /etc/init/nginx.conf
}

update_go() {
	# Update the server
	apt-get update
	# apt-get -y upgrade
}

autoremove_go() {
	apt-get -y autoremove
}

network_go() {
	IPADDR=$(/sbin/ifconfig eth0 | awk '/inet / { print $2 }' | sed 's/addr://')
	sed -i "s/^${IPADDR}.*//" /etc/hosts
	echo ${IPADDR} ubuntu.localhost >> /etc/hosts			# Just to quiet down some error messages
}

tools_go() {
	# Install basic tools
	apt-get -y install build-essential binutils-doc git subversion
}

node_go(){
	cd /tmp
	wget https://nodejs.org/dist/v6.10.3/node-v6.10.3-linux-x64.tar.xz
	mkdir node
	tar xvf node-v*.tar.?z --strip-components=1 -C ./node
	mkdir node/etc
	echo 'prefix=/usr/local' > node/etc/npmrc
	sudo mv node /opt/
	sudo chown -R root: /opt/node
	sudo ln -s /opt/node/bin/node /usr/local/bin/node
	sudo ln -s /opt/node/bin/npm /usr/local/bin/npm
	sudo npm install pm2 nodemon -g
}
apache_go() {
	# Install Apache
	apt-get -y install apache2

	sed -i "s/^\(.*\)www-data/\1ubuntu/g" ${apache_config_file}
	chown -R ubuntu:ubuntu /var/log/apache2

	if [ ! -f "${apache_vhost_file}" ]; then
		cat << EOF > ${apache_vhost_file}
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /vagrant/${project_web_root}
    LogLevel debug

    ErrorLog /var/log/apache2/error.log
    CustomLog /var/log/apache2/access.log combined

    <Directory /vagrant/${project_web_root}>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
	fi

	a2dissite 000-default
	a2ensite vagrant_vhost

	a2enmod rewrite

	service apache2 reload
	update-rc.d apache2 enable
}

php_go() {
	apt-get -y install php7.0 php7.0-curl php7.0-mysql php7.0-sqlite  php-pear

	sed -i "s/display_startup_errors = Off/display_startup_errors = On/g" ${php_config_file}
	sed -i "s/display_errors = Off/display_errors = On/g" ${php_config_file}

	if [ ! -f "{$xdebug_config_file}" ]; then
		cat << EOF > ${xdebug_config_file}
zend_extension=xdebug.so
xdebug.remote_enable=1
xdebug.remote_connect_back=1
xdebug.remote_port=9000
xdebug.remote_host=10.0.2.2
EOF
	fi

	service apache2 reload

	# Install latest version of Composer globally
#	if [ ! -f "/usr/local/bin/composer" ]; then
#		curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
#	fi

	# Install PHP Unit 4.8 globally
	#if [ ! -f "/usr/local/bin/phpunit" ]; then
	#	curl -O -L https://phar.phpunit.de/phpunit-old.phar
	#	chmod +x phpunit-old.phar
	#	mv phpunit-old.phar /usr/local/bin/phpunit
#	fi
}

mysql_go() {
	# Install MySQL
	echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
	echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections
	apt-get -y install mysql-client mysql-server

	#sed -i "s/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" ${mysql_config_file}

	# Allow root access from any host
	echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION" | mysql -u root --password=root
	echo "GRANT PROXY ON ''@'' TO 'root'@'%' WITH GRANT OPTION" | mysql -u root --password=root

	if [ -d "/vagrant/provision-sql" ]; then
		echo "Executing all SQL files in /vagrant/provision-sql folder ..."
		echo "-------------------------------------"
		for sql_file in /vagrant/provision-sql/*.sql
		do
			echo "EXECUTING $sql_file..."
	  		time mysql -u root --password=root < $sql_file
	  		echo "FINISHED $sql_file"
	  		echo ""
		done
	fi

	service mysql restart
	update-rc.d apache2 enable
}

main

exit 0
