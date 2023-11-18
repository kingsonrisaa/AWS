#!/bin/bash
# Configure Authentication Variables 
DBName='dbwordpress'
DBUser='dbuserwordpress'
DBPassword='securepassword1234'
DBRootPassword='securepassword1234'

# Install system software 
sudo dnf install wget php-mysqlnd httpd php-fpm php-mysqli mariadb105-server php-json php php-devel -y


# Web and DB Servers 

sudo systemctl enable httpd
sudo systemctl enable mariadb
sudo systemctl start httpd
sudo systemctl start mariadb


# Set Mariadb Root Password
sudo mysqladmin -u root password $DBRootPassword


#  Install Wordpress
sudo wget http://wordpress.org/latest.tar.gz -P /var/www/html
cd /var/www/html
sudo tar -zxvf latest.tar.gz
sudo cp -rvf wordpress/* .
sudo rm -R wordpress
sudo rm latest.tar.gz


# Configure Wordpress

sudo cp ./wp-config-sample.php ./wp-config.php
sudo sed -i "s/'database_name_here'/'$DBName'/g" wp-config.php
sudo sed -i "s/'username_here'/'$DBUser'/g" wp-config.php
sudo sed -i "s/'password_here'/'$DBPassword'/g" wp-config.php   
sudo chown apache:apache * -R


# Create Wordpress DB

echo "CREATE DATABASE $DBName;" >> /tmp/dbfiletmp.setup
echo "CREATE USER '$DBUser'@'localhost' IDENTIFIED BY '$DBPassword';" >> /tmp/dbfiletmp.setup
echo "GRANT ALL ON $DBName.* TO '$DBUser'@'localhost';" >> /tmp/dbfiletmp.setup
echo "FLUSH PRIVILEGES;" >> /tmp/dbfiletmp.setup
mysql -u root --password=$DBRootPassword < /tmp/dbfiletmp.setup
sudo rm /tmp/dbfiletmp.setup
