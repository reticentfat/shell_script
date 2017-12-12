#!/bin/sh
. /usr/local/app/dana/current/shbb/profile
#. /home/chenly/profile
usage () {
    echo "usage: $0  target_dir" 1>&2
    exit 2
}

  if [ $# -lt 1 ] ; then
     usage
  fi
V_DATE=$1
V_YEAR=$(echo $V_DATE | cut -c 1-4)
V_month=$(echo $V_DATE | cut -c 1-6)"01"
TARGET_DIR=$AUTO_DATA_TARGET/$V_YEAR/$V_DATE
REPORT_DIR=$AUTO_DATA_REPORT/$V_YEAR/$V_DATE
SOURCE_DIR=$AUTO_SRC_DATA/$V_DATE
CODE_DIR=$AUTO_DATA_NODIST

  if [ ! -d "$TARGET_DIR" ]; then
    if ! mkdir -p $TARGET_DIR
    then
      echo "mkdir $TARGET_DIR error"
      exit 1
    fi
  fi

  if [ ! -d "$REPORT_DIR" ]; then
    if ! mkdir -p $REPORT_DIR
    then
      echo "mkdir $REPORT_DIR error"
      exit 1
    fi
  fi
#取上一个月的最后一天
#判断是否是最后一天
v_day=$(gawk 'BEGIN{
             t="'$V_month'000000"
             yy=substr(t,1,4);mm=substr(t,5,2);dd=substr(t,7,2);hh=substr(t,9,2) ;Mi=substr(t,11,2); ss=substr(t,13,2)
             s=yy" "mm" "dd" "hh" "Mi" "ss
             a=mktime(s)-86400
             print strftime("%Y%m%d",a)
           }'
       )
#取上一个月1日
last_day=$v_day
last_year=$(echo $v_day | cut -c 1-4)
sour_file_3=$AUTO_DATA_TARGET/$last_year/$last_day/shbb_ci_agent_meiti.txt
#sour_file_3=$AUTO_DATA_REPORT/$last_year/$last_day/shbb_ci_agent_meiti.txt

  if [ ! -d "$AUTO_DATA_TARGET/$last_year/$last_day" ]; then
    if ! mkdir -p $AUTO_DATA_TARGET/$last_year/$last_day
    then
      echo "mkdir $AUTO_DATA_TARGET/$last_year/$last_day error"
      exit 1
    fi
  fi


#判断月份
month=$(echo $V_DATE | cut -c 5-6)
if [ $month = "01" ];then
    sour_file_3=$AUTO_DATA_TARGET/$V_YEAR/$V_DATE/shbb_ci_agent_meiti.txt  
    touch $sour_file_3  
fi

if [ ! -f "$sour_file_3" ];then
    touch $sour_file_3
fi

		# 处理交易日志中当日定制的座席推荐用户
		result_file=$TARGET_DIR/shbb_agent_ci_subscribe.${V_DATE}.txt
                #result_file=$REPORT_DIR/shbb_agent_ci_subscribe.${V_DATE}.txt
 		bzcat ${SOURCE_DIR}/usa2-biz.log.*${V_DATE}.bz2|
		awk -F\| '{
		  if(($2=="subscribe")&&($12=="CI"||$12=="CITJ"))
		  {
                   if(!(length($14)>0))
                     {
                       $14="未知"
                     }
	    	   print $3"|"$6"|"$7"|"$12"|"$13"|"$14"|"substr($15,1,8) #1电话号码、2版本，3appcode，4渠道1，5渠道2，6渠道3
		  }
		}'|sort -u > $result_file
	sour_file_1=$AUTO_DATA_TARGET/$V_YEAR/$V_month/shbb_ci_agent_meiti.txt
        #sour_file_1=$AUTO_DATA_REPORT/$V_YEAR/$V_month/shbb_ci_agent_meiti.txt

#先创建文件夹
  if [ ! -d "$AUTO_DATA_TARGET/$V_YEAR/$V_month" ]; then
    if ! mkdir -p $AUTO_DATA_TARGET/$V_YEAR/$V_month
    then
      echo "mkdir $AUTO_DATA_TARGET/$V_YEAR/$V_month error"
      exit 1
    fi
  fi

	sour_file_2=$AUTO_DATA_TARGET/$V_YEAR/$V_DATE/meiti_payuser_list.txt

	if [ ! -f "$sour_file_1" ];then
  	   touch $sour_file_1
 	fi


  	if [ ! -f "$sour_file_2" ];then
   		echo " open file $sour_file_2 fail"
   		exit 1
 	fi
  	if [ ! -f "$sour_file_3" ];then
   		echo " open file $sour_file_3 fail"
   		exit 1
 	fi


 # 当日新增收费用户
   	awk -F'[|,]' '{
   	           str_date="'$V_DATE'|"
                   last_month="'$last_day'"
  		   if(FILENAME=="'$sour_file_1'")
  		   {
		     d[$1]=1
		   }
                   if(FILENAME=="'$sour_file_3'")
                   {
                     e[$1]=1
                   }
		   else{ 
                   if(!(length($12)>0))
                     {
                       $12="未知"
                     }
                   # 如果最后一次订购时间在上个月，且上月,本月均 未收费，算在本月收费
                   if(!($1 in e) && !($1 in d) && ($10=="CI"||$10=="CITJ")&&(substr($9,1,6)==substr(last_month,1,6)))
                     { 
                       print $1"|"$4"|"$3"|"$6"|"$5"|"$2"|"$10"|"$11"|"$12"|"$7"|"$8"|"$9"|"str_date
                     } # 最后一次订购时间在本月，且本月为收费

                   else if(!($1 in d) && ($10=="CI"||$10=="CITJ")&&(substr($9,1,6)==substr(str_date,1,6)))
		     {
		       print $1"|"$4"|"$3"|"$6"|"$5"|"$2"|"$10"|"$11"|"$12"|"$7"|"$8"|"$9"|"str_date
		     }
                 }
	}' $sour_file_1 $sour_file_3 $sour_file_2 >> $sour_file_1
   if [ $V_month != $V_DATE ] ;then
    cp $sour_file_1 $TARGET_DIR
    #cp $sour_file_1 $REPORT_DIR
   fi
   wait $!
