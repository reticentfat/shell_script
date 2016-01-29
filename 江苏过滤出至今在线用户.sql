#首先合并到一个txt
find -name "*.txt" -exec 'cat' {} \; > wy.txt
#排重,压缩
sort -u wy.txt | bzip2 >wy.txt.bz2
crontab上写

bzcat /data/match/orig/20160127/snapshot.txt.bz2 | awk -F'|' '{if($3=="06"&&$8=="025") print $1"|"$9"|"}'| bzip2 > /data/match/orig/20160127/jiangsu.txt.bz2
 50 14 29 01 * bzcat  jiangsu.txt.bz2  wy.txt.bz2  | awk -F'|' '{if(NF==3) aa[$1]=$1; else if((NF==2)&&($1 in aa))  print}' | bzip2 > /data/match/orig/20160127/shanxi_zaixian.txt.bz2
 awk -F'|' -v CODE_DIR=/home/oracle/etl/data/nodist.tsv '{if(FILENAME==CODE_DIR) d[$4]=$2 ; else if(FILENAME != CODE_DIR &&( substr($1,1,7) in d) ) print $1"|"d[substr($1,1,7)];}' /home/oracle/etl/data/nodist.tsv /home/oracle/shanxi_buzaixian.txt |bzip2>/home/oracle/shanxi_result.txt.bz2
bunzip2 shanxi_buzaixian.txt.bz2
cat shanxi_zaixian.txt | awk -F'|' '{d=$2".txt";print $0>>d }'
