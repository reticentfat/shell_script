#!/bin/sh
DEALDATE1=`date -v-10d  +%Y%m%d`
DEALDATE2=`date -v-9d   +%Y%m%d`
DEALDATE3=`date -v-8d   +%Y%m%d`
DEALDATE4=`date -v-7d   +%Y%m%d`
DEALDATE5=`date -v-6d   +%Y%m%d`
DEALDATE6=`date -v-5d   +%Y%m%d`
DEALDATE7=`date -v-4d   +%Y%m%d`


cat /data/match/mm7/${DEALDATE1}/*wuxian*.out /data/match/mm7/${DEALDATE1}/*wuxian*.mt   |  grep ',851,' | grep -e ',10511052,'  | awk -F',' '{print $1"^"$15"^"$19"^"$10"^"$14"^"$35"^"$(NF-2)}' |  awk -F':' '{print $4}' | awk -F'^' '{print substr($1,2,14)"^"$2"^"$3"^"$4"^"$5"^"$6"^"$7}' | awk -F'^' '{print $5}'  >> /data/wuying/guizhou_hsh_${DEALDATE1}_${DEALDATE7}_all.txt
cat /data/match/mm7/${DEALDATE2}/*wuxian*.out /data/match/mm7/${DEALDATE2}/*wuxian*.mt   |  grep ',851,' | grep -e ',10511052,'  | awk -F',' '{print $1"^"$15"^"$19"^"$10"^"$14"^"$35"^"$(NF-2)}' |  awk -F':' '{print $4}' | awk -F'^' '{print substr($1,2,14)"^"$2"^"$3"^"$4"^"$5"^"$6"^"$7}' | awk -F'^' '{print $5}'  >> /data/wuying/guizhou_hsh_${DEALDATE1}_${DEALDATE7}_all.txt
cat /data/match/mm7/${DEALDATE3}/*wuxian*.out /data/match/mm7/${DEALDATE3}/*wuxian*.mt   |  grep ',851,' | grep -e ',10511052,'  | awk -F',' '{print $1"^"$15"^"$19"^"$10"^"$14"^"$35"^"$(NF-2)}' |  awk -F':' '{print $4}' | awk -F'^' '{print substr($1,2,14)"^"$2"^"$3"^"$4"^"$5"^"$6"^"$7}' | awk -F'^' '{print $5}'  >> /data/wuying/guizhou_hsh_${DEALDATE1}_${DEALDATE7}_all.txt
cat /data/match/mm7/${DEALDATE4}/*wuxian*.out /data/match/mm7/${DEALDATE4}/*wuxian*.mt   |  grep ',851,' | grep -e ',10511052,'  | awk -F',' '{print $1"^"$15"^"$19"^"$10"^"$14"^"$35"^"$(NF-2)}' |  awk -F':' '{print $4}' | awk -F'^' '{print substr($1,2,14)"^"$2"^"$3"^"$4"^"$5"^"$6"^"$7}' | awk -F'^' '{print $5}'  >> /data/wuying/guizhou_hsh_${DEALDATE1}_${DEALDATE7}_all.txt
cat /data/match/mm7/${DEALDATE5}/*wuxian*.out /data/match/mm7/${DEALDATE5}/*wuxian*.mt   |  grep ',851,' | grep -e ',10511052,'  | awk -F',' '{print $1"^"$15"^"$19"^"$10"^"$14"^"$35"^"$(NF-2)}' |  awk -F':' '{print $4}' | awk -F'^' '{print substr($1,2,14)"^"$2"^"$3"^"$4"^"$5"^"$6"^"$7}' | awk -F'^' '{print $5}'  >> /data/wuying/guizhou_hsh_${DEALDATE1}_${DEALDATE7}_all.txt
cat /data/match/mm7/${DEALDATE6}/*wuxian*.out /data/match/mm7/${DEALDATE6}/*wuxian*.mt   |  grep ',851,' | grep -e ',10511052,'  | awk -F',' '{print $1"^"$15"^"$19"^"$10"^"$14"^"$35"^"$(NF-2)}' |  awk -F':' '{print $4}' | awk -F'^' '{print substr($1,2,14)"^"$2"^"$3"^"$4"^"$5"^"$6"^"$7}' | awk -F'^' '{print $5}'  >> /data/wuying/guizhou_hsh_${DEALDATE1}_${DEALDATE7}_all.txt
cat /data/match/mm7/${DEALDATE7}/*wuxian*.out /data/match/mm7/${DEALDATE7}/*wuxian*.mt   |  grep ',851,' | grep -e ',10511052,'  | awk -F',' '{print $1"^"$15"^"$19"^"$10"^"$14"^"$35"^"$(NF-2)}' |  awk -F':' '{print $4}' | awk -F'^' '{print substr($1,2,14)"^"$2"^"$3"^"$4"^"$5"^"$6"^"$7}' | awk -F'^' '{print $5}'  >> /data/wuying/guizhou_hsh_${DEALDATE1}_${DEALDATE7}_all.txt



cat /data/match/mm7/${DEALDATE1}/*wuxian*.out /data/match/mm7/${DEALDATE1}/*wuxian*.mt   |  grep ',851,' | grep -e ',10511052,'  | awk -F',' '{if($(NF-2)==1000 || $(NF-2)==2000 || $(NF-2)==4446) print $1"^"$15"^"$19"^"$10"^"$14"^"$35"^"$(NF-2)}' |  awk -F':' '{print $4}' | awk -F'^' '{print substr($1,2,14)"^"$2"^"$3"^"$4"^"$5"^"$6"^"$7}' | awk -F'^' '{print $5}' >>  /data/wuying/guizhou_hsh_${DEALDATE1}_${DEALDATE7}_success.txt
cat /data/match/mm7/${DEALDATE2}/*wuxian*.out /data/match/mm7/${DEALDATE2}/*wuxian*.mt   |  grep ',851,' | grep -e ',10511052,'  | awk -F',' '{if($(NF-2)==1000 || $(NF-2)==2000 || $(NF-2)==4446) print $1"^"$15"^"$19"^"$10"^"$14"^"$35"^"$(NF-2)}' |  awk -F':' '{print $4}' | awk -F'^' '{print substr($1,2,14)"^"$2"^"$3"^"$4"^"$5"^"$6"^"$7}' | awk -F'^' '{print $5}' >>  /data/wuying/guizhou_hsh_${DEALDATE1}_${DEALDATE7}_success.txt
cat /data/match/mm7/${DEALDATE3}/*wuxian*.out /data/match/mm7/${DEALDATE3}/*wuxian*.mt   |  grep ',851,' | grep -e ',10511052,'  | awk -F',' '{if($(NF-2)==1000 || $(NF-2)==2000 || $(NF-2)==4446) print $1"^"$15"^"$19"^"$10"^"$14"^"$35"^"$(NF-2)}' |  awk -F':' '{print $4}' | awk -F'^' '{print substr($1,2,14)"^"$2"^"$3"^"$4"^"$5"^"$6"^"$7}' | awk -F'^' '{print $5}' >>  /data/wuying/guizhou_hsh_${DEALDATE1}_${DEALDATE7}_success.txt
cat /data/match/mm7/${DEALDATE4}/*wuxian*.out /data/match/mm7/${DEALDATE4}/*wuxian*.mt   |  grep ',851,' | grep -e ',10511052,'  | awk -F',' '{if($(NF-2)==1000 || $(NF-2)==2000 || $(NF-2)==4446) print $1"^"$15"^"$19"^"$10"^"$14"^"$35"^"$(NF-2)}' |  awk -F':' '{print $4}' | awk -F'^' '{print substr($1,2,14)"^"$2"^"$3"^"$4"^"$5"^"$6"^"$7}' | awk -F'^' '{print $5}' >>  /data/wuying/guizhou_hsh_${DEALDATE1}_${DEALDATE7}_success.txt
cat /data/match/mm7/${DEALDATE5}/*wuxian*.out /data/match/mm7/${DEALDATE5}/*wuxian*.mt   |  grep ',851,' | grep -e ',10511052,'  | awk -F',' '{if($(NF-2)==1000 || $(NF-2)==2000 || $(NF-2)==4446) print $1"^"$15"^"$19"^"$10"^"$14"^"$35"^"$(NF-2)}' |  awk -F':' '{print $4}' | awk -F'^' '{print substr($1,2,14)"^"$2"^"$3"^"$4"^"$5"^"$6"^"$7}' | awk -F'^' '{print $5}' >>  /data/wuying/guizhou_hsh_${DEALDATE1}_${DEALDATE7}_success.txt
cat /data/match/mm7/${DEALDATE6}/*wuxian*.out /data/match/mm7/${DEALDATE6}/*wuxian*.mt   |  grep ',851,' | grep -e ',10511052,'  | awk -F',' '{if($(NF-2)==1000 || $(NF-2)==2000 || $(NF-2)==4446) print $1"^"$15"^"$19"^"$10"^"$14"^"$35"^"$(NF-2)}' |  awk -F':' '{print $4}' | awk -F'^' '{print substr($1,2,14)"^"$2"^"$3"^"$4"^"$5"^"$6"^"$7}' | awk -F'^' '{print $5}' >>  /data/wuying/guizhou_hsh_${DEALDATE1}_${DEALDATE7}_success.txt
cat /data/match/mm7/${DEALDATE7}/*wuxian*.out /data/match/mm7/${DEALDATE7}/*wuxian*.mt   |  grep ',851,' | grep -e ',10511052,'  | awk -F',' '{if($(NF-2)==1000 || $(NF-2)==2000 || $(NF-2)==4446) print $1"^"$15"^"$19"^"$10"^"$14"^"$35"^"$(NF-2)}' |  awk -F':' '{print $4}' | awk -F'^' '{print substr($1,2,14)"^"$2"^"$3"^"$4"^"$5"^"$6"^"$7}' | awk -F'^' '{print $5}' >>  /data/wuying/guizhou_hsh_${DEALDATE1}_${DEALDATE7}_success.txt




awk -v success=/data/wuying/guizhou_hsh_${DEALDATE1}_${DEALDATE7}_success.txt -v all=/data/wuying/guizhou_hsh_${DEALDATE1}_${DEALDATE7}_all.txt -v file_ok=/data/wuying/guizhou_hsh_all_${DEALDATE1}_${DEALDATE7}_faile.txt '{if(FILENAME==success) o[$1]=$0;else if(FILENAME==all && !($1 in o)) print $0 > file_ok}' /data/wuying/guizhou_hsh_${DEALDATE1}_${DEALDATE7}_success.txt  /data/wuying/guizhou_hsh_${DEALDATE1}_${DEALDATE7}_all.txt  



awk -F '|' -v NODIST=/data/wuying/PKFILTER_DIC/nodist.tsv -v file_ok1=/data/wuying/guizhou_hsh_all_${DEALDATE1}_${DEALDATE7}_faile.txt -v file_oka=/data/wuying/guizhou_hsh_${DEALDATE1}_${DEALDATE7}_faile_ok.txt '{if(FILENAME==NODIST) o[$4]=$2;else if(FILENAME==file_ok1 && (substr($1,1,7) in o)) print $1","o[substr($1,1,7)] > file_oka}' /data/wuying/PKFILTER_DIC/nodist.tsv /data/wuying/guizhou_hsh_all_${DEALDATE1}_${DEALDATE7}_faile.txt

cat /data/wuying/guizhou_hsh_${DEALDATE1}_${DEALDATE7}_faile_ok.txt | sort -u > /home/wuying/public_html/guizhou_hsh/guizhou_hsh_${DEALDATE1}_${DEALDATE7}_faile.csv

