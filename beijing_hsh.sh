#!/bin/sh

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

#DEALDATE=`date -v-0d  +%Y%m%d`
#DEALDATE2=`date -v-1d  +%Y%m%d`

#DEALDATE_1=`date -v-${AGO_DAY2}d  +%Y-%m-%d`
#DEALDATE_2=`date -v-${AGO_DAY_2}d  +%Y-%m-%d`

###2014-06-01,13911455413,594,100,6012

#主叫号码	??? 工号?????	?业务开通时间	? 是否成功
#13501362306	6356	2014-6-2 9:37	是


/usr/local/bin/mysql -h172.16.88.144 -unewci  -pwN6phYeeRzyz5uzB -D newqianxiang -D wireless_base -N -e " select  n.mobile,n.staffno,time,gid   from newqianxiang.coupon_log n , wireless_base.addr_info_20090430 h  where  substr(n.mobile,1,7)=h.mobile_7 and   gid in ('HSH_05_MMS','HSH_MMS') and h.no='010' and type=1 and sort=1 and  time >= '$DEALDATE_1'  and  time < '$DEALDATE_2'  " |  awk -F'\t' '{print $1","$2","$3","$4}' >  /data/wuying/beijing_hsh/beijing_${DEALDATE}_hsh_all_log.txt

##优惠券所有相关推荐文件
/usr/local/bin/mysql -h172.16.88.144 -unewci  -pwN6phYeeRzyz5uzB -D newqianxiang -D wireless_base -N -e " select  n.mobile, staffno , dotime,business_name    from newqianxiang.tb_recommend_all n , wireless_base.addr_info_20090430 h  where  substr(n.mobile,1,7)=h.mobile_7 and  business_name  in ('HSH_05_MMS','HSH_MMS') and h.no='010'  and dotime >= '$DEALDATE_1'  and dotime < '$DEALDATE_2'  " |  awk -F'\t' '{print $1","$2","$3","$4}' >>  /data/wuying/beijing_hsh/beijing_${DEALDATE}_hsh_all_log.txt


 
#获取当日惠生活实际订购用户明细
bzcat /data/match/mm7/${DEALDATE}/outputumessage_001_wuxian_${DEALDATE}_snapshot.bz2 | awk -F'|' -v first_date=${DEALDATE}  '{if($8 == "010" && $11 == "SUB_ZUOXI" && ($14 =="HSH_MMS" || $14 =="HSH_05_MMS")  ) print $1","$14","$3","$4","$5}' | awk -F','   '{ if( $3 == "06"  )  print   $1","$2","$4",是" ; else if (  $3 == "07" && substr($5,1,8)==substr(first_date,1,8) ) print $1","$2","$5",是" }'  > /data/wuying/beijing_hsh/beijing_${DEALDATE}_hsh_dzz.txt


##主叫号码,工号,业务开通时间,是否成功
 
cat /data/wuying/beijing_hsh/beijing_${DEALDATE}_hsh_all_log.txt   | awk -F',' '{print $1","$2","$3","$4 }' | sort -u > /data/wuying/beijing_hsh/beijing_${DEALDATE}_hsh_tjall.txt



 awk -F',' -v CODE_DIR=/data/wuying/beijing_hsh/beijing_${DEALDATE}_hsh_dzz.txt      -v file_no=/data/wuying/beijing_hsh/beijing_${DEALDATE}_hsh_tjall_ok_a.csv       '{
 if( FILENAME == CODE_DIR )  d[$1$2]=substr($3,1,4)"-"substr($3,5,2)"-"substr($3,7,2)" "substr($3,9,2)":"substr($3,11,2)":"substr($3,13,2)","$4; 
 else if ( FILENAME != CODE_DIR &&  ($1$4  in d) )  print  $1","$2","d[$1$4] >> file_no; 
 
 }'   /data/wuying/beijing_hsh/beijing_${DEALDATE}_hsh_dzz.txt    /data/wuying/beijing_hsh/beijing_${DEALDATE}_hsh_tjall.txt

cat /data/wuying/beijing_hsh/beijing_${DEALDATE}_hsh_dzz.txt  | awk '{if(NR==1) print "主叫号码,工号,业务开通时间,是否成功"}' > /data/wuying/beijing_hsh/beijing_${DEALDATE}_hsh_tjall_ok.csv 

cat /data/wuying/beijing_hsh/beijing_${DEALDATE}_hsh_tjall_ok.csv | sort -u >> /data/wuying/beijing_hsh/beijing_${DEALDATE}_hsh_tjall_ok.csv

scp /data/wuying/beijing_hsh/beijing_${DEALDATE}_hsh_tjall_ok.csv  wuying@172.16.101.171:/home/wuying/beijing_hsh/ 
#rm -f /home/wuying/public_html/guangxi_jkbd/*_new.txt
#rm -f /home/wuying/public_html/guangxi_jkbd/*_new_ok.txt
