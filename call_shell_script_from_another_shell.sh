#!/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/home/gateway/bin:/data/www/;
export PATH
LANG=zh_CN.UTF-8
DEALDATE=`date -v-0d  +%Y%m%d`
DEALDATETIME=`date -v-2H  +%Y%m%d%H00`
DEALDATE_1=`date -v-1d  +%Y%m%d`
DEALDATE_year=`date -v-1d  +%Y`
DEALDATE_2=`date -v-0d  +%Y%m%d` 
DEALDATE_3=`date -v-2d  +%Y%m%d`
DEALDATE_Y=`date -v-1d  +%Y`
DEALDATE_MD=`date -v-1d  +%m%d`
LOG_DIR='/data/www/stat/log/'${DEALDATE_Y}/${DEALDATE_MD}
ARG1='/data/log/h5_lottery/'${DEALDATE_1}/h5_lottery_${DEALDATE_1}_ip.txt
DIC_IP='/data/log/h5_lottery/dictionary/ip-result.txt'
echo ${DEALDATE}
echo ${DEALDATETIME}
echo ${LOG_DIR}
cd /data/log/h5_lottery/
if [ ! -d "${DEALDATE_1}" ]; then
   mkdir ${DEALDATE_1}   
fi
echo "mkdir_done"
cd ./${DEALDATE_1} 
-----------得到ip文件--------------
#cat /data/www/stat/log/2016/0928/log.txt | awk -F'~' '{print $3}' |  sort | uniq >h5_lottery_20160928_ip.txt 
cat ${LOG_DIR}/log.txt | awk -F'~' '{print $3}' |  sort | uniq >${ARG1}
sh /home/gateway/bin/ip_query_batch2.sh -f "$ARG1"
iconv -f UTF-8  -t GB2312 /data/log/h5_lottery/dictionary/ip-result.txt | sort -u > /data/log/h5_lottery/dictionary/ip-result-gbk.txt
#dos转换unix
cat ${LOG_DIR}/log.txt | tr -d "\r"  >${LOG_DIR}/log_unix.txt
awk -F'[ \t~]' -v CODE_DIR=/data/log/h5_lottery/dictionary/ip-result-gbk.txt '{ if(FILENAME==CODE_DIR) d[$1]=$3"|"$4 ; else if($3 in d  ) print $1"|"$2"|"$3"|"$4"|"$5"|"d[$3] }' /data/log/h5_lottery/dictionary/ip-result-gbk.txt  ${LOG_DIR}/log_unix.txt >log_city.txt
awk -F'|' '{if($6==""||$6=="中国"||$6=="美国") print $1"|"$2"|"$3"|"$4"|"$5"|未知|未知";else if($7=="") print  $1"|"$2"|"$3"|"$4"|"$5"|"$6"|未知" ; else print $0}' log_city.txt> log_ctiy_full.txt
cat log_ctiy_full.txt | awk -F'[|=]' '{print $2"|"$3"|"substr($5,0,2)"|"$(NF-2)"|"$(NF-1)"|"$NF}' >  tmp5.txt
awk -F'|' -v CODE_DIR=/data/log/h5_lottery/dictionary/h5_lottery_dictionary.txt '{ if(FILENAME==CODE_DIR) d[$1]=$2 ; else if( $3 in d  ) print $1"|"$2"|"d[$3]"|"$4"|"$5"|"$6;  }' /data/log/h5_lottery/dictionary/h5_lottery_dictionary.txt tmp5.txt | iconv -f GB18030  -t UTF-8 > tmp3.txt 
awk -F'|' '$4~/^1/{print $0}' tmp3.txt >  tmp4.txt
cat tmp4.txt | awk -F'|' '{print $5"|"$6"|"$3}' | sort -u | awk -F'|' '{print $1,$2,$3}' | sort | uniq -c | awk  '{print $2,$3,$4,$1}'>UV.txt
cat tmp4.txt | awk -F'|' 'substr($1,9,2)=="20"{print $5"|"$6"|"$3}' | sort -u | awk -F'|' '{print $1,$2,$3}' | sort | uniq -c | awk  '{print $2,$3,$4,$1}'>OnlineUser.txt
cat tmp3.txt | awk -F'|' '{print $5"|"$6"|"$3}' | awk -F'|' '{print $1,$2,$3}' | sort | uniq -c | awk  '{print $2,$3,$4,$1}'> PV.txt
cat tmp3.txt | awk -F'|' '{print $5"|"$6"|"$3}' | sort -u | awk -F'|' '{print $1,$2,$3}' | sort | uniq -c | awk  '{print $2,$3,$4,$1}'> IP.txt
---------------------------------------------------------------------
cat PV.txt | awk -F' ' '{print $1","$2","$3","$4",0,0,0"}'> h5_lottery_tmp_PV.txt
cat UV.txt |  awk -F' ' '{print $1","$2","$3",0,"$4",0,0"}'> h5_lottery_tmp_UV.txt
cat IP.txt |  awk -F' ' '{print $1","$2","$3",0,0,"$4",0"}'> h5_lottery_tmp_IP.txt
cat OnlineUser.txt  |  awk -F' ' '{print $1","$2","$3",0,0,0,"$4}'>h5_lottery_tmp_OnlineUser.txt
#PV,UV,IP,OnlineUser
#四个文件输出符都为空格awk -F' '
cat h5_lottery_tmp_*.txt |awk -F',' '{ aa[$1","$2","$3] +=$4; bb[$1","$2","$3] +=$5 ; cc[$1","$2","$3] +=$6; dd[$1","$2","$3] +=$7}END{for (i in aa){ print i","aa[i]","bb[i]","cc[i]","dd[i]} }' >dic_allcount.txt
awk -F',' -v DIR=/data/log/h5_lottery/${DEALDATE_3}/dic_allcount.txt '{if (FILENAME==DIR) aa[$1$2$3]=$4 ;else if (FILENAME!=DIR&&aa[$1$2$3]==0 ) print $0",100" ; else if (FILENAME!=DIR&&aa[$1$2$3]!=0 ) print $0","($4-aa[$1$2$3])*100/aa[$1$2$3] }' /data/log/h5_lottery/${DEALDATE_3}/dic_allcount.txt dic_allcount.txt > dic_allcount_1.txt
cat dic_allcount_1.txt | iconv -f UTF-8  -t GB2312 |awk -F',' -v TIME=${DEALDATE_1}  'BEGIN{print "省份,城市,业务,时间,PV,UV,IP,在线人数,转发量,增幅,交叉营销";}{printf "%s,%s,%s,%d,%d,%d,%d,%d,%d,%.2f%%,%s\n",$1,$2,$3,TIME,$4,$5,$6,$7,"0",$8,"0"}' |iconv -f GB2312  -t  UTF-8> h5_lottery_${DEALDATE_1}.csv
scp h5_lottery_${DEALDATE_1}.csv oracle@192.100.7.27:/home/oracle/etl/data/KPI_DATA/${DEALDATE_year}/${DEALDATE_1}
#scp h5_lottery_20161017.cvs oracle@192.100.7.27:/home/oracle/etl/data/KPI_DATA/2016/20161017
#scp 192.100.7.27/home/oracle/etl/data/KPI_DATA/2016/20161017
