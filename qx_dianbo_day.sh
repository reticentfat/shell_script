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
#数据文件
CMPP_FILE=$AUTO_DATA_TARGET/$V_YEAR/$V_DATE/qx_cmpp_dianbo.txt
MM7_FILE=$AUTO_DATA_TARGET/$V_YEAR/$V_DATE/qx_mm7_dianbo.txt
#字典文件
QX_DICT=$AUTO_DANA_NODIST/qx_appcode.txt
#结果文件
DATA_FILE=$AUTO_DATA_TARGET/$V_YEAR/$V_DATE/qx_dianboSucUser.txt
RESULT_DIANBO=$AUTO_DATA_REPORT/$V_YEAR/$V_DATE/report.region.qx_subscribeBilling_dianbo_city.csv
#前向点播数据
deal_qxDianbo(){
QX_DICT=$1
CMPP_FILE=$2
MM7_FILE=$3
RESULT_DIANBO=$4

gawk -F\| 'BEGIN{
	while(getline var< "'$QX_DICT'"){
		split(var,a,"|")
		#获取点播字典表:appcode|短信|大类|业务类型|业务主类|业务名称|业务金额|业务资费
		if(a[7]=="02"){
			dianbo[a[3]]=a[3]","a[10]","a[4]","a[8]","a[14]","a[5]","a[6]
			#dianbo[a[3]]=a[3]","a[12]
		}
	}
}{
	area_info=$1","$2","$3","$4
	phone=$5
	appcode=$6
	sendNum=$7
	if($6 in dianbo ){
		dianboUser[area_info","dianbo[appcode]"`"phone]=1
		dianboCount[area_info","dianbo[appcode]]+=sendNum
	}
}END{
	for(k in dianboUser){
		dBUser[substr(k,1,index(k,"`")-1)]++
	}
	for(i in dianboCount){
		print i","dBUser[i]","dianboCount[i] >>"'$RESULT_DIANBO'"
	}
}' $CMPP_FILE $MM7_FILE
}
main(){
#判断数据源是否存在
DIR_LIST="$CMPP_FILE $MM7_FILE $QX_DICT"
for i in $DIR_LIST
do 
	if [ ! -f $i ];then
		echo "$i not found"
		exit 2
	fi
done
#生成点播数据
echo "省编码,市编码,省名称,市名称,appcode,短信,业务类型,业务主类,业务名称,业务金额,业务资费,点播用户数,点播成功下发次数" >$RESULT_DIANBO
deal_qxDianbo $QX_DICT $CMPP_FILE $MM7_FILE $RESULT_DIANBO
}
main
