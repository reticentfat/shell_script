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
SOURCE_DIR=$AUTO_DATA_TARGET/$V_YEAR/$V_DATE
REPORT_DIR=$AUTO_DATA_REPORT/$V_YEAR/$V_DATE
CODE_DIR=$AUTO_DATA_NODIST
NODIST_NOSVN_DIR=$AUTO_DANA_NODIST

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
SOURCE_FILE=$SOURCE_DIR/meiti_payuser_list.txt

  

  # 字典文件
  FILE_CHANEL=$NODIST_NOSVN_DIR/shbb_chanel.txt
  #FILE_CHANEL=/home/chenly/shbb_chanel.txt

  FILE_APP_CODE=$CODE_DIR/meiti_app_code.txt

  FILE_YEAR_CODE=$CODE_DIR/shbb_appcode_year.txt



 #目标文件
  RESULT_FILE=$REPORT_DIR/report.region.payuser_chanel_meiti_city.csv

   awk -F'[|,]' '{
    if(FILENAME=="'$FILE_APP_CODE'")
      {
         app[$1]=$2
         appfee[$1]=$6
      }
    else if(FILENAME=="'$FILE_CHANEL'")
      {
         chanelname[$1]=1
      }
    else if(FILENAME=="'$FILE_YEAR_CODE'")
      {
        year_code[$1","$2]=1
      }
    else if ($2 in app)
      {
         appcode=$2;proviname=$3;provino=$4;cityname=$5;cityno=$6;chanel=$10
         #处理杂志名称
         servicecode=app[appcode]
         #处理渠道信息
         if(!(chanel in chanelname))
         {
           chanel="None"
         }
         indexstr=appcode","provino","proviname","cityno","cityname","servicecode","chanel
         p_city[indexstr]++
         if((provino","appcode in year_code)&&(provino=100))
              {
                  p_city_pay[indexstr]+=24
              }
         else
              {
                  p_city_pay[indexstr]+=appfee[appcode]
              }          
      }
}END{
    city_title="APPCODE,省编码,省名称,地市编码,地市名称,杂志名称,渠道,计费用户数,信息费预估,收入预估"
    printf("%s\n",city_title)
    for(name in p_city)
         {
             k=p_city[name]>0?p_city[name]:0
   	     m=p_city_pay[name]>0?p_city_pay[name]:0
   	     n=m/2
             printf("%s,%d,%.1f,%.1f\n",name,k,m,n)
   	 }  
}' $FILE_APP_CODE $FILE_CHANEL $FILE_YEAR_CODE $SOURCE_FILE > $RESULT_FILE

           ERROR=$?
           if [ $ERROR -gt 0 ]; then
         	  exit $ERROR
           else
         	wait $!
           fi


  
