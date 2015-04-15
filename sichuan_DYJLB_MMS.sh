#!/bin/sh
DEALDATE=`date -v-1d  +%Y%m%d`
FILE_NAME=sichuan_DYJLB_MMS_${DEALDATE}.txt.bz2
DATE_DIR_FTP="/DYJLB_MMS"
GDQX_DIR="/data/wuying/wangyuan"
 bzcat /data/match/mm7/${DEALDATE}/outputumessage_001_wuxian_${DEALDATE}_snapshot.bz2 | awk -F'|' '{if($8 == "028" && $3 == "06" && $2 == "10511008") print $1"|"$4"|99991230000000|订购中|"$11;else if ($8 == "028" && $3 == "07" && $2 == "10511008") print $1"|"$5"|"$4"|已退订|"$11;}' >  /data/wuying/wangyuan/temp1_${DEALDATE}.txt
awk -F'|' -v NODIST_DIR=/home/chensm/nodist.tsv 'BEGIN{print "用户号码|订购时间|退订时间|操作状态|操作渠道|地市";}{if(FILENAME == NODIST_DIR) nodist[$4] = $2;else if(FILENAME != NODIST_DIR && substr($1, 1, 7) in nodist)  print $1"|"$2"|"$3"|"$4"|"$5"|"nodist[substr($1, 1, 7)];}' /home/chensm/nodist.tsv /data/wuying/wangyuan/temp1_${DEALDATE}.txt | bzip2 > /data/wuying/wangyuan/sichuan_DYJLB_MMS_${DEALDATE}.txt.bz2

ftp -v -n 218.206.87.169 << EOF
user sichuan h4o2p6s6
cd $DATE_DIR_FTP
lcd $GDQX_DIR
prompt
put $FILE_NAME
bye
EOF
