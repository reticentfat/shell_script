#! /bin/sh

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
if [ $# -lt 4 ] ; then
    usage
fi
###20151231
DATE_LAST=$1
###20151128000000
DATE_FIRST=$2
###20151201000000
DATE_BEGIN=$3 
###20151229000000
DATE_END=$4 
 
##创建目录
cd /data/match/new_income/
if [ ! -d "$DATE_LAST" ]; then
   mkdir $DATE_LAST   
fi
###留存用户
bzcat /data/match/orig/${DATE_LAST}/snapshot.txt.bz2 | awk -F '|' -v first_date=${DATE_FIRST} -v begin_date=${DATE_BEGIN} '{ if(  $3 == "06" && $5 < first_date  )  print $1","$2","$3","$5",99991230000000,lcyh" ; else if (  $3 == "07" &&  $4 >=begin_date && $5 < first_date ) print $1","$2","$3","$5","$4",lcyh" }'  > /data/match/new_income/${DATE_LAST}/qx_${DATE_LAST}_isjf.txt
###bzcat /data/match/orig/20100930/snapshot.txt.bz2 | awk -F '|' -v first_date='20100829000000' -v begin_date='20100901000000' '{ if(  $3 == "06" && $5 < first_date )  print $1","$2","$3","$5",99991230000000,lcyh" ; else if(  $3 == "07" &&  $4 >=begin_date && $5 < first_date ) print $1","$2","$3","$5","$4",lcyh"  }'  | head
bzcat /data/match/orig/${DATE_LAST}/user_sn.txt.bz2 | awk -F '|' -v first_date=${DATE_FIRST}  -v begin_date=${DATE_BEGIN} '{ if(  $3 == "06" && $5 < first_date )  print $1","$2","$3","$5",99991230000000,lcyh" ; else if(  $3 == "07" &&  $4 >=begin_date && $5 < first_date ) print $1","$2","$3","$5","$4",lcyh" }'  >> /data/match/new_income/${DATE_LAST}/qx_${DATE_LAST}_isjf.txt
####bzcat /data/match/orig/20100930/user_sn.txt.bz2 | awk -F '|' -v first_date='20100829000000' -v begin_date='20100901000000' '{ if(  $3 == "06" && $5 < first_date )  print $1","$2","$3","$5",99991230000000,lcyh" ; else if(  $3 == "07" &&  $4 >=begin_date && $5 < first_date ) print $1","$2","$3","$5","$4",lcyh"  }'  | head
###新增用户满足72小时
bzcat /data/match/orig/${DATE_LAST}/snapshot.txt.bz2 | awk -F '|' -v first_date=${DATE_FIRST} -v last_date=${DATE_END} '{ if (  $3 == "06" && $5 >= first_date && $5 < last_date  ) print $1","$2","$3","$5",99991230000000,xzyh" ; else if ( $3 == "07" &&  $5 >= first_date && $5 < last_date &&  ( $4 - $5 ) > 3000000 ) print $1","$2","$3","$5","$4",xzyh" }'  >> /data/match/new_income/${DATE_LAST}/qx_${DATE_LAST}_isjf.txt
##bzcat /data/match/orig/20100930/snapshot.txt.bz2 | awk -F '|' -v first_date='20100829000000' -v last_date='20100928000000' '{ if ( $3 == "06" && $5 >= first_date && $5 < last_date  ) print $1","$2","$3","$5",99991230000000,xzyh" ; else if ( $3 == "07" &&  $5 >= first_date && $5 < last_date &&  ( $4 - $5 ) > 3000000 ) print $1","$2","$3","$5","$4",xzyh" }' | head 
bzcat /data/match/orig/${DATE_LAST}/user_sn.txt.bz2 | awk -F '|' -v first_date=${DATE_FIRST} -v last_date=${DATE_END} '{ if (  $3 == "06" && $5 >= first_date && $5 < last_date  ) print $1","$2","$3","$5",99991230000000,xzyh" ; else if ( $3 == "07" &&  $5 >= first_date && $5 < last_date &&  ( $4 - $5 ) > 3000000 ) print $1","$2","$3","$5","$4",xzyh" }'  >> /data/match/new_income/${DATE_LAST}/qx_${DATE_LAST}_isjf.txt
##bzcat /data/match/orig/20100930/user_sn.txt.bz2 | awk -F '|' -v first_date='20100829000000' -v last_date='20100928000000' '{ if ( $3 == "06" && $5 >= first_date && $5 < last_date  ) print $1","$2","$3","$5",99991230000000,xzyh" ; else if ( $3 == "07" &&  $5 >= first_date && $5 < last_date &&  ( $4 - $5 ) > 3000000 ) print $1","$2","$3","$5","$4",xzyh" }' | head 
###新增用户不满足72小时
bzcat /data/match/orig/${DATE_LAST}/snapshot.txt.bz2 | awk -F '|' -v first_date=${DATE_FIRST} -v last_date=${DATE_END} '{ if ( $3 == "07" &&  $5 >= first_date && $5 < last_date &&  ( $4 - $5 ) <= 3000000 ) print $1","$2","$3","$5","$4",xzyh,否" }'  > /data/match/new_income/${DATE_LAST}/qx_${DATE_LAST}_isjf72.txt
##bzcat /data/match/orig/20151231/snapshot.txt.bz2 | awk -F '|' -v first_date='20151128000000' -v last_date='20151229000000' '{ if ( $3 == "07" &&  $5 >= first_date && $5 < last_date &&  ( $4 - $5 ) <= 3000000 ) print $1","$2","$3","$5","$4",xzyh,否" }' | head  
bzcat /data/match/orig/${DATE_LAST}/user_sn.txt.bz2 | awk -F '|' -v first_date=${DATE_FIRST} -v last_date=${DATE_END} '{ if ( $3 == "07" &&  $5 >= first_date && $5 < last_date &&  ( $4 - $5 ) <= 3000000 ) print $1","$2","$3","$5","$4",xzyh,否" }'  >> /data/match/new_income/${DATE_LAST}/qx_${DATE_LAST}_isjf72.txt
##bzcat /data/match/orig/20151231/user_sn.txt.bz2 | awk -F '|' -v first_date='20151128000000' -v last_date='20151229000000' '{ if ( $3 == "07" &&  $5 >= first_date && $5 < last_date &&  ( $4 - $5 ) <= 3000000 ) print $1","$2","$3","$5","$4",xzyh,否" }' | head 
rm /data/match/new_income/${DATE_LAST}/qx_${DATE_LAST}_isjf_ok.txt
awk  -F',' -v CODE_DIR=/data/match/orig/mm7/${DATE_LAST}/stats_month.wuxian_qianxiang.0 -v fileok=/data/match/new_income/${DATE_LAST}/qx_${DATE_LAST}_isjf_ok.txt '{
if( FILENAME == CODE_DIR )  d[$1$2]=$1","$2","$3;
 else if ( FILENAME != CODE_DIR &&  substr($2,1,3) == "103"  &&  $1$2 in d ) print  d[$1$2]","$0 >> fileok ;
 else if ( FILENAME != CODE_DIR &&  substr($2,1,3) == "103"  && !($1$2 in d )) print $1","$2",0,"$0 >> fileok ;
}' /data/match/orig/mm7/${DATE_LAST}/stats_month.wuxian_qianxiang.0    /data/match/new_income/${DATE_LAST}/qx_${DATE_LAST}_isjf.txt
awk  -F',' -v CODE_DIR=/data/match/orig/mm7/${DATE_LAST}/stats_month.wuxian_qianxiang.1000 -v fileok=/data/match/new_income/${DATE_LAST}/qx_${DATE_LAST}_isjf_ok.txt '{
if( FILENAME == CODE_DIR )  d[$1$2]=$1","$2","$3;
 else if ( FILENAME != CODE_DIR &&  substr($2,1,3) == "105"  &&  $1$2 in d ) print  d[$1$2]","$0 >> fileok ;
 else if ( FILENAME != CODE_DIR &&  substr($2,1,3) == "105"  && !($1$2 in d )) print $1","$2",0,"$0 >> fileok ;
}' /data/match/orig/mm7/${DATE_LAST}/stats_month.wuxian_qianxiang.1000    /data/match/new_income/${DATE_LAST}/qx_${DATE_LAST}_isjf.txt
cd /data/match/new_income/${DATE_LAST}/
if [ ! -d "province_isjf" ]; then
   mkdir province_isjf   
fi
cd /data/match/new_income/${DATE_LAST}/province_isjf/
rm *.*
awk -F',' -v NODIST_DIR=/data/match/orig/profile/nodist.tsv -v OPTCODE_DIR=/home/oracle/etl/data/optcode.txt -v data_last=${DATE_LAST} '{
if(FILENAME == NODIST_DIR){split($0,tmp,"|");p=tmp[1];c=tmp[2];m=tmp[4];nodist[m]=p","c;}
else if(FILENAME == OPTCODE_DIR) optcode[$3] = $7","$4;
else{if($2 in optcode){nod=substr($1,1,7);split(nodist[nod],t1,",");province=t1[1];city=t1[2];split(optcode[$2],t2,",");optcost=t2[1];
jfcode=t2[2];out="/data/match/new_income/"data_last"/province_isjf/"province".txt";
subtime=substr($7,1,4)"-"substr($7,5,2)"-"substr($7,7,2)" "substr($7,9,2)":"substr($7,11,2)":"substr($7,13,2);
unsubtime=substr($8,1,4)"-"substr($8,5,2)"-"substr($8,7,2)" "substr($8,9,2)":"substr($8,11,2)":"substr($8,13,2);
print $1","$2","$3","$4","$5","optcost","province","city","subtime","unsubtime","jfcode","$6","$9 >> out;}}
}' /data/match/orig/profile/nodist.tsv /home/oracle/etl/data/optcode.txt /data/match/new_income/${DATE_LAST}/qx_${DATE_LAST}_isjf_ok.txt
    
bzip2 /data/match/new_income/${DATE_LAST}/province_isjf/*.txt 
cd /data/match/new_income/${DATE_LAST}/
if [ ! -d "province_isjf72" ]; then
   mkdir province_isjf72   
fi
cd /data/match/new_income/${DATE_LAST}/province_isjf72/
rm *.*
awk -F',' -v NODIST_DIR=/data/match/orig/profile/nodist.tsv -v OPTCODE_DIR=/home/oracle/etl/data/optcode.txt -v data_last=${DATE_LAST} '{
if(FILENAME == NODIST_DIR){split($0,tmp,"|");p=tmp[1];c=tmp[2];m=tmp[4];nodist[m]=p","c;}
else if(FILENAME == OPTCODE_DIR) optcode[$3] = $7","$4;
else{if($2 in optcode){nod=substr($1,1,7);split(nodist[nod],t1,",");province=t1[1];city=t1[2];split(optcode[$2],t2,",");optcost=t2[1];
jfcode=t2[2];out="/data/match/new_income/"data_last"/province_isjf72/"province".txt";
subtime=substr($4,1,4)"-"substr($4,5,2)"-"substr($4,7,2)" "substr($4,9,2)":"substr($4,11,2)":"substr($4,13,2);
unsubtime=substr($5,1,4)"-"substr($5,5,2)"-"substr($5,7,2)" "substr($5,9,2)":"substr($5,11,2)":"substr($5,13,2);
print $1","$2","optcost","province","city","subtime","unsubtime","jfcode","$3","$6","$7 >> out;}}
}' /data/match/orig/profile/nodist.tsv /home/oracle/etl/data/optcode.txt /data/match/new_income/${DATE_LAST}/qx_${DATE_LAST}_isjf72.txt
    
bzip2 /data/match/new_income/${DATE_LAST}/province_isjf72/*.txt 

bzip2 /data/match/new_income/${DATE_LAST}/qx_${DATE_LAST}_isjf.txt
bzip2 /data/match/new_income/${DATE_LAST}/qx_${DATE_LAST}_isjf_ok.txt
bzip2 /data/match/new_income/${DATE_LAST}/qx_${DATE_LAST}_isjf72.txt

