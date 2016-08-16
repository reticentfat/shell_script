---27上
bzcat /home/oracle/wy.txt.bz2  /data/match/orig/20160630/snapshot.txt.bz2  | awk -F'|' '{if(NF==2) aa[$1]=$1;else if($2=="10511050"&&($1 in aa)&&$8=="0371")  print $1","$2","$3","$8","$14","$5}' | bzip2 > /home/oracle/123.txt.bz2
