业务提取目前在线且激活状态用户比对9月份下发一条都没接收成功的用户量
27上
        bzcat /data/homeoracle/etl/data/data/snapshot/snapshot.txt.bz2 | awk -F'|' '($2==10511008||$2==10301101||$2==10511076||$2==10511085)&&$3==06&&$7==1{print $1"|"$2}' >1111.txt
        把10301101替换成10611009
        sed -i 's/|10301101/|10611009/g;'  1111.txt
       
          awk -F'[,|]' -v CODE_DIR=/data/match/orig/mm7/20150930/stats_month.wuxian_qianxiang.1000     '{
     if( FILENAME == CODE_DIR  )  d[$1$2]=$1 ;
         else if ( FILENAME != CODE_DIR && !($1$2 in d) ) print   $1"|"$2 ;      
        }'     /data/match/orig/mm7/20150930/stats_month.wuxian_qianxiang.1000  1111.txt > 1111_0930_1.txt
        cat 1111_0930_1.txt | awk -F'|' '$2!="10611009" {print }' > 1111_0930_2.txt
        awk -F'[,|]' -v CODE_DIR=/data/match/orig/mm7/20151031/stats_month.wuxian_qianxiang.1000     '{
     if( FILENAME == CODE_DIR  )  d[$1$2]=$1 ;
         else if ( FILENAME != CODE_DIR && !($1$2 in d) ) print   $1"|"$2 ;      
        }'     /data/match/orig/mm7/20151031/stats_month.wuxian_qianxiang.1000  1111_0930_2.txt > 1111_0930_3.txt
        awk -F'[,|]' -v CODE_DIR=/data/match/orig/mm7/20151109/stats_month.wuxian_qianxiang.1000     '{
     if( FILENAME == CODE_DIR  )  d[$1$2]=$1 ;
         else if ( FILENAME != CODE_DIR && !($1$2 in d) ) print   $1"|"$2 ;      
        }'     /data/match/orig/mm7/20151109/stats_month.wuxian_qianxiang.1000  1111_0930_3.txt > 1111_0930_4.txt
        
        
        awk -F'|' -v CODE_DIR=/data/match/orig/profile/nodist.tsv  '{
     if( FILENAME == CODE_DIR  )  d[$4]=$1 ;
         else if ( FILENAME != CODE_DIR && (substr($1,1,7) in d) ) print   $1"|"$2"|"d[substr($1,1,7)] ;      
        }'     /data/match/orig/profile/nodist.tsv  1111_0930_4.txt > 1111_0930_4_shengfen.txt
        cat 1111_0930_4_shengfen.txt | awk -F'|' '{print $2,$3}' | sort |uniq -c | sort -rn | awk '{print $2","$3","$1}'>result2.txt
        sed -i 's/10511008/电影俱乐部彩信/g;s/10511085/手机商界-商务专刊体验版彩信/g;s/10511076/手机医疗-新生活彩信/g'  result2.txt
        ---------------------------媒体生活播报业务目前在线激活的用户明细且订购时间为2015年11月1日之前的----------
         bzcat /data/homeoracle/etl/data/data/snapshot/snapshot.txt.bz2 | awk -F'|' '$2~/^2/&&$3==06&&$7==1{print $1"|"$2}' >shbb.txt
          把25上/data/match/mm7/20151115/stats_month.bizdev_shenghbb.1000传到27上
          scp  gateway@192.100.7.25:/data/match/mm7/20151115/stats_month.bizdev_shenghbb.1000  /data/homeoracle
           awk -F'[,|]' -v CODE_DIR=stats_month.bizdev_shenghbb.1000     '{
     if( FILENAME == CODE_DIR  )  d[$1$2]=$1 ;
         else if ( FILENAME != CODE_DIR && !($1$2 in d) ) print   $1"|"$2 ;      
        }'     stats_month.bizdev_shenghbb.1000  shbb.txt > shbb_1.txt
        awk -F'|' -v CODE_DIR=/data/match/orig/profile/nodist.tsv  '{
     if( FILENAME == CODE_DIR  )  d[$4]=$1 ;
         else if ( FILENAME != CODE_DIR && (substr($1,1,7) in d) ) print   $1"|"$2"|"d[substr($1,1,7)] ;      
        }'     /data/match/orig/profile/nodist.tsv  shbb_1.txt > shbb_1_shengfen.txt
        awk -F'[,|]' -v CODE_DIR=/data/homeoracle/etl/data/opt_code_all.txt  '{
     if( FILENAME == CODE_DIR  )  d[$1]=$5 ;
         else if ( FILENAME != CODE_DIR && ($2 in d) ) print   $1"|"d[$1]"|"$3 ;      
        }'     /data/homeoracle/etl/data/opt_code_all.txt  shbb_1_shengfen.txt> shbb_result.txt
        cat shbb_result.txt  | awk -F'|' '{print $2,$3}' | sort |uniq -c | sort -rn | awk '{print $2","$3","$1}'>result_1118.txt
