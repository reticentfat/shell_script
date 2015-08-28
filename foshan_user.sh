#/bin/sh

YT=`date -v-1d +%Y-%m-%d`
TODAY=`date +%Y-%m-%d`


echo 'use WZCX_DB ; select MOBILE_SN,ADDR_CODE,ADDR_NATION_CODE,CAR_NO,CAR_TYPE,CAR_SN,FEE_APP_CODE,MOBILE_TYPE from wzcx_sub where OPT_ADDR = "GUANGDONG" AND CP_ID = "FOSHAN" AND MOBILE_MODIFY_STATE = 3 into outfile "/data0/gateway/cron/ftplog2dcp/foshan_wzcx_user.txt" fields terminated by " "   LINES TERMINATED BY "\n";' |  mysql -uroot -p1234567890;



echo "wireless_operation tables finish "

STR="FOSHAN"
DEALDATE=$STR`date +%Y%m%d`

if [ ! -d ./$DEALDATE ];then
mkdir ./$DEALDATE
fi

mv foshan_wzcx_user.txt ./$DEALDATE/

bzip2 $DEALDATE/foshan_wzcx_user.txt 

#rm -rf /data0/gateway/cron/ftplog2dcp/$DEALDATE
mv $DEALDATE /data0/12580/api/fosha_data/







