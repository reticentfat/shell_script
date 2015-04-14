#/bin/sh

#----------------------
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/home/wuying/;
export PATH
#export PATH=/home/wuying/
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
CODE_DIR='/data0/match/orig/profile'
#希望优化后报表输出内容： 
#时间 省份名称 坐席工号 业务名称 推荐次数 推荐成功定制次数 业务定制次数 业务定制成功次数 

#2013-05-12,001,290,9162
#2013-05-12,001,290,9162

##生成坐席定制
##优惠券所有相关业务坐席定制的生成处理 先从日志表中获取所有惠生活日志再从推荐表中获取推荐日志，将推荐日志从所有日志中剔除就是坐席定制优惠券所有相关日志文件
mysql -h172.16.88.144 -unewci  -pwN6phYeeRzyz5uzB -D newqianxiang -D wireless_base -N -e " select   time,n.mobile,case when gid='HSH_MMS' then '594' when   gid='HSH_05_MMS' then '592' when   gid='NMGYHJ_SMS' then '541' when gid='ZJYHJ_MMS' then '313' when gid='ZKJLB_SMS' then '486'  when gid='ZKJ_SMS' then '487' end , case when length(h.no) =3  then concat(substr(h.no,2,3),'0') else substr(h.no,2,4)  end , n.staffno  from newqianxiang.coupon_log n , wireless_base.addr_info_20090430 h  where  substr(n.mobile,1,7)=h.mobile_7 and   gid in ('HSH_05_MMS','HSH_MMS','NMGYHJ_SMS','ZJYHJ_MMS','ZKJLB_SMS','ZKJ_SMS') and type=1 and sort=1 and  time >= '$DEALDATE_1'  and  time < '$DEALDATE_2'  " |  awk -F'\t' '{print $1","$2","$3","$4","$5}'  >  /data/wuying/zxdz/hsh_${DEALDATE}_all_log_791.txt

##优惠券所有相关推荐文件
mysql -h172.16.88.144 -unewci  -pwN6phYeeRzyz5uzB -D newqianxiang -D wireless_base -N -e " select dotime,n.mobile, case when business_name='HSH_MMS' then '594' when   business_name='HSH_05_MMS' then '592' when   business_name='NMGYHJ_SMS' then '541' when business_name='ZJYHJ_MMS' then '313' when  business_name='ZKJLB_SMS' then '486'  when business_name='ZKJ_SMS' then '487'  end,  case when  length(h.no) =3 then concat(substr(h.no,2,3),'0') else substr(h.no,2,4)  end  , staffno  from newqianxiang.tb_recommend_all n , wireless_base.addr_info_20090430 h  where  substr(n.mobile,1,7)=h.mobile_7 and  business_name  in ('HSH_05_MMS','HSH_MMS','NMGYHJ_SMS','ZJYHJ_MMS','ZKJLB_SMS','ZKJ_SMS')   and dotime >= '$DEALDATE_1'  and dotime < '$DEALDATE_2'  " |  awk -F'\t' '{print $1","$2","$3","$4","$5}' >  /data/wuying/zxdz/hsh_${DEALDATE}_tuijian_log_791.txt 

##坐席违章退订记录

mysql -h172.16.88.144 -unewci  -pwN6phYeeRzyz5uzB -D WZCX_DB -D qxcaipiao -N -e " SELECT  w.opttime,'91', h.provinceid,w.ZUOXI_ID,w.MOBILE_SN,'tuiding' from WZCX_DB.wzcx_log w,qxcaipiao.wz_haoduan h  where substr(w.MOBILE_SN,1,7)=h.mobile  and opttime>='$DEALDATE_1' and opttime<'$DEALDATE_2' and STATUS=3 and OPT_TYPE =1  " |  awk -F'\t' '{print $1","$2","$3","$4","$5",退订"}' >  /data/wuying/zxdz/weizhang_${DEALDATE}_cancle_log_791.txt 

##剔除优惠券所有相关推荐得到优惠券所有相关定制、

 awk -F',' -v CODE_DIR=/data/wuying/zxdz/hsh_${DEALDATE}_tuijian_log_791.txt     -v file_no=/data/wuying/zxdz/hsh_${DEALDATE}_dingzhi_ok_791.txt       '{
 if( FILENAME == CODE_DIR )  d[$2$3]=$0; 
 else if ( FILENAME != CODE_DIR &&  !($2$3  in d) ) print $1","$3","$4","$5","$2",开通" >> file_no
}'   /data/wuying/zxdz/hsh_${DEALDATE}_tuijian_log_791.txt   /data/wuying/zxdz/hsh_${DEALDATE}_all_log_791.txt 



##生成坐席定制
cat /data/wxlog/new_ci/14[6-7]/${DATEYEAR}/${DEALDATE2}  | grep 'dingzhiajax.php' |  awk -F'[|"]' '{print $3","$8","$12","$20","$24",开通"}'  > /data/wuying/zxdz/recommon_dingzhi_${DEALDATE}_791.txt

cat /data/wxlog/new_ci/14[6-7]/${DATEYEAR}/${DEALDATE2}  | grep 'unsub' |   grep 'staffno' | awk -F'[|"]' '{print  $3","$8","$20","$36","$24",退订" }' | grep -v 'QX' >> /data/wuying/zxdz/recommon_dingzhi_${DEALDATE}_791.txt

cat /data/wuying/zxdz/hsh_${DEALDATE}_dingzhi_ok_791.txt >> /data/wuying/zxdz/recommon_dingzhi_${DEALDATE}_791.txt
cat /data/wuying/zxdz/weizhang_${DEALDATE}_cancle_log_791.txt   >> /data/wuying/zxdz/recommon_dingzhi_${DEALDATE}_791.txt

##生成坐席推荐 统计时间	地市名称	坐席工号	业务名称	操作类型（开通/取消）	操作结果（成功/失败）	操作时间

###2013-05-15,315,931,1024,15276912186
##2013-05-15,315,290,9319,13720430263
##2013-05-15,316,290,9319,13720430263
##2013-05-15,582,210,8002,15900503908
##2013-05-15,315,290,9230,13891621986
##2013-05-15,88,210,8815,15000683258

cat /data/wxlog/recommend/${RECOMMDATE}/recommend_*.txt  /data/wxlog/zhufu_log/zhufu${DEALDATE3}_NR.txt |  grep ${DEALDATE_1}  | sort -u | awk  '{ gsub(/\t/,"") ; print }'  | awk -F'|'  '{print $9","$5","$7","$6","$2",开通"}'   >   /data/wuying/zxdz/recommon_tuijian_${DEALDATE}_791.txt
 
##匹配坐席定制订购成功用户号码
##582,短信包月,12580生活播报-健康宝典短信版,10102008,
##325,短信包月,营养助理,10102008,
##341,短信包月,今日关注,10202007,
##168,短信包月,折扣短信包月,10301001,
##108,短信包月,12580生活播报-生活百科短信版,10301009,

 ##匹配坐席定制订购推荐成功用户号码
  
awk  -F ',' -v opt_code=/data/wuying/PKFILTER_DIC/zx_dictionary.txt    -v file_oka=/data/wuying/zxdz/recommon_dingzhi_${DEALDATE}_791.txt  -v file_ok1=/data/wuying/zxdz/recommon_dingzhi_${DEALDATE}_dic_791.txt  -v file_okb=/data/wuying/zxdz/recommon_tuijian_${DEALDATE}_791.txt  -v file_ok2=/data/wuying/zxdz/recommon_tuijian_${DEALDATE}_dic_791.txt '{

         if(FILENAME == opt_code   )  o[$1]=$4","$3 ;

         else if(FILENAME == file_oka &&  $2 in o   ) print  $5","o[$2]","$1","$2","$3","$4","$6 >> file_ok1;

         else if(FILENAME == file_okb &&  $2 in o   ) print  $5","o[$2]","$1","$2","$3","$4","$6 >> file_ok2;
         
}'   /data/wuying/PKFILTER_DIC/zx_dictionary.txt   /data/wuying/zxdz/recommon_dingzhi_${DEALDATE}_791.txt  /data/wuying/zxdz/recommon_tuijian_${DEALDATE}_791.txt



 bzip2 /data/wuying/zxdz/recommon_dingzhi_${DEALDATE}_dic_791.txt
 
 bzip2 /data/wuying/zxdz/recommon_tuijian_${DEALDATE}_dic_791.txt
 
 ##13892046319,10511051,12580生活播报-法律百科彩信版,2014-04-20 6:08:53,584,290,9162,开通
 ##13892046319,10511051,12580生活播报-法律百科彩信版,2014-04-20 6:09:07,584,290,9162,开通
 ##15094570207,10301022,排列三排列五开奖信息,2014-04-20 7:31:50,319,451,7363,开通

 
 bzcat /data/wuying/zxdz/recommon_dingzhi_${DEALDATE}_dic_791.txt.bz2  /data/match/mm7/${DEALDATE}/outputumessage_001_wuxian_${DEALDATE}_snapshot.bz2 | awk -F'[,|]' '{if(NF==8) aa[$1$2]=$4","$1","$2","$3","$5","$6","$7","$8 ; else if ($1$2  in aa)  print aa[$1$2];  }'  >  /data/wuying/zxdz/recommon_dingzhi_${DEALDATE}_dic_suc_tmp_791.txt 
 bzcat /data/wuying/zxdz/recommon_dingzhi_${DEALDATE}_dic_791.txt.bz2  /data/wuying/user_sn.txt.bz2 | awk -F'[,|]' '{if(NF==8) aa[$1$2]=$4","$1","$2","$3","$5","$6","$7","$8 ; else  if (   ($1$2  in aa) )  print aa[$1$2];  }'   >>  /data/wuying/zxdz/recommon_dingzhi_${DEALDATE}_dic_suc_tmp_791.txt
 
   
 
 bzcat /data/wuying/zxdz/recommon_tuijian_${DEALDATE}_dic_791.txt.bz2  /data/match/mm7/${DEALDATE}/outputumessage_001_wuxian_${DEALDATE}_snapshot.bz2 | awk -F'[,|]' '{if(NF==8) aa[$1$2]=$4","$1","$2","$3","$5","$6","$7","$8 ; else if ($1$2  in aa)  print aa[$1$2];  }'  >  /data/wuying/zxdz/recommon_tuijian_${DEALDATE}_dic_suc_tmp_791.txt 
 bzcat /data/wuying/zxdz/recommon_tuijian_${DEALDATE}_dic_791.txt.bz2  /data/wuying/user_sn.txt.bz2 | awk -F'[,|]' '{if(NF==8) aa[$1$2]=$4","$1","$2","$3","$5","$6","$7","$8 ; else  if (   ($1$2  in aa) )  print aa[$1$2];  }'   >>  /data/wuying/zxdz/recommon_tuijian_${DEALDATE}_dic_suc_tmp_791.txt
 
 

 ##有订购关系为成功无订购关系为失败 
 
 
 cat /data/wuying/zxdz/recommon_dingzhi_${DEALDATE}_dic_suc_tmp_791.txt /data/wuying/zxdz/recommon_tuijian_${DEALDATE}_dic_suc_tmp_791.txt |  awk -F',' '{print $0",成功" }' | bzip2 > /data/wuying/zxdz/recommon_all_${DEALDATE}_dic_suc_tmp_791.txt.bz2
 
  bzcat /data/wuying/zxdz/recommon_dingzhi_${DEALDATE}_dic_791.txt.bz2  /data/wuying/zxdz/recommon_tuijian_${DEALDATE}_dic_791.txt.bz2 | bzip2 > /data/wuying/zxdz/recommon_all_${DEALDATE}_dic_791.txt.bz2 
 
 bzcat /data/wuying/zxdz/recommon_all_${DEALDATE}_dic_suc_tmp_791.txt.bz2  /data/wuying/zxdz/recommon_all_${DEALDATE}_dic_791.txt.bz2 |  awk -F','  '{if(NF==9) { aa[$2$3]=$0 ; print $0 ;}  else  if (  ! ($1$2  in aa) )  print $4","$1","$2","$3","$5","$6","$7","$8",失败";  }'   >  /data/wuying/zxdz/recommon_all_${DEALDATE}_dic_sucfail_tmp_791.txt
 
 ##
  ##云南|保山|875|1846944|871|34040000|
 ##云南|保山|875|1846945|871|34040000|
 ##云南|保山|875|1846946|871|34040000|

 
 ##匹配省份名称 时间,省份名称,坐席工号,业务名称,推荐次数,推荐成功定制次数,业务定制次数,业务定制成功次数,省编码
 cat /data/wuying/zxdz/recommon_all_${DEALDATE}_dic_sucfail_tmp_791.txt | awk '{if(NR==1)print "统计时间,省份名称,地市名称,用户号码,坐席工号,业务名称,操作类型（开通/取消）,操作结果（成功/失败）,操作时间" }' > /data/wuying/zxdz/jiangxi_zxlog_${DEALDATE}.txt 
   
awk  -F '[|,]' -v tjdate=${DEALDATE_1}  -v opt_code=/data/wuying/PKFILTER_DIC/nodist.tsv     -v file_oka=/data/wuying/zxdz/recommon_all_${DEALDATE}_dic_sucfail_tmp_791.txt   -v file_ok1=/data/wuying/zxdz/jiangxi_zxlog_${DEALDATE}.txt   '{

         if(FILENAME == opt_code   && $5 =="791" )  o[$4]=$1","$2 ;

         else if(FILENAME == file_oka &&  substr($2,1,7) in o ) print tjdate","o[substr($2,1,7)]","$2","$7","$4","$8","$9","$1 >> file_ok1;
    
}'   /data/wuying/PKFILTER_DIC/nodist.tsv     /data/wuying/zxdz/recommon_all_${DEALDATE}_dic_sucfail_tmp_791.txt 

#iconv -f GB2312 -t UTF-8   /data/wuying/zxdz/recommon_tuijiandingzhi_${DEALDATE}_dic_allcount_ok.txt > /data/wuying/zxdz/report.region.wireless_tjdz_${DEALDATE}.csv

#scp -p /data/wuying/zxdz/recommon_all_${DEALDATE}_dic_sucfail_tmp_791_ok.txt  oracle@172.16.100.158:/home/oracle/etl/data/KPI_DATA/${DATEYEAR}/${DEALDATE}/report.region.wireless_recommci_province.csv

rm /data/wuying/zxdz/*${DEALDATE}*_791.txt
rm /data/wuying/zxdz/*${DEALDATE}*791*.bz2


ftp -i -v -n 218.206.87.169 <<EOF
user jiangxi_kaofen PLzoYQzoIRXYTGduhtoI4evK
cd zuoxi_log
lcd /data/wuying/zxdz/

mput jiangxi_zxlog_${DEALDATE}.txt 

EOF

