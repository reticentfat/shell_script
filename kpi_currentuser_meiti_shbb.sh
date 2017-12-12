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
REPORT_DIR=$AUTO_DATA_REPORT/$V_YEAR/$V_DATE
CODE_DIR=/logs/out/dana/data/nodist
REPORT_DIR_SHBB=/home/wangjun5

if [ ! -d "$REPORT_DIR" ]; then
  if ! mkdir -p $REPORT_DIR
  then
    echo "mkdir $REPORT_DIR error"
    exit 1
  fi
fi


  # 字典文件
  CODE_FILE=$CODE_DIR/kpi_meiti_app_shbb.txt
  SOURCE_FILE=$REPORT_DIR/report.region.subscribe_pause_currentuser_meiti_city.csv
  SOURCE_FILE1=$REPORT_DIR/report.region.payuser_chanel_meiti_city.csv

  # 结果文件
  REPORT_RESULT_FILE=$REPORT_DIR_SHBB/report.region.kpi_currentuser_meiti_shbb.csv
 awk -F'[|,]' '{
       if(FILENAME=="'$CODE_FILE'")
         {
            app[$1]=$3
            appserv[$1]=$4
         }
       else 
         { 
            if(FILENAME=="'$SOURCE_FILE'")
              {   
                 if ($6=="订制")
                 {
                   prov=$1;provname=$2;city=$3;cityname=$4;appcode=$5;is_subscribe=$6;servicecode=$7;normalnum=$12;pausenum=$13;allnum=$14
                 }              
              }
            else if(FILENAME=="'$SOURCE_FILE1'")
              { 
                 appcode=$1;prov=$2;provname=$3;city=$4;cityname=$5;servicecode=$6;feeuser=$8;feenum=$9
              }
            #处理计费类型
            if(appcode in app)
              {
               serv=appserv[appcode]  #业务代码
               if((appcode=="22230033")&&(prov=="100"))
                 {
                    feetype="包年计费（24元/年）"
                 }
               else
                 {
                    feetype=app[appcode]
                 } 
                 arr_index=prov","provname","city","cityname","servicecode","feetype","serv
                 p[arr_index]=1      
                 if(FILENAME=="'$SOURCE_FILE'")
                   { if ($6=="订制")
                     {
                       all_user[arr_index]=all_user[arr_index]+allnum
                       if(normalnum>0)
                         {
                            normal_user[arr_index]=normal_user[arr_index]+normalnum
                         }   
                       if(pausenum>0)
                         {
                            pause_user[arr_index]=pause_user[arr_index]+pausenum
                         }
                     }
                   }
                 else if(FILENAME=="'$SOURCE_FILE1'")
                   {
                     if(feeuser>0)
                       {
                          fee_user[arr_index]=fee_user[arr_index]+feeuser
                       }  
                     if(feenum>0)
                       {
                          fee_num[arr_index]=fee_num[arr_index]+feenum
                       }                                        
                  }                 
              }
         }
}END{
      title="省编码,省名称,地市编码,地市名称,杂志名称,计费类型,业务代码,总用户数,正常用户数,暂停用户数,计费用户数,信息费预估"
      printf("%s\n",title)
      for(name in p)
         { 
            printf("%s,%d,%d,%d,%d,%d\n",name,all_user[name],normal_user[name],pause_user[name],fee_user[name],fee_num[name])
         }
}' $CODE_FILE $SOURCE_FILE $SOURCE_FILE1 > $REPORT_RESULT_FILE
           ERROR=$?
           if [ $ERROR -gt 0 ]; then
         	  exit $ERROR
           else
         	wait $!
           fi
