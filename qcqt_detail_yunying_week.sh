#!/bin/sh
. /usr/local/app/dana/current/ETL/profile

ARGV="$@"

usage () {
    echo "usage: $0 source_dir code_dir" 1>&2
    exit 2
}

if [ $# -lt 1 ] ; then
    usage
fi

ERROR=0
V_DATE=$1
V_MONTH=$(echo $V_DATE | cut -c 1-6)
V_YEAR=$(echo $V_DATE | cut -c 1-4)
end_date=`$AUTO_WORK_BIN/addday.php d $V_DATE -6`
report_dir=$AUTO_DATA_REPORT/$V_YEAR/week_${end_date}_${V_DATE}

WEEKNUM=`$AUTO_WORK_BIN/addday.php w $V_DATE 0`

[ $WEEKNUM -ne 2 ] && exit 0
src_dir=$AUTO_SRC_DATA
mo_file_name='monster-cmppmo.log.*.bz2'
mvwap_file_name='wvap-access.log.*.bz2'
result=$report_dir/report.region.chpyy_qcqtdetail_province.csv

if [ ! -d $report_dir ];then
  mkdir $report_dir
fi

i=6
while [ $i -ge 0 ]
do
 THIS_OUTDATE=`$AUTO_WORK_BIN/addday.php d $V_DATE -$i`
 mo_week_file=`echo $mo_week_file $src_dir/$THIS_OUTDATE/$mo_file_name`
 mvwap_week_file=`echo $mvwap_week_file $src_dir/$THIS_OUTDATE/$mvwap_file_name`
 i=$((i-1))
done 

{ cat ${AUTO_DATA_NODIST}/nodist.tsv|awk -F"|" '{print $4"|"$5"|"$1}';bzcat ${mo_week_file};bzcat ${mvwap_week_file};}|
awk -F'[|,]' '
NF==3 { 
   nodist[substr($1,1,7)]=$2","$3
}
 NF>10 && $14=="10658880" {
  if(substr($10,1,7) in nodist){
    index_str=nodist[substr($10,1,7)]
  }
  else{
    index_str="000,未知"
  }
  pro[index_str]=1
  if($28=="00000"){
    sxqt[index_str]++
  }
  if($28=="0000")
  {
    sxqc[index_str]++
  }
 }
 NF==7 && $3=="cancelall" {
  if(substr($4,1,7) in nodist){
    index_str=nodist[substr($4,1,7)]
  }
  else{
    index_str="000,未知"
  }
  pro[index_str]=1
  #所有退操作失败量
  if(!(($6==0 && $7==200)||($6==200 && $7==0)||($6==0 && $7==0))){
    td_fail_all[index_str]++
   }
   #未订任何业务的退定数
  if($6==200 && $7==200){
    no_buss_td[index_str]++
  }
  #无线退订超时
  else if($6=="505" && $7=="0"){
    wx_td_chao[index_str]++
  }
  #媒体退订超时
  else if($6=="0" && $7=="505"){
    mt_td_chao[index_str]++
  }
 }
END{
 title="省份编码,省份名称,全退请求量,平均全退数量,全查请求量,平均全查数量,退订操作失败总量,无业务退订失败占比%,无线退订超时占比%,媒体退订超时占比%,其它退定失败占比%"
 print title
 for(name in pro){
  a=no_buss_td[name]
  b=wx_td_chao[name]
  c=mt_td_chao[name]
  d=td_fail_all[name]-no_buss_td[name]-wx_td_chao[name]-mt_td_chao[name]
  printf("%s,%d,%.2f,%.d,%.2f,%d,%.2f,%.2f,%.2f,%.2f\n",name,sxqt[name],sxqt[name]/7,sxqc[name],sxqc[name]/7,td_fail_all[name],a,b,c,d)
 }
}' >$result

