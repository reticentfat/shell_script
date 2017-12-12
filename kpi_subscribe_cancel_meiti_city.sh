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

   # 结果文件
   SOURCE_FILE=$REPORT_DIR/report.region.subscribe_cancel_meiti_city.csv
   REPORT_RESULT_FILE=$REPORT_DIR/report.region.kpi_subscribe_cancel_meiti_city.csv
   # 字典表文
   FILE_APP_CODE=$CODE_DIR/kpi_meiti_app_code.txt
   ERROR=0


   awk -F'[|,]' '{
        if(FILENAME=="'$FILE_APP_CODE'")
         {
            app[$1]=$3
            appserv[$1]=$4
         }
       else 
         { 
            prov=$1;city=$2;provname=$3;cityname=$4;appcode=$5;servicecode=$6;subscribe=$11;cancel=$12;subscribe_cancel=$13;cancel_subscribe=$14
            #处理计费类型
            if(appcode in app)
              {
               serv=appserv[appcode]
               if((appcode=="22230033")&&(prov=="100"))
                 {
                    feetype="包年计费（24元/年）"
                 }
               else
                 {
                    feetype=app[appcode]
                 }
              }

            if (appcode in app)
              {
                 arr_index=prov","provname","city","cityname","servicecode","feetype","serv
                 p[arr_index]=1
                      if(subscribe>0)
                        {
                           subscribe_user[arr_index]+=subscribe
                        }   
                      if(cancel>0)
                        {
                           cancel_user[arr_index]+=cancel
                        }     
                      if(subscribe_cancel>0)
                        {
                           subscribe_canceluser[arr_index]+=subscribe_cancel
                        }  
                      if(cancel_subscribe>0)
                        {
                           cancel_subscribeuser[arr_index]+=cancel_subscribe
                        }                                       
              }
         }

}END{
      title="省编码,省名称,地市编码,地市名称,杂志名称,计费类型,业务代码,订阅用户数,退订用户数,即订即退用户数,即退即订用户数"
      printf("%s\n",title)
      for(name in p)
         { 
            printf("%s,%d,%d,%d,%d\n",name,subscribe_user[name],cancel_user[name],subscribe_canceluser[name],cancel_subscribeuser[name])
         }
}' $FILE_APP_CODE $SOURCE_FILE > $REPORT_RESULT_FILE
