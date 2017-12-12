#!/bin/sh
. /usr/local/app/dana/current/shbb/profile
#. /home/chenly/profile
usage () {
    echo "usage: $0  REPORT_DIR" 1>&2
    exit 2
}

if [ $# -lt 1 ] ; then
    usage
fi
V_DATE=$1
V_YEAR=$(echo $V_DATE | cut -c 1-4)
SOURCE_DIR=$AUTO_DATA_REPORT/$V_YEAR/$V_DATE
REPORT_DIR=$AUTO_DATA_REPORT/$V_YEAR/$V_DATE
CODE_DIR=$AUTO_DATA_NODIST

if [ ! -d "$REPORT_DIR" ]; then
  if ! mkdir -p $REPORT_DIR
  then
    echo "mkdir $REPORT_DIR error"
    exit 1
  fi
fi

if [ ! -d "$SOURCE_DIR" ]; then
  echo "$SOURCE_DIR not found"
  exit 1
fi




#包年用户名单列表
  SOURCE_FILE=$REPORT_DIR/report.region.payuser_chanel_meiti_city.csv
  #SOURCE_FILE=/logs/out/dana/report/$V_YEAR/$V_DATE/report.region.payuser_chanel_meiti_city.csv

  

  # 字典文件
  CODE_FILE=$CODE_DIR/caiwu_code.txt
  #CODE_FILE=/home/chenly/caiwu_code.txt


 #目标文件
  RESULT_FILE=$REPORT_DIR/report.region.caiwu_pay_chanel_meiti_city.csv

   awk -F'[|,]' '{
    if(FILENAME=="'$CODE_FILE'")
      {
         app[$1]=$3
      }
    else
      {
        if(($1 in app)||($1=="22220033"))  #appcode为22220033时只统计北京下的数据
          {
            appcode=$1;proviname=$3;province=$2;cityname=$5;city=$4;servicecode=$6;feeuser=$8;fee_estimate=$9;in_estimate=$10
            if((appcode=="22230033")&&(province=="100"))
              {
                 feetype="包年计费（24元/年）"
              }
            else if((appcode=="22220033")&&(province=="100"))
              {
                 feetype="包月计费（1元/月）"
              }
            else
              {
                 feetype=app[$1]
              }
            indexstr=province","city","proviname","cityname","servicecode","feetype
            user[indexstr]+=feeuser
            fee[indexstr]+=fee_estimate
            estimate[indexstr]+=in_estimate
            p_city[indexstr]=1
          }
      }
}END{
    city_title="省编码,地市编码,省名称,地市名称,杂志名称,计费类型,计费用户数,信息费预估,收入预估"
    printf("%s\n",city_title)
    for(name in p_city)
         {
             printf("%s,%d,%d,%.1f\n",name,user[name],fee[name],estimate[name])
   	 }  
}' $CODE_FILE $SOURCE_FILE > $RESULT_FILE

           ERROR=$?
           if [ $ERROR -gt 0 ]; then
         	  exit $ERROR
           else
         	wait $!
           fi


  
