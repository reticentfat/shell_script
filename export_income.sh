#! /usr/bin/ksh
export PATH=/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/data/app/oracle/product/11.2.0/db/bin/
export ORACLE_HOME=/data/app/oracle/product/11.2.0/db

export ORACLE_SID=wreportdb
ORACLE_NLS=$ORACLE_HOME/nls/data ;
export ORACLE_NLS
NLS_LANG="simplified chinese"_china.ZHS16CGB231280 ;
export NLS_LANG

if [ $# -eq 2 ];then
   INDATE=$1 
   INDATE_1=$2

fi

# define work variable
HOMEDIR=/home/oracle/etl/bin
DATADIR=/data/
DEALDATE=""
USERID="ptj"
PASSWD="ptj"
SRVNAME="wreportdb"
DATAFILE="qianxiang_dianbo.txt"
DATAFILE1="qiangxiang_month_allcity.txt"
DIR_YEAR=`date --date='2 days ago' +%Y` 
if [ ${INDATE:=999} = 999 ];then
  DEALDATE=`date --date='2 days ago'  +%Y%m%d`
  DEAL_DATE=`date --date='2 days ago'  +%Y-%m-%d`
else
  DEALDATE=$INDATE
  DEAL_DATE=$INDATE_1
fi
cd $DATADIR
if [ ! -d "$DIR_YEAR" ]; then
  mkdir $DIR_YEAR
  
fi
cd $DIR_YEAR
if [ ! -d "$DEALDATE" ]; then
  mkdir $DEALDATE
  
fi
create_month()
{

ksh  /home/oracle/etl/bin/qiangxiang_sms_pay_user.sh  ${DEALDATE}
ksh  /home/oracle/etl/bin/qiangxiang_mms_pay_user.sh  ${DEALDATE}
ksh  /home/oracle/etl/bin/qiangxiang_smswz_pay_user.sh ${DEALDATE}
ksh  /home/oracle/etl/bin/qiangxiang_yearsms_pay_user.sh  ${DEALDATE}
ksh  /home/oracle/etl/bin/qiangxiang_yearmms_pay_user.sh  ${DEALDATE}

}
create_monthall()
{
cat  /data/${DIR_YEAR}/${DEALDATE}/qiangxiang_mms_pay_city.csv | awk '{if ( NR != 1) print $0 }' > /data/${DIR_YEAR}/${DEALDATE}/qiangxiang_month_allcity.txt
cat  /data/${DIR_YEAR}/${DEALDATE}/qiangxiang_sms_pay_city.csv | awk '{if ( NR != 1) print $0 }' >> /data/${DIR_YEAR}/${DEALDATE}/qiangxiang_month_allcity.txt
cat  /data/${DIR_YEAR}/${DEALDATE}/qiangxiang_smswz_pay_city.csv | awk '{if ( NR != 1) print $0 }' >> /data/${DIR_YEAR}/${DEALDATE}/qiangxiang_month_allcity.txt


cat  /data/${DIR_YEAR}/${DEALDATE}/qiangxiang_year_sms_pay_city.csv | awk '{if ( NR != 1) print $0 }' >> /data/${DIR_YEAR}/${DEALDATE}/qiangxiang_month_allcity.txt

cat  /data/${DIR_YEAR}/${DEALDATE}/qiangxiang_year_mms_pay_city.csv | awk '{if ( NR != 1) print $0 }' >> /data/${DIR_YEAR}/${DEALDATE}/qiangxiang_month_allcity.txt


cat /data/gateway/cron/upstat/dbfile/wuxian_beijing_shbb.${DEALDATE}.csv | grep '22220032' | awk -F',' '{print $2","$3","$4","$5","$1","$8}' | awk -F',' '{a=$4 ; sum6=sum6+$6} END {print "100,"a",100,"a",22220032,"sum6}' |iconv -f UTF-8  -t GB2312 >> /data/${DIR_YEAR}/${DEALDATE}/qiangxiang_month_allcity.txt


cat /data/gateway/cron/upstat/dbfile/wuxian_beijing_shbb.${DEALDATE}.csv | grep '22230033' | awk -F',' '{print $2","$3","$4","$5","$1","$8}' | awk -F',' '{a=$4 ; sum6=sum6+$6} END {print "100,"a",100,"a",22230033,"sum6}' |iconv -f UTF-8  -t GB2312 >> /data/${DIR_YEAR}/${DEALDATE}/qiangxiang_month_allcity.txt





#iconv -f UTF-8  -t GB2312  /data/${DIR_YEAR}/${DEALDATE}/qiangxiang_month_allcity.txt  > /data/${DIR_YEAR}/${DEALDATE}/qiangxiang_month_allcity_ok.txt;

}

create_dianboday()
{
 awk -F'[|,]'  -v CODE_DIR=/data/match/orig/profile/qiangxiang_sms_dianbo_app_code.txt -v fileok=/data/${DIR_YEAR}/${DEALDATE}/qianxiang_dianbo.txt '{  if ( FILENAME == CODE_DIR  )  d[$1]= $1 ; else if ( FILENAME != CODE_DIR &&  $2 in d  ) print   $0"," >> fileok  }'  /data/match/orig/profile/qiangxiang_sms_dianbo_app_code.txt /data/match/orig/mm7/${DEALDATE}/stats_month.wuxian_qianxiang.0
}
 
gen_ctrl_msg()
{
INFILES="INFILE '${DATADIR}/${DIR_YEAR}/${DEALDATE}/${DATAFILE}' BADFILE '${DATADIR}/log/${DATAFILE}.${DEALDATE}.bad' DISCARDFILE '${DATADIR}/log/${DATAFILE}.${DEALDATE}.dis'"
echo "LOAD DATA ${INFILES}"
echo "APPEND INTO TABLE PTJ.TMP_dianbo_day"
echo "FIELDS TERMINATED BY ','"
echo "("
echo "    mobile   "
echo "   ,appcode  "
echo "   ,totals   "
echo "   ,deal_date   constant '${DEAL_DATE}'  "
echo ")"
}

gen_ctrl_msg1()
{   
INFILES1=" CHARACTERSET ZHS16GBK  INFILE '${DATADIR}/${DIR_YEAR}/${DEALDATE}/${DATAFILE1}' BADFILE '${DATADIR}/log/${DATAFILE1}.${DEALDATE}.bad' DISCARDFILE '${DATADIR}/log/${DATAFILE1}.${DEALDATE}.dis'"
echo "LOAD DATA ${INFILES1}"
echo "APPEND INTO TABLE PTJ.TB_THEORY_INCOME"
echo "FIELDS TERMINATED BY ','"
echo "("
echo "   DEAL_DATE      constant '${DEAL_DATE}' "
echo "   ,PROV_CODE    "
echo "   ,PROV_NAME "
echo "   ,CITY_CODE "
echo "   ,CITY_NAME  "
echo "   , APPCODE "
echo "   ,JF_USER_NUM   "
echo ")"
}



main()
{
create_month
create_monthall
create_dianboday
gen_ctrl_msg > ${HOMEDIR}/tmp/dianbo.ctl
gen_ctrl_msg1 > ${HOMEDIR}/tmp/month.ctl
sqlldr userid=${USERID}/${PASSWD} control=${HOMEDIR}/tmp/dianbo.ctl errors=100000 log=${DATADIR}/log/${DATAFILE}.${DEALDATE}.log direct=true
sqlldr userid=${USERID}/${PASSWD} control=${HOMEDIR}/tmp/month.ctl errors=100000 log=${DATADIR}/log/${DATAFILE1}.${DEALDATE}.log direct=true


}
main
