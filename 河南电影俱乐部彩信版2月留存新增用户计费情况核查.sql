---27上
---先找2月初留存
oracle@wreport:/home/oracle$ bzcat /data/match/orig/20160130/snapshot.txt.bz2 | awk -F'|' '$2==10511008&&$3==06&&$8=="0371"{print }' >henan_DYJLB_MMS_1yue.txt
---2月新增
oracle@wreport:/home/oracle$ bzcat /data/match/orig/20160228/snapshot.txt.bz2 | awk -F'|' '$2==10511008&&$8=="0371"&&$5>=20160201000000&&$5<20160301000000{print }' >henan_DYJLB_MMS_2yuexinzeng.txt
oracle@wreport:/home/oracle$ cat henan_DYJLB_MMS_1yue.txt henan_DYJLB_MMS_2yuexinzeng.txt > wy.txt
oracle@wreport:/home/oracle$ cat wy.txt | awk -F'|' '{print $1"|"$2}' | bzip2>wy.txt.bz2
--然后匹配这75841用户在2月底的情况
oracle@wreport:/home/oracle$ bzcat /data/match/orig/20160228/snapshot.txt.bz2 /home/oracle/wy.txt.bz2  | awk -F'|' '{if($2==10511008&&$8=="0371") aa[$1$2]=$0;else if(NF==2&&($1$2 in aa))  print aa[$1$2] }' | bzip2 > /home/oracle/hn_dy_2yue.txt.bz2
cat hn_dy_2yue.txt | awk -F'|' '{if ($3=="06") print $1"|"$2"|"$9"|"$4"|99999999999999";else if ($3=="07") print $1"|"$2"|"$9"|"$5"|"$4}' > henan2yue.txt
------然后匹配下行
oracle@wreport:/home/oracle$ bzcat hn_dy_2yue.txt.bz2 | awk -F'|' '{print $1","$2}' >hndyjlb.txt
awk -F',' -v CODE_DIR=/data/match/orig/mm7/20160228/stats_month.wuxian_qianxiang.1000  -v fileok=hndyjlb_ok.txt   '{
     if( FILENAME == CODE_DIR  )  d[$1$2]=$1","$2","$3 ;
         else if ( FILENAME != CODE_DIR && ($1$2 in d) ) print   d[$1$2]","$0 >> fileok ; 
         else if ( FILENAME != CODE_DIR && !($1$2 in d) ) print   $1","$2",0,"$0 >> fileok ;      
        }'     /data/match/orig/mm7/20160228/stats_month.wuxian_qianxiang.1000  hndyjlb.txt
        --------------------------------------------------------
        awk  -F',' -v CODE_DIR=/data0/match/orig/mm7/20100930/stats_month.wuxian_qianxiang.1000 -v fileok=cxzkq_ok.txt '{
	if( FILENAME == CODE_DIR  )  d[$1$2]=$1","$2","$3;
	 else if ( FILENAME != CODE_DIR &&  substr($2,1,3) == "105"   &&  $1$2 in d ) print d[$1$2]","$0 >> fileok ;
	 else if ( FILENAME != CODE_DIR &&  substr($2,1,3) == "105"   && !($1$2 in d )) print $1","$2",0,"$0 >> fileok ;
	}' /data0/match/orig/mm7/20100930/stats_month.wuxian_qianxiang.1000     cxzkq.txt
