bzcat /data0/match/orig/20150331/snapshot.txt.bz2 | awk -F'|' '{if ($2~/^103/&&$8=="0971"&&$3=="06") print $1"|"$2 }' | bzip2>/home/oracle/qinghai2duanxin.txt.bz
bzcat /data0/match/orig/20150331/snapshot.txt.bz2 | awk -F'|' '{if ($2~/^105/&&$8=="0971"&&$3=="06") print $1"|"$2 }' | bzip2>/home/oracle/qinghai2caixin.txt.bz
bzcat /data0/match/orig/20150630/snapshot.txt.bz2 | awk -F'|' '{if ($2~/^105/&&$8=="0971"&&$3=="06") print $1"|"$2"|" }' | bzip2>/home/oracle/qinghai3caixin.txt.bz
bzcat /data0/match/orig/20150630/snapshot.txt.bz2 | awk -F'|' '{if ($2~/^103/&&$8=="0971"&&$3=="06") print $1"|"$2"|" }' | bzip2>/home/oracle/qinghai3duanxin.txt.bz
然后匹配
bzcat /home/oracle/qinghai2duanxin.txt.bz  /home/oracle/qinghai3duanxin.txt.bz  | awk -F'[|^]' '{if(NF==2) aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > /home/oracle/qinghai2duanjiao.txt.bz2
bzcat /home/oracle/qinghai2caixin.txt.bz  /home/oracle/qinghai3caixin.txt.bz  | awk -F'[|^]' '{if(NF==2) aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > /home/oracle/qinghai2caijiao.txt.bz2
--------上边是存量包月客户留存率，下边是新增包月客户留存率-------------
bzcat /data0/match/orig/20150430/snapshot.txt.bz2 | awk -F'|' '{if ($2~/^103/&&$8=="0971"&&$5>=20150401000000&&$5<20150501000000) print $1"|"$2 }' >/home/oracle/qinghai4yueduanxinzeng.txt
bzcat /data0/match/orig/20150630/snapshot.txt.bz2 | awk -F'|' '{if ($2~/^103/&&$8=="0971"&&$5>=20150501000000&&$5<20150701000000) print $1"|"$2 }' >/home/oracle/qinghai4yueduanxinzeng2.txt
合并
cat qinghai4yueduanxinzeng.txt qinghai4yueduanxinzeng2.txt>qinghai4yueduanxinzengquan.txt
bzip2 qinghai4yueduanxinzengquan.txt
匹配
bzcat /home/oracle/qinghai4yueduanxinzengquan.txt.bz2  /home/oracle/qinghai3duanxin.txt.bz  | awk -F'[|^]' '{if(NF==2) aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > /home/oracle/qinghai2duanxinzengjiao.txt.bz2
------------------------------------------------
bzcat /data0/match/orig/20150430/snapshot.txt.bz2 | awk -F'|' '{if ($2~/^105/&&$8=="0971"&&$5>=20150401000000&&$5<20150501000000) print $1"|"$2 }' >/home/oracle/qinghai4yuecaixinzeng.txt
bzcat /data0/match/orig/20150630/snapshot.txt.bz2 | awk -F'|' '{if ($2~/^105/&&$8=="0971"&&$5>=20150501000000&&$5<20150701000000) print $1"|"$2 }' >/home/oracle/qinghai4yuecaixinzeng2.txt
合并
cat qinghai4yuecaixinzeng.txt qinghai4yuecaixinzeng2.txt>qinghai4yuecaixinzengquan.txt
bzip2 qinghai4yuecaixinzengquan.txt
匹配
bzcat /home/oracle/qinghai4yuecaixinzengquan.txt.bz2  /home/oracle/qinghai3caixin.txt.bz  | awk -F'[|^]' '{if(NF==2) aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > /home/oracle/qinghai2caixinzengjiao.txt.bz2
