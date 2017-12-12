#!/bin/sh
. /usr/local/app/dana/current/shbb/profile
#彩信网关及时率
usage () {
    echo "usage: $0  target_dir" 1>&2
    exit 2
}

if [ $# -lt 1 ] ; then
    usage
fi
V_DATE=$1
V_YEAR=$(echo $V_DATE | cut -c 1-4)
TARGET_DIR=$AUTO_SRC_CMPP/$V_DATE
REPORT_DIR=$AUTO_DATA_REPORT/$V_YEAR/$V_DATE

if [ ! -d "$TARGET_DIR" ]; then
  echo "$TARGET_DIR not found"
  exit 1
fi

CODE_DIR=$AUTO_DATA_NODIST
if [ ! -d "$REPORT_DIR" ]; then
  if ! mkdir -p $REPORT_DIR
  then
    echo "mkdir $REPORT_DIR error"
    exit 1
  fi
fi

# appcode分部门字典
dept_code=$CODE_DIR/appcode.txt.bz2 
code_appcode_dept=$TARGET_DIR/tmp_$$
bzcat $dept_code > $code_appcode_dept



nodist=$CODE_DIR/nodist.tsv
cmpp_out=$TARGET_DIR/*.out
cmpp_mt=$TARGET_DIR/*.mt
report_file=$REPORT_DIR/report.region.jishu_chanpiyuying_cmpp_province.csv

awk -F'[,|]' '{
  if(FILENAME=="'$code_appcode_dept'"){
    dept[$5]=$4","$1
  }
  else if(FILENAME=="'$nodist'"){
    nodist[substr($4,1,7)]=$5","$1
  }
  else
  {
    tel=substr($12,1,7)
    if(tel in nodist){
      pro=nodist[tel]
    }else 
    {
      pro="000,未知"
    }
    if(index(FILENAME,".out")>0){
      stat=$(NF-3)
    }
    else{
      stat="未知"
   }
   if($15 in dept){
     dept_name=dept[$15]
   }
   else {
     dept_name="未知,未知"
   }
  index_str=pro","$15","dept_name","stat
  rp[index_str]++

}
}END{
title="省份编码,省份名称,业务编码,业务名称,业务部门,接收状态,状态条数"
print title
for(name in rp){
  split(name,b,",")
  index_dep=b[1]","b[2]","b[3]","b[4]","b[5]

  printf("%s,%d\n",name,rp[name])
}
}' $code_appcode_dept $nodist $cmpp_out $cmpp_mt >$report_file

if [ $? -ne 0 ];then
 rm $code_appcode_dept
 exit 2
else
  rm $code_appcode_dept
fi

 



