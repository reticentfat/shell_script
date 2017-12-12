#!/bin/sh
. /usr/local/app/dana/current/ETL/profile

if [ $# -eq 1 ] ; then
    V_DATE=$1
else
    echo "Usage:$0 "
    exit 1
fi

V_YEAR=$(echo $V_DATE | cut -c 1-4)
WEEKNUM=$(date -v-0d -j ${V_DATE}0000 +%w)
[ $WEEKNUM -ne 0 ] && exit 
END_DATE=$(date -v-0d -j $V_DATE"0000" +%Y%m%d)
BEGIN_DATE=$(date -v-6d -j $V_DATE"0000" +%Y%m%d)

CODE_DIR=$AUTO_DATA_NODIST
REPORT_DIR=/logs/out/dana/wire/$V_YEAR/week_${BEGIN_DATE}_${END_DATE}
dianbo_file=$REPORT_DIR/dianbo.csv
node_file=$CODE_DIR/qx_appcode_extend.txt
QX_DICT=$AUTO_DANA_NODIST/qx_appcode.txt
data_file=$REPORT_DIR/report.region.qianxiang_pause_subcribe_city.csv
result_file=$REPORT_DIR/report.region.qianxiang_pause_subcribe_extend_city.csv
if [ ! -f "$data_file" ];then
	echo "订购文件不存在"
	exit 1
fi
>$result_file
#生成自然周点播用户中间文件
loop=6
while [ $loop -ge 0  ];
do
	TMPDATE=`date -v+${loop}d -j ${BEGIN_DATE}"0000" +%Y%m%d`
	TMPYEAR=$(echo $TMPDATE |cut -c 1-4)
	DATAFILE=`echo $AUTO_DATA_TARGET/$TMPYEAR/$TMPDATE/qx_cmpp_dianbo.txt $AUTO_DATA_TARGET/$TMPYEAR/$TMPDATE/qx_mm7_dianbo.txt $DATAFILE`
	loop=`expr $loop - 1`
done
#生成点播用户结果文件
gawk -F\| 'BEGIN{
	while(getline var< "'$QX_DICT'"){
		split(var,a,"|")
		#获取点播字典表:appcode|短信|大类|业务类型|业务主类|业务名称|业务金额|业务资费
		if(a[7]=="02"){
			dianbo[a[3]]=a[3]","a[10]","a[4]","a[8]","a[14]","a[5]","a[6]
		}
	}
}{
	area_info=$1","$2","$3","$4
	phone=$5
	appcode=$6
	sendNum=$7
	if($6 in dianbo ){
		dianboUser[area_info","dianbo[appcode]"`"phone]=1
	}
}END{
	for(k in dianboUser){
		dBUser[substr(k,1,index(k,"`")-1)]++
	}
	for(i in dBUser ){
		print i","dBUser[i]
	}
}' $DATAFILE >$dianbo_file
if [ ! -f "$dianbo_file" ];then
	echo "点播文件不存在"
	exit 1
fi
awk 'BEGIN{
      FS=","
    }{
       if(FILENAME=="'$node_file'"){
           a[$1]=$2
       }else if(FILENAME=="'$data_file'"){
            if($6 in a){
            print $1","$2","$3","$4","a[$6]","$6","$7","$8","$9","$10","$11","$12","$13","$14","$15","$16","$17","$18","$19","$20","$21","$22","$23","$24 >>"'$result_file'"
            }else{
            print $1","$2","$3","$4","$5","$6","$7","$8","$9","$10","$11","$12","$13","$14","$15","$16","$17","$18","$19","$20","$21","$22","$23","$24 >>"'$result_file'"
            }
	   }else{
		if($9 in a){
            print $1","$2","$3","$4","a[$9]","$9","$7","$11",,"$12",,,,,,,,,,,,,," >>"'$result_file'"
            }else{
            print $1","$2","$3","$4","$8","$9","$7","$11",,"$12",,,,,,,,,,,,,," >>"'$result_file'"
            }
	   }
    }' $node_file $data_file $dianbo_file
