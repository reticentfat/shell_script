#!/bin/sh
. /usr/local/app/dana/current/shbb/profile
usage () {
    echo "usage: $0  target_dir" 1>&2
    exit 2
}
  if [ $# -lt 1 ] ; then
     usage
  fi
V_DATE=$1
V_YEAR=$(echo $V_DATE | cut -c 1-4)
V_MONTH=$(echo $V_DATE|cut -c 1-6)
last_3date=`date -v-3d -j ${V_DATE}"0000" +%Y%m%d`
V_DAY=$(echo $V_DATE|cut -c  7-8)
TARGET_DIR=$AUTO_DATA_TARGET/$V_YEAR/$V_DATE
REPORT_DIR=$AUTO_DATA_REPORT/$V_YEAR/$V_DATE
CODE_DIR=$AUTO_DANA_NODIST/qx_appcode.txt

  if [ ! -d "$TARGET_DIR" ]; then
    if ! mkdir -p $TARGET_DIR
    then
      echo "mkdir $TARGET_DIR error"
      exit 1
    fi
  fi
  # 字典文件
  FILE_APP_CODE=$AUTO_DANA_NODIST/qx_appcode.txt

  # 数据文件
  DATA_FILE=$TARGET_DIR/etl_qx_billingUser.txt
  CMPP_FILE=$TARGET_DIR/qx_cmpp.txt
 #目标文件
  REPORT_FILE=$REPORT_DIR/qx_sms_billing.csv
  echo "省编码,市编码,省名称,市名称,appcode,业务名称,渠道,留存计费用户,新增计费用户,计费用户" >$REPORT_FILE

          awk -F\| '{
                   
                  if(FILENAME=="'$FILE_APP_CODE'")
                  {
                  	app[$3]=$5/100
                  }
                  else if(FILENAME=="'$CMPP_FILE'")
                  {
                     userid=$1
                     appcode=$2
                     # 下发次数
                     sendnum=$3
                     USER_NUM[userid","appcode]=sendnum
                  }
                  else if(FILENAME=="'$DATA_FILE'"){
				  prov_name=$3;prov_code=$1;appcode=$6;city=$4;city_code=$2;                       chanel=length($11)>0?$11:"未知";status=$7;optime=$8;pritime=$9;finaltime=$10;user_flag=$12
			      area_info=prov_code","city_code","prov_name","city
				  outlist=area_info","appcode","chanel  
					if(USER_NUM[$5","$6]>=(app[$6]/2))# 包月用户有单条过高的限制
                   {
					  #留存计费
					  if(user_flag=="save"){
						billSaveUser[outlist]++
					  }else if(user_flag=="new"){
						billNewUser[outlist]++
					  }
					   #计费用户
					   city_appcode_chanel[outlist]++
					   cityUser[outlist]=1			
				  } 
               }
			   }END{
                for(name in cityUser){
                     printf("%s,%d,%d,%d\n",name,billSaveUser[name],billNewUser[name],city_appcode_chanel[name]) >>"'$REPORT_FILE'"
                }         
			   }' $FILE_APP_CODE $CMPP_FILE $DATA_FILE




