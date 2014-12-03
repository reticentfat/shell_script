#!/bin/sh

##每周一执行 15 0 * * 1 sh /home/oracle/etl/bin/guangdong_foshan.sh

DEALDATE=`date '+%Y%m%d'`
echo $DEALDATE

ftp -i -v -n 211.***.***.*** <<EOF
user czxms fs123456
lcd /home/oracle/etl/data/guangdong/foshan/
put ${DEALDATE}_foshan_wzcx_data_cancel.txt
EOF
