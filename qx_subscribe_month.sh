#!/bin/sh
. /usr/local/app/dana/current/shbb/profile

if [ $# -eq 1 ] ; then
    V_DATE=$1
else
    echo "Usage:$0 20140101"
    exit 1
fi

V_DAY=$(echo $V_DATE | cut -c 7-8)
#判断是否是2号，否：退出
if [ $V_DAY -eq 02 ];then
	echo "如果是2号,继续执行，否则退出,避免再生资源"
else
	exit 1
fi
V_DATE=$(date -v-2d -j $V_DATE"0000" +%Y%m%d)
V_MONTH=$(echo $V_DATE |cut -c 1-6)
V_YEAR=$(echo $V_MONTH | cut -c 1-4)
LAST_DATE=$(date -v-1m -j $V_DATE"0000" +%Y%m%d)
LAST_YEAR=$(echo $LAST_DATE|cut -c 1-4)
LAST_MONTH=$(echo $LAST_DATE|cut -c 1-6)
CODE_DIR=$AUTO_DATA_NODIST
NODIST_DIR=$AUTO_DANA_NODIST
dict_file=$NODIST_DIR/qx_appcode.txt
QX_SICHUAN=$AUTO_DATA_NODIST/qx_sichuan_appcode.txt

TARGET_DIR=$AUTO_DATA_TARGET/$V_YEAR/$V_DATE
LAST_TARGET=$AUTO_DATA_TARGET/$LAST_YEAR/$LAST_DATE
#数据文件
DATA_FILE=$TARGET_DIR/etl_qx_subscribe.txt
LAST_FILE=$LAST_TARGET/etl_qx_subscribe.txt
#结果文件
REPORT_DIR=$AUTO_DATA_REPORT/$V_YEAR/month_${V_MONTH}
REPORT_SUB=$REPORT_DIR/report.region.qx_subscribe_city.csv
REPORT_NINE=$REPORT_DIR/report.region.qianxiang_pause_subcribe_city.csv

#临时文件
tmp_report_month_subscribe=$REPORT_DIR/tmp_report_month_subscribe.csv
#清空中间文件
>$tmp_report_month_subscribe
####################################################################################################
#周新增订购退订指标
cat $AUTO_DATA_REPORT/$V_YEAR/$V_MONTH*/report.region.qx_subscribe_city.csv |awk -F\, '{city[$1","$2","$3","$4","$5","$6","$7","$8","$9","$10","$11","$12]=1;sub_new[$1","$2","$3","$4","$5","$6","$7","$8","$9","$10","$11","$12]+=$13;sub_can[$1","$2","$3","$4","$5","$6","$7","$8","$9","$10","$11","$12]+=$14}END{for(i in city){print i","sub_new[i]","sub_can[i]}}' >$tmp_report_month_subscribe
#留存用户，新增包月留存，存量包月留存，本月开通72小时，暂停用户
echo "省编码,市编码,省名称,市名称,appcode,短彩类型,业务类型,大类,业务名称,业务金额,业务资费,渠道,存量用户数,新增订购用户数,新增退订用户数,存量暂停用户数,免费期退订用户数,新增包月留存用户数,上月新增用户数,存量留存用户数,上月在订用户数" >$REPORT_SUB
gawk '{
	FS="[|,]"
	OFS=","
	while(getline var < "'$dict_file'"){
		#appcode|短彩|业务类型|业务主类|业务名称|业务金额|业务资费
		split(var,a,"|")
		dict[a[3]]=a[3]","a[10]","a[4]","a[8]","a[14]","a[5]","a[6]
	}
}{
	if(FILENAME=="'$LAST_FILE'"){
		phone=$5;appcode=$6;optime=substr($8,1,6);status=$7;
		chanelOne=(length($12)>0)?$12:"未知";
		area_info=$1","$2","$3","$4
		dict_list=area_info","dict[appcode]","chanelOne
		if(status=="06" && appcode in dict){
		#上周在订用户
			last_sub[dict_list","phone]=1
			lastSubUser[dict_list]++
		#上周新增订购用户
			if(optime=="'$LAST_MONTH'"){
				last_new[dict_list","phone]=1
				lastNewUser[dict_list]++
			}
		}
	}else if(FILENAME=="'$DATA_FILE'"){
		phone=$5;appcode=$6;option_time=$8;status=$7;pause_status=$11;first_time=$9
		chanelOne=(length($12)>0) ? $12:"未知";
		area_info=$1","$2","$3","$4
		dict_list=area_info","dict[appcode]","chanelOne
		if(appcode in dict){
		if(status=="06"){
		#存量用户数
			subUser[dict_list]++
			if(pause_status==0){
				pauseUser[dict_list]++
			}
			if(dict_list","phone in last_sub){
		#上月订购留存用户数
				sav_sub[dict_list]++
			}
			if(dict_list","phone in last_new){
				sav_new[dict_list]++
			}
		}
		#开通72小时退订用户
			 #退订时间
			yy=substr(option_time,1,4);mm=substr(option_time,5,2);dd=substr(option_time,7,2);hh=substr(option_time,9,2) ;Mi=substr(option_time,11,2); ss=substr(option_time,13,2)
			s=yy" "mm" "dd" "hh" "Mi" "ss
			d=mktime(s)
			#本月首次订购时间
			yy=substr(first_time,1,4);mm=substr(first_time,5,2);dd=substr(first_time,7,2);hh=substr(first_time,9,2) ;Mi=substr(first_time,11,2); ss=substr(first_time,13,2)
			s=yy" "mm" "dd" "hh" "Mi" "ss
			e=mktime(s)
			#时间差=退订时间-上一次订购时间
			if( substr(option_time,1,6)>="'$V_MONTH'"&& status=="07" && (d-e)<=259200){
				subscribe_pause[dict_list]++
			}
			cityUser[dict_list]=1
		}
	}else{
		dict_list=$1","$2","$3","$4","$5","$6","$7","$8","$9","$10","$11","$12
		sub_new[dict_list]+=$13
		sub_can[dict_list]+=$14
		cityUser[dict_list]=1
	}
}END{
	for(i in cityUser){
		print i,subUser[i],sub_new[i],sub_can[i],pauseUser[i],subscribe_pause[i],sav_new[i],lastNewUser[i],sav_sub[i],lastSubUser[i]
	}
}' $LAST_FILE $DATA_FILE $tmp_report_month_subscribe >>$REPORT_SUB
#九大业务与四川用的是一个结果文件
# echo "省编码,省名称,市编码,市名称,业务主类,业务名称,业务类型,业务资费,前向订购用户数,订购用户数,点播用户数,退订用户数,计费用户数,四川业务类型,四川业务名称,四川业务资费,暂停用户数,本月开通72小时退订用户数" > $RESULT_NINE
# gawk 'BEGIN{
	# FS=OFS=","
	# while(getline var < "'$QX_SICHUAN'"){
		# split(var,a,"|")
		# si[a[3]]=a[12]","a[11]","a[6]
	# }
# }{	
	# dict_list=$1","$2","$3","$4","$5","$5","$7","$11
	# if($5 in si){
		# city[dict_list]=si[$5]
		# sub_user[dict_list]+=$13
		# sub_new[dict_list]+=$14
		# sub_can[dict_list]+=$15
		# pause[dict_list]+=$16
		# sub_pause[dict_list]+=$17
	# }
# }END{
	# for(i in city){
		# print i","sub_user[i],sub_new[i],"0",sub_can[i],"0",city[i],pause[i],sub_pause[i]
	# }
# }' $REPORT_SUB >>$RESULT_NINE
rm $tmp_report_month_subscribe
