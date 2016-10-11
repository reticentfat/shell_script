---192.100.7.25上
sudo -s
su shujuyzx
ssh shujuyzx@172.200.5.31
王远：
       请从10月1日-10月7日，将短信的下发的各个端口号汇总排重后写到一个索引文件中，然后将端口号与10月1-7日的短信下发日志匹配，导出最近一条下发日志。打包下载。
从服务器172.200.5.31 的 /logs/archives/monster/目录下获取相应日期目录下的日志文件。
/logs/archives/monster/20161001/monster-cmppmt.log.20161001*.bz2
cd /logs/archives/monster/
----------生成索引文件-----------------
bzcat /logs/archives/monster/2016100[1-7]/monster-cmppmt.log.2016100[1-7]*.bz2 | awk -F',' '{print $10}' | sort -u > /data/logs/shujuyzx/port.txt
bzip2 /data/logs/shujuyzx/port.txt
bzcat /data/logs/shujuyzx/port.txt.bz2 

bzcat /logs/archives/monster/2016100[1-7]/monster-cmppmt.log.2016100[1-7]*.bz2 /data/logs/shujuyzx/port.txt.bz2    | awk -F',' '{if(NF>5) aa[$10]=$0;else if((NF==1)&&($1 in aa))  print aa[$1]}' >> /data/logs/shujuyzx/port_result.txt

scp /data/logs/shujuyzx/port_result.txt gateway@192.100.7.25:/home/gateway/quanliang_mail/
