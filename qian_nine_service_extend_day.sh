#!/bin/sh
. /usr/local/app/dana/current/ETL/profile

if [ $# -eq 1 ] ; then
    V_DATE=$1
else
    echo "Usage:$0 "
    exit 1
fi


CODE_DIR=$AUTO_DATA_NODIST
V_YEAR=$(echo $V_DATE | cut -c 1-4)
REPORT_DIR=/logs/out/dana/wire/$V_YEAR/$V_DATE
node_file=$CODE_DIR/qx_appcode_extend.txt
data_file=$REPORT_DIR/report.region.qianxiang_pause_subcribe_city.csv
dianbo_file=$AUTO_DATA_REPORT/$V_YEAR/$V_DATE/report.region.qx_subscribeBilling_dianbo_city.csv
result_file=$REPORT_DIR/report.region.qianxiang_pause_subcribe_extend_city.csv
if [ ! -f $dianbo_file ];then	
	echo "订购文件不存在"
	exit 1
fi
if [ ! -f $data_file ];then
	echo "点播文件不存在"
	exit 2
fi
#清空结果文件
>$result_file 
awk 'BEGIN{
      FS=","
    }{
       if(FILENAME=="'$node_file'"){
           a[$1]=$2
       }else if(FILENAME=="'$data_file'"){
            if($6 in a ){
            print $1","$2","$3","$4","a[$6]","$6","$7","$8","$9","$10","$11","$12","$13","$14","$15","$16","$17","$18 >>"'$result_file'"
            }else{
            print $1","$2","$3","$4","$5","$6","$7","$8","$9","$10","$11","$12","$13","$14","$15","$16","$17","$18 >>"'$result_file'"
            }
       }else{
			if($9 in a){
				print $1","$2","$3","$4","a[$9]","$9","$7","$11",,"$12",,,,,,,," >>"'$result_file'"
            }else{
            print $1","$2","$3","$4","$8","$9","$7","$11",,"$12",,,,,,,," >>"'$result_file'"
            }
	   }
    }' $node_file $data_file $dianbo_file
