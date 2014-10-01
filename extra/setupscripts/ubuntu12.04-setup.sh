#!/bin/sh
# setup zbyprinting server
SRC=../..

# install htdocs
cp -r ${SRC}/src/htdocs/zbyprinting /var/www
mv /var/www/zbyprinting/cgi/Configure.php.example /var/www/zbyprinting/cgi/Configure.php

# install scripts and programs
cp ${SRC}/src/scripts/zbyprinting-analysis /usr/local/bin/zbyprinting-analysis
cp ${SRC}/src/scripts/zbyprinting-cups-pdf /usr/local/bin/zbyprinting-cups-pdf
cp ${SRC}/src/scripts/zbyprinting-sendjob /usr/local/bin/zbyprinting-sendjob
g++ -s -O2 ${SRC}/src/programs/png-analysis.cpp -o /usr/local/bin/zbyprinting-analysis-PNG -lpng

# configure cups-pdf
CUPSPDFCONF='/etc/cups/cups-pdf.conf'
echo 'Out /var/spool/cups-pdf' > ${CUPSPDFCONF}
echo 'AnonDirName /var/spool/cups-pdf' >> ${CUPSPDFCONF}
echo 'Label 1' >> ${CUPSPDFCONF}
echo 'AnonUser root' >> ${CUPSPDFCONF}
echo 'AnonUMask 0022' >> ${CUPSPDFCONF}
echo 'PostProcessing /usr/local/bin/zbyprinting-cups-pdf' >> ${CUPSPDFCONF}
chmod 777 /var/spool/cups-pdf

# configure cupsd
service cups stop
CUPSDCONF='/etc/cups/cupsd.conf'
echo 'MaxLogSize 0' > ${CUPSDCONF}
echo 'LogLevel debug' >> ${CUPSDCONF}
echo 'SystemGroup sys root' >> ${CUPSDCONF}
echo '# Allow remote access' >> ${CUPSDCONF}
echo 'Port 631' >> ${CUPSDCONF}
echo 'Listen /var/run/cups/cups.sock' >> ${CUPSDCONF}
echo '# Enable printer sharing and shared printers.' >> ${CUPSDCONF}
echo 'Browsing On' >> ${CUPSDCONF}
echo 'BrowseOrder allow,deny' >> ${CUPSDCONF}
echo 'BrowseAllow all' >> ${CUPSDCONF}
echo 'BrowseRemoteProtocols CUPS' >> ${CUPSDCONF}
echo 'BrowseAddress @LOCAL' >> ${CUPSDCONF}
echo 'BrowseLocalProtocols CUPS dnssd' >> ${CUPSDCONF}
echo 'DefaultAuthType Basic' >> ${CUPSDCONF}
echo '<Location />' >> ${CUPSDCONF}
echo '  # Allow shared printing...' >> ${CUPSDCONF}
echo '  Order allow,deny' >> ${CUPSDCONF}
echo '  Allow all' >> ${CUPSDCONF}
echo '</Location>' >> ${CUPSDCONF}
echo '<Location /admin>' >> ${CUPSDCONF}
echo '  # Restrict access to the admin pages...' >> ${CUPSDCONF}
echo '  Order allow,deny' >> ${CUPSDCONF}
echo '</Location>' >> ${CUPSDCONF}
echo '<Location /admin/conf>' >> ${CUPSDCONF}
echo '  AuthType Default' >> ${CUPSDCONF}
echo '  Require user @SYSTEM' >> ${CUPSDCONF}
echo '  # Restrict access to the configuration files...' >> ${CUPSDCONF}
echo '  Order allow,deny' >> ${CUPSDCONF}
echo '</Location>' >> ${CUPSDCONF}
echo '<Policy default>' >> ${CUPSDCONF}
echo '  <Limit Send-Document Send-URI Hold-Job Release-Job Restart-Job Purge-Jobs Set-Job-Attributes Create-Job-Subscription Renew-Subscription Cancel-Subscription Get-Notifications Reprocess-Job Cancel-Current-Job Suspend-Current-Job Resume-Job CUPS-Move-Job CUPS-Get-Document>' >> ${CUPSDCONF}
echo '    Require user @OWNER @SYSTEM' >> ${CUPSDCONF}
echo '    Order deny,allow' >> ${CUPSDCONF}
echo '  </Limit>' >> ${CUPSDCONF}
echo '  <Limit CUPS-Add-Modify-Printer CUPS-Delete-Printer CUPS-Add-Modify-Class CUPS-Delete-Class CUPS-Set-Default CUPS-Get-Devices>' >> ${CUPSDCONF}
echo '    AuthType Default' >> ${CUPSDCONF}
echo '    Require user @SYSTEM' >> ${CUPSDCONF}
echo '    Order deny,allow' >> ${CUPSDCONF}
echo '  </Limit>' >> ${CUPSDCONF}
echo '  <Limit Pause-Printer Resume-Printer Enable-Printer Disable-Printer Pause-Printer-After-Current-Job Hold-New-Jobs Release-Held-New-Jobs Deactivate-Printer Activate-Printer Restart-Printer Shutdown-Printer Startup-Printer Promote-Job Schedule-Job-After CUPS-Accept-Jobs CUPS-Reject-Jobs>' >> ${CUPSDCONF}
echo '    AuthType Default' >> ${CUPSDCONF}
echo '    Require user @SYSTEM' >> ${CUPSDCONF}
echo '    Order deny,allow' >> ${CUPSDCONF}
echo '  </Limit>' >> ${CUPSDCONF}
echo '  <Limit Cancel-Job CUPS-Authenticate-Job>' >> ${CUPSDCONF}
echo '    Require user @OWNER @SYSTEM' >> ${CUPSDCONF}
echo '    Order deny,allow' >> ${CUPSDCONF}
echo '  </Limit>' >> ${CUPSDCONF}
echo '  <Limit All>' >> ${CUPSDCONF}
echo '    Order deny,allow' >> ${CUPSDCONF}
echo '  </Limit>' >> ${CUPSDCONF}
echo '</Policy>' >> ${CUPSDCONF}
echo '<Policy authenticated>' >> ${CUPSDCONF}
echo '  <Limit Create-Job Print-Job Print-URI>' >> ${CUPSDCONF}
echo '  AuthType Default' >> ${CUPSDCONF}
echo '  Order deny,allow' >> ${CUPSDCONF}
echo '</Limit>' >> ${CUPSDCONF}
echo '  <Limit Send-Document Send-URI Hold-Job Release-Job Restart-Job Purge-Jobs Set-Job-Attributes Create-Job-Subscription Renew-Subscription Cancel-Subscription Get-Notifications Reprocess-Job Cancel-Current-Job Suspend-Current-Job Resume-Job CUPS-Move-Job CUPS-Get-Document>' >> ${CUPSDCONF}
echo 'AuthType Default' >> ${CUPSDCONF}
echo 'Require user @OWNER @SYSTEM' >> ${CUPSDCONF}
echo 'Order deny,allow' >> ${CUPSDCONF}
echo '  </Limit>' >> ${CUPSDCONF}
echo '  <Limit CUPS-Add-Modify-Printer CUPS-Delete-Printer CUPS-Add-Modify-Class CUPS-Delete-Class CUPS-Set-Default>' >> ${CUPSDCONF}
echo '  AuthType Default' >> ${CUPSDCONF}
echo '  Require user @SYSTEM' >> ${CUPSDCONF}
echo '  Order deny,allow' >> ${CUPSDCONF}
echo '    </Limit>' >> ${CUPSDCONF}
echo '  <Limit Pause-Printer Resume-Printer Enable-Printer Disable-Printer Pause-Printer-After-Current-Job Hold-New-Jobs Release-Held-New-Jobs Deactivate-Printer Activate-Printer Restart-Printer Shutdown-Printer Startup-Printer Promote-Job Schedule-Job-After CUPS-Accept-Jobs CUPS-Reject-Jobs>' >> ${CUPSDCONF}
echo '    AuthType Default' >> ${CUPSDCONF}
echo '    Require user @SYSTEM' >> ${CUPSDCONF}
echo '    Order deny,allow' >> ${CUPSDCONF}
echo '      </Limit>' >> ${CUPSDCONF}
echo '  <Limit Cancel-Job CUPS-Authenticate-Job>' >> ${CUPSDCONF}
echo '      AuthType Default' >> ${CUPSDCONF}
echo '      Require user @OWNER @SYSTEM' >> ${CUPSDCONF}
echo '      Order deny,allow' >> ${CUPSDCONF}
echo '        </Limit>' >> ${CUPSDCONF}
echo '  <Limit All>' >> ${CUPSDCONF}
echo '        Order deny,allow' >> ${CUPSDCONF}
echo '          </Limit>' >> ${CUPSDCONF}
echo '</Policy>' >> ${CUPSDCONF}
echo 'DefaultAuthType Basic' >> ${CUPSDCONF}
echo 'WebInterface Yes' >> ${CUPSDCONF}
echo 'ServerAlias *' >> ${CUPSDCONF}
echo 'PageLogFormat %j %{job-originating-host-name} %{job-name}' >> ${CUPSDCONF}
echo 'LogFilePerm 0644' >> ${CUPSDCONF}
echo '' >> ${CUPSDCONF}
echo '' >> ${CUPSDCONF}
service cups start
cp /usr/share/ppd/cups-pdf/CUPS-PDF.ppd /usr/share/cups/model/
lpadmin -p zbyprinting -E -v cups-pdf:/ -m CUPS-PDF.ppd

# configure mysql client
MYSQLCONF='/etc/my.cnf'
echo '[client]' >> ${MYSQLCONF}
echo 'default-character-set=utf8' >> ${MYSQLCONF}

# init database
echo 'CREATE DATABASE zbyprinting CHARACTER SET utf8;' > /tmp/zbyprinting.sql
echo 'USE zbyprinting;' >> /tmp/zbyprinting.sql
cat ${SRC}/src/mysqldb/mysqldb.sql >> /tmp/zbyprinting.sql
echo 'please enter you mysql password.'
mysql -uroot -p < /tmp/zbyprinting.sql
rm -f /tmp/zbyprinting.sql

# configure apparmor
sed -i '/\/var\/spool\/cups-pdf\/\*\* rw,/a\ \ /usr/local/bin/zbyprinting-cups-pdf uxr,' /etc/apparmor.d/usr.sbin.cupsd
service apparmor force-reload

