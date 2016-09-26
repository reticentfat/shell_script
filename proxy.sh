#! /usr/bin/sh
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/home/gateway/;
DEALDATE=`date -d "0 day ago" +"%Y%m%d"`
DEALDATE1=`date -d "1 day ago" +"%Y%m%d"`
DEALDATE_23H=`date -d "1 hour ago" +"%H"`
DEALDATETIME=`date -d "1 hour ago" +%Y%m%d%H00`
cd /data/proxy
if [ ! -d "${DEALDATE}" ]; then
   mkdir ${DEALDATE}   
fi
echo "mkdir_done"
if [ ${DEALDATE_23H} -eq 23 ];then
zcat /data/logs/bossproxy/appproxy.log-${DEALDATE}*.gz | grep 'BIP2B247,'| awk -F':' -v CODE_TIME=${DEALDATE_23H} 'substr($1,8,2)==CODE_TIME{print $0}'| awk -F',' -v CODE_DIR=${DEALDATE1} '{ print CODE_DIR""substr($10,9,2)","$4","$7","$8","$10","$11","$14",12580"}' >/data/proxy/${DEALDATE1}/boss_sys_${DEALDATETIME}.txt
zcat /data/logs/bossproxy/bossproxy.log${DEALDATE}*.gz  | grep  'BIP2B247,' |  awk -F':' -v CODE_TIME=${DEALDATE_23H} 'substr($1,8,2)==CODE_TIME{print $0}'| awk -F',' -v CODE_DIR=${DEALDATE1} '$8=="06"||$8=="07"||$8=="02"||$8=="99"{ print CODE_DIR""substr($1,8,2)","$4","$7","$8","$10","$11","$14",BOSS"}' >> /data/proxy/${DEALDATE1}/boss_sys_${DEALDATETIME}.txt
zcat /data/logs/bossproxy/bossproxy.log-${DEALDATE}*.gz | grep 'BIP2B248,' |   awk -F':' -v CODE_TIME=${DEALDATE_23H} 'substr($1,8,2)==CODE_TIME{print $0}'| awk -F',' -v CODE_DIR=${DEALDATE1} '$8=="06"||$8=="07"||$8=="02"||$8=="99"{ print CODE_DIR""substr($1,8,2)","$5","$7","$8","$9","$14","$18",BOSS"}'  >> /data/proxy/${DEALDATE1}/boss_sys_${DEALDATETIME}.txt
cat /data/proxy/${DEALDATE1}/boss_sys_${DEALDATETIME}.txt | awk -F',' '{print $1,$8,$6,$3,$4,$7}' | sort | uniq -c | sort -rn  | awk '{print $2"|"$3"|"$4"|"$5"|"$6"|"$7"|"$1}' > /data/proxy/${DEALDATE1}/boss_sys_wc_tmp1_${DEALDATETIME}.txt
awk -F'|' -v CODE_DIR=/home/gateway/dic/nodist_umgstat_gbk.txt '{ if(FILENAME==CODE_DIR) d[$5]=$1 ; else if( $3 in d  ) print $1"|"$2"|"d[$3]"|"$4"|"$5"|"$6"|"$7;  }' /home/gateway/dic/nodist_umgstat_gbk.txt  /data/proxy/${DEALDATE1}/boss_sys_wc_tmp1_${DEALDATETIME}.txt>/data/proxy/${DEALDATE1}/boss_sys_wc_tmp2_${DEALDATETIME}.txt
awk -F'|' -v CODE_DIR=/home/gateway/dic/opt_code_all.txt '{ if(FILENAME==CODE_DIR) d[$2]=$5 ; else if($4 in d  ) print $1"|"$2"|"$3"|"d[$4]"|"$5"|"$6"|"$7 }' /home/gateway/dic/opt_code_all.txt  /data/proxy/${DEALDATE1}/boss_sys_wc_tmp2_${DEALDATETIME}.txt>/data/proxy/${DEALDATE1}/boss_sys_wc_${DEALDATETIME}.txt
iconv -f gbk -t utf-8 /data/proxy/${DEALDATE1}/boss_sys_wc_${DEALDATETIME}.txt > /data/proxy/${DEALDATE1}/boss_sys_wc_utf-8_${DEALDATETIME}.txt
scp /data/proxy/${DEALDATE1}/boss_sys_wc_utf-8_${DEALDATETIME}.txt gateway@192.100.7.13:/data/www/12580/Monitor/proxylog
else
cat /data/logs/bossproxy/appproxy.log | grep 'BIP2B247,'| awk -F':' -v CODE_TIME=${DEALDATE_23H} 'substr($1,8,2)==CODE_TIME{print $0}'| awk -F',' -v CODE_DIR=${DEALDATE} '{ print CODE_DIR""substr($10,9,2)","$4","$7","$8","$10","$11","$14",12580"}' >/data/proxy/${DEALDATE}/boss_sys_${DEALDATETIME}.txt
cat /data/logs/bossproxy/bossproxy.log  | grep  'BIP2B247,' |  awk -F':' -v CODE_TIME=${DEALDATE_23H} 'substr($1,8,2)==CODE_TIME{print $0}'| awk -F',' -v CODE_DIR=${DEALDATE} '$8=="06"||$8=="07"||$8=="02"||$8=="99"{ print CODE_DIR""substr($1,8,2)","$4","$7","$8","$10","$11","$14",BOSS"}' >> /data/proxy/${DEALDATE}/boss_sys_${DEALDATETIME}.txt
cat /data/logs/bossproxy/bossproxy.log | grep 'BIP2B248,' |   awk -F':' -v CODE_TIME=${DEALDATE_23H} 'substr($1,8,2)==CODE_TIME{print $0}'| awk -F',' -v CODE_DIR=${DEALDATE} '$8=="06"||$8=="07"||$8=="02"||$8=="99"{ print CODE_DIR""substr($1,8,2)","$5","$7","$8","$9","$14","$18",BOSS"}'  >> /data/proxy/${DEALDATE}/boss_sys_${DEALDATETIME}.txt
cat /data/proxy/${DEALDATE}/boss_sys_${DEALDATETIME}.txt | awk -F',' '{print $1,$8,$6,$3,$4,$7}' | sort | uniq -c | sort -rn  | awk '{print $2"|"$3"|"$4"|"$5"|"$6"|"$7"|"$1}' > /data/proxy/${DEALDATE}/boss_sys_wc_tmp1_${DEALDATETIME}.txt
awk -F'|' -v CODE_DIR=/home/gateway/dic/nodist_umgstat_gbk.txt '{ if(FILENAME==CODE_DIR) d[$5]=$1 ; else if( $3 in d  ) print $1"|"$2"|"d[$3]"|"$4"|"$5"|"$6"|"$7;  }' /home/gateway/dic/nodist_umgstat_gbk.txt  /data/proxy/${DEALDATE}/boss_sys_wc_tmp1_${DEALDATETIME}.txt>/data/proxy/${DEALDATE}/boss_sys_wc_tmp2_${DEALDATETIME}.txt
awk -F'|' -v CODE_DIR=/home/gateway/dic/opt_code_all.txt '{ if(FILENAME==CODE_DIR) d[$2]=$5 ; else if($4 in d  ) print $1"|"$2"|"$3"|"d[$4]"|"$5"|"$6"|"$7 }' /home/gateway/dic/opt_code_all.txt  /data/proxy/${DEALDATE}/boss_sys_wc_tmp2_${DEALDATETIME}.txt>/data/proxy/${DEALDATE}/boss_sys_wc_${DEALDATETIME}.txt
iconv -f gbk -t utf-8 /data/proxy/${DEALDATE}/boss_sys_wc_${DEALDATETIME}.txt > /data/proxy/${DEALDATE}/boss_sys_wc_utf-8_${DEALDATETIME}.txt
scp /data/proxy/${DEALDATE}/boss_sys_wc_utf-8_${DEALDATETIME}.txt gateway@192.100.7.13:/data/www/12580/Monitor/proxylog
#rm /data/proxy/boss_sys_${DEALDATETIME}.txt
fi
#mysql
#cat /data/logs/bossproxy/appproxy.log | grep 'BIP2B247,'|awk -F':' 'substr($1,8,2)=="15"{print $0}' | tail -5
