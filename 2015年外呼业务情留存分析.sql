---27上----
/data/match/orig/20150930/snapshot.txt.bz2
---先找6月电影俱乐部彩信版新增用户
bzcat /data/match/orig/20150630/snapshot.txt.bz2 | awk -F'|' '$2=="10511008"&&$8=="0371"&&$5>="20150601000000"&&$5<"20150701000000" {print $1"|"$2 }'  | bzip2 >/home/oracle/henan_DYJLB_MMS_6yuexinzeng.txt.bz2
bzcat /data/match/orig/20150731/snapshot.txt.bz2 /home/oracle/henan_DYJLB_MMS_6yuexinzeng.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_6yuexinzeng7liucun.txt.bz2
bzcat /data/match/orig/20150831/snapshot.txt.bz2 /home/oracle/henan_DYJLB_MMS_6yuexinzeng7liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_6yuexinzeng8liucun.txt.bz2
bzcat /data/match/orig/20150930/snapshot.txt.bz2 /home/oracle/henan_DYJLB_MMS_6yuexinzeng8liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_6yuexinzeng9liucun.txt.bz2
bzcat /data/match/orig/20151031/snapshot.txt.bz2 /home/oracle/henan_DYJLB_MMS_6yuexinzeng9liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_6yuexinzeng10liucun.txt.bz2
bzcat /data/match/orig/20151130/snapshot.txt.bz2 /home/oracle/henan_DYJLB_MMS_6yuexinzeng10liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_6yuexinzeng11liucun.txt.bz2
bzcat /data/match/orig/20151231/snapshot.txt.bz2 /home/oracle/henan_DYJLB_MMS_6yuexinzeng11liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_6yuexinzeng12liucun.txt.bz2
bzcat /data/match/orig/20160131/snapshot.txt.bz2 /home/oracle/henan_DYJLB_MMS_6yuexinzeng12liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_6yuexinzeng01liucun.txt.bz2
---先找7月电影俱乐部彩信版新增用户
bzcat /data/match/orig/20150731/snapshot.txt.bz2 | awk -F'|' '$2=="10511008"&&$8=="0371"&&$5>="20150701000000"&&$5<"20150801000000" {print $1"|"$2 }'| bzip2 >/home/oracle/henan_DYJLB_MMS_7yuexinzeng.txt.bz2
bzcat /data/match/orig/20150831/snapshot.txt.bz2 /home/oracle/henan_DYJLB_MMS_7yuexinzeng.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_7yuexinzeng8liucun.txt.bz2
bzcat /data/match/orig/20150930/snapshot.txt.bz2 henan_DYJLB_MMS_7yuexinzeng8liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_7yuexinzeng9liucun.txt.bz2
bzcat /data/match/orig/20151031/snapshot.txt.bz2 henan_DYJLB_MMS_7yuexinzeng9liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_7yuexinzeng10liucun.txt.bz2
bzcat /data/match/orig/20151130/snapshot.txt.bz2 henan_DYJLB_MMS_7yuexinzeng10liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_7yuexinzeng11liucun.txt.bz2
bzcat /data/match/orig/20151231/snapshot.txt.bz2 henan_DYJLB_MMS_7yuexinzeng11liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_7yuexinzeng12liucun.txt.bz2
bzcat /data/match/orig/20160131/snapshot.txt.bz2 henan_DYJLB_MMS_7yuexinzeng12liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_7yuexinzeng01liucun.txt.bz2
---先找8月电影俱乐部彩信版新增用户
bzcat /data/match/orig/20150831/snapshot.txt.bz2 | awk -F'|' '$2=="10511008"&&$8=="0371"&&$5>="20150801000000"&&$5<"20150901000000" {print $1"|"$2 }' | bzip2 >/home/oracle/henan_DYJLB_MMS_8yuexinzeng.txt.bz2
bzcat /data/match/orig/20150930/snapshot.txt.bz2 /home/oracle/henan_DYJLB_MMS_8yuexinzeng.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_8yuexinzeng9liucun.txt.bz2
bzcat /data/match/orig/20151031/snapshot.txt.bz2 /home/oracle/henan_DYJLB_MMS_8yuexinzeng9liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_8yuexinzeng10liucun.txt.bz2
bzcat /data/match/orig/20151130/snapshot.txt.bz2 /home/oracle/henan_DYJLB_MMS_8yuexinzeng10liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_8yuexinzeng11liucun.txt.bz2
bzcat /data/match/orig/20151231/snapshot.txt.bz2 /home/oracle/henan_DYJLB_MMS_8yuexinzeng11liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_8yuexinzeng12liucun.txt.bz2
bzcat /data/match/orig/20160131/snapshot.txt.bz2 /home/oracle/henan_DYJLB_MMS_8yuexinzeng12liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_8yuexinzeng01liucun.txt.bz2
---先找9月电影俱乐部彩信版新增用户
bzcat /data/match/orig/20150930/snapshot.txt.bz2 | awk -F'|' '$2=="10511008"&&$8=="0371"&&$5>="20150901000000"&&$5<"20151001000000" {print $1"|"$2 }' | bzip2 >/home/oracle/henan_DYJLB_MMS_9yuexinzeng.txt.bz2
bzcat /data/match/orig/20151031/snapshot.txt.bz2 /home/oracle/henan_DYJLB_MMS_9yuexinzeng.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_9yuexinzeng10liucun.txt.bz2
bzcat /data/match/orig/20151130/snapshot.txt.bz2 /home/oracle/henan_DYJLB_MMS_9yuexinzeng10liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_9yuexinzeng11liucun.txt.bz2
bzcat /data/match/orig/20151231/snapshot.txt.bz2 /home/oracle/henan_DYJLB_MMS_9yuexinzeng11liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_9yuexinzeng12liucun.txt.bz2
bzcat /data/match/orig/20160131/snapshot.txt.bz2 /home/oracle/henan_DYJLB_MMS_9yuexinzeng12liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_9yuexinzeng01liucun.txt.bz2
---先找10月电影俱乐部彩信版新增用户
bzcat /data/match/orig/20151031/snapshot.txt.bz2 | awk -F'|' '$2=="10511008"&&$8=="0371"&&$5>="20151001000000"&&$5<"20151101000000" {print $1"|"$2 }' | bzip2 >/home/oracle/henan_DYJLB_MMS_10yuexinzeng.txt.bz2
bzcat /data/match/orig/20151130/snapshot.txt.bz2 /home/oracle/henan_DYJLB_MMS_10yuexinzeng.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_10yuexinzeng11liucun.txt.bz2
bzcat /data/match/orig/20151231/snapshot.txt.bz2 /home/oracle/henan_DYJLB_MMS_10yuexinzeng11liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_10yuexinzeng12liucun.txt.bz2
bzcat /data/match/orig/20160131/snapshot.txt.bz2 /home/oracle/henan_DYJLB_MMS_10yuexinzeng12liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_10yuexinzeng01liucun.txt.bz2
---先找11月电影俱乐部彩信版新增用户
bzcat /data/match/orig/20151130/snapshot.txt.bz2 | awk -F'|' '$2=="10511008"&&$8=="0371"&&$5>="20151101000000"&&$5<"20151201000000" {print $1"|"$2 }' | bzip2 >/home/oracle/henan_DYJLB_MMS_11yuexinzeng.txt.bz2
bzcat /data/match/orig/20151231/snapshot.txt.bz2 /home/oracle/henan_DYJLB_MMS_11yuexinzeng.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_11yuexinzeng12liucun.txt.bz2
bzcat /data/match/orig/20160131/snapshot.txt.bz2 /home/oracle/henan_DYJLB_MMS_12yuexinzeng.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_11yuexinzeng01liucun.txt.bz2
---先找12月电影俱乐部彩信版新增用户
bzcat /data/match/orig/20151231/snapshot.txt.bz2 | awk -F'|' '$2=="10511008"&&$8=="0371"&&$5>="20151201000000"&&$5<"20160101000000" {print $1"|"$2 }' | bzip2 >/home/oracle/henan_DYJLB_MMS_12yuexinzeng.txt.bz2
bzcat /data/match/orig/20160131/snapshot.txt.bz2 /home/oracle/henan_DYJLB_MMS_12yuexinzeng.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_12yuexinzeng01liucun.txt.bz2
----------------------------然后健康宝典彩信---------
-----7月------------------------------------------
bzcat /data/match/orig/20150731/snapshot.txt.bz2 | awk -F'|' '$2=="10511050"&&$8=="0371"&&$5>="20150701000000"&&$5<"20150801000000" {print $1"|"$2 }'| bzip2 >/home/oracle/henan_YYBS_MMS_7yuexinzeng.txt.bz2
bzcat /data/match/orig/20150831/snapshot.txt.bz2 henan_YYBS_MMS_7yuexinzeng.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511050"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_YYBS_MMS_7yuexinzeng8liucun.txt.bz2
bzcat /data/match/orig/20150930/snapshot.txt.bz2 henan_YYBS_MMS_7yuexinzeng8liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511050"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_YYBS_MMS_7yuexinzeng9liucun.txt.bz2
bzcat /data/match/orig/20151031/snapshot.txt.bz2 henan_YYBS_MMS_7yuexinzeng9liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511050"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_YYBS_MMS_7yuexinzeng10liucun.txt.bz2
bzcat /data/match/orig/20151130/snapshot.txt.bz2 henan_YYBS_MMS_7yuexinzeng10liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511050"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_YYBS_MMS_7yuexinzeng11liucun.txt.bz2
bzcat /data/match/orig/20151231/snapshot.txt.bz2 henan_YYBS_MMS_7yuexinzeng11liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511050"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_YYBS_MMS_7yuexinzeng12liucun.txt.bz2
bzcat /data/match/orig/20160131/snapshot.txt.bz2 henan_YYBS_MMS_7yuexinzeng12liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511050"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_YYBS_MMS_7yuexinzeng01liucun.txt.bz2
---------8月
bzcat /data/match/orig/20150831/snapshot.txt.bz2 | awk -F'|' '$2=="10511050"&&$8=="0371"&&$5>="20150801000000"&&$5<"20150901000000" {print $1"|"$2 }'| bzip2 >/home/oracle/henan_YYBS_MMS_08yuexinzeng.txt.bz2
bzcat /data/match/orig/20150930/snapshot.txt.bz2 henan_YYBS_MMS_08yuexinzeng.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511050"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_YYBS_MMS_8yuexinzeng9liucun.txt.bz2
bzcat /data/match/orig/20151031/snapshot.txt.bz2 henan_YYBS_MMS_8yuexinzeng9liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511050"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_YYBS_MMS_8yuexinzeng10liucun.txt.bz2
bzcat /data/match/orig/20151130/snapshot.txt.bz2 henan_YYBS_MMS_8yuexinzeng10liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511050"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_YYBS_MMS_8yuexinzeng11liucun.txt.bz2
bzcat /data/match/orig/20151231/snapshot.txt.bz2 henan_YYBS_MMS_8yuexinzeng11liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511050"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_YYBS_MMS_8yuexinzeng12liucun.txt.bz2
bzcat /data/match/orig/20160131/snapshot.txt.bz2 henan_YYBS_MMS_8yuexinzeng12liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511050"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_YYBS_MMS_8yuexinzeng01liucun.txt.bz2
---9月
bzcat /data/match/orig/20150930/snapshot.txt.bz2 | awk -F'|' '$2=="10511050"&&$8=="0371"&&$5>="20150901000000"&&$5<"20151001000000" {print $1"|"$2 }'| bzip2 >/home/oracle/henan_YYBS_MMS_9yuexinzeng.txt.bz2
bzcat /data/match/orig/20151031/snapshot.txt.bz2 henan_YYBS_MMS_9yuexinzeng.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511050"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_YYBS_MMS_9yuexinzeng10liucun.txt.bz2
bzcat /data/match/orig/20151130/snapshot.txt.bz2 henan_YYBS_MMS_9yuexinzeng10liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511050"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_YYBS_MMS_9yuexinzeng11liucun.txt.bz2
bzcat /data/match/orig/20151231/snapshot.txt.bz2 henan_YYBS_MMS_9yuexinzeng11liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511050"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_YYBS_MMS_9yuexinzeng12liucun.txt.bz2
bzcat /data/match/orig/20160131/snapshot.txt.bz2 henan_YYBS_MMS_9yuexinzeng12liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511050"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_YYBS_MMS_9yuexinzeng01liucun.txt.bz2
---10月
bzcat /data/match/orig/20151031/snapshot.txt.bz2 | awk -F'|' '$2=="10511050"&&$8=="0371"&&$5>="20151001000000"&&$5<"20151101000000" {print $1"|"$2 }'| bzip2 >/home/oracle/henan_YYBS_MMS_10yuexinzeng.txt.bz2
bzcat /data/match/orig/20151130/snapshot.txt.bz2 henan_YYBS_MMS_10yuexinzeng.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511050"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_YYBS_MMS_10yuexinzeng11liucun.txt.bz2
bzcat /data/match/orig/20151231/snapshot.txt.bz2 henan_YYBS_MMS_10yuexinzeng11liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511050"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_YYBS_MMS_10yuexinzeng12liucun.txt.bz2
bzcat /data/match/orig/20160131/snapshot.txt.bz2 henan_YYBS_MMS_10yuexinzeng12liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511050"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_YYBS_MMS_10yuexinzeng01liucun.txt.bz2
---11月
bzcat /data/match/orig/20151130/snapshot.txt.bz2 | awk -F'|' '$2=="10511050"&&$8=="0371"&&$5>="20151101000000"&&$5<"20151201000000" {print $1"|"$2 }'| bzip2 >/home/oracle/henan_YYBS_MMS_11yuexinzeng.txt.bz2
bzcat /data/match/orig/20151231/snapshot.txt.bz2 henan_YYBS_MMS_11yuexinzeng.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511050"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_YYBS_MMS_11yuexinzeng12liucun.txt.bz2
bzcat /data/match/orig/20160131/snapshot.txt.bz2 henan_YYBS_MMS_11yuexinzeng12liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511050"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_YYBS_MMS_11yuexinzeng01liucun.txt.bz2
---12月
bzcat /data/match/orig/20151231/snapshot.txt.bz2 | awk -F'|' '$2=="10511050"&&$8=="0371"&&$5>="20151201000000"&&$5<"20160101000000" {print $1"|"$2 }'| bzip2 >/home/oracle/henan_YYBS_MMS_12yuexinzeng.txt.bz2
bzcat /data/match/orig/20160131/snapshot.txt.bz2 henan_YYBS_MMS_12yuexinzeng.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10511050"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_YYBS_MMS_12yuexinzeng01liucun.txt.bz2
--------健康随行---------------------
---9月-------------
bzcat /data/match/orig/20150930/snapshot.txt.bz2 | awk -F'|' '$2=="10301085"&&$8=="0371"&&$5>="20150901000000"&&$5<"20151001000000" {print $1"|"$2 }'| bzip2 >/home/oracle/henan_JKSX_SMS_9yuexinzeng.txt.bz2
bzcat /data/match/orig/20151031/snapshot.txt.bz2 henan_JKSX_SMS_9yuexinzeng.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10301085"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_YYBS_MMS_9yuexinzeng10liucun.txt.bz2
bzcat /data/match/orig/20151130/snapshot.txt.bz2 henan_YYBS_MMS_9yuexinzeng10liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10301085"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_JKSX_SMS_9yuexinzeng11liucun.txt.bz2
bzcat /data/match/orig/20151231/snapshot.txt.bz2 henan_JKSX_SMS_9yuexinzeng11liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10301085"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_JKSX_SMS_9yuexinzeng12liucun.txt.bz2
bzcat /data/match/orig/20160131/snapshot.txt.bz2 henan_JKSX_SMS_9yuexinzeng12liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10301085"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_JKSX_SMS_9yuexinzeng01liucun.txt.bz2
-----------------10月
bzcat /data/match/orig/20151031/snapshot.txt.bz2 | awk -F'|' '$2=="10301085"&&$8=="0371"&&$5>="20151001000000"&&$5<"20151101000000" {print $1"|"$2 }'| bzip2 >/home/oracle/henan_JKSX_SMS_10yuexinzeng.txt.bz2
bzcat /data/match/orig/20151130/snapshot.txt.bz2 henan_JKSX_SMS_10yuexinzeng.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10301085"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_JKSX_SMS_10yuexinzeng11liucun.txt.bz2
bzcat /data/match/orig/20151231/snapshot.txt.bz2 henan_JKSX_SMS_10yuexinzeng11liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10301085"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_JKSX_SMS_10yuexinzeng12liucun.txt.bz2
bzcat /data/match/orig/20160131/snapshot.txt.bz2 henan_JKSX_SMS_10yuexinzeng12liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10301085"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_JKSX_SMS_10yuexinzeng01liucun.txt.bz2
---11月----
bzcat /data/match/orig/20151130/snapshot.txt.bz2 | awk -F'|' '$2=="10301085"&&$8=="0371"&&$5>="20151101000000"&&$5<"20151201000000" {print $1"|"$2 }'| bzip2 >/home/oracle/henan_JKSX_SMS_11yuexinzeng.txt.bz2
bzcat /data/match/orig/20151231/snapshot.txt.bz2 henan_JKSX_SMS_11yuexinzeng.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10301085"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_JKSX_SMS_11yuexinzeng12liucun.txt.bz2
bzcat /data/match/orig/20160131/snapshot.txt.bz2 henan_JKSX_SMS_11yuexinzeng12liucun.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10301085"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_JKSX_SMS_11yuexinzeng01liucun.txt.bz2
---12月---
bzcat /data/match/orig/20151231/snapshot.txt.bz2 | awk -F'|' '$2=="10301085"&&$8=="0371"&&$5>="20151201000000"&&$5<"20160101000000" {print $1"|"$2 }'| bzip2 >/home/oracle/henan_JKSX_SMS_12yuexinzeng.txt.bz2
bzcat /data/match/orig/20160131/snapshot.txt.bz2 henan_JKSX_SMS_12yuexinzeng.txt.bz2 | awk -F'[|^]' '{if((NF==20)&&$2=="10301085"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_JKSX_SMS_12yuexinzeng01liucun.txt.bz2
-------2月留存从plsql查-----------
select count(distinct n.mobile_sn ) 

from new_wireless_subscription n, mobilenodist m 
where substr(n.mobile_sn, 1, 7) = m.beginno 
and n.appcode ='10301085'
and n.mobile_sub_state ='3' 
and m.province = '河南' 
and n.prior_time < to_date('2016-01-01', 'yyyy-mm-dd')
and n.prior_time >= to_date('2015-12-01', 'yyyy-mm-dd')
