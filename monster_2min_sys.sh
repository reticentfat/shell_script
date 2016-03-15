#/bin/sh
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/home/wuying/;
export PATH
##sh -x monster_2min_sys.sh 20160302 201603022034 201603022036
if [ $# -eq 4 ];then
   INDATE=$1
   INDATE_m=$2
   INDATE_2m=$3
   INDATE_num=$4
fi

if [ ${INDATE:=999} = 999 ];then

  DEALDATE=`date -v-0d  +%Y%m%d`
  TODAYTIME=`date  -v-2M  +%Y%m%d%H%M%S`
else

  DEALDATE=$INDATE

fi
if [ ${INDATE_m:=999} = 999 ];then

  DEALDATE_M=`date -v-0M  +%Y%m%d%H%M`
  DEALDATE_2M=`date -v-2M  +%Y%m%d%H%M`
  
else
  DEALDATE_M=$INDATE_m
  DEALDATE_2M=$INDATE_2m
  DEALDATE_num=$INDATE_num
fi

CODE_DIR=/data/logs/shujuyzx/monster/${DEALDATE}
CODE_DIR_UP=/data/logs/shujuyzx/monster/ 
DATE_DIR=/logs/monster/

cd  /data/logs/shujuyzx/monster

if [ ! -d "$CODE_DIR" ]; then
  mkdir ${DEALDATE}
fi

#获取2分钟前的短信下发内容，及2分钟前的状态报告
cat ${DATE_DIR}/monster-cmppmt.log ${DATE_DIR}/monster-cmppmt.log.0 | awk -F'[\],]' -v  begintime=${DEALDATE_2M} -v endtime=${DEALDATE_M} '{if(substr($2,3,12)<endtime  && substr($2,3,12) >=begintime ) print $13","$16","$11","substr($2,3,44)","$33","$20}' > ${CODE_DIR}/monster-cmppmt.log.${DEALDATE_2M}.txt
bzcat ${DATE_DIR}/monster-cmppmt.log.${DEALDATE_num}.bz2 | awk -F'[\],]' -v  begintime=${DEALDATE_2M} -v endtime=${DEALDATE_M} '{if(substr($2,3,12)<endtime  && substr($2,3,12) >=begintime ) print $13","$16","$11","substr($2,3,44)","$33","$20}' >> ${CODE_DIR}/monster-cmppmt.log.${DEALDATE_2M}.txt 
#bzip2 ${CODE_DIR}/monster-cmppmt.log.${DEALDATE_2M}.txt
cat ${DATE_DIR}/monster-cmpp-report.log ${DATE_DIR}/monster-cmpp-report.log.0 | awk -F'[\],]' -v  begintime=${DEALDATE_2M} -v endtime=${DEALDATE_M} '{if($8<endtime  && $8 >=begintime ) print $3","$5","$6","$7","$8}' > ${CODE_DIR}/monster-cmpp-report.log.${DEALDATE_2M}.txt
bzcat ${DATE_DIR}/monster-cmpp-report.log.${DEALDATE_num}.bz2 | awk -F'[\],]' -v  begintime=${DEALDATE_2M} -v endtime=${DEALDATE_M} '{if($8<endtime  && $8 >=begintime ) print $3","$5","$6","$7","$8 }' >> ${CODE_DIR}/monster-cmpp-report.log.${DEALDATE_2M}.txt 
#bzip2 ${CODE_DIR}/monster-cmpp-report.log.${DEALDATE_2M}.txt
#匹配2分钟前的短信下发为指定APPcode业务明细
#13681753642,10101057,1065888040,20160302203557SMS2101010575310e3b745acbf85ea,0302025aa37968c5b90494b89f46e4cf07c8,UMGYWCXX
#15768334972,10201073,1065888018,20160302203558SMS0102010731001aa8145bf065f88,03022f4b580695ad7419837966e0b5606a52,UMGXXFWDB
#13564883558,10101055,1065888042345,20160302203558SMS21010105553108341498e2aa75d,03023f385cff2e1049fdddbf3d8887c51d07,UMGYWCXX
#13760947265,10101066,1065888050093,20160302203559SMS010101066100187aa4198e1f526,030274cf62bacaff947e2bc6a21515bf61ad,UMGYWCXX
#15017229806,10101062,1065888018,20160302203559SMS2101010621001d77f4e8e4b0421,0302a57e346c434ca7dc1087abceb0412487,UMGYWCXX
#15017229806,10101062,1065888018,20160302203559SMS2101010621001d77f4e8e4b0421,030286d6b728454148170b9e506713a30668,UMGYWCXX
#15017229806,10101062,1065888018,20160302203559SMS2101010621001d77f4e8e4b0421,03023dcb5236041297db86967d6ddf133274,UMGYWCXX
#15017229806,10201072,1065888018,20160302203559SMS0102010721001cc0a4d83ceae6d,0302ab95b50e73aa5c725e5273e48f931aa6,UMGSQHYDB
 cat  ${CODE_DIR_UP}/dic/phone_dsf_down_dic.txt  ${CODE_DIR}/monster-cmppmt.log.${DEALDATE_2M}.txt  | awk -F'[,|]'     '{if(NF==9) aa[$2]=$2 ; else if ($2  in aa)  print   $0 ;   }'    > ${CODE_DIR}/monster-cmppmt.log.${DEALDATE_2M}_dsf.txt
#短信勾兑
#03020938220101031956,0,13918671033,201603020938,201603021700
#03021659570101051014,0,13901130815,201603021659,201603021700
#03021659490101039461,0,13910314361,201603021659,201603021700
#03021659490101065221,0,13910636397,201603021659,201603021700
#03021659260101030345,0,13526649851,201603021659,201603021700
#03021659440101063530,0,13910607147,201603021659,201603021700
cat ${CODE_DIR}/monster-cmpp-report.log.${DEALDATE_2M}.txt  ${CODE_DIR}/monster-cmppmt.log.${DEALDATE_2M}_dsf.txt | awk -F',' -v fileok=${CODE_DIR}/monster-cmpp.log.${DEALDATE_2M}_dsf_ok.txt -v file0=${CODE_DIR_UP}/monster-cmpp.log.${DEALDATE_2M}_dsf_no.txt '{if(NF==5) aa[$1$3]=$2","$3","$4","$5 ; else if ($5$1  in aa)  print   $4","$2","$3","aa[$5$1] >> fileok;   else if (!($5$1  in aa))  print  >> file0;  }'   
#20160302140003SMS0101010661001ea1247a2fc9ce5,1065888050093,0,15255802129,201603021400,201603021400
#20160302140003SMS01010106610013ea1479eee1d56,1065888050093,0,15255802129,201603021400,201603021400
#20160302140005SMS01010106610013b2e439d4b9ca7,1065888050093,0,13801271218,201603021400,201603021400
#20160302140005SMS0101010661001be594ab65d9fee,1065888050093,0,13893119815,201603021400,201603021400
#20160302140005SMS010101066100194734eb987e420,1065888050093,0,13801979640,201603021400,201603021400

#短信历史未勾兑 ${CODE_DIR_UP}/monster-cmpp.log.${DEALDATE_2M}_dsf_no.txt
cat ${CODE_DIR_UP}/monster-cmpp.log.*_dsf_no.txt  > ${CODE_DIR}/monster-cmpp.log.all_dsf_no.txt 
rm  ${CODE_DIR_UP}/monster-cmpp.log.*_dsf_no.txt
#勾兑短信历史判断发送时间超过3天的日志状态返回为NOBACK,未满足的继续累积到下次比对else if (  !($33$13  in aa) )  print $33","$13","$16","$20",NOBACK","substr($2,3,14) >> fileok;  ( SYSDATETIME-substr($2,3,14) ) > 3000000  &&
 cat ${CODE_DIR}/monster-cmpp-report.log.${DEALDATE_2M}.txt ${CODE_DIR}/monster-cmpp.log.all_dsf_no.txt | awk -F',' -v fileok=${CODE_DIR}/monster-cmpp.log.${DEALDATE_2M}_dsf_ok.txt -v file0=${CODE_DIR_UP}/monster-cmpp.log.${DEALDATE_2M}_dsf_no.txt   '{if(NF==5)  aa[$1$3]=$2","$3","$4","$5 ;  else if ($5$1  in aa)  print  $4","$2","$3","aa[$5$1] >> fileok;    else if (   !($5$1  in aa) )  print  >> file0;  }'   
##
 awk  -F '[|,]' -v opt_code=${CODE_DIR_UP}/dic/phone_dsf_down_dic.txt -v file_ok=${CODE_DIR}/monster-cmpp.log.${DEALDATE_2M}_dsf_ok.txt  -v file_oka=${CODE_DIR}/monster-cmpp.log.${DEALDATE_2M}_dsf_allok.txt -v file_okb=${CODE_DIR}/monster-cmpp.log.${DEALDATE_2M}_dsfapp_allok.txt  -v time=${DEALDATE_2M}   '{
         if(FILENAME == opt_code   )  {o[$2]=$1 ;d[$2]=$3; print o[$2];print d[$2]}
         else if(FILENAME == file_ok &&  ($2 in o)   ) {print  o[$2]","time","$0 >> file_oka;print  d[$2]","time","$0 >> file_okb;}
          
 }'   ${CODE_DIR_UP}/dic/phone_dsf_down_dic.txt   ${CODE_DIR}/monster-cmpp.log.${DEALDATE_2M}_dsf_ok.txt  

cat ${CODE_DIR}/monster-cmpp.log.${DEALDATE_2M}_dsf_allok.txt | awk -F',' -v dir=${CODE_DIR} '{d=dir"/"$1$2"00";print $3","$5","$6","$7","$8 >>d}'
cat ${CODE_DIR}/monster-cmpp.log.${DEALDATE_2M}_dsfapp_allok.txt | awk -F',' -v dir=${CODE_DIR} '{d=dir"/"$1$2"00";print $3","$4","$5","$6","$7","$8 >>d}'

bzip2 report_*${DEALDATE_2M}
 
#scp -p /home/wuying/boss*_1_4.txt.bz2 oracle@172.16.101.210:/home/oracle/etl/data/



