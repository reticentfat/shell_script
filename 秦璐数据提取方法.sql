无线-产品-11提取方法
5.31上
scp /data/logs/archives/bossproxy/20180[1-3][0-9][0-9]/bossproxy.log.20180[1-3][0-9][0-9]1600.bz2 gateway@192.100.7.25:/home/gateway/quanliang_mail/
scp /data/logs/archives/bossproxy/20180[1-3][0-9][0-9]/appproxy.log.20180[1-3][0-9][0-9]1000.bz2 gateway@192.100.7.25:/home/gateway/quanliang_mail/
产品10 需要用原有文件拆分
bzcat app.txt.bz2 | awk -F',' '{d=substr($3,5,4)".txt";print $0>> d;}'
bzcat boss.txt.bz2 | awk -F',' '{d=substr($2,1,6)".txt";print $0>> d;}'
----------
无线-产品-10提取方法
5.31
scp gateway@192.100.7.25:/data/home/gateway/wy.txt.bz2 ~
cd /data/logs/archives/bossproxy
bzcat ~/wy.txt.bz2 ./20180[1-3][0-3][0-9]/appproxy.log.20180[1-3][0-3][0-9]0[0-9]00.bz2 | awk -F',' '{if(NF==3) aa[$1$2]=$3;else if($4$7 in aa)  print aa[$4$7]","substr($1,1,15)","$3","$4","$6","$7","$8","$11","$14}' | bzip2 > ~/app.txt.bz2
appproxy.log.201706090900.bz2
bzcat ~/wy.txt.bz2 ./20180[1-3][0-3][0-9]/bossproxy.log.20180[1-3][0-3][0-9]0[0-9]00.bz2 | awk -F',' '{if(NF==3) aa[$1$2]=$3;else if($5$7 in aa)  print aa[$5$7]","substr($1,1,15)","$3","$4","$6","$7","$8","$11","$14}' | bzip2 > ~/boss.txt.bz2
scp ~/boss.txt.bz2 app.txt.bz2 gateway@192.100.7.25:/data/home/gateway
rename  dump_weizhang_ test_ *
