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

  # 字典文件
CODE_FILE=$CODE_DIR/shbb_status_code.txt
#CODE_FILE1=$AUTO_DATA_REPORT/payuser_code.txt  
FILE_APP_CODE=$CODE_DIR/meiti_app_code.txt
#SOURCE_FILE=$REPORT_DIR/out_mt_meiti_num.txt 
SOURCE_FILE=$SOURCE_DIR/out_mt_meiti_num.txt

  # 结果文件
RESULT_FILE=$REPORT_DIR/report.region.kpi_out_mt_rate_meiti_city.csv
 awk -F'[|,]' '{
       if(FILENAME=="'$CODE_FILE'")
         { if($2>0)
             {
                  i++
                  staut_code[$1]=$2
                  staut_code_order[i]=$1
             }
         }
        else if(FILENAME=="'$FILE_APP_CODE'")
         {
            app[$1]=$3
            appserv[$1]=$4
         }
       else 
         {  
            province=$1;provname=$3;city=$2;cityname=$4;servicename=$5;appcode=$6;sendstatu=$7
             sub_all=$8;sub_succ=$9;accept_succ=$10;fail=$11;no_num=$12  
            #处理计费类型
            if(appcode in app)
              {
               serv=appserv[appcode]
               if((appcode=="22230033")&&(province=="100"))
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
                   indexstr=province","city","provname","cityname","servicename","feetype","serv
                   all[indexstr]+=sub_all
                   subsucc[indexstr]+=sub_succ
                   acceptsucc[indexstr]+=accept_succ
                   nonum[indexstr]+=no_num #无状态报告条数
                   p[indexstr]=1
                   # 需要显示的状态
                   if(sendstatu in staut_code)
                      {
                           arr_stau=sendstatu
                      }
                   else
                      {
                           if(sendstatu=="1000")
                             {
                                 arr_stau="1000"
                             }
                           else
                             {
                                 arr_stau="OTHERS"
                             }
                      }
                    
                   if(arr_stau=="1000")
                      {
                           city_out_suss[indexstr]+=accept_succ
                      }
                   else
                      {
                           city_out_stau[indexstr","arr_stau]+=fail
                      }
               }
           }
        }END{
                # 生成表头
                i++
                staut_code_order[i]="OTHERS"

                str="省编码,地区编码,省份名称,地区名称,杂志名称,计费类型,业务代码,下行提交总量,成功提交量,成功接收量,到达率"
                for(m=1;m<=i;m++)
                   {
                      str=str",接收失败("staut_code_order[m]")"
                   }
                printf("%s,%s\n",str,"无状态报告条数")
                for(name in p)
                   {
                      str3=""
                      for(m=1;m<=i;m++)
                          {
                            sta_str_num=staut_code_order[m]
                            aa=(length(city_out_stau[name","sta_str_num])>0)? city_out_stau[name","sta_str_num]:0
                            str3=str3","aa
                          }
                      Succ_rate=(subsucc[name]>0) ? acceptsucc[name] * 100 / subsucc[name] :0
                      printf("%s,%d,%d,%d,%.2f%s%s,%d\n",name,all[name],subsucc[name],acceptsucc[name],Succ_rate,"%",str3,nonum[name]) 
                  }
     }' $CODE_FILE $FILE_APP_CODE $SOURCE_FILE > $RESULT_FILE
           ERROR=$?
           if [ $ERROR -gt 0 ]; then
         	  exit $ERROR
           else
         	wait $!
           fi
