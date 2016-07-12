---27上
--------2月新增计费用户留存-----------
cat /data/2016/20160228/qiangxiang_mms_pay_users.txt | awk -F',' '$2=="10511008"&&$5=="371"{print  $1","$2}' >2yue_henan_DYJLB_MMS_pay_users.txt
----匹配下行，有一条下行就可以计费-------------------
awk -F',' -v CODE_DIR=/data/match/orig/mm7/20160228/stats_month.wuxian_qianxiang.1000     '{
     if( FILENAME == CODE_DIR  )  d[$1$2]=$1 ;
         else if ( FILENAME != CODE_DIR && ($1$2 in d) ) print   $1"|"$2 ;      
        }'     /data/match/orig/mm7/20160228/stats_month.wuxian_qianxiang.1000  2yue_henan_DYJLB_MMS_pay_users.txt > 2yue_henan_DYJLB_MMS_pay_users_final.txt
        ---------------------------然后匹配2月新增符合72小时用户----------------
 awk -F'|' -v CODE_DIR=2yue_henan_DYJLB_MMS_pay_users_final.txt     '{
     if( FILENAME == CODE_DIR  )  d[$1$2]=$1$2 ;
         else if ( FILENAME != CODE_DIR && ($1$2 in d) ) print   $1"|"$2 ;      
        }'     2yue_henan_DYJLB_MMS_pay_users_final.txt  2yue-hn-flbk.txt > 2yue-hn-flbk-pipei.txt
        -----------13403731737|10511008
        --------------------匹配三月是否留存-------------------------------------
         bzip2 -z 2yue-hn-flbk-pipei.txt
 ----bzcat /data/match/orig/20150630/snapshot.txt.bz2 | awk -F'|' '$2=="10511008"&&$8=="0371"&&$5>="20150601000000"&&$5<"20150701000000" {print $1"|"$2 }'  | bzip2 >/home/oracle/henan_DYJLB_MMS_6yuexinzeng.txt.bz2
bzcat /data/match/orig/20160331/snapshot.txt.bz2 /home/oracle/2yue-hn-flbk-pipei.txt.bz2 | awk -F'|' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_2yuexinzeng3liucun.txt.bz2
bzcat /data/match/orig/20160430/snapshot.txt.bz2 /home/oracle/henan_DYJLB_MMS_2yuexinzeng3liucun.txt.bz2 | awk -F'|' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_2yuexinzeng4liucun.txt.bz2
bzcat /data/match/orig/20160531/snapshot.txt.bz2 /home/oracle/henan_DYJLB_MMS_2yuexinzeng4liucun.txt.bz2 | awk -F'|' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_2yuexinzeng5liucun.txt.bz2
bzcat /data/match/orig/20160630/snapshot.txt.bz2 /home/oracle/henan_DYJLB_MMS_2yuexinzeng5liucun.txt.bz2 | awk -F'|' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_2yuexinzeng6liucun.txt.bz2
-----------------------3月新增计费用户留存---------
cat /data/2016/20160331/qiangxiang_mms_pay_users.txt | awk -F',' '$2=="10511008"&&$5=="371"{print  $1","$2}' >3yue_henan_DYJLB_MMS_pay_users.txt
----匹配下行，有一条下行就可以计费-------------------
awk -F',' -v CODE_DIR=/data/match/orig/mm7/20160331/stats_month.wuxian_qianxiang.1000     '{
     if( FILENAME == CODE_DIR  )  d[$1$2]=$1 ;
         else if ( FILENAME != CODE_DIR && ($1$2 in d) ) print   $1"|"$2 ;      
        }'     /data/match/orig/mm7/20160331/stats_month.wuxian_qianxiang.1000  3yue_henan_DYJLB_MMS_pay_users.txt > 3yue_henan_DYJLB_MMS_pay_users_final.txt
        -----------------然后匹配3月新增符合72小时用户---
        awk -F'|' -v CODE_DIR=3yue_henan_DYJLB_MMS_pay_users_final.txt     '{
     if( FILENAME == CODE_DIR  )  d[$1$2]=$1$2 ;
         else if ( FILENAME != CODE_DIR && ($1$2 in d) ) print   $1"|"$2 ;      
        }'     3yue_henan_DYJLB_MMS_pay_users_final.txt  3yue-hn-flbk.txt > 3yue-hn-flbk-pipei.txt
        -------------匹配四月是否留存---------------
             bzip2 -z 3yue-hn-flbk-pipei.txt
        bzcat /data/match/orig/20160430/snapshot.txt.bz2 /home/oracle/3yue-hn-flbk-pipei.txt.bz2 | awk -F'|' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_3yuexinzeng4liucun.txt.bz2
bzcat /data/match/orig/20160531/snapshot.txt.bz2 /home/oracle/henan_DYJLB_MMS_3yuexinzeng4liucun.txt.bz2 | awk -F'|' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_3yuexinzeng5liucun.txt.bz2
bzcat /data/match/orig/20160630/snapshot.txt.bz2 /home/oracle/henan_DYJLB_MMS_3yuexinzeng5liucun.txt.bz2 | awk -F'|' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_3yuexinzeng6liucun.txt.bz2
-----------------------4月新增计费用户留存---------
cat /data/2016/20160430/qiangxiang_mms_pay_users.txt | awk -F',' '$2=="10511008"&&$5=="371"{print  $1","$2}' >4yue_henan_DYJLB_MMS_pay_users.txt
----匹配下行，有一条下行就可以计费-------------------
awk -F',' -v CODE_DIR=/data/match/orig/mm7/20160430/stats_month.wuxian_qianxiang.1000     '{
     if( FILENAME == CODE_DIR  )  d[$1$2]=$1 ;
         else if ( FILENAME != CODE_DIR && ($1$2 in d) ) print   $1"|"$2 ;      
        }'     /data/match/orig/mm7/20160430/stats_month.wuxian_qianxiang.1000  4yue_henan_DYJLB_MMS_pay_users.txt > 4yue_henan_DYJLB_MMS_pay_users_final.txt
        ----------------
                -----------------然后匹配4月新增符合72小时用户---
        awk -F'|' -v CODE_DIR=4yue_henan_DYJLB_MMS_pay_users_final.txt     '{
     if( FILENAME == CODE_DIR  )  d[$1$2]=$1$2 ;
         else if ( FILENAME != CODE_DIR && ($1$2 in d) ) print   $1"|"$2 ;      
        }'     4yue_henan_DYJLB_MMS_pay_users_final.txt  4yue-hn-flbk.txt > 4yue-hn-flbk-pipei.txt
        -------------匹配四月是否留存---------------
             bzip2 -z 4yue-hn-flbk-pipei.txt
        bzcat /data/match/orig/20160531/snapshot.txt.bz2 /home/oracle/4yue-hn-flbk-pipei.txt.bz2 | awk -F'|' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_4yuexinzeng5liucun.txt.bz2
bzcat /data/match/orig/20160630/snapshot.txt.bz2 /home/oracle/henan_DYJLB_MMS_4yuexinzeng5liucun.txt.bz2 | awk -F'|' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_4yuexinzeng6liucun.txt.bz2
        
-----------------------5月新增计费用户留存---------
cat /data/2016/20160531/qiangxiang_mms_pay_users.txt | awk -F',' '$2=="10511008"&&$5=="371"{print  $1","$2}' >5yue_henan_DYJLB_MMS_pay_users.txt
----匹配下行，有一条下行就可以计费-------------------
awk -F',' -v CODE_DIR=/data/match/orig/mm7/20160531/stats_month.wuxian_qianxiang.1000     '{
     if( FILENAME == CODE_DIR  )  d[$1$2]=$1 ;
         else if ( FILENAME != CODE_DIR && ($1$2 in d) ) print   $1"|"$2 ;      
        }'     /data/match/orig/mm7/20160531/stats_month.wuxian_qianxiang.1000  5yue_henan_DYJLB_MMS_pay_users.txt > 5yue_henan_DYJLB_MMS_pay_users_final.txt
        ----------------
                -----------------然后匹配5月新增符合72小时用户---
        awk -F'|' -v CODE_DIR=5yue_henan_DYJLB_MMS_pay_users_final.txt     '{
     if( FILENAME == CODE_DIR  )  d[$1$2]=$1$2 ;
         else if ( FILENAME != CODE_DIR && ($1$2 in d) ) print   $1"|"$2 ;      
        }'     5yue_henan_DYJLB_MMS_pay_users_final.txt  5yue-hn-flbk.txt > 5yue-hn-flbk-pipei.txt
        -------------匹配四月是否留存---------------
             bzip2 -z 5yue-hn-flbk-pipei.txt
        bzcat /data/match/orig/20160630/snapshot.txt.bz2 /home/oracle/5yue-hn-flbk-pipei.txt.bz2 | awk -F'|' '{if((NF==20)&&$2=="10511008"&&$8=="0371"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > henan_DYJLB_MMS_5yuexinzeng6liucun.txt.bz2

        

