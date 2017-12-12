#!/bin/sh
. /usr/local/app/dana/current/shbb/profile
#执行日期
if [ $# -eq 1 ] ; then
    V_DATE=$1
else
    echo "Usage:$0 20140101"
    exit 1
fi
V_YEAR=$(echo $V_DATE|cut -c  1-4)
V_MONTH=$(echo $V_DATE|cut -c 1-6)
V_DAY=$(echo $V_DATE|cut -c 7-8)
#月末倒数第3天
lastMonthEnd=` date -v-3d -j ${V_DATE}"0000" +%Y%m%d `
REPORT_DIR=$AUTO_DATA_REPORT/$V_YEAR/$V_DATE
REPORT_NINE_DIR=/logs/out/dana/wire/$V_YEAR/$V_DATE
#数据文件
DATA_FILE=$AUTO_DATA_TARGET/$V_YEAR/$V_DATE/etl_qx_subscribe.txt
#字典文件
#QX_DICT=$AUTO_DATA_NODIST/wuxian_appcode.txt
QX_DICT=$AUTO_DANA_NODIST/qx_appcode.txt
QX_CHANEL_TMP=$AUTO_DANA_NODIST/qxChanelTmp.txt
QX_CHANEL=$AUTO_DANA_NODIST/qx_channel.txt
QX_SICHUAN=$AUTO_DATA_NODIST/qx_sichuan_appcode.txt
#结果文件
RESULT_ADD_ORDER=$REPORT_DIR/report.region.qx_subscribe_city.csv
RESULT_LAW_ORDER=$REPORT_DIR/report.region.qx_subscribe_law_city.csv
RESULT_LJ_ORDER=$REPORT_DIR/report.region.qx_subscribe_lj_city.csv
RESULT_SH=$REPORT_DIR/report.region.qx_subscribe_sh_city.csv
#四川前向报表结果文件
RESULT_SICHUAN=$REPORT_DIR/report.region.qianxiang_subscribe_city.csv
#九大业务依赖的结果文件
RESULT_NINE=$REPORT_NINE_DIR/report.region.qianxiang_pause_subcribe_city.csv
#前向订购数据
deal_addQxOrder(){
QX_DICT=$1
DATA_FILE=$2
QX_CHANEL_TMP=$3
RESULT_ADD_ORDER=$4
RESULT_LJ_ORDER=$5
RESULT_SH=$6
gawk -F\| 'BEGIN{
#导入前向业务字典
while(getline var < "'$QX_DICT'"){
	split(var,a,"|")
	#获取点播字典表:appcode|短彩|业务类型|业务主类|业务名称|业务金额|业务资费
	#a[3]","a[10]","a[8]","a[12]","a[4]","a[6]
	dict[a[3]]=a[3]","a[10]","a[4]","a[8]","a[12]","a[5]","a[6]
}
}{
if($6 in  dict){
    phone=$5;appcode=$6;status=$7;
	chanelOne=(length($12)>0)?$12:"未知" ;optime=$8;firstTime=$9;finalTime=$10;pauseStatus=$11;
	area_info=$1","$2","$3","$4
	#新增订购用户数
	if(status=="06" && substr(optime,1,8)=="'$V_DATE'" ){
		newSubUserChannel[area_info","dict[appcode]","chanelOne]++
		newSubUser[area_info","dict[appcode]]++
	}else if(status=="07" && substr(firstTime,1,8)=="'$V_DATE'"){	
		newSubUserChannel[area_info","dict[appcode]","chanelOne]++
		newSubUser[area_info","dict[appcode]]++
	}
	#新增退订用户数
	if(status=="07" && substr(optime,1,8)=="'$V_DATE'" ){
		newCancelUserChannel[area_info","dict[appcode]","chanelOne]++
		newCancelUser[area_info","dict[appcode]]++
	}
	#当月当日累计暂停用户数
	if(substr(firstTime,1,8)>="'$V_MONTH'01" && pauseStatus=="0" && substr(firstTime,1,8)<="'$V_DATE'"){
		newPauseUserChannel[area_info","dict[appcode]","chanelOne]++
	}
	#即订即退用户数
	if(status=="07" && substr(optime,1,8)=="'$V_DATE'" && substr(finalTime,1,8)=="'$V_DATE'"){
		SubCanUserChannel[area_info","dict[appcode]","chanelOne]++
	}
	t=optime
	yy=substr(t,1,4);mm=substr(t,5,2);dd=substr(t,7,2);
	hh=substr(t,9,2) ;Mi=substr(t,11,2); ss=substr(t,13,2)
	s=yy" "mm" "dd" "hh" "Mi" "ss
	opTemp=mktime(s)
	#首次订购时间转时间戮开始:
	t=firstTime
	yy=substr(t,1,4);mm=substr(t,5,2);dd=substr(t,7,2);
	hh=substr(t,9,2) ;Mi=substr(t,11,2); ss=substr(t,13,2)
	s=yy" "mm" "dd" "hh" "Mi" "ss
	firstTemp=mktime(s)
	#免费期退订用户数
	if(status=="07" && substr(optime,1,8)=="'$V_DATE'" && (opTemp-firstTemp)<=259200){
		freeCancelUserChannel[area_info","dict[appcode]","chanelOne]++
		freeCancelUser[area_info","dict[appcode]]++
	}
	#当月订当月退用户
	if(status=="07" && substr(optime,1,6)=="'$V_MONTH'" && substr(firstTime,1,6)=="'$V_MONTH'" && substr(optime,1,8)=="'$V_DATE'"){
		MonSubCanUserChannel[area_info","dict[appcode]","chanelOne]++
	}
	#存量用户数 
	if(status=="06"){
		subUser[area_info","dict[appcode]]++
		SubUserChannel[area_info","dict[appcode]","chanelOne]++
	}
	#暂停用户数
	if(status=="06" && pauseStatus=="0"){
		pauseUserChannel[area_info","dict[appcode]","chanelOne]++
		pauseUser[area_info","dict[appcode]]++
	}
	#通用数组
	cityUser[area_info","dict[appcode]]=1
	cityUserChannel[area_info","dict[appcode]","chanelOne]=1
	qxChanel[chanelOne]=1
}
}END{
	for(i in cityUserChannel){
		print i","newSubUserChannel[i]","newCancelUserChannel[i]","SubCanUserChannel[i]","freeCancelUserChannel[i]","MonSubCanUserChannel[i]  >>"'$RESULT_ADD_ORDER'"
	}
	for(j in cityUserChannel){
		print j","SubUserChannel[j]","newPauseUserChannel[j]","pauseUserChannel[j] >>"'$RESULT_LJ_ORDER'"
	}
	for(k in qxChanel){
		print k	>>"'$QX_CHANEL_TMP'"
	}
	for(l in cityUser){
		print l","subUser[l]","newSubUser[l]",0,"newCancelUser[l]",0,"pauseUser[l]","freeCancelUser[l] >>"'$RESULT_SH'"
	}
}' $DATA_FILE
}
main(){
#判断数据源是否存在
DIR_LIST="$DATA_FILE $QX_DICT"
for i in $DIR_LIST
do 
	if [ ! -f $i ];then
		echo "$i not found"
		exit 2
	fi
done
#生成前向订购数据,某些指标是可加的，所以不融合
echo "省编码,市编码,省名称,市名称,appcode,短彩类型,业务类型,大类,业务名称,业务金额,业务资费,渠道,新增订购用户数,新增退订用户数,即订即退用户数,免费期退订用户数,当月订当月退用户" >$RESULT_ADD_ORDER
echo "省编码,市编码,省名称,市名称,appcode,短彩类型,业务类型,大类,业务名称,业务金额,业务资费,渠道,存量用户数,本月暂停用户数,存量暂停用户数" >$RESULT_LJ_ORDER
#将合并的结果文件置空，避免追加
>$RESULT_SH
deal_addQxOrder $QX_DICT $DATA_FILE $QX_CHANEL_TMP $RESULT_ADD_ORDER $RESULT_LJ_ORDER $RESULT_SH
#若渠道字典文件不存在，新建空文件(主要用于字典初始化)
if [ ! -f $QX_CHANEL ];then
	> $QX_CHANEL
fi
awk '{if(FILENAME=="'$QX_CHANEL'"){a[$1]=1}else{if(!($1 in a)){print}}}' $QX_CHANEL $QX_CHANEL_TMP |awk '$1!~/[0-9]+/ && $1!=""{print}'|sort -u >>$QX_CHANEL
#生成四川前向报表日报
# echo "省编码,省名称,市编码,市名称,业务主类,业务名称,业务类型,业务资费,前向订购用户数,订购用户数,点播用户数,退订用户数,计费用户数,四川业务类型,四川业务名称,四川业务资费" > $RESULT_SICHUAN
# if [ -f "$RESULT_SH" ];then
# gawk 'BEGIN{
	# FS=OFS=","
	# while(getline var < "'$QX_SICHUAN'"){
		# split(var,a,"|")
		# si[a[3]]=a[12]","a[11]","a[6]
	# }
# }{
	# if($5 in si){
		# print $1,$2,$3,$4,$8,$9,$7,$11,$12,$13,$14,$15,$16,a[$5]
	# }
# }' $RESULT_SH >>$RESULT_SICHUAN
# else
	# exit 1
# fi
#生成九大业务日报文件
# echo "省编码,省名称,市编码,市名称,业务主类,业务名称,业务类型,业务资费,前向订购用户数,订购用户数,点播用户数,退订用户数,计费用户数,四川业务类型,四川业务名称,四川业务资费,暂停用户数,本月开通72小时退订用户数" > $RESULT_NINE
# cat $RESULT_SH |awk -F\, '{print $1","$2","$3","$4","$5","$5","$10","$11","$12","$13","$14","$15","$16",,,,"$17","$18}' >>$RESULT_NINE
#前向订退量法律百科报表
echo "省编码,市编码,省名称,市名称,appcode,短彩类型,业务类型,大类,业务名称,业务金额,业务资费,渠道,新增订购用户数,新增退订用户数" >$RESULT_LAW_ORDER
if [ -f "$RESULT_ADD_ORDER" ];then
	cat $RESULT_ADD_ORDER |grep -E "10301079|10511051" |awk -F\, '{print $1","$2","$3","$4","$5","$5","$10","$11","$12","$13","$14}'>>$RESULT_LAW_ORDER
else 
	echo "$RESULT_ADD_ORDER not found"
exit 2
fi
}
main
rm $QX_CHANEL_TMP