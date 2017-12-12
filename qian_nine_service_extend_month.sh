#!/bin/sh
. /usr/local/app/dana/current/ETL/profile

if [ $# -eq 1 ] ; then
    V_DATE=$1
else
    echo "Usage:$0 "
    exit 1
fi

V_DAY=$(echo $V_DATE | cut -c 7-8)
if [ $V_DAY -ne "02" ];then
    echo "不是月初，日期不符合文件生成日期"
    exit 1
fi

DATE=`date  -v-2d -j ${V_DATE}"0000" +%Y%m%d`
V_YEAR=$(echo $DATE | cut -c 1-4)
V_MONTH=$(echo $DATE | cut -c 1-6)

CODE_DIR=$AUTO_DATA_NODIST
node_file=$CODE_DIR/qx_appcode_extend.txt
REPORT_DIR=/logs/out/dana/wire/$V_YEAR/month_$V_MONTH
DATA_DIR=$AUTO_DATA_REPORT/$V_YEAR/month_$V_MONTH
data_file=$DATA_DIR/report.region.qianxiang_pause_subcribe_city.csv
dianbo_file=$DATA_DIR/report.region.qx_subscribeBilling_dianbo_city.csv
result_file=$REPORT_DIR/report.region.qianxiang_pause_subcribe_extend_city.csv
if [ ! -f "$data_file" ];then
	echo "订购文件不存在"
	exit 1
fi
if [ ! -f "$dianbo_file" ];then
	echo "点播文件不存在"
	exit 2
fi
>$result_file
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
