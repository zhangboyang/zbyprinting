#!/bin/sh
lpadmin -p Zby\'s_Printing_Service -D 石头、剪子、布\ 打印店 -o printer-is-shared=false -v http://zby.pkuschool.edu.cn:631/printers/zbyprinting -m drv:///sample.drv/generic.ppd -L Zby\'s\ Printing\ Service -E
