#!/bin/ksh
cd /data/match/orig/profile/

usage () {
    echo "usage: $0  target_dir" 1>&2
    exit 2
}

  if [ $# -lt 1 ] ; then
     usage
  fi
V_DATE=$1
V_YEAR=$(echo $V_DATE | cut -c 1-4)
v_month=$(echo $V_DATE | cut -c 1-6)
TARGET_DIR='/data'/$V_YEAR/$V_DATE
#取上一个月的最后一天
#判断是否是最后一天
v_day=$(gawk 'BEGIN{
             t="'$v_month'01000000"
             yy=substr(t,1,4);mm=substr(t,5,2);dd=substr(t,7,2);hh=substr(t,9,2) ;Mi=substr(t,11,2); ss=substr(t,13,2)
             s=yy" "mm" "dd" "hh" "Mi" "ss
             a=mktime(s)-86400
             print strftime("%Y%m%d",a)
           }'
       )
day=$(echo $v_day | cut -c 7-8)
year=$(echo $v_day | cut -c 1-4)

CODE_DIR='/data/match/orig/profile'

  if [ ! -d "$TARGET_DIR" ]; then
    if ! mkdir -p $TARGET_DIR
    then
      echo "mkdir $TARGET_DIR error"
      exit 1
    fi
  fi
  if [ ! -f "$CODE_DIR/nodist.tsv" ]; then
    echo "$CODE_DIR/nodist.tsv not found"
    exit 1
  fi
  ERROR=0
  if [ ! -f "$TARGET_DIR/$$_tmp" ];then
    mkfifo $TARGET_DIR/$$_tmp
  fi
  # 字典文件
  FILE_NODIST=$CODE_DIR/nodist.tsv
  FILE_APP_CODE=$CODE_DIR/qiangxiang_year_mms_app_code.txt

  # 数据文件'10511039','10511043'
  
 bzcat /data/match/orig/${V_DATE}/snapshot.txt.bz2 | grep -e '|10511039|'  -e '|10511043|' | awk -F '|' -v first_date='20100701000000'   '{ if(  $3 == "06" && $5 >= first_date )  print $0; else if(  $3 == "07" &&  $4 >=first_date ) print $0; }' > $TARGET_DIR/$$_tmp&
  
  DATA_FILE=$TARGET_DIR/$$_tmp

 #目标文件
   TARGET_FILE=$TARGET_DIR/qiangxiang_year_mms_pay_users.txt

  gawk -F\| 'BEGIN{
                   Current_date="'${V_DATE}'235959";Month=substr(Current_date,1,6)"00000000";Code_File_nodist="'$CODE_DIR'/nodist.tsv"
                   Code_File_appcode="'$CODE_DIR'/qiangxiang_year_mms_app_code.txt"
                 }
                 {
                if(FILENAME==Code_File_nodist)
                 {
                   nodist[$4]=$1","$5","$2","$3
                  }
                else if(FILENAME==Code_File_appcode)
                  {
                  if ($3>0) app[$2]=$3
                  }
                else if ($2 in app)
                   {
                  op_time=$4;prior_time=$5;last_time=$6;appcode=$2;is_subscribed=$3;userid=$1;chanel=$11

                  if(substr(userid,1,7) in nodist)
                  {
                    province[userid]=nodist[substr(userid,1,7)]
                  }
                  else if(substr(userid,1,8) in nodist)
                  {
                    province[userid]=nodist[substr(userid,1,8)]
                  }
                  else
                  {
                   province[userid]="未知,000,未知,000"
                  }
                  user_type=(last_time <Month) ? 1:0  # 老用户 1 新用户 0
                  last_day =substr(last_time,7,2)
                  prior_day=substr(prior_time,7,2)
                  t=op_time
                  yy=substr(t,1,4);mm=substr(t,5,2);dd=substr(t,7,2);hh=substr(t,9,2) ;Mi=substr(t,11,2); ss=substr(t,13,2)
                  s=yy" "mm" "dd" "hh" "Mi" "ss
                  a=mktime(s)   #操作时间
                  t=last_time
                  yy=substr(t,1,4);mm=substr(t,5,2);dd=substr(t,7,2);hh=substr(t,9,2) ;Mi=substr(t,11,2); ss=substr(t,13,2)
                  s=yy" "mm" "dd" "hh" "Mi" "ss
                  b=mktime(s)   #最后一次订阅时间
                  t=Current_date
                  yy=substr(t,1,4);mm=substr(t,5,2);dd=substr(t,7,2);hh=substr(t,9,2) ;Mi=substr(t,11,2) ;ss=substr(t,13,2)
                  s=yy" "mm" "dd" "hh" "Mi" "ss
                  c=mktime(s)   #当前时间
             
	          out_list=userid","appcode","app[appcode]","province[userid]","chanel	              
				              
	          if (user_type==1)  #老用户
                  {
                      if ( is_subscribed=="06" )  #老用户，当前状态为订购 
                      {
                        print out_list
                      }  
                      else if((is_subscribed=="07")&&(op_time>=Month))
                      {
                        print out_list
                      }
                  }
                  else if (user_type==0)  #新用户
                  {
                      if ((is_subscribed=="06")&&(prior_time==last_time) )  #新用户，当前状态为订购 
                      {
                        print out_list
                      } 
                      else if ((is_subscribed=="07")&&(prior_time==last_time) ) 
                      {
                        print out_list
                      }
                      else if(prior_time<last_time)  #重复订购（当月首次订购时间<最后一次订购时间）
                      {
                        print out_list
                      }
                 }
			              
              
            }
          }' $FILE_NODIST $FILE_APP_CODE $DATA_FILE  >$TARGET_FILE
         # 出报表结果
          qiangxiang_outSucc_file=/data/match/orig/mm7/$V_DATE/stats_month.wuxian_qianxiang.1000 
          
          awk -F'[|,]' '{
                   
                  if(FILENAME=="'$FILE_APP_CODE'")
                  {
                  	app[$2]=$3
                  }
                  else if(FILENAME=="'$qiangxiang_outSucc_file'")
                  {
                     userid=$1
                     appcode=$2
                     # 下发次数
                     sendnum=$3
                     USER_NUM[userid"|"appcode]=sendnum
                  }
                  else if(USER_NUM[$1"|"$2]>(0/2))# 包月用户有单条过高的限制
                   {
                       prov_name=$4
                       prov_code=$5
                       appcode=$2
                       city=$6
                       city_code=$7
                       chanel=(length($8)>0) ? $8:"未知"
                       province_appcode[prov_code","prov_name","appcode]++

                       city_appcode[prov_code","prov_name","city_code","city","appcode]++

                       province_chanel[prov_code","prov_name","appcode","chanel]++

                       city_appcode_chanel[prov_code","prov_name","city_code","city","appcode","chanel]++

                       country[appcode]++

                    }  
               }END{
 
           		printf("%s\n","provinceno,province,citycode,city,appcode,feeusers") >"'$TARGET_DIR'/qiangxiang_year_mms_pay_city.csv"
           	   
            
                for(name in city_appcode){
                     printf("%s,%d\n",name,city_appcode[name]) >>"'$TARGET_DIR'/qiangxiang_year_mms_pay_city.csv"
                    }
               

            }' $FILE_APP_CODE $qiangxiang_outSucc_file $TARGET_FILE
           # rm $DATA_FILE
          #  rm $TARGET_FILE
           wait $!




