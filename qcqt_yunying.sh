#!/bin/sh
. /usr/local/app/dana/current/shbb/profile
usage () {
    echo "usage: $0  target_dir" 1>&2
    exit 2
}

if [ $# -lt 1 ] ; then
    usage
fi
v_date=$1
v_year=$(echo $v_date | cut -c 1-4)
REPORT_DIR=$AUTO_DATA_REPORT/$v_year/$v_date
result=$REPORT_DIR/report.region.chanpin_qcqt_province.csv
nodist=$code_dir/nodist.tsv
{ cat ${AUTO_DATA_NODIST}/nodist.tsv|awk -F"|" '{print $4"|"$5"|"$1}';bzcat ${AUTO_SRC_DATA}/${v_date}/monster-cmppmo.log.*.bz2;bzcat ${AUTO_SRC_DATA}/${v_date}/wvap-access.log.*.bz2;}|

awk -F'[|,]' '
NF==3 { 
nodist[substr($1,1,7)]=$2","$3
}
NF>10 && $14=="10658880"  {
 if(substr($10,1,7) in nodist){
  index_str=nodist[substr($10,1,7)]
 }
 else{
  index_str="000,未知"
 }
 pro[index_str]=1
 if($28=="00000"){
   sxqt[index_str]++
   if(!($10 in qt_user)){
     qt_user[$10]=1
     sxqt_user[index_str]++
   }
 }
 if($28=="0000")
 {
   sxqc[index_str]++
   if(!($10 in qc_user)){
     qc_user[$10]=1
     sxqc_user[index_str]++
   }


 }
}
NF==7 && $3=="cancelall" && $5==0{
 if(substr($4,1,7) in nodist){
  index_str=nodist[substr($4,1,7)]
 }
 else{
  index_str="000,未知"
 }
 pro[index_str]=1

 if($6==0 && $7==200){
   wxdt[index_str]++
 }
 else if($6==200 && $7==0){
   meiti[index_str]++
 }
 else if($6==0 && $7==0){
  wxmt_qt[index_str]++
}

}END{
  title="省编码,省份名称,全退用户数,全退请求量,全查用户数,全查请求量,无线退订成功量,媒体退订成功量,无线媒体全退量"
  print title
 for(name in pro){
   printf("%s,%d,%d,%d,%d,%d,%d,%d\n",name,sxqt_user[name],sxqt[name],sxqc_user[name],sxqc[name],wxdt[name],meiti[name],wxmt_qt[name])
 }
}' >$result


