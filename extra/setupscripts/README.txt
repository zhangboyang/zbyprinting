main server setup scripts
for Ubuntu 12.04 (Server) and CentOS 6 (minimal install)
these scripts have been tested on ubuntu 12.04.5 and centos 6.5

how to install:
1. run `ubuntu12.04-dep.sh' >>OR<< `centos6-dep.sh' >>AS ROOT<<
      notice: your database password shouldn't contain any symbols.
2. run `ubuntu12.04-setup.sh' >>OR<< `centos6-setup.sh' >>AS ROOT<<
3. change the database password (default is `toor') in
      /var/www/html/zbyprinting/cgi/Configure.php
      /usr/local/bin/zbyprinting-analysis
4. you may want to disable `CheckLCPassword()'
      add `return true;' at the beginning of CheckLCPassword()
      in file /var/www/html/zbyprinting/cgi/CheckLCPassword.php

how to test:
1. add printer -> http://SERVERADDR:631/printers/zbyprinting
2. send a test page to that printer
3. go to -> http://SERVERADDR/zbyprinting
