#/bin/sh

YT=`date -v-1d +%Y-%m-%d`
TODAY=`date +%Y-%m-%d`


#echo 'use wzcx_db ; select mobile_sn,addr_code,addr_nation_code,car_no,car_type,car_sn,fee_app_code,mobile_type from wzcx_sub where opt_addr = "guangdong" and cp_id = "foshan" and mobile_modify_state = 3 into outfile "/usr/local/www/cron/foshan_wzcx_user.txt" fields terminated by " "   lines terminated by "\n";' |  mysql -uroot -p010@bj12580umg2011;
echo 'use WZCX_DB ; select MOBILE_SN,ADDR_CODE,ADDR_NATION_CODE,CAR_NO,CAR_TYPE,CAR_SN,FEE_APP_CODE,MOBILE_TYPE from wzcx_sub where OPT_ADDR = "GUANGDONG" AND CP_ID = "FOSHAN" AND MOBILE_MODIFY_STATE = 3 into outfile "/usr/local/www/cron/foshan_wzcx_user.txt" fields terminated by " "   LINES TERMINATED BY "\n";' |  mysql -h192.100.7.19 -ur_slave_db -pwzMIWdZ93n45d5NT;





echo "wireless_operation tables finish "

STR="FOSHAN"
DEALDATE=$STR`date +%Y%m%d`

if [ ! -d ./$DEALDATE ];then
mkdir ./$DEALDATE
fi

mv foshan_wzcx_user.txt ./$DEALDATE/

bzip2 $DEALDATE/foshan_wzcx_user.txt 

mv $DEALDATE /usr/local/www/interface/fs_wzcx/















