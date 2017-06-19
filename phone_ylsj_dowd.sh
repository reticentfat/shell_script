#/bin/sh

#----------------------
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/home/gateway/;
export PATH
#export PATH=/home/gateway/
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


##彩信网关状态报告  流水号，手机号，状态报告，处理时间
# bzcat /data/monster/20140910/monster-mm7-report.log.201409100000.bz2 |  awk -F'[:,]'  '{print $5","substr($7,3,13)","$10","$12}' | head
#090910543191005702806,13917396978,1000,2014-09-10T00
#090710274591005708456,13547820856,1000,2014-09-10T00
#090910555591005602421,13524972380,1000,2014-09-10T00
##彩信网关下发顺序 流水号，手机号，APPCODE，计费代码,提交时间
#bzcat monster-mm7mt.log.201409091600.bz2 | awk -F'[:,]' '{print $30","$15","$18","$22","substr($4,2,14)}' | head
 
#091000000191005606577,15766134541,10511012,125823,20140910000001
#091000001491005705408,15957233220,12200001,12580002,20140910000013


###2013-05-15","10202007","今日关注","315","931","1024 
##15276912186,10202007,今日关注,2013-05-15,315,931,1024,

##先过滤出商界和医疗对应的业务
 bzcat  /data/211/PKFILTER_DIC/phone_yiliao_shangjie_dic.txt.bz2 /data/monster/${RECOMMDATE}/monster-cmppmt.log.${DEALDATE}00.bz2 | awk -F'[\],|]'     '{if(NF<20) aa[$2]=$2 ; else if ($16  in aa)  print   $0 ;   }' | bzip2  > /data/monster/${RECOMMDATE}/monster-cmppmt.log.${DEALDATE}00_dy.bz2
 bzcat  /data/211/PKFILTER_DIC/phone_yiliao_shangjie_dic.txt.bz2 /data/monster/${RECOMMDATE}/monster-mm7mt.log.${DEALDATE}00.bz2  | awk -F'[:,|]'      '{if(NF<20) aa[$2]=$2 ; else if ($18  in aa)  print  $0  ;   }'  | bzip2 > /data/monster/${RECOMMDATE}/monster-mm7mt.log.${DEALDATE}00_dy.bz2 

#短信勾兑
 bzcat /data/monster/${RECOMMDATE}/monster-cmpp-report.log.${DEALDATE}00.bz2  /data/monster/${RECOMMDATE}/monster-cmppmt.log.${DEALDATE}00_dy.bz2 | awk -F'[\],]' -v fileok=/data/monster/${RECOMMDATE}/monster-cmpp.log.${DEALDATE}00_ok.txt -v file0=/data/monster/monster-cmpp.log.${DEALDATE}00_no.txt '{if(NF<20) aa[$3$6]=$5","$7 ; else if ($33$13  in aa)  print   $13","$16","$20","aa[$33$13]","substr($2,3,44) >> fileok;   else if (!($33$13  in aa))  print  >> file0;  }'   
#彩信勾兑
bzcat /data/monster/${RECOMMDATE}/monster-mm7-report.log.${DEALDATE}00.bz2  /data/monster/${RECOMMDATE}/monster-mm7mt.log.${DEALDATE}00_dy.bz2 | awk -F'[:,]' -v fileok=/data/monster/${RECOMMDATE}/monster-mm7.log.${DEALDATE}00_ok.txt -v file0=/data/monster/monster-mm7.log.${DEALDATE}00_no.txt '{if(NF<20) aa[$5substr($7,3,13)]=$10 ; else if ($30$15  in aa)  print  $15","$18","$22","aa[$30$15]","substr($4,2,14)","substr($4,2,44) >> fileok;   else if (!($30$15  in aa))  print  >> file0;  }'   

#短信历史未勾兑
cat /data/monster/monster-cmpp.log.*_no.txt | bzip2 > /data/monster/${RECOMMDATE}/monster-cmpp.log.all_no.txt.bz2
rm  /data/monster/monster-cmpp.log.*_no.txt
#勾兑短信历史判断发送时间超过3天的日志状态返回为NOBACK,未满足的继续累积到下次比对

bzcat /data/monster/${RECOMMDATE}/monster-cmpp-report.log.${DEALDATE}00.bz2 /data/monster/${RECOMMDATE}/monster-cmpp.log.all_no.txt.bz2    | awk -F'[\],]' -v fileok=/data/monster/${RECOMMDATE}/monster-cmpp.log.${DEALDATE}00_ok.txt -v file0=/data/monster/monster-cmpp.log.${DEALDATE}00_no.txt -v SYSDATETIME=${TODAYTIME} '{if(NF<20) aa[$3$6]=$5","$7 ; else if ($33$13  in aa)  print  $13","$16","$20","aa[$33$13]","substr($2,3,44) >> fileok;    else if (   !($33$13  in aa) )  print  >> file0;  }'   

#彩信历史未勾兑
cat /data/monster/monster-mm7.log.*_no.txt | bzip2 > /data/monster/${RECOMMDATE}/monster-mm7.log.all_no.txt.bz2
rm  /data/monster/monster-mm7.log.*_no.txt
#勾兑彩信历史判断发送时间超过3天的日志状态返回为NOBACK,未满足的继续累积到下次比对
bzcat /data/monster/${RECOMMDATE}/monster-mm7-report.log.${DEALDATE}00.bz2  /data/monster/${RECOMMDATE}/monster-mm7.log.all_no.txt.bz2 | awk -F'[:,]' -v fileok=/data/monster/${RECOMMDATE}/monster-mm7.log.${DEALDATE}00_ok.txt -v file0=/data/monster/monster-mm7.log.${DEALDATE}00_no.txt -v SYSDATETIME=${TODAYTIME} '{if(NF<20) aa[$5substr($7,3,13)]=$10 ; else if ($30$15  in aa)  print  $15","$18","$22","aa[$30$15]","substr($4,2,14)","substr($4,2,44) >> fileok;  else if (  !($30$15  in aa) && (( SYSDATETIME - substr($4,2,14) ) >3000000)   )  print $30","$15","$18","$22",NOBACK,"substr($4,2,14) >> fileok;  else if (  !($30$15  in aa) && (( SYSDATETIME - substr($4,2,14)) <= 3000000) )  print  >> file0;  }'   


#匹配短信勾兑成功号码对应商界与医疗的业务代码
#yiliao|10511074|801174|中医健康|1258182|800|包月计费|手机医疗
#shangjie|10511084|801174|商务专刊包月|1258194|500|包月计费|手机商界
#HSH_shangjie|10201077|901808|惠生活短信点播5元|UMGHSHDB|500|按次/按条计费|广东惠生活
#下发时间，下行号码，下行APPCODE,下行计费代码，下行流水号，接收状态
##15276116317,20100052,UMGYWCXX,MI:1000,20140910000001,09100000010101065351
 awk  -F '[|,]' -v opt_code=/data/211/PKFILTER_DIC/phone_yiliao_shangjie_dic.txt    -v file_oka=/data/monster/${RECOMMDATE}/monster-cmpp.log.${DEALDATE}00_ok.txt   -v file_okb=/data/monster/${RECOMMDATE}/monster-mm7.log.${DEALDATE}00_ok.txt -v file_ok_shangjie_cmpp=/data/monster/${RECOMMDATE}/monster_shangjie_${DEALDATE}00_cmpp_ok.txt  -v file_ok_shangjie_mm7=/data/monster/${RECOMMDATE}/monster_shangjie_${DEALDATE}00_mm7_ok.txt  -v file_ok_yiliao=/data/monster/${RECOMMDATE}/monster_yiliao_${DEALDATE}00_ok.txt -v file_ok_hsh_shangjie_cmpp=/data/monster/${RECOMMDATE}/monster_hsh_${DEALDATE}00_cmpp_ok.txt  -v file_ok_hsh_shangjie_mm7=/data/monster/${RECOMMDATE}/monster_hsh_${DEALDATE}00_mm7_ok.txt '{
         if(FILENAME == opt_code   )  o[$2]=$1","$3","$4 ;
         else if(FILENAME == file_oka &&  ($2 in o)  && substr(o[$2],1,1)=="s" ) print  o[$2]","$0 >> file_ok_shangjie_cmpp;
         else if(FILENAME == file_oka &&  ($2 in o)  && substr(o[$2],1,1)=="H" ) print  o[$2]","$0 >> file_ok_hsh_shangjie_cmpp;
         else if(FILENAME == file_oka &&  ($2 in o)  && substr(o[$2],1,1)=="y" ) print  o[$2]","$0 >> file_ok_yiliao;
         else if(FILENAME == file_okb &&  ($2 in o)  && substr(o[$2],1,1)=="s" ) print  o[$2]","$0 >> file_ok_shangjie_mm7;
         else if(FILENAME == file_okb &&  ($2 in o)  && substr(o[$2],1,1)=="H" ) print  o[$2]","$0 >> file_ok_hsh_shangjie_mm7;
         else if(FILENAME == file_okb &&  ($2 in o)  && substr(o[$2],1,1)=="y" ) print  o[$2]","$0 >> file_ok_yiliao;

 }'   /data/211/PKFILTER_DIC/phone_yiliao_shangjie_dic.txt   /data/monster/${RECOMMDATE}/monster-cmpp.log.${DEALDATE}00_ok.txt  /data/monster/${RECOMMDATE}/monster-mm7.log.${DEALDATE}00_ok.txt

#/data/monster/20140911/monster-cmpp.log.201409111300_ok.txt
cat /data/monster/${RECOMMDATE}/monster_shangjie_${DEALDATE}00_cmpp_ok.txt | awk -F',' '{print $9","$5","$6","$7","$4","$8}' | bzip2 >  /data/monster/${RECOMMDATE}/monster_shangjie_${DEALDATE}00_cmpp_ok.txt.bz2
cat /data/monster/${RECOMMDATE}/monster_shangjie_${DEALDATE}00_mm7_ok.txt | awk -F',' '{print $9","$5","$6","$7","$4","$8}' | bzip2 >  /data/monster/${RECOMMDATE}/monster_shangjie_${DEALDATE}00_mm7_ok.txt.bz2
cat /data/monster/${RECOMMDATE}/monster_hsh_${DEALDATE}00_cmpp_ok.txt | awk -F',' '{print $9","$5","$6","$7","$4","$8}' | bzip2 >  /data/monster/${RECOMMDATE}/monster_hsh_${DEALDATE}00_cmpp_ok.txt.bz2
cat /data/monster/${RECOMMDATE}/monster_hsh_${DEALDATE}00_mm7_ok.txt | awk -F',' '{print $9","$5","$6","$7","$4","$8}' | bzip2 >  /data/monster/${RECOMMDATE}/monster_hsh_${DEALDATE}00_mm7_ok.txt.bz2
cat /data/monster/${RECOMMDATE}/monster_yiliao_${DEALDATE}00_ok.txt | awk -F',' '{print $9","$5","$6","$7","$4","$8}' | bzip2 >  /data/monster/${RECOMMDATE}/monster_yiliao_${DEALDATE}00_ok.txt.bz2
 
scp /data/monster/${RECOMMDATE}/monster_shangjie_${DEALDATE}00_cmpp_ok.txt.bz2 /data/monster/${RECOMMDATE}/monster_shangjie_${DEALDATE}00_mm7_ok.txt.bz2  /data/monster/${RECOMMDATE}/monster_yiliao_${DEALDATE}00_ok.txt.bz2 /data/monster/${RECOMMDATE}/monster_hsh_${DEALDATE}00_cmpp_ok.txt.bz2 /data/monster/${RECOMMDATE}/monster_hsh_${DEALDATE}00_mm7_ok.txt.bz2 gateway@192.100.7.47:/data/gateway/monster/
 
#rm /data/wuying/zxdz/*${DEALDATE}*.txt
#rm /data/wuying/zxdz/*${DEALDATE}*.bz2



