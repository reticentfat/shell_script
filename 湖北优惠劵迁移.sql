匹配出三个月都没有下行的号码
---------先找在线的-------
 bzcat /data/homeoracle/etl/data/data/snapshot/snapshot.txt.bz2 | awk -F'|' '$2=="10511024"&&$3=="06"&&$8=="027"{print $1"|"$2}' >hubei_yhj_0323.txt
    ----------然后比较---------------
    awk -F'[,|]' -v CODE_DIR=/data/match/orig/mm7/20160131/stats_month.wuxian_qianxiang.1000     '{
     if( FILENAME == CODE_DIR  )  d[$1$2]=$1 ;
         else if ( FILENAME != CODE_DIR && !($1$2 in d) ) print   $1"|"$2 ;      
        }'     /data/match/orig/mm7/20160131/stats_month.wuxian_qianxiang.1000  hubei_yhj_0323.txt > hubei_yhj_0323_1.txt
        ------7155到1949---
        
        awk -F'[,|]' -v CODE_DIR=/data/match/orig/mm7/20160229/stats_month.wuxian_qianxiang.1000     '{
     if( FILENAME == CODE_DIR  )  d[$1$2]=$1 ;
         else if ( FILENAME != CODE_DIR && !($1$2 in d) ) print   $1"|"$2 ;      
        }'     /data/match/orig/mm7/20160229/stats_month.wuxian_qianxiang.1000  hubei_yhj_0323_1.txt > hubei_yhj_0323_2.txt
       -----1949 到1802------ 
      scp  gateway@192.100.7.25:/data/match/mm7/20160322/stats_month.bizdev_shenghbb.1000  /data/homeoracle/stats_month.bizdev_shenghbb_0322.1000
      awk -F'[,|]' -v CODE_DIR=stats_month.bizdev_shenghbb_0322.1000     '{
     if( FILENAME == CODE_DIR  )  d[$1$2]=$1 ;
         else if ( FILENAME != CODE_DIR && !($1$2 in d) ) print   $1"|"$2 ;      
        }'     stats_month.bizdev_shenghbb_0322.1000  hubei_yhj_0323_2.txt > hubei_yhj_0323_3.txt
        -----------------1802个-----------------
        -----取在线且暂停的-----------
        bzcat /data/homeoracle/etl/data/data/snapshot/snapshot.txt.bz2 | awk -F'|' '$2=="10511024"&&$3=="06"&&$8=="027"&&$7=="0"{print $1"|"$2}' >hubei_yhj_zanting_0323.txt
        --------------522----
         awk -F'[,|]' -v CODE_DIR=hubei_yhj_0323_3.txt     '{
     if( FILENAME == CODE_DIR  )  d[$1$2]=$1 ;
         else if ( FILENAME != CODE_DIR && !($1$2 in d) ) print   $1"|"$2 ;      
        }'     hubei_yhj_0323_3.txt  hubei_yhj_zanting_0323.txt > hubei_yhj_zanting_0323_ok.txt
