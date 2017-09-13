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
###020
PROVINCE=$5
 
##创建目录
cd /data/gd_jf/
rm *.txt
if [ ! -d "$DATE_LAST" ]; then
   mkdir $DATE_LAST   
fi
###留存用户
bzcat /data/match/orig/${DATE_LAST}/snapshot.txt.bz2 | awk -F '|' -v first_date=${DATE_FIRST} -v begin_date=${DATE_BEGIN} -v province_code=${PROVINCE} '{ if(  $3 == "06" && $8==province_code && $5 < first_date  )  print $1","$2","$3","$5",99991230000000,lcyh" ; else if (  $3 == "07" && $8==province_code && $4 >=begin_date && $5 < first_date ) print $1","$2","$3","$5","$4",lcyh" }'  > /data/gd_jf//${DATE_LAST}/gd_${DATE_LAST}_isjf.txt
###新增用户满足72小时
bzcat /data/match/orig/${DATE_LAST}/snapshot.txt.bz2 | awk -F '|' -v first_date=${DATE_FIRST} -v last_date=${DATE_END} -v province_code=${PROVINCE} '{ if (  $3 == "06" && $8==province_code && $5 >= first_date && $5 < last_date  ) print $1","$2","$3","$5",99991230000000,xzyh" ; else if ( $3 == "07" &&  $8==province_code && $5 >= first_date && $5 < last_date &&  ( $4 - $5 ) > 3000000 ) print $1","$2","$3","$5","$4",xzyh" }'  >> /data/gd_jf/${DATE_LAST}/gd_${DATE_LAST}_isjf.txt
cat /data/gd_jf/${DATE_LAST}/gd_${DATE_LAST}_isjf.txt | awk -F',' '$2 == "10511055"	|| $2 == "10511052"	|| $2 == "10511003"	|| $2 == "10511004"	|| $2 == "10511050"	|| $2 == "10511005"	|| $2 == "10511019"	|| $2 == "10511020"	|| $2 == "10511022"	|| $2 == "10511051" {print $0 }' > /data/gd_jf/10_gaizao.txt
#cat /data/gd_jf/20170630/gd_20170630_isjf.txt | awk -F',' '$2 == "10511055"	|| $2 == "10511052"	|| $2 == "10511003"	|| $2 == "10511004"	|| $2 == "10511050"	|| $2 == "10511005"	|| $2 == "10511019"	|| $2 == "10511020"	|| $2 == "10511022"	|| $2 == "10511051" {print $0 }' > /data/gd_jf/10_gaizao.txt
awk  -F',' -v CODE_DIR=/data/match/orig/mm7/${DATE_LAST}/stats_month.wuxian_qianxiang.1000 -v fileok=/data/gd_jf/gd_mms_others.txt '{
if( FILENAME == CODE_DIR && $2 != "10511055"	&& $2 != "10511052"	&& $2 != "10511003"	&& $2 != "10511004"	&& $2 != "10511050"	&& $2 != "10511005"	&& $2 != "10511019"	&& $2 != "10511020"	&& $2 != "10511022"	&& $2 != "10511051"  )  d[$1$2]=$1","$2","$3;
 else if ( FILENAME != CODE_DIR &&  substr($2,1,3) == "105"  &&  $1$2 in d ) print  $0 >> fileok ;
}' /data/match/orig/mm7/${DATE_LAST}/stats_month.wuxian_qianxiang.1000    /data/gd_jf/${DATE_LAST}/gd_${DATE_LAST}_isjf.txt

awk  -F',' -v CODE_DIR=/data/match/orig/mm7/${DATE_LAST}/stats_month.wuxian_qianxiang.0 -v OPTCODE_DIR=/data/match/orig/profile/qiangxiang_sms_app_code.txt -v fileok=/data/gd_jf/gd_sms.txt '{
if( FILENAME == OPTCODE_DIR  )  
{
app[$2]=$3;
}
else if ( FILENAME == CODE_DIR ) 
{
                     userid=$1
                     appcode=$2
                     # 下发次数
                     sendnum=$3
                     USER_NUM[userid"|"appcode]=sendnum
                     d[$1$2]=$1","$2","$3
                  }
else if( USER_NUM[$1"|"$2]>=(app[$2]/2) &&  substr($2,1,3) == "103"  &&  $1$2 in d )  print  $0 >> fileok ;

}' /data/match/orig/profile/qiangxiang_sms_app_code.txt /data/match/orig/mm7/${DATE_LAST}/stats_month.wuxian_qianxiang.0    /data/gd_jf/${DATE_LAST}/gd_${DATE_LAST}_isjf.txt
awk  -F',' '{print $1","$2}' gd_sms.txt gd_mms_others.txt 10_gaizao.txt | sort -u  >gd_qx_tmp.txt
awk -F '[|,]' -v CODE_DIR=/home/oracle/etl/data/nodist.tsv '{ if(FILENAME==CODE_DIR) d[$4]=$1"|"$2 ; else if( (substr($1,1,7) in d ) ) print d[substr($1,1,7)]"|"$0;  }' /home/oracle/etl/data/nodist.tsv  /data/${DATE_LAST:0:4}/${DATE_LAST}/qianxiang_dianbo.txt>dianbo_tmp.txt
awk -F '[|,]' '$1=="广东"{print $3","$4}' dianbo_tmp.txt >gd_dianbo_tmp.txt
cat gd_qx_tmp.txt gd_dianbo_tmp.txt > gd_tmp.txt
awk -F',' -v CODE_DIR=/data/gd_jf/dic/wy_code_classname.txt '{ if(FILENAME==CODE_DIR) d[$1]=$2 ; else if( ($2 in d) ) print $0","d[$2] }' /data/gd_jf/dic/wy_code_classname.txt  gd_tmp.txt > gd_tmp_fullname.txt
if [ ! -d "$PROVINCE$DATE_LAST" ]; then
   mkdir $PROVINCE$DATE_LAST   
fi
cp gd_tmp_fullname.txt  /data/gd_jf/$PROVINCE$DATE_LAST/gd_tmp_fullname.txt
cd $PROVINCE$DATE_LAST
cat gd_tmp_fullname.txt| awk -F',' '{print $3","$1}' | sort -u | awk -F',' '{d=$1".txt"; print $2>>d }' 
bzip2   *.txt
