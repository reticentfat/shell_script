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
last_3date=`date -v-3d -j ${V_DATE}"0000" +%Y%m%d`
V_DAY=$(echo $V_DATE|cut -c  7-8)
#数据文件
CMPP_FILE=$AUTO_DATA_REPORT/$V_YEAR/$V_DATE/qx_sms_billing.csv
MM7_FILE=$AUTO_DATA_REPORT/$V_YEAR/$V_DATE/qx_mms_billing.csv
#字典文件
QX_DICT=$AUTO_DANA_NODIST/qx_appcode.txt
QX_CHANEL=$AUTO_DANA_NODIST/qx_chanel.txt
#结果文件
RESULT_FILE=$AUTO_DATA_REPORT/$V_YEAR/$V_DATE/report.region.qx_billing_city.csv
#判断文件是否存在
list="$CMPP_FILE $MM7_FILE $QX_DICT"
for i in $list
do
	if [ ! -f $i ];then
		echo "$i not exits"
		exit 3
	fi
done

echo "省编码,市编码,省名称,市名称,appcode,短彩类型,业务类型,大类,业务名称,业务金额,业务资费,渠道,留存计费用户,新增计费用户,计费用户" >$RESULT_FILE
#前向新增计费用户
awk -F\, 'BEGIN{
#导入前向业务字典
while(getline var < "'$QX_DICT'"){
	split(var,a,"|")
	#获取点播字典表:appcode|短彩|业务类型|业务主类|业务名称|业务金额|业务资费
	dict[a[3]]=a[3]","a[10]","a[4]","a[8]","a[14]","a[5]","a[6]
}
}{
#留存计费
#新增计费
#计费用户
area_info=$1","$2","$3","$4
appcode=$5;channel=$6
if( appcode in dict){
	print area_info","dict[appcode]","channel","$7","$8","$9
}
}' $CMPP_FILE $MM7_FILE >>$RESULT_FILE
rm $CMPP_FILE $MM7_FILE
