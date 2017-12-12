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
V_YEAR=$(echo $V_DATE | cut -c 1-4)
WEEKNUM=$(date -v-0d -j ${V_DATE}0000 +%w)
[ $WEEKNUM -ne 2 ] && exit 
END_DATE=$(date -v-0d -j $V_DATE"0000" +%Y%m%d)
BEGIN_DATE=$(date -v-6d -j $V_DATE"0000" +%Y%m%d)
LAST_END_DATE=$(date -v-7d -j $V_DATE"0000" +%Y%m%d)

#数据文件
DATA_FILE=$AUTO_DATA_REPORT/$V_YEAR/week_${BEGIN_DATE}_${END_DATE}/qx_dianbo_tmp_user.txt
#当前周期数据文件
loop=6
while [ $loop -ge 0 ] 
do
  TMP_DAY=$(date -v-${loop}d -j $END_DATE"0000" +%Y%m%d)
  TMP_YEAR=$(echo $TMP_DAY | cut -c 1-4)
  TMP_CMPP_FILE=`echo "$TMP_CMPP_FILE $AUTO_DATA_TARGET/$TMP_YEAR/$TMP_DAY/qx_cmpp_dianbo.txt"`
  TMP_MM7_FILE=`echo "$TMP_MM7_FILE $AUTO_DATA_TARGET/$TMP_YEAR/$TMP_DAY/qx_mm7_dianbo.txt"`
  loop=`expr $loop - 1`
done
cat $TMP_CMPP_FILE $TMP_MM7_FILE |awk -F\| '{a[$1"|"$2"|"$3"|"$4"|"$5"|"$6]+=$7}END{for(i in a){print i"|"a[i]}}' >$DATA_FILE
#上一周期数据文件
loop=6
while [ $loop -ge 0 ] 
do
  TMP_DAY=$(date -v-${loop}d -j $LAST_END_DATE"0000" +%Y%m%d)
  TMP_YEAR=$(echo $TMP_DAY | cut -c 1-4)
  LAST_CMPP=`echo "$LAST_CMPP $AUTO_DATA_TARGET/$TMP_YEAR/$TMP_DAY/qx_cmpp_dianbo.txt"`
  LAST_MM7=`echo "$LAST_MM7 $AUTO_DATA_TARGET/$TMP_YEAR/$TMP_DAY/qx_mm7_dianbo.txt"`
  loop=`expr $loop - 1`
done
LAST_FILE=$AUTO_DATA_REPORT/$V_YEAR/week_${BEGIN_DATE}_${END_DATE}/qx_dianbo_lastUser.txt
cat $LAST_CMPP $LAST_MM7|awk -F\| '{print $1"|"$2"|"$3"|"$4"|"$5"|"$6}'|sort -u >$LAST_FILE
#字典文件
QX_DICT=$AUTO_DANA_NODIST/qx_appcode.txt
#结果文件
RESULT_DIANBO=$AUTO_DATA_REPORT/$V_YEAR/week_${BEGIN_DATE}_${END_DATE}/report.region.qx_subscribeBilling_dianbo_city.csv
#前向点播数据
deal_qxDianbo(){
QX_DICT=$1
LAST_FILE=$2
DATA_FILE=$3
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
}{if(FILENAME=="'$LAST_FILE'"){
	area_info=$1","$2","$3","$4
	phone=$5
	appcode=$6
        if(!(area_info","phone","appcode in lastUser)){
            lastUserCount[area_info","dianbo[appcode]]++
	    lastUser[area_info","phone","appcode]=1
        }
}else if(FILENAME=="'$DATA_FILE'"){
	area_info=$1","$2","$3","$4
	phone=$5
	appcode=$6
	sendNum=$7
	if($6 in dianbo ){
		dianboUser[area_info","dianbo[appcode]"`"phone]=1
		dianboCount[area_info","dianbo[appcode]]+=sendNum
		if((area_info","phone","appcode in lastUser) && (!(area_info","phone","appcode in serveUser))){
			serveUser[area_info","phone","appcode]=1
			dianboServeUser[area_info","dianbo[appcode]]++
		}
	}
}}END{
	for(k in dianboUser){
		dBUser[substr(k,1,index(k,"`")-1)]++
	}
	for(i in dianboCount){
		print i","dBUser[i]","dianboCount[i]","dianboServeUser[i]","lastUserCount[i] >>"'$RESULT_DIANBO'"
	}
}' $LAST_FILE $DATA_FILE
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
echo "省编码,市编码,省名称,市名称,appcode,短信,业务类型,业务主类,业务名称,业务金额,业务资费,点播用户数,点播成功下发次数,点播留存用户数,上月点播成功用户数" >$RESULT_DIANBO
deal_qxDianbo $QX_DICT $LAST_FILE $DATA_FILE $RESULT_DIANBO
}
main
