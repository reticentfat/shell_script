----------20101228------------
5.	数据统计	截止25日收入
	210：
	8 10 28 12 * sh  /home/oracle/etl/bin/qx_newincome.sh 20101225 20101128000000 20101201000000 20101225000000 20101225
	-------------------------sh
	#! /usr/bin/ksh
export PATH=/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/data/app/oracle/product/11.2.0/db/bin/
export ORACLE_HOME=/data/app/oracle/product/11.2.0/db

export ORACLE_SID=wreportdb
ORACLE_NLS=$ORACLE_HOME/nls/data ;
export ORACLE_NLS
NLS_LANG="simplified chinese"_china.ZHS16CGB231280 ;
export NLS_LANG
usage () {
    echo "usage: $0 REPORT_DIR " 1>&2
    exit 2
}

if [ $# -lt 5 ] ; then
    usage
fi



###留存用户
###20100930000000
DATE_LAST=$1
###20100829000000
DATE_FIRST=$2
###20100901000000
DATE_BEGIN=$3 
###20100928000000
DATE_END=$4 
####
DATE_SUC=$5 
##创建目录
cd /data/match/new_income/
if [ ! -d "$DATE_LAST" ]; then
   mkdir $DATE_LAST   
fi    

bzcat /data/match/orig/${DATE_LAST}/snapshot.txt.bz2 | awk -F '|' -v first_date=${DATE_FIRST} -v begin_date=${DATE_BEGIN} '{ if(  $3 == "06" && $5 < first_date  )  print $1","$2","$3","$5",99991230000000,lcyh" ; else if (  $3 == "07" &&  $4 >=begin_date && $5 < first_date ) print $1","$2","$3","$5","$4",lcyh" }'  > /data/match/new_income/${DATE_LAST}/qx_${DATE_LAST}.txt
###bzcat /data/match/orig/20100930/snapshot.txt.bz2 | awk -F '|' -v first_date='20100829000000' -v begin_date='20100901000000' '{ if(  $3 == "06" && $5 < first_date )  print $1","$2","$3","$5",99991230000000,lcyh" ; else if(  $3 == "07" &&  $4 >=begin_date && $5 < first_date ) print $1","$2","$3","$5","$4",lcyh"  }'  | head
bzcat /data/match/orig/${DATE_LAST}/user_sn.txt.bz2 | awk -F '|' -v first_date=${DATE_FIRST}  -v begin_date=${DATE_BEGIN} '{ if(  $3 == "06" && $5 < first_date )  print $1","$2","$3","$5",99991230000000,lcyh" ; else if(  $3 == "07" &&  $4 >=begin_date && $5 < first_date ) print $1","$2","$3","$5","$4",lcyh" }'  >> /data/match/new_income/${DATE_LAST}/qx_${DATE_LAST}.txt
####bzcat /data/match/orig/20100930/user_sn.txt.bz2 | awk -F '|' -v first_date='20100829000000' -v begin_date='20100901000000' '{ if(  $3 == "06" && $5 < first_date )  print $1","$2","$3","$5",99991230000000,lcyh" ; else if(  $3 == "07" &&  $4 >=begin_date && $5 < first_date ) print $1","$2","$3","$5","$4",lcyh"  }'  | head


###新增用户满足72小时
bzcat /data/match/orig/${DATE_LAST}/snapshot.txt.bz2 | awk -F '|' -v first_date=${DATE_FIRST} -v last_date=${DATE_END} '{ if (  $3 == "06" && $5 >= first_date && $5 < last_date  ) print $1","$2","$3","$5",99991230000000,xzyh" ; else if ( $3 == "07" &&  $5 >= first_date && $5 < last_date &&  ( $4 - $5 ) > 3000000 ) print $1","$2","$3","$5","$4",xzyh" }'  >> /data/match/new_income/${DATE_LAST}/qx_${DATE_LAST}.txt
##bzcat /data/match/orig/20100930/snapshot.txt.bz2 | awk -F '|' -v first_date='20100829000000' -v last_date='20100928000000' '{ if ( $3 == "06" && $5 >= first_date && $5 < last_date  ) print $1","$2","$3","$5",99991230000000,xzyh" ; else if ( $3 == "07" &&  $5 >= first_date && $5 < last_date &&  ( $4 - $5 ) > 3000000 ) print $1","$2","$3","$5","$4",xzyh" }' | head 
bzcat /data/match/orig/${DATE_LAST}/user_sn.txt.bz2 | awk -F '|' -v first_date=${DATE_FIRST} -v last_date=${DATE_END} '{ if (  $3 == "06" && $5 >= first_date && $5 < last_date  ) print $1","$2","$3","$5",99991230000000,xzyh" ; else if ( $3 == "07" &&  $5 >= first_date && $5 < last_date &&  ( $4 - $5 ) > 3000000 ) print $1","$2","$3","$5","$4",xzyh" }'  >> /data/match/new_income/${DATE_LAST}/qx_${DATE_LAST}.txt
##bzcat /data/match/orig/20100930/user_sn.txt.bz2 | awk -F '|' -v first_date='20100829000000' -v last_date='20100928000000' '{ if ( $3 == "06" && $5 >= first_date && $5 < last_date  ) print $1","$2","$3","$5",99991230000000,xzyh" ; else if ( $3 == "07" &&  $5 >= first_date && $5 < last_date &&  ( $4 - $5 ) > 3000000 ) print $1","$2","$3","$5","$4",xzyh" }' | head 

rm /data/match/new_income/${DATE_LAST}/qx_${DATE_LAST}_ok.txt

awk  -F',' -v CODE_DIR=/data/match/orig/mm7/${DATE_SUC}/stats_month.wuxian_qianxiang.0  -v fileok=/data/match/new_income/${DATE_LAST}/qx_${DATE_SUC}_ok.txt '{
        if( FILENAME == CODE_DIR )  d[$1$2]=$1","$2","$3;
         else if ( FILENAME != CODE_DIR &&  substr($2,1,3) == "103"  &&  $1$2 in d ) print  d[$1$2]","$0 >> fileok ;
        }' /data/match/orig/mm7/${DATE_SUC}/stats_month.wuxian_qianxiang.0    /data/match/new_income/${DATE_LAST}/qx_${DATE_LAST}.txt
        
        
awk  -F',' -v CODE_DIR=/data/match/orig/mm7/${DATE_SUC}/stats_month.wuxian_qianxiang.1000  -v CODE_DIR1=/home/oracle/etl/data/stats_month.bizdev_shenghbb.1000  -v fileok=/data/match/new_income/${DATE_LAST}/qx_${DATE_SUC}_ok.txt '{
        if( FILENAME == CODE_DIR )  d[$1$2]=$1","$2","$3;
         else if ( FILENAME == CODE_DIR1 )  d[$1$2]=$1","$2","$3;
         else if ( FILENAME != CODE_DIR &&  FILENAME != CODE_DIR1  &&  (substr($2,1,3) == "105" || substr($2,1,1) == "2" )  &&  $1$2 in d ) print  d[$1$2]","$0 >> fileok ;       
  }'  /data/match/orig/mm7/${DATE_SUC}/stats_month.wuxian_qianxiang.1000  /home/oracle/etl/data/stats_month.bizdev_shenghbb.1000  /data/match/new_income/${DATE_LAST}/qx_${DATE_LAST}.txt
         
##rm /data/match/new_income/${DATE_LAST}/*.bz2        
##bzip2 -k /data/match/new_income/${DATE_LAST}/qx_${DATE_LAST}_ok.txt 
  bzip2 -k /data/match/new_income/${DATE_LAST}/qx_${DATE_SUC}_ok.txt  
  
