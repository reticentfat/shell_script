#!/bin/sh
. /usr/local/app/dana/current/shbb/profile

if [ $# -eq 1 ] ; then
    V_DATE=$1
else
    echo "Usage:$0 20140101"
    exit 1
fi


deal_week(){
END_DATE=$(date -v-0d -j $V_DATE"0000" +%Y%m%d)
BEGIN_DATE=$(date -v-6d -j $V_DATE"0000" +%Y%m%d)
LAST_END_DATE=$(date -v-7d -j $V_DATE"0000" +%Y%m%d)
LAST_YEAR=$(echo $LAST_END_DATE|cut -c 1-4)
LAST_BEGIN_DATE=$(date -v-13d -j $V_DATE"0000" +%Y%m%d)

CODE_DIR=$AUTO_DATA_NODIST
NODIST_DIR=$AUTO_DANA_NODIST
dict_file=$NODIST_DIR/qx_appcode.txt
TARGET_DIR=$AUTO_DATA_TARGET/$V_YEAR/$END_DATE
LAST_TARGET=$AUTO_DATA_TARGET/$LAST_YEAR/$LAST_END_DATE
#数据文件
DATA_FILE=$TARGET_DIR/etl_qx_subscribe.txt
LAST_FILE=$LAST_TARGET/etl_qx_subscribe.txt
#结果文件
REPORT_DIR=$AUTO_DATA_REPORT/$V_YEAR/week_${BEGIN_DATE}_${END_DATE}
REPORT_SUB=$AUTO_DATA_REPORT/$V_YEAR/week_${BEGIN_DATE}_${END_DATE}/report.region.qx_subscribe_city.csv
#临时文件
tmp_week_subsribe=$REPORT_DIR/tmp_report_week_subscribe_sh.csv
tmp_report_week_subscribe=$REPORT_DIR/tmp_report_week_subscribe.csv
#清空中间文件
>$tmp_week_subsribe
>$tmp_report_week_subscribe
####################################################################################################
#周新增订购退订指标
loop=6
while [ $loop -ge 0 ] 
do
  day=$(date -v-${loop}d -j $END_DATE"0000" +%Y%m%d)
  V_YEAR=$(echo $day | cut -c 1-4)
  cat $AUTO_DATA_REPORT/$V_YEAR/$day/report.region.qx_subscribe_city.csv >>$tmp_week_subsribe
  loop=`expr $loop - 1`
done

awk -F\, '{
    flag=$1","$2","$3","$4","$5","$6","$7","$8","$9","$10","$11","$12
    all[flag]=1
    a[flag]+=$13
    b[flag]+=$14
}END{for(i in all){
    printf("%s,%d,%d\n",i,a[i],b[i])
}}' $tmp_week_subsribe >$tmp_report_week_subscribe
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
		phone=$5;appcode=$6;optime=substr($8,1,8);status=$7;
		chanelOne=(length($12)>0) ? $12:"未知";
		area_info=$1","$2","$3","$4
		dict_list=area_info","dict[appcode]","chanelOne
		if(status=="06" && appcode in dict){
		#上周在订用户
			last_sub[dict_list","phone]=1
			lastSubUser[dict_list]++
		#上周新增订购用户
			if(optime<="'$LAST_END_DATE'"&&optime>="'$LAST_BEGIN_DATE'"){
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
			if( substr(option_time,1,8)>="'$BEGIN_DATE'"&& substr(option_time,1,8)<="'$END_DATE'" && status=="07" && (d-e)<=259200){
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
}' $LAST_FILE $DATA_FILE $tmp_report_week_subscribe >>$REPORT_SUB
rm $tmp_week_subsribe $tmp_report_week_subscribe
}
deal_nine_week(){
END_DATE=$(date -v-0d -j $V_DATE"0000" +%Y%m%d)
BEGIN_DATE=$(date -v-6d -j $V_DATE"0000" +%Y%m%d)
LAST_END_DATE=$(date -v-7d -j $V_DATE"0000" +%Y%m%d)
LAST_YEAR=$(echo $LAST_END_DATE|cut -c 1-4)
LAST_BEGIN_DATE=$(date -v-13d -j $V_DATE"0000" +%Y%m%d)

CODE_DIR=$AUTO_DATA_NODIST
NODIST_DIR=$AUTO_DANA_NODIST
dict_file=$NODIST_DIR/qx_appcode.txt
TARGET_DIR=$AUTO_DATA_TARGET/$V_YEAR/$END_DATE
LAST_TARGET=$AUTO_DATA_TARGET/$LAST_YEAR/$LAST_END_DATE
#数据文件
DATA_FILE=$TARGET_DIR/etl_qx_subscribe.txt
LAST_FILE=$LAST_TARGET/etl_qx_subscribe.txt
#结果文件
REPORT_DIR=/logs/out/dana/wire/$V_YEAR/week_${BEGIN_DATE}_${END_DATE}
REPORT_SUB=$REPORT_DIR/week_${BEGIN_DATE}_${END_DATE}/report.region.qianxiang_pause_subcribe_city.csv
#临时文件
tmp_week_subsribe=$REPORT_DIR/tmp_report_week_subscribe_sh_tmp.csv
tmp_report_week_subscribe=$REPORT_DIR/tmp_report_week_subscribe.csv
tmp_result=$REPORT_DIR/tmp_result.csv
#九大业务周报
echo "省编码,省名称,市编码,市名称,业务主类,业务名称,业务类型,业务资费,前向包月订购用户数,订购用户数,点播用户数,退订用户数,付费用户数,上周新增包月用户数,上周新增留存用户数,本周留存包月用户数,上周包月用户数,本周留存点播用户数,上周点播用户数,四川业务类型,四川业务名称,四川业务资费,暂停用户数,本周开通72小时退订用户数" > $REPORT_FILE
####################################################################################################
#清空中间文件
>$tmp_week_subsribe
>$tmp_report_week_subscribe
#周新增订购退订指标
loop=6
while [ $loop -ge 0 ] 
do
  day=$(date -v-${loop}d -j $END_DATE"0000" +%Y%m%d)
  V_YEAR=$(echo $day | cut -c 1-4)
  cat $AUTO_DATA_REPORT/$V_YEAR/$day/report.region.qx_subscribe_city.csv >>$tmp_week_subsribe
  loop=`expr $loop - 1`
done

awk -F\, '{
    flag=$1","$2","$3","$4","$5
    all[flag]=1
    a[flag]+=$13
    b[flag]+=$14
}END{for(i in all){
    printf("%s,%d,%d\n",i,a[i],b[i])
}}' $tmp_week_subsribe >$tmp_report_week_subscribe
#留存用户，新增包月留存，存量包月留存，本月开通72小时，暂停用户
gawk '{
	FS="[|,]"
	OFS=","
	while(getline var < "'$dict_file'"){
		#appcode|短彩|业务类型|业务主类|业务名称|业务金额|业务资费
		dict[a[3]]=1
	}
}{
	if(FILENAME=="'$LAST_FILE'"){
		phone=$5;appcode=$6;optime=$8;status=$7;
		area_info=$1","$2","$3","$4
		dict_list=area_info","appcode
		if(status=="06" && appcode in dict){
		#上周在订用户
			last_sub[dict_list","phone]=1
			lastSubUser[dict_list]++
		#上周新增订购用户
			if(optime<="'$LAST_END_DATE'"&&optime>="'$LAST_BEGIN_DATE'"){
				last_new[dict_list","phone]=1
				lastNewUser[dict_list]++
			}
			
		}
	}else if(FILENAME=="'$DATA_FILE'"){
		phone=$5;appcode=$6;optime=substr($8,1,8);status=$7;pause_status=$11;first_time=$9
		chanelOne=(length($12)>0) ? $12:"未知";
		area_info=$1","$2","$3","$4
		dict_list=area_info","appcode
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
		#本月开通72小时退订用户
			 #退订时间
			yy=substr(option_time,1,4);mm=substr(option_time,5,2);dd=substr(option_time,7,2);hh=substr(option_time,9,2) ;Mi=substr(option_time,11,2); ss=substr(option_time,13,2)
			s=yy" "mm" "dd" "hh" "Mi" "ss
			d=mktime(s)
			#本月首次订购时间
			yy=substr(first_time,1,4);mm=substr(first_time,5,2);dd=substr(first_time,7,2);hh=substr(first_time,9,2) ;Mi=substr(first_time,11,2); ss=substr(first_time,13,2)
			s=yy" "mm" "dd" "hh" "Mi" "ss
			e=mktime(s)
			#时间差=退订时间-上一次订购时间
			if( substr(option_time,1,8)>="'$BEGIN_DATE'"&& substr(option_time,1,8)<="'$END_DATE'" && status=="07" && (d-e)<=259200){
				subscribe_pause[dict_list]++
			}
		cityUser[dict_list]=1	
		}else{
			next
		}
	}else{
		dict_list=$1","$2","$3","$4","$5","$6","$7","$8","$9","$10","$11","$12
		sub_new[dict_list]+=$13
		sub_can[dict_list]+=$14
		cityUser[dict_list]=1
	}
}END{
	for(i in cityUser){
		print i,",",subUser[i],sub_new[i],"0",sub_can[i],"0",sav_new[i],lastNewUser[i],sav_sub[i],lastSubUser[i],",,,,,"pauseUser[i],subscribe_pause[i]
	}
}' $LAST_FILE $DATA_FILE $tmp_report_week_subscribe >$tmp_result
if [ -f "$tmp_result" ];then
cat $tmp_result|awk -F\, '{print $1,$2,$3,$4,$5,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24}' >>$REPORT_SUB
else	
	echo "$tmp_result not found"
	exit 3
fi
rm $tmp_week_subsribe $tmp_report_week_subscribe $tmp_result
}
V_YEAR=$(echo $V_DATE | cut -c 1-4)
WEEKNUM=$(date -v-0d -j ${V_DATE}0000 +%w)
#if [ $WEEKNUM -eq "0" ];then 
#	deal_nine_week
#el
if [ $WEEKNUM -eq "2" ];then
	deal_week
else
	exit 1
fi	
