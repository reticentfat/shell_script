 select 
 n.province 省份,
 o.opt_cost 业务名称,

to_char(t.mobile_sub_time, 'yyyy') 订购年份,
count(t.mobile_sn) 在线的生活播报暂停用户量 
   from new_wireless_subscription_shbb t, mobilenodist n, opt_code o
  where substr(t.mobile_sn, 1, 7) = n.beginno
  and t.appcode = o.appcode
    --and t.appcode in ('10511051','10301079')
    
    and t.mobile_sub_state='3'
    and t.is_paused='0'
    group by n.province ,o.opt_cost,to_char(t.mobile_sub_time, 'yyyy')
    --提取一年内前向退订用户号码，排除截止目前前向和媒体业务在线的用户明细。并作统计：省份，退订前向业务且不在线用户量---
    --27上先把提取一年内前向退订用户号码排除
    bzcat /home/oracle/etl/data/data/snapshot/archives.txt.bz2 | awk -F'^' '$6~/^1/{print $2}' | sort -u | bzip2>tui.txt.bz2
   bzcat /data/homeoracle/etl/data/data/snapshot/snapshot.txt.bz2 | awk -F'|' '$3==06 { print $1 }'| sort -u | bzip2>zai.txt.bz2
   ---然后提取在tui.txt.bz2而不在zai.txt.bz2里边的
   bzip2 -d tui.txt.bz2 zai.txt.bz2
   awk -F',' -v CODE_DIR=zai.txt     '{
     if( FILENAME == CODE_DIR  )  d[$1]=$1 ;
         else if ( FILENAME != CODE_DIR && !($1 in d) ) print   $1 ;      
        }'     zai.txt  tui.txt > wy_ok.txt
     awk -F'|' -v CODE_DIR=/data/match/orig/profile/nodist.tsv  '{
     if( FILENAME == CODE_DIR  )  d[$4]=$1 ;
         else if ( FILENAME != CODE_DIR && (substr($1,1,7) in d) ) print   $1"|"d[substr($1,1,7)] ;      
        }'     /data/match/orig/profile/nodist.tsv  wy_ok.txt > shengfen.txt
        cat shengfen.txt | awk -F'|' '{print $2}' | sort  |uniq -c | sort -rn | awk '{print $2","$1}'>test.txt
     bzip2   shengfen.txt tui.txt zai.txt wy_ok.txt
     /data/match/mm7/20151029/stats_month.bizdev_shenghbb.1000
     20150831_stats_month.bizdev_shenghbb.1000
     20151031_stats_month.bizdev_shenghbb.1000
     20150930_stats_month.bizdev_shenghbb.1000
        bzcat /data/homeoracle/etl/data/data/snapshot/snapshot.txt.bz2 | awk -F'|' '$2~/^2/&&$3==06&&$7==0{print $1"|"$2}' >zaiting.txt 
        awk -F'[,|]' -v CODE_DIR=zaiting.txt     '{
     if( FILENAME == CODE_DIR  )  d[$1$2]=$1 ;
         else if ( FILENAME != CODE_DIR && ($1$2 in d) ) print   $1"|"$2 ;      
        }'     zaiting.txt  20150831_stats_month.bizdev_shenghbb.1000 > zaiting_0831.txt
          awk -F'[,|]' -v CODE_DIR=zaiting.txt     '{
     if( FILENAME == CODE_DIR  )  d[$1$2]=$1 ;
         else if ( FILENAME != CODE_DIR && ($1$2 in d) ) print   $1"|"$2 ;      
        }'     zaiting.txt  20150930_stats_month.bizdev_shenghbb.1000 > zaiting_0930.txt
         awk -F'[,|]' -v CODE_DIR=zaiting.txt     '{
     if( FILENAME == CODE_DIR  )  d[$1$2]=$1 ;
         else if ( FILENAME != CODE_DIR && ($1$2 in d) ) print   $1"|"$2 ;      
        }'     zaiting.txt  20151031_stats_month.bizdev_shenghbb.1000 > zaiting_1031.txt
         awk -F'|' -v CODE_DIR=/data/match/orig/profile/nodist.tsv  '{
     if( FILENAME == CODE_DIR  )  d[$4]=$1 ;
         else if ( FILENAME != CODE_DIR && (substr($1,1,7) in d) ) print   $1"|"$2"|"d[substr($1,1,7)] ;      
        }'     /data/match/orig/profile/nodist.tsv  zanting.txt > zanting_shengfen.txt
        awk -F'|' -v CODE_DIR=/data/match/orig/profile/nodist.tsv  '{
     if( FILENAME == CODE_DIR  )  d[$4]=$1 ;
         else if ( FILENAME != CODE_DIR && (substr($1,1,7) in d) ) print   $1"|"$2"|"d[substr($1,1,7)] ;      
        }'     /data/match/orig/profile/nodist.tsv  zanting.txt > zanting_shengfen.txt
    cat zanting_shengfen.txt  | awk -F'|' '{print $2,$3}' | sort |uniq -c | sort -rn | awk '{print $2","$3","$1}'>result1.txt
     /data/homeoracle/etl/data/opt_code_all.txt
     awk -F'|' -v CODE_DIR=/data/homeoracle/etl/data/opt_code_all.txt  '{
     if( FILENAME == CODE_DIR  )  d[$1]=$5 ;
         else if ( FILENAME != CODE_DIR && ($1 in d) ) print   d[$1]"|"$2"|"$3 ;      
        }'     /data/homeoracle/etl/data/opt_code_all.txt  result1.txt > zanting_result.txt
