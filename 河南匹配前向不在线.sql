
awk -F'|' '{print $1"|" }' 12580目标.TXT | sort | uniq -u |unix2dos | bzip2 > wy.txt.bz2
上传到27上
bzcat /data/homeoracle/etl/data/data/snapshot/snapshot.txt.bz2 /home/oracle/wy.txt.bz2  | awk -F'|' '{if(NF==20&&$9=="373"&&$3=="06"&&$2~/^1/) aa[$1]=$1;else if(NF==2&&!($1 in aa))  print }' | bzip2 > /home/oracle/hn_guolv.txt.bz2
bzcat /data/homeoracle/etl/data/data/snapshot/snapshot.txt.bz2 /home/oracle/wy.txt.bz2  | awk -F'|' '{if(NF==20&&$9=="373"&&$3=="06"&&$2~/^1/) aa[$1]=$1;else if(NF==2&&($1 in aa))  print }'  > /home/oracle/hn_zaixian.txt
