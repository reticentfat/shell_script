#/bin/sh

#----------------------
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/home/wuying/;
export PATH
#export PATH=/home/wuying/
if [ $# -eq 3 ];then
   AGO_DAY1=$1
   AGO_DAY2=$2
   AGO_DAY_2=$3
   
fi

if [ ${AGO_DAY1:=999} = 999 ];then
RECOMMDATE=`date -v-0d  +%Y%m%d`
DEALDATE=`date -v-1d  +%Y%m%d`
DATEYEAR=`date -v-1d  +%Y`
DEALDATE2=`date -v-1d  +%m%d`
DEALDATE3=`date -v-1d  +%Y%m`
DEALDATE_1=`date -v-1d  +%Y-%m-%d`
DEALDATE_2=`date -v-0d  +%Y-%m-%d` 
else
RECOMMDATE=`date -v-${AGO_DAY1}d  +%Y%m%d`
DEALDATE=`date -v-${AGO_DAY2}d  +%Y%m%d`
DATEYEAR=`date -v-${AGO_DAY2}d  +%Y`
DEALDATE2=`date -v-${AGO_DAY2}d  +%m%d`
DEALDATE3=`date -v-${AGO_DAY2}d  +%Y%m`
DEALDATE_1=`date -v-${AGO_DAY2}d  +%Y-%m-%d`
DEALDATE_2=`date -v-${AGO_DAY_2}d  +%Y-%m-%d`
fi
CODE_DIR='/data0/match/orig/profile'
#希望优化后报表输出内容： 
#时间 省份名称 坐席工号 业务名称 推荐次数 推荐成功定制次数 业务定制次数 业务定制成功次数 

#2013-05-12,001,290,9162
#2013-05-12,001,290,9162
#佛山违章新增和更新日志
mysql -h172.16.88.144 -unewci  -pwN6phYeeRzyz5uzB -D qxcaipiao -D WZCX_DB -N -e " SELECT mobile_sn,car_no,car_type from WZCX_DB.wzcx_log w,qxcaipiao.wz_haoduan h  where substr(w.MOBILE_SN,1,7)=h.mobile and h.cityid='757' and opttime>='$DEALDATE_1' and opttime<'$DEALDATE_2' and STATUS=1 "   | awk -F'\t' '{print $1"|"$2"|"$3}' >  /data/wuying/foshan_wz/fosha_${DEALDATE_1}-update.txt
mysql -h172.16.88.144 -unewci  -pwN6phYeeRzyz5uzB -D qxcaipiao -D WZCX_DB -N -e " SELECT mobile_sn,car_no,car_type from WZCX_DB.wzcx_log w,qxcaipiao.wz_haoduan h  where substr(w.MOBILE_SN,1,7)=h.mobile and h.cityid='757' and opttime>='$DEALDATE_1' and opttime<'$DEALDATE_2' and STATUS=0 and car_no !='' " | awk -F'\t' '{print $1"|"$2"|"$3}' >  /data/wuying/foshan_wz/fosha_${DEALDATE_1}-insert.txt


php /home/wuying/bin/carinfo_split.php /data/wuying/foshan_wz/fosha_${DEALDATE_1}-update.txt /data/wuying/foshan_wz/fosha_${DEALDATE_1}-update_1.txt
php /home/wuying/bin/carinfo_split.php /data/wuying/foshan_wz/fosha_${DEALDATE_1}-insert.txt /data/wuying/foshan_wz/fosha_${DEALDATE_1}-insert_1.txt

cat /data/wuying/foshan_wz/fosha_${DEALDATE_1}-insert_1.txt | awk -F'|' '{if(length($3)==1) print $1"|"$2"|0"$3 ;else print $1"|"$2"|"$3; }' | sort -u > /data/wuying/foshan_wz/fosha_${DEALDATE_1}-insert_2.txt

cat /data/wuying/foshan_wz/fosha_${DEALDATE_1}-update_1.txt | awk -F'|' '{print $1"||"}' | sort -u > /data/wuying/foshan_wz/fosha_${DEALDATE_1}-update_2.txt

cat /data/wuying/foshan_wz/fosha_${DEALDATE_1}-update_1.txt | awk -F'|' '{if(length($3)==1) print $1"|"$2"|0"$3 ;else print $1"|"$2"|"$3; }' | sort -u > /data/wuying/foshan_wz/fosha_${DEALDATE_1}-update_3.txt

cat /data/wuying/foshan_wz/fosha_${DEALDATE_1}-insert_2.txt /data/wuying/foshan_wz/fosha_${DEALDATE_1}-update_2.txt /data/wuying/foshan_wz/fosha_${DEALDATE_1}-update_3.txt | iconv -f UTF-8  -t GB2312 > /data/wuying/foshan_wz/fosha_${DEALDATE_1}-insertupdate.txt

scp /data/wuying/foshan_wz/fosha_${DEALDATE_1}-insertupdate.txt oracle@172.16.100.158:/home/oracle/foshan_wz/ 
scp   /data/wuying/foshan_wz/fosha_${DEALDATE_1}-insertupdate_ok.txt  wuying@172.16.101.171:/home/wuying/foshan_wz/fosha_${DEALDATE_1}-insertupdate.txt

#iconv -f GB2312 -t UTF-8   /data/wuying/zxdz/recommon_tuijiandingzhi_${DEALDATE}_dic_allcount_ok.txt > /data/wuying/zxdz/report.region.wireless_tjdz_${DEALDATE}.csv

