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
V_MONTH=$(echo $V_DATE | cut -c 1-6)
last_3date=`date -v-3d -j ${V_DATE}"0000" +%Y%m%d`
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
  MM7_FILE=$TARGET_DIR/qx_mm7.txt
 #目标文件
  REPORT_FILE=$REPORT_DIR/qx_mms_billing.csv
 # 出报表结果
 echo "省编码,市编码,省名称,市名称,appcode,渠道,留存计费,新增计费,计费用户" >$REPORT_FILE
          awk -F\| '{
                   
                  if(FILENAME=="'$FILE_APP_CODE'")
                  {
                  	app[$3]=$5/100
                  }
                  else if(FILENAME=="'$MM7_FILE'")
                  {
                     userid=$1
                     appcode=$2
                     # 下发次数
                     sendnum=$3
                     USER_NUM[userid"|"appcode]=sendnum
                  }
                  else if(FILENAME=="'$DATA_FILE'"){
					if( ( USER_NUM[$5"|"$6]>(0/2) &&  $6 != "10511055"	&& $6 != "10511052"	&& $6 != "10511003"	&& $6 != "10511004"	&& $6 != "10511050"	&& $6 != "10511005"	&& $6 != "10511019"	&& $6 != "10511020"	&& $6 != "10511022"	&& $6 != "10511051" ) || ( $6 == "10511055" )	|| ( $6 == "10511052"	) || ( $6 == "10511003"	 ) || ( $6 == "10511004" )	|| ( $6 == "10511050" )	|| ( $6 == "10511005" )	|| ($6 == "10511019")	|| ( $6 == "10511020"	) || ($6 == "10511022")	|| ($6 == "10511051") )# 包月用户有单条过高的限制且不为彩改短的业务（10511055	10511052	10511003	10511004	10511050	10511005	10511019	10511020	10511022	10511051），或者为彩改短的业务直接输出，不限制单高 
                   {
                       prov_name=$3
                       prov_code=$1
                       appcode=$6
                       city=$4
                       city_code=$2
                       chanel=length($11)>0? $11:"未知" 
                       status=$7;optime=$8;pritime=$9;finaltime=$10;user_flag=$12
					   area_info=prov_code","city_code","prov_name","city
				        outlist=area_info","appcode","chanel
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
               }' $FILE_APP_CODE $MM7_FILE $DATA_FILE



