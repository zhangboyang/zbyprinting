#!/bin/sh
# script to install programs used by zbyprinting
# for Ubuntu Server 12.04

# install necessary programs
apt-get -y install build-essential cups cups-pdf lighttpd mysql-server mysql-client php5-cgi php5-mysql libcups2-dev libpng12-dev

# enable php support
lighttpd-enable-mod fastcgi
lighttpd-enable-mod fastcgi-php
/etc/init.d/lighttpd force-reload

