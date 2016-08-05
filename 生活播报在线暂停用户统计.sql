请统计一下目前生活播报在线用户中同时订购主刊和子刊的用户中，主刊暂停的且子刊未暂停的用户量，及主刊未暂停且子刊有暂停的用户量，主刊和子刊都暂停的用户量。
---27上---
cd /data/homeoracle/etl/data/data/snapshot
bzcat snapshot.txt.bz2 | awk -F'|' '$3=="06"&&$2~/^2/&&$14=="SHBB"{print $1","$14","$7}' | sort -u | bzip2>shbb_0805.txt.bz2
bzcat snapshot.txt.bz2 | awk -F'|' '$3=="06"&&$2~/^2/&&$14!="SHBB"{print $1","$14","$7}' | sort -u | bzip2>zikan_0805.txt.bz2
 bzcat shbb_0805.txt.bz2 | awk -F',' '{print $1","$3}' | sort -u | bzip2>shbb.txt.bz2
 bzcat shbb.txt.bz2  zikan_0805.txt.bz2  | awk -F',' '{if(NF==2&&$2=="0") aa[$1]=$1;else if(($1 in aa)&&$3=="1")  print $0}' | bzip2 > zhuanting_zijihuo.txt.bz2
  bzcat shbb.txt.bz2  zikan_0805.txt.bz2  | awk -F',' '{if(NF==2&&$2=="1") aa[$1]=$1;else if(($1 in aa)&&$3=="0")  print $0}' | bzip2 > zhujihuo_zizanting.txt.bz2
    bzcat shbb.txt.bz2  zikan_0805.txt.bz2  | awk -F',' '{if(NF==2&&$2=="0") aa[$1]=$1;else if(($1 in aa)&&$3=="0")  print $0}' | bzip2 > zhuanting_zizanting.txt.bz2
    bzcat zhuanting_zijihuo.txt.bz2 | awk -F',' '{print $1}' | sort -u | wc -l
   bzcat zhujihuo_zizanting.txt.bz2 | awk -F',' '{print $1}' | sort -u | wc -l
   
   bzcat zhuanting_zizanting.txt.bz2 | awk -F',' '{print $1}' | sort -u | wc -l
