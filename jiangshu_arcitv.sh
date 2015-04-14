#/bin/sh

#----------------------
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/home/wuying/;
export PATH
#export PATH=/home/wuying/
if [ $# -eq 1 ];then
   INDATE=$1
fi

if [ ${INDATE:=999} = 999 ];then

DEALDATE=`date -v+0d  +%Y%m%d`
DEALDATE2=`date -v-1d  +%Y%m%d`
DEALDATE2_G=`date -v-1d  +%Y-%m`


else
DEALDATE=$INDATE
fi
 
cat   /home/wuying/public_html/jiangs_mms_active/MmsActive${DEALDATE}.csv | sort -u  | awk '{ print substr($1,1,11)"|" } ' |  grep -v '13921133888'  |   bzip2 > /home/wuying/public_html/jiangs_mms_active/MmsActive${DEALDATE}.csv.bz2 

 
bzcat /home/wuying/public_html/jiangs_mms_active/MmsActive${DEALDATE}.csv.bz2  /data/match/mm7/${DEALDATE2}/outputumessage_001_meiti_${DEALDATE2}_snapshot.bz2 | awk -F'|' '{if(NF==2) aa[$1]=$1"|" ; else if ( ($1  in aa) && $3=="06" && $7=="0" && $1 !="13921133888" )  print $1","$14;  }'    >  /home/wuying/public_html/jiangs_mms_active/MmsActive${DEALDATE}_ok.txt


rm /home/wuying/public_html/jiangs_mms_active/MmsActive${DEALDATE}.csv

scp /home/wuying/public_html/jiangs_mms_active/MmsActive${DEALDATE}_ok.txt  yaoyi@172.16.101.206:/home/yaoyi/active/

 
