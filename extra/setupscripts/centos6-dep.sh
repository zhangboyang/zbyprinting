#!/bin/sh
# script to install programs used by zbyprinting
# for CentOS 6

# install necessary programs
yum -y groupinstall "Base" "PHP Support" "MySQL Database server" "MySQL Database client" "Web Server" "Print Server" "Development Tools"

# install EPEL (for cups-devel)
wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -i epel-release-6-8.noarch.rpm

# install necessary programs
yum -y install php-mysql cups-devel libpng-devel cups-pdf gcc

# autostart httpd and mysqld
chkconfig httpd on
chkconfig mysqld on

# start httpd and mysqld now
service httpd start
service mysqld start

# finish mysql installation
mysql_secure_installation

