bzcat /data0/match/orig/20150331/snapshot.txt.bz2 | awk -F'|' '{if ($3=="06") print $1"|"$2"|"$8 }' | bzip2>/home/oracle/quanguo2.txt.bz
bzcat /data0/match/orig/20150630/snapshot.txt.bz2 | awk -F'|' '{if ($3=="06") print $1"|"$2"|"$8"|" }' | bzip2>/home/oracle/quanguo3.txt.bz
然后匹配
bzcat /home/oracle/quanguo2.txt.bz  /home/oracle/quanguo3.txt.bz  | awk -F'[|^]' '{if(NF==3) aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > /home/oracle/quanguoquan.txt.bz2
bzcat quanguoquan.txt.bz2 | awk -F'|' '{print $3}' |sort |uniq -c
bzcat quanguo2.txt.bz | awk -F'|' '{print $3}' |sort |uniq -c
 bzcat quanguo2.txt.bz | awk -F'|' '{if($2~/^103/)print $3}' |sort |uniq -c
 bzcat quanguoquan.txt.bz2 | awk -F'|' '{if($2~/^103/)print $3}' |sort |uniq -c
--------上边是存量包月客户留存率，下边是新增包月客户留存率-------------
bzcat /data0/match/orig/20150430/snapshot.txt.bz2 | awk -F'|' '{if ($5>=20150401000000&&$5<20150501000000) print $1"|"$2"|"$8 }' >/home/oracle/quanguo4yueduanxinzeng.txt
bzcat /data0/match/orig/20150630/snapshot.txt.bz2 | awk -F'|' '{if ($5>=20150501000000&&$5<20150701000000) print $1"|"$2"|"$8 }' >/home/oracle/quanguo4yueduanxinzeng2.txt
合并
cat quanguo4yueduanxinzeng.txt quanguo4yueduanxinzeng2.txt>quanguo4yueduanxinzengquan.txt
bzip2 quanguo4yueduanxinzengquan.txt
匹配
bzcat /home/oracle/quanguo4yueduanxinzengquan.txt.bz2  /home/oracle/quanguo3.txt.bz  | awk -F'[|^]' '{if(NF==3) aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > /home/oracle/quanguoxinzengjiao.txt.bz2
bzcat quanguoxinzengjiao.txt.bz2 | awk -F'|' '{print $3}' |sort |uniq -c
bzcat quanguo4yueduanxinzengquan.txt.bz2 | awk -F'|' '{print $3}' |sort |uniq -c
bzcat quanguoxinzengjiao.txt.bz2 | awk -F'|' '{if($2~/^103/)print $3}' |sort |uniq -c
 bzcat quanguo4yueduanxinzengquan.txt.bz2 | awk -F'|' '{if($2~/^103/)print $3}' |sort |uniq -c
