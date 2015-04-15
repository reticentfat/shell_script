#!/bin/sh
DEALDATE=`date -v-0d  +%Y%m%d`
DEALDATE2=`date -v-1d  +%Y%m%d`


bzcat /data/wuying/snapshot.txt.bz2 | awk -F'|' -v begin=${DEALDATE2}000000 -v end=${DEALDATE}000000  '{if($5 >=begin  && $5 < end && $8=="0771" && ($2=="10301063" || $2=="10511050"))  print $1","$2","$3","$5","$4","$11","$13","$14","$7}' > /home/wuying/public_html/guangxi_jkbd/guangxi_jkbd_${DEALDATE2}_new.txt




awk  -F '[ :\t|,]' -v nodist=/data/wuying/PKFILTER_DIC/nodist.tsv  -v opt_code=/data/wuying/opt_code_all.txt -v file_oka=/home/wuying/public_html/guangxi_jkbd/guangxi_jkbd_${DEALDATE2}_new.txt   -v file_ok1=/home/wuying/public_html/guangxi_jkbd/guangxi_jkbd_${DEALDATE2}_new_ok.txt  '{if(FILENAME == opt_code) o[$1]=$5","$3 ;else if(FILENAME == nodist  ) n[$4]=$1","$2 ;else if(FILENAME == file_oka &&  ($2 in o)  && (substr($1,1,7) in n) && $3==06 ) print   $1","n[substr($1,1,7)]","o[$2]","$4",""99991231000000"  >> file_ok1;else if(FILENAME == file_oka &&  ($2 in o)  && (substr($1,1,7) in n) && $3==07 ) print   $1","n[substr($1,1,7)]","o[$2]","$4","$5  >> file_ok1}' /data/wuying/PKFILTER_DIC/nodist.tsv /data/wuying/opt_code_all.txt  /home/wuying/public_html/guangxi_jkbd/guangxi_jkbd_${DEALDATE2}_new.txt


awk -F',' -v tuijian=/data/wuying/zxdz/recommon_tuijian_${DEALDATE2}.txt -v dingzhi=/data/wuying/zxdz/recommon_dingzhi_${DEALDATE2}.txt -v file_oka=/home/wuying/public_html/guangxi_jkbd/guangxi_jkbd_${DEALDATE2}_new_ok.txt -v file_ok1=/home/wuying/public_html/guangxi_jkbd/guangxi_jkbd_${DEALDATE2}_new_ok_end.csv '{if(FILENAME==tuijian && ($2==582 || $2==583)) t[$5]=$4;else if(FILENAME==dingzhi && ($2==582 || $2==583)) d[$5]=$4;else if(FILENAME==file_oka && ($1 in t)) print $0","t[$1] >> file_ok1;else if(FILENAME==file_oka && ($1 in d)) print $0","d[$1] >> file_ok1;else if(FILENAME==file_oka && !($1 in t) && !($1 in d)) print $0"," >> file_ok1}' /data/wuying/zxdz/recommon_tuijian_${DEALDATE2}.txt  /data/wuying/zxdz/recommon_dingzhi_${DEALDATE2}.txt /home/wuying/public_html/guangxi_jkbd/guangxi_jkbd_${DEALDATE2}_new_ok.txt


scp /home/wuying/public_html/guangxi_jkbd/guangxi_jkbd_${DEALDATE2}_new_ok_end.csv  wuying@172.16.101.171:/home/wuying/guangxi_jkbd/ 
#rm -f /home/wuying/public_html/guangxi_jkbd/*_new.txt
#rm -f /home/wuying/public_html/guangxi_jkbd/*_new_ok.txt
