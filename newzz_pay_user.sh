#!/bin/sh
. /usr/local/app/dana/current/shbb/profile
#. /home/shihy/bin/shbb_20090423/profile
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
TARGET_DIR=$AUTO_DATA_REPORT/$V_YEAR/$V_DATE
SOURCE_DIR=$AUTO_SRC_DATA/$V_DATE/data
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

CODE_DIR=$AUTO_DATA_NODIST

if [ ! -d "$TARGET_DIR" ]; then
    if ! mkdir -p $TARGET_DIR
    then
        echo "mkdir $TARGET_DIR error"
        exit 1
    fi
fi

ERROR=0
if [ ! -f "$TARGET_DIR/$$_tmp" ];then
    mkfifo $TARGET_DIR/$$_tmp
fi

# 字典文件
FILE_NODIST=$CODE_DIR/nodist.tsv
FILE_APP_CODE=$CODE_DIR/news_appcode.txt

#目标文件
TARGET_FILE=$TARGET_DIR/newzz_pay_users.txt
shbb_outSucc_file=/logs/out/mm7/$V_DATE/stats_month.bizdev_shenghbb.1000


#判断字典文件是否存在
if [ ! -f "$FILE_NODIST" ]; then
    echo "$FILE_NODIST not found"
    exit 1
fi

if [ ! -f "$FILE_APP_CODE" ]; then
    echo "$FILE_APP_CODE not found"
    exit 1
fi
  
  
  
  
  
  
  
  
pbunzip2 -d -p4 -c $SOURCE_DIR/snapshot/snapshot.txt.bz2 |
gawk 'BEGIN{
          FS="|"
          Current_date="'${V_DATE}'235959"
          Month=substr(Current_date,1,6)"00000000"
          while(getline var < "'$FILE_NODIST'")
              {
                  split(var,v,"|")
                  nodist[v[4]]=v[1]","v[5]","v[2]","v[3]
              }
          while(getline var < "'$FILE_APP_CODE'")
              {
                  split(var,v,"|")
                  if (v[3]>0) app[v[1]]=v[3]
              }
      }
      {if($2 in app){
          op_time=$4;prior_time=$5;last_time=$6;appcode=$2;is_subscribed=$3;userid=$1;chanel=$11
          if(substr(userid,1,7) in nodist){
              province[userid]=nodist[substr(userid,1,7)]
          }else if(substr(userid,1,8) in nodist){
              province[userid]=nodist[substr(userid,1,8)]
          }else{
              province[userid]="未知,000,未知,000"
          }
          user_type=(last_time <Month) ? 1:0  # 老用户 1 新用户 0
          last_day =substr(last_time,7,2)
          prior_day=substr(prior_time,7,2)
          t=op_time
          yy=substr(t,1,4);mm=substr(t,5,2);dd=substr(t,7,2);hh=substr(t,9,2) ;Mi=substr(t,11,2); ss=substr(t,13,2)
          s=yy" "mm" "dd" "hh" "Mi" "ss
          a=mktime(s)
          t=last_time
          yy=substr(t,1,4);mm=substr(t,5,2);dd=substr(t,7,2);hh=substr(t,9,2) ;Mi=substr(t,11,2); ss=substr(t,13,2)
          s=yy" "mm" "dd" "hh" "Mi" "ss
          b=mktime(s)
          t=Current_date
          yy=substr(t,1,4);mm=substr(t,5,2);dd=substr(t,7,2);hh=substr(t,9,2) ;Mi=substr(t,11,2) ;ss=substr(t,13,2)
          s=yy" "mm" "dd" "hh" "Mi" "ss
          c=mktime(s)
          # 判断是否大于72小时
          if (is_subscribed=="06"){
              is_72=((c-b-259200) > 0) ?1:0  #如果是订阅状态用当前时间减去最后一次订阅时间
          }else{
              is_72=((a-b-259200) > 0)?1:0 #如果是非订阅状态操作时间减去最后一次订阅时间
          }
          out_list=userid","appcode","app[appcode]","province[userid]","chanel
          
          #满足计费的各种条件
          if(user_type==1 ||
              #最后订购时间在21日之前,首次订购,超过72小时
              ((last_day < 21) && (is_72==1) && (prior_time==last_time)) ||
              #最后订购时间在21日之前,多次重复订购
              ((last_day < 21) &&(prior_time < last_time))  ||
              #最后订购时间在21日后，非首次订购，首次订购在21日之前 收费
              ((last_day >= 21) && (prior_time < last_time)&&(prior_day < 21))
          ){
              print out_list
          }
          
          
          
          
      }
}' $FILE_NODIST $FILE_APP_CODE $DATA_FILE  >$TARGET_FILE



#出报表结果
awk -F'[|,]' '{
    if(FILENAME=="'$FILE_APP_CODE'"){
      	app[$1]=$3;app_name[$1]=$2
    }else if(FILENAME=="'$shbb_outSucc_file'"){
        userid=$1
        appcode=$2
        sendnum=$3 #下发次数
        USER_NUM[userid"|"appcode]=sendnum
    }else if(USER_NUM[$1"|"$2]>(app[$2]/2)){
        #包月用户有单条过高的限制
        prov_name=$4
        prov_code=$5
        appcode=$2
        appcode_name=app_name[appcode]
        city=$6
        city_code=$7
        chanel=(length($8)>0) ? $8:"未知"
        province_appcode[prov_code","prov_name","appcode","appcode_name]++
        city_appcode[prov_code","prov_name","city_code","city","appcode","appcode_name]++
        province_chanel[prov_code","prov_name","appcode","appcode_name","chanel]++
        city_appcode_chanel[prov_code","prov_name","city_code","city","appcode","appcode_name","chanel]++
        country[appcode","appcode_name]++
    }  
}END{
     printf("%s\n","省份编码,省份名称,appcode,杂志名称,计费用户数") >"'$TARGET_DIR'/report.region.newzz_pay_province.csv"
     printf("%s\n","省份编码,省份名称,地区编码,地区名称,appcode,杂志名称,计费用户数") >"'$TARGET_DIR'/report.region.newzz_pay_city.csv"
     printf("%s\n","省份编码,省份名称,appcode,杂志名称,渠道,计费用户数") >"'$TARGET_DIR'/report.region.newzz_pay_chanel_province.csv"
     printf("%s\n", "省份编码,省份名称,地区编码,地区名称,appcode,杂志名称,渠道,计费用户数") >"'$TARGET_DIR'/report.region.newzz_pay_chanel_city.csv"
     printf("%s\n","合计,appcode,计费用户数") >"'$TARGET_DIR'/report.region.newzz_pay_country.csv"
     
     for(name in province_appcode){
         printf("%s,%d\n",name,province_appcode[name]) >>"'$TARGET_DIR'/report.region.newzz_pay_province.csv"
     }
     for(name in city_appcode){
         printf("%s,%d\n",name,city_appcode[name]) >>"'$TARGET_DIR'/report.region.newzz_pay_city.csv"
     }
     for(name in province_chanel){
         printf("%s,%d\n",name,province_chanel[name]) >>"'$TARGET_DIR'/report.region.newzz_pay_chanel_province.csv"
     }
     for(name in city_appcode_chanel){
         printf("%s,%d\n",name,city_appcode_chanel[name]) >>"'$TARGET_DIR'/report.region.newzz_pay_chanel_city.csv"
     }
     for(name in country){
         printf("%s,%s,%d\n","合计",name,country[name]) >>"'$TARGET_DIR'/report.region.newzz_pay_country.csv"
     }
}' $FILE_APP_CODE $shbb_outSucc_file $TARGET_FILE


rm $TARGET_FILE

wait $!

