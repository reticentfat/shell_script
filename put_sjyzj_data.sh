#/bin/sh

YT1=`date -v-0d +%Y-%m-%d`
YT=`date -v-0d +%Y%m%d`
echo $YT1


date

mysql -ur_slave_db -pwzMIWdZ93n45d5NT -h192.100.7.19 -D WZCX_DB -N -e " SELECT mobile_sn, mobile_sub_time, fee_app_code,OPT_ADDR,cp_id FROM wzcx_sub WHERE mobile_modify_time > '"$YT1" 01:00:00' AND mobile_sub_time <= '"$YT1" 01:00:00' into outfile '/tmp/"$YT"_wzcx.txt' LINES TERMINATED BY '\n';" 



scp /tmp/"$YT"_*.txt gateway@192.100.7.25:/data/wxlog/

date
