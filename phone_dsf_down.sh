#/bin/sh

#----------------------
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/home/wuying/;
export PATH
#export PATH=/home/wuying/
if [ $# -eq 2 ];then
   AGO_DAY1=$1
   AGO_DAY2=$2
  
   
   
fi

if [ ${AGO_DAY1:=999} = 999 ];then
RECOMMDATE=`date -v-1H +%Y%m%d`
DEALDATE=`date  -v-1H  +%Y%m%d%H`
TODAYTIME=`date  -v-1H  +%Y%m%d%H%M%S`
DATEYEAR=`date -v-1d  +%Y`
DEALDATE2=`date -v-1d  +%m%d`
DEALDATE3=`date -v-1d  +%Y%m`
DEALDATE_1=`date -v-1d  +%Y-%m-%d`
DEALDATE_2=`date -v-0d  +%Y-%m-%d` 
else
RECOMMDATE=`date -v-${AGO_DAY1}d  +%Y%m%d`
DEALDATE=`date -v-${AGO_DAY1}d -v${AGO_DAY2}H  +%Y%m%d%H`
TODAYTIME=`date -v-${AGO_DAY1}d -v${AGO_DAY2}H  +%Y%m%d%H%M%S`
DATEYEAR=`date -v-${AGO_DAY2}d  +%Y`
DEALDATE2=`date -v-${AGO_DAY2}d  +%m%d`
DEALDATE3=`date -v-${AGO_DAY2}d  +%Y%m`
DEALDATE_1=`date -v-${AGO_DAY2}d  +%Y-%m-%d`
DEALDATE_2=`date -v-${AGO_DAY2}d  +%Y-%m-%d`
fi


##短信网关状态报告返回值顺序 流水号，手机号，状态报告，提交时间，处理时间
##bzcat monster-cmpp-report.log.201409091600.bz2 | awk -F'[\],]' '{print $3","$6","$5","$7","$8}' 
#09091459500101045265,13543780701,0,201409091459,201409091459
#09091459510101045922,13829195797,0,201409091459,201409091459
##短信网关下发值顺序 流水号，手机号，APPCODE，计费代码
# bzcat /data/monster/20140910/monster-cmppmt.log.201409100000.bz2 | awk -F'[\],]' '{print $33","$13","$16","$20}' | head

#09100000010101065351,15276116317,20100052,UMGYWCXX
#09092359470101018121,18221424813,10101000,UMGYWCXX


##先过滤出商界和医疗对应的业务 106588805009 10101066  106588805010 10101067
 bzcat  /data/wuying/PKFILTER_DIC/phone_dsf_down_dic.txt.bz2 /data/monster/${RECOMMDATE}/monster-cmppmt.log.${DEALDATE}00.bz2 | awk -F'[\],|]'     '{if(NF<20) aa[$2]=$2 ; else if ($16  in aa)  print   $0 ;   }' | bzip2  > /data/monster/${RECOMMDATE}/monster-cmppmt.log.${DEALDATE}00_dsf_dy.bz2
# bzcat  /data/wuying/PKFILTER_DIC/phone_dsf_down_dic.txt.bz2 /data/monster/${RECOMMDATE}/monster-mm7mt.log.${DEALDATE}00.bz2  | awk -F'[:,|]'      '{if(NF<20) aa[$2]=$2 ; else if ($18  in aa)  print  $0  ;   }'  | bzip2 > /data/monster/${RECOMMDATE}/monster-mm7mt.log.${DEALDATE}00_dsf_dy.bz2 

#短信勾兑
 bzcat /data/monster/${RECOMMDATE}/monster-cmpp-report.log.${DEALDATE}00.bz2  /data/monster/${RECOMMDATE}/monster-cmppmt.log.${DEALDATE}00_dsf_dy.bz2 | awk -F'[\],]' -v fileok=/data/monster/${RECOMMDATE}/monster-cmpp.log.${DEALDATE}00_dsf_ok.txt -v file0=/data/monster/monster-cmpp.log.${DEALDATE}00_dsf_no.txt '{if(NF<20) aa[$3$6]=$5","$7","$8 ; else if ($33$13  in aa)  print   $13","$16","$11","aa[$33$13]","substr($2,3,44) >> fileok;   else if (!($33$13  in aa))  print  >> file0;  }'   
#彩信勾兑
#bzcat /data/monster/${RECOMMDATE}/monster-mm7-report.log.${DEALDATE}00.bz2  /data/monster/${RECOMMDATE}/monster-mm7mt.log.${DEALDATE}00_dsf_dy.bz2 | awk -F'[:,]' -v fileok=/data/monster/${RECOMMDATE}/monster-mm7.log.${DEALDATE}00_dsf_ok.txt -v file0=/data/monster/monster-mm7.log.${DEALDATE}00_dsf_no.txt '{if(NF<20) aa[$5substr($7,3,13)]=$10 ; else if ($30$15  in aa)  print  $15","$18","$22","aa[$30$15]","substr($4,2,14)","substr($4,2,44) >> fileok;   else if (!($30$15  in aa))  print  >> file0;  }'   

#短信历史未勾兑 monster-cmpp.log.${DEALDATE}00_dsf_no.txt
cat /data/monster/monster-cmpp_dsf.log.*_no.txt | bzip2 > /data/monster/${RECOMMDATE}/monster-cmpp.log.all_dsf_no.txt.bz2
rm  /data/monster/monster-cmpp_dsf.log.*_no.txt
#勾兑短信历史判断发送时间超过3天的日志状态返回为NOBACK,未满足的继续累积到下次比对else if (  !($33$13  in aa) )  print $33","$13","$16","$20",NOBACK","substr($2,3,14) >> fileok;  ( SYSDATETIME-substr($2,3,14) ) > 3000000  &&
bzcat /data/monster/${RECOMMDATE}/monster-cmpp-report.log.${DEALDATE}00.bz2 /data/monster/${RECOMMDATE}/monster-cmpp.log.all_dsf_no.txt.bz2    | awk -F'[\],]' -v fileok=/data/monster/${RECOMMDATE}/monster-cmpp.log.${DEALDATE}00_dsf_ok.txt -v file0=/data/monster/monster-cmpp.log.${DEALDATE}00_dsf_no.txt -v SYSDATETIME=${TODAYTIME} '{if(NF<20) aa[$3$6]=$5","$7 ; else if ($33$13  in aa)  print  $13","$16","$20","aa[$33$13]","substr($2,3,44) >> fileok;    else if (   !($33$13  in aa) )  print  >> file0;  }'   

#彩信历史未勾兑
#cat /data/monster/monster-mm7.log.*_dsf_no.txt | bzip2 > /data/monster/${RECOMMDATE}/monster-mm7.log.all_dsf_no.txt.bz2
#rm  /data/monster/monster-mm7.log.*_dsf_no.txt
#勾兑彩信历史判断发送时间超过3天的日志状态返回为NOBACK,未满足的继续累积到下次比对else if (  !($30$15  in aa))  print $30","$15","$18","$22",NOBACK,"substr($4,2,14) >> fileok;  (SYSDATETIME-substr($4,2,14))>3000000  && 
#bzcat /data/monster/${RECOMMDATE}/monster-mm7-report.log.${DEALDATE}00.bz2  /data/monster/${RECOMMDATE}/monster-mm7.log.all_dsf_no.txt.bz2 | awk -F'[:,]' -v fileok=/data/monster/${RECOMMDATE}/monster-mm7.log.${DEALDATE}00_dsf_ok.txt -v file0=/data/monster/monster-mm7.log.${DEALDATE}00_dsf_no.txt -v SYSDATETIME=${TODAYTIME} '{if(NF<20) aa[$5substr($7,3,13)]=$10 ; else if ($30$15  in aa)  print  $15","$18","$22","aa[$30$15]","substr($4,2,14)","substr($4,2,44) >> fileok;  else if (  !($30$15  in aa))  print  >> file0;  }'   


#匹配短信勾兑成功号码对应商界与医疗的业务代码
#yiliao|10511074|801174|中医健康|1258182|800|包月计费|手机医疗
#shangjie|10511084|801174|商务专刊包月|1258194|500|包月计费|手机商界
#1dsf_yzm|10101066
#2dsf_yzm|10101067

#下发时间，下行号码，下行APPCODE,下行计费代码，下行流水号，接收状态
##15276116317,20100052,UMGYWCXX,MI:1000,20140910000001,09100000010101065351
 awk  -F '[|,]' -v opt_code=/data/wuying/PKFILTER_DIC/phone_dsf_down_dic.txt    -v file_oka=/data/monster/${RECOMMDATE}/monster-cmpp.log.${DEALDATE}00_dsf_ok.txt  -v file_oka=/data/monster/${RECOMMDATE}/monster-cmpp.log.${DEALDATE}_dsf_allok.txt   -v file_okb=/data/monster/${RECOMMDATE}/monster-cmpp.log.${DEALDATE}_dsfapp_allok.txt    -v time=${DEALDATE}   '{
         if(FILENAME == opt_code   )  {o[$2]=$1","$3  ;d[$2]=$3","$1; print o[$2];print d[$2];}
         else if(FILENAME != opt_code &&  ($2 in o) ) {print  o[$2]","time","$0 >> file_oka;print  d[$2]","time","$0 >> file_okb;} 
         
 }'   /data/wuying/PKFILTER_DIC/phone_dsf_down_dic.txt   /data/monster/${RECOMMDATE}/monster-cmpp.log.${DEALDATE}00_dsf_ok.txt  

#/data/monster/20140911/monster-cmpp.log.201409111300_ok.txt

cat /data/monster/${RECOMMDATE}/monster-cmpp.log.${DEALDATE}_dsf_allok.txt | awk -F',' -v dir=/data/monster/${RECOMMDATE}/ '{d=dir$1$3"00";print $10","$6","$7","$4","$8","$9 >>d}'
cat /data/monster/${RECOMMDATE}/monster-cmpp.log.${DEALDATE}_dsfapp_allok.txt | awk -F',' -v dir=/data/monster/${RECOMMDATE}/ '{d=dir$1$3"00";print $10","$5","$6","$7","$4","$8","$9 >>d}'

bzip2 /data/monster/${RECOMMDATE}/report_*${DEALDATE}00

#cat /data/monster/${RECOMMDATE}/report_10101066_${DEALDATE}00.txt | awk -F',' '{print $10","$5","$6","$7","$4","$8","$9}' | bzip2 >  /data/monster/${RECOMMDATE}/report_10101066_${DEALDATE}00.bz2
#cat /data/monster/${RECOMMDATE}/report_10101066_${DEALDATE}00.txt | awk -F',' '{print $10","$6","$7","$4","$8","$9}' | bzip2 >  /data/monster/${RECOMMDATE}/report_ruanyun_${DEALDATE}00.bz2

#cat /data/monster/${RECOMMDATE}/monster_shangjie_${DEALDATE}00_mm7_ok.txt | awk -F',' '{print $10","$5","$6","$7","$4","$8","$9}' | bzip2 >  /data/monster/${RECOMMDATE}/monster_shangjie_${DEALDATE}00_mm7_ok.txt.bz2
#cat /data/monster/${RECOMMDATE}/report_10101067_${DEALDATE}00.txt | awk -F',' '{print $10","$5","$6","$7","$4","$8","$9}' | bzip2 >  /data/monster/${RECOMMDATE}/report_10101067_${DEALDATE}00.bz2
#cat /data/monster/${RECOMMDATE}/report_10101067_${DEALDATE}00.txt | awk -F',' '{print $10","$6","$7","$4","$8","$9}' | bzip2 >  /data/monster/${RECOMMDATE}/report_ruanyun_b_${DEALDATE}00.bz2
  
scp /data/monster/${RECOMMDATE}/report_1*_${DEALDATE}00.bz2  gateway@192.100.7.47:/data/www/sms/log/report/
 
ftp -i -v -n 218.207.201.185 <<EOF
user fetion ##
lcd  /data/monster/${RECOMMDATE}/
mput  report_ruanyun_${DEALDATE}00.bz2
EOF

ftp -i -v -n 123.57.68.153 <<EOF
user ftpuser1 *##
lcd  /data/monster/${RECOMMDATE}/
mput *report_ruanyun_b_${DEALDATE}00.bz2
EOF

ftp -i -v -n 120.26.219.238 <<EOF
user user1 8##3B
lcd  /data/monster/${RECOMMDATE}/
mput *report_jieyong_${DEALDATE}00.bz2
EOF

#rm /data/wuying/zxdz/*${DEALDATE}*.txt
#rm /data/wuying/zxdz/*${DEALDATE}*.bz2



