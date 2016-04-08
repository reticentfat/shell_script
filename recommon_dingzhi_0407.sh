#/bin/sh

#----------------------
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/home/gateway/;
export PATH
#export PATH=/home/gateway/
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
mysql -h172.200.7.13 -ur_slave_db -pf2fJaXWmU1fNjmdM -D newqianxiang -D wireless_base -N -e " select  substr(time,1,10),n.mobile,case when gid='HSH_MMS' then '594' when   gid='HSH_05_MMS' then '592' when   gid='NMGYHJ_SMS' then '541' when gid='ZJYHJ_MMS' then '313' when gid='ZKJLB_SMS' then '486'  when gid='ZKJ_SMS' then '487' end , case when length(h.no) =3  then concat(substr(h.no,2,3),'0') else substr(h.no,2,4)  end , n.staffno  from newqianxiang.coupon_log n , wireless_base.addr_info_20090430 h  where  substr(n.mobile,1,7)=h.mobile_7 and   gid in ('HSH_05_MMS','HSH_MMS','NMGYHJ_SMS','ZJYHJ_MMS','ZKJLB_SMS','ZKJ_SMS') and type=1 and sort=1 and  time >= '$DEALDATE_1'  and  time < '$DEALDATE_2'  " |  awk '{print $1","$2","$3","$4","$5}' >  /data/zxdz/hsh_${DEALDATE}_all_log.txt
##2014-05-27,15810993107,594,100,6304
##2014-05-27,15847241064,541,471,05017
##2014-05-27,18392010817,592,290,9212

##优惠券所有相关推荐文件 r_slave_db	f2fJaXWmU1fNjmdM
mysql -h172.200.7.13 -ur_slave_db -pf2fJaXWmU1fNjmdM -D newqianxiang -D wireless_base -N -e " select substr(dotime,1,10),n.mobile, case when business_name='HSH_MMS' then '594' when   business_name='HSH_05_MMS' then '592' when   business_name='NMGYHJ_SMS' then '541' when business_name='ZJYHJ_MMS' then '313' when  business_name='ZKJLB_SMS' then '486'  when business_name='ZKJ_SMS' then '487'  end,  case when  length(h.no) =3 then concat(substr(h.no,2,3),'0') else substr(h.no,2,4)  end  , staffno  from newqianxiang.tb_recommend_all n , wireless_base.addr_info_20090430 h  where  substr(n.mobile,1,7)=h.mobile_7 and  business_name  in ('HSH_05_MMS','HSH_MMS','NMGYHJ_SMS','ZJYHJ_MMS','ZKJLB_SMS','ZKJ_SMS')   and dotime >= '$DEALDATE_1'  and dotime < '$DEALDATE_2'  " |  awk '{print $1","$2","$3","$4","$5}' >  /data/zxdz/hsh_${DEALDATE}_tuijian_log.txt 
 
##剔除优惠券所有相关推荐得到优惠券所有相关定制、

 awk -F',' -v CODE_DIR=/data/zxdz/hsh_${DEALDATE}_tuijian_log.txt     -v file_no=/data/zxdz/hsh_${DEALDATE}_dingzhi_ok.txt       '{
 if( FILENAME == CODE_DIR )  d[$2$3]=$0; 
 else if ( FILENAME != CODE_DIR &&  !($2$3  in d) ) print $1","$3","$4","$5 >> file_no
}'   /data/zxdz/hsh_${DEALDATE}_tuijian_log.txt   /data/zxdz/hsh_${DEALDATE}_all_log.txt 


 awk -F',' -v CODE_DIR=/data/zxdz/hsh_${DEALDATE}_tuijian_log.txt   -v file_phone=/data/zxdz/hsh_${DEALDATE}_dingzhiphone_ok.txt         '{
 if( FILENAME == CODE_DIR )  d[$2$3]=$0; 
 else if ( FILENAME != CODE_DIR &&  !($2$3  in d) )  print $1","$3","$4","$5","$2 >> file_phone; 
 
}'   /data/zxdz/hsh_${DEALDATE}_tuijian_log.txt   /data/zxdz/hsh_${DEALDATE}_all_log.txt 

############违章定制数据生成及统计#####################
##生成坐席定制
##违章所有相关业务坐席定制的生成处理 先从日志表中获取所有违章日志再从推荐表中获取推荐日志，将推荐日志从所有日志中剔除就是坐席定制违章所有相关日志文件

mysql -h192.100.7.19 -ur_slave_db  -pwzMIWdZ93n45d5NT -D WZCX_DB -D wzcx_content  -N -e " select substr(opttime,1,10),w.mobile_sn,  case when w.opt_addr='ANHUI' and  w.FEE_APP_CODE='GENERAL_WZCX_3' then '91' when w.opt_addr='BEIJING' and  w.FEE_APP_CODE='A' then '99'  when w.opt_addr='BEIJING' and  w.FEE_APP_CODE='B' then '98'  when w.opt_addr='BEIJING' and  w.FEE_APP_CODE='C' then '90'  when w.opt_addr='BEIJING' and  w.FEE_APP_CODE='D' then '100' when w.opt_addr='BEIJING' and  w.FEE_APP_CODE='E' then '93' when w.opt_addr='GUANGDONG' and  w.FEE_APP_CODE='1' then '99' when w.opt_addr='GUANGDONG' and  w.FEE_APP_CODE='10' then '98'  when w.opt_addr='GUANGDONG' and  w.FEE_APP_CODE='2' then '90' when w.opt_addr='GUANGDONG' and  w.FEE_APP_CODE='3' then '91'  when w.opt_addr='GUANGDONG' and  w.FEE_APP_CODE='4' then '92' when w.opt_addr='GUANGDONG' and  w.FEE_APP_CODE='5' then '93' when w.opt_addr='GUANGDONG' and  w.FEE_APP_CODE='6' then '94' when w.opt_addr='GUANGDONG' and  w.FEE_APP_CODE='7' then '95'  when w.opt_addr='GUANGDONG' and  w.FEE_APP_CODE='8' then '96'  when w.opt_addr='GUANGDONG' and  w.FEE_APP_CODE='9' then '97'  when w.opt_addr='HEBEI' and  w.FEE_APP_CODE='GENERAL_WZCX_3' then '91'  when w.opt_addr='HENAN' and  w.FEE_APP_CODE='GENERAL_WZCX_3' then '91'  when w.opt_addr='HUNAN' and  w.FEE_APP_CODE='GENERAL_WZCX_5' then '93' when w.opt_addr='JIANGXI' and  w.FEE_APP_CODE='GENERAL_WZCX_3' then '91'  when w.opt_addr='NEIMENGGU' and  w.FEE_APP_CODE='GENERAL_WZCX_3' then '91' when w.opt_addr='SHANDONG' and  w.FEE_APP_CODE='GENERAL_WZCX_3' then '91' when w.opt_addr='SHANGHAI' and  w.FEE_APP_CODE='GENERAL_WZCX_3' then '91' when w.opt_addr='SHENZHEN' and  w.FEE_APP_CODE='2' then '90' when w.opt_addr='SHENZHEN' and  w.FEE_APP_CODE='3' then '91'  when w.opt_addr='YUNNAN' and  w.FEE_APP_CODE='GENERAL_WZCX_3' then '91'  when w.opt_addr='ZHONGSHAN' and  w.FEE_APP_CODE='2' then '90' end id,   case when length(h.no) =3  then concat(substr(h.no,2,3),'0') else substr(h.no,2,4)  end , w.ZUOXI_ID    from WZCX_DB.wzcx_log w , wzcx_content.addr_info_20090430 h  where  substr(w.mobile_sn,1,7)=h.mobile_7  and w.status=0 and w.opt_type=1 and w.opttime>='$DEALDATE_1' and  w.opttime<'$DEALDATE_2'; " |  awk '{print $1","$2","$3","$4","$5}' >  /data/zxdz/weizhang_${DEALDATE}_all_log.txt 
#2014-05-26,13660641444,91,200,49639
#2014-05-26,13601374218,90,100,6691
#2014-05-26,13716587425,90,100,6421
##违章所有相关推荐文件
mysql -h192.100.7.19 -ur_slave_db  -pwzMIWdZ93n45d5NT -D car_weizhang -D wzcx_content  -N -e " select substr(dotime,1,10),w.mobile ,  case when w.opt_addr='ANHUI' and  w.FEE_APP_CODE='GENERAL_WZCX' then '91' when w.opt_addr='BEIJING' and  w.FEE_APP_CODE='A' then '99'  when w.opt_addr='BEIJING' and  w.FEE_APP_CODE='B' then '98'  when w.opt_addr='BEIJING' and  w.FEE_APP_CODE='C' then '90'  when w.opt_addr='BEIJING' and  w.FEE_APP_CODE='D' then '100' when w.opt_addr='BEIJING' and  w.FEE_APP_CODE='E' then '93'  when w.opt_addr='HEBEI' and  w.FEE_APP_CODE='GENERAL_WZCX' then '91'  when w.opt_addr='HENAN' and  w.FEE_APP_CODE='GENERAL_WZCX' then '91'  when w.opt_addr='HUNAN' and  w.FEE_APP_CODE='GENERAL_WZCX' then '93'  when w.opt_addr='JIANGXI' and  w.FEE_APP_CODE='GENERAL_WZCX' then '91'  when w.opt_addr='NEIMENGGU' and  w.FEE_APP_CODE='GENERAL_WZCX' then '91' when w.opt_addr='SHANDONG' and  w.FEE_APP_CODE='GENERAL_WZCX' then '91' when w.opt_addr='SHANGHAI' and  w.FEE_APP_CODE='GENERAL_WZCX' then '91'  when w.opt_addr='YUNNAN' and  w.FEE_APP_CODE='GENERAL_WZCX_3' then '91' end id,   case when length(h.no) =3  then concat(substr(h.no,2,3),'0') else substr(h.no,2,4)  end ccid, w.staffno from car_weizhang.recommend w , wzcx_content.addr_info_20090430  h  where  substr(w.mobile,1,7)=h.mobile_7     and w.dotime>='$DEALDATE_1' and  w.dotime<'$DEALDATE_2'; " |  awk '{print $1","$2","$3","$4","$5}' >   /data/zxdz/weizhang_${DEALDATE}_tuijian_log.txt 
#2014-05-26,13722092104,91,471,05079
#2014-05-26,13947399518,91,471,05218
#2014-05-26,13947905692,91,471,05090

##剔除违章所有相关推荐得到违章所有相关定制、

 awk -F',' -v CODE_DIR=/data/zxdz/weizhang_${DEALDATE}_tuijian_log.txt     -v file_no=/data/zxdz/weizhang_${DEALDATE}_dingzhi_ok.txt       '{
 if( FILENAME == CODE_DIR )  d[$2$3]=$0; 
 else if ( FILENAME != CODE_DIR &&  !($2$3  in d) ) print $1","$3","$4","$5 >> file_no
}'   /data/zxdz/weizhang_${DEALDATE}_tuijian_log.txt   /data/zxdz/weizhang_${DEALDATE}_all_log.txt 

 awk -F',' -v CODE_DIR=/data/zxdz/weizhang_${DEALDATE}_tuijian_log.txt   -v file_phone=/data/zxdz/weizhang_${DEALDATE}_dingzhiphone_ok.txt         '{
 if( FILENAME == CODE_DIR )  d[$2$3]=$0; 
 else if ( FILENAME != CODE_DIR &&  !($2$3  in d) )  print $1","$3","$4","$5","$2 >> file_phone; 
 
}'   /data/zxdz/weizhang_${DEALDATE}_tuijian_log.txt   /data/zxdz/weizhang_${DEALDATE}_all_log.txt 
########################################


##生成坐席定制的分日分省份分坐席工号分业务统计
cat /data/wxlog/new_ci/14[6-7]/${DATEYEAR}/${DEALDATE2}  | grep dingzhiajax.php |  awk -F'[|"]' '{print substr($3,1,10)","$8","$12","$20}'  | sort  | uniq -c | awk '{print $2","$1}'  > /data/zxdz/recommon_dingzhi_${DEALDATE}_count.txt
cat /data/zxdz/hsh_${DEALDATE}_dingzhi_ok.txt | sort  | uniq -c | awk '{print $2","$1}'  >> /data/zxdz/recommon_dingzhi_${DEALDATE}_count.txt
cat /data/zxdz/weizhang_${DEALDATE}_dingzhi_ok.txt | sort  | uniq -c | awk '{print $2","$1}'  >> /data/zxdz/recommon_dingzhi_${DEALDATE}_count.txt

##生成坐席推荐的分日分省份分坐席工号分业务统计

 cat /data/wxlog/recommend/${RECOMMDATE}/recommend_*.txt  /data/wxlog/zhufu_log/zhufu${DEALDATE3}_NR.txt |  grep ${DEALDATE_1} | sort -u | awk  '{ gsub(/\t/,"") ; print }'  | awk -F'|'  '{print substr($9,1,10)","$5","$7","$6}' | sort  | uniq -c |  awk '{print $2","$1}' >   /data/zxdz/recommon_tuijian_${DEALDATE}_count.txt



##生成坐席定制
cat /data/wxlog/new_ci/14[6-7]/${DATEYEAR}/${DEALDATE2}  | grep 'dingzhiajax.php' |  awk -F'[|"]' '{print substr($3,1,10)","$8","$12","$20","$24}'  > /data/zxdz/recommon_dingzhi_${DEALDATE}.txt
cat /data/zxdz/hsh_${DEALDATE}_dingzhiphone_ok.txt >> /data/zxdz/recommon_dingzhi_${DEALDATE}.txt
cat /data/zxdz/weizhang_${DEALDATE}_dingzhiphone_ok.txt >> /data/zxdz/recommon_dingzhi_${DEALDATE}.txt

##生成坐席推荐 
###2013-05-15,315,931,1024,15276912186
##2013-05-15,315,290,9319,13720430263
##2013-05-15,316,290,9319,13720430263
##2013-05-15,582,210,8002,15900503908
##2013-05-15,315,290,9230,13891621986
##2013-05-15,88,210,8815,15000683258

cat /data/wxlog/recommend/${RECOMMDATE}/recommend_*.txt  /data/wxlog/zhufu_log/zhufu${DEALDATE3}_NR.txt |  grep ${DEALDATE_1}  | sort -u | awk  '{ gsub(/\t/,"") ; print }'  | awk -F'|'  '{print substr($9,1,10)","$5","$7","$6","$2}'   >   /data/zxdz/recommon_tuijian_${DEALDATE}.txt
 
##匹配坐席定制订购成功用户号码
##582,短信包月,12580生活播报-健康宝典短信版,10102008,
##325,短信包月,营养助理,10102008,
##341,短信包月,今日关注,10202007,
##168,短信包月,折扣短信包月,10301001,
##108,短信包月,12580生活播报-生活百科短信版,10301009,

 ##匹配坐席定制订购推荐成功用户号码
  
awk  -F ',' -v opt_code=/data/211/PKFILTER_DIC/zx_dictionary.txt    -v file_oka=/data/zxdz/recommon_dingzhi_${DEALDATE}.txt  -v file_ok1=/data/zxdz/recommon_dingzhi_${DEALDATE}_dic.txt  -v file_okb=/data/zxdz/recommon_tuijian_${DEALDATE}.txt  -v file_ok2=/data/zxdz/recommon_tuijian_${DEALDATE}_dic.txt '{

         if(FILENAME == opt_code   )  o[$1]=$4","$3 ;

         else if(FILENAME == file_oka &&  $2 in o   ) print  $5","o[$2]","$1","$2","$3","$4 >> file_ok1;

         else if(FILENAME == file_okb &&  $2 in o   ) print  $5","o[$2]","$1","$2","$3","$4 >> file_ok2;
         
}'   /data/211/PKFILTER_DIC/zx_dictionary.txt   /data/zxdz/recommon_dingzhi_${DEALDATE}.txt  /data/zxdz/recommon_tuijian_${DEALDATE}.txt

#2013-05-12,001,290,9162,30
#2013-05-12,001,290,9162,20
  
awk  -F ',' -v opt_code=/data/211/PKFILTER_DIC/zx_dictionary.txt    -v file_oka=/data/zxdz/recommon_dingzhi_${DEALDATE}_count.txt  -v file_ok1=/data/zxdz/recommon_dingzhi_${DEALDATE}_dic_count.txt  -v file_okb=/data/zxdz/recommon_tuijian_${DEALDATE}_count.txt  -v file_ok2=/data/zxdz/recommon_tuijian_${DEALDATE}_dic_count.txt '{

         if(FILENAME == opt_code   )  o[$1]=$4","$3 ;

         else if(FILENAME == file_oka &&  $2 in o   ) print  $1","o[$2]","$2","$3","$4","$5 >> file_ok1;

         else if(FILENAME == file_okb &&  $2 in o   ) print  $1","o[$2]","$2","$3","$4","$5  >> file_ok2;
         
}'   /data/211/PKFILTER_DIC/zx_dictionary.txt   /data/zxdz/recommon_dingzhi_${DEALDATE}_count.txt  /data/zxdz/recommon_tuijian_${DEALDATE}_count.txt



 bzip2 /data/zxdz/recommon_dingzhi_${DEALDATE}_dic.txt
 
 bzip2 /data/zxdz/recommon_tuijian_${DEALDATE}_dic.txt
 ###2013-05-15","10202007","今日关注","315","931","1024 
 ##15276912186,10202007,今日关注,2013-05-15,315,931,1024,
 bzcat /data/zxdz/recommon_dingzhi_${DEALDATE}_dic.txt.bz2  /data/match/mm7/${DEALDATE}/outputumessage_001_wuxian_${DEALDATE}_snapshot.bz2 | awk -F'[,|]' '{if(NF==7) aa[$1$2]=$4","$2","$3","$5","$6","$7 ; else if ($1$2  in aa)  print aa[$1$2];  }'  >  /data/zxdz/recommon_dingzhi_${DEALDATE}_dic_suc_tmp.txt 
 bzcat /data/zxdz/recommon_dingzhi_${DEALDATE}_dic.txt.bz2  /data/user_sn.txt.bz2 | awk -F'[,|]' '{if(NF==7) aa[$1$2]=$4","$2","$3","$5","$6","$7 ; else  if (   ($1$2  in aa) )  print aa[$1$2];  }'   >>  /data/zxdz/recommon_dingzhi_${DEALDATE}_dic_suc_tmp.txt
 cat /data/zxdz/recommon_dingzhi_${DEALDATE}_dic_suc_tmp.txt | awk   '{a[$0]++ } END {for (j in a)   print j","a[j] }'   >  /data/zxdz/recommon_dingzhi_${DEALDATE}_dic_suc_count.txt

   
 
 bzcat /data/zxdz/recommon_tuijian_${DEALDATE}_dic.txt.bz2  /data/match/mm7/${DEALDATE}/outputumessage_001_wuxian_${DEALDATE}_snapshot.bz2 | awk -F'[,|]' '{if(NF==7) aa[$1$2]=$4","$2","$3","$5","$6","$7 ; else if ($1$2  in aa)  print aa[$1$2];  }'  >  /data/zxdz/recommon_tuijian_${DEALDATE}_dic_suc_tmp.txt 
 bzcat /data/zxdz/recommon_tuijian_${DEALDATE}_dic.txt.bz2  /data/user_sn.txt.bz2 | awk -F'[,|]' '{if(NF==7) aa[$1$2]=$4","$2","$3","$5","$6","$7 ; else  if (   ($1$2  in aa) )  print aa[$1$2];  }'   >>  /data/zxdz/recommon_tuijian_${DEALDATE}_dic_suc_tmp.txt
 
 
 cat /data/zxdz/recommon_tuijian_${DEALDATE}_dic_suc_tmp.txt |awk   '{a[$0]++ } END {for (j in a)   print j","a[j] }'   >  /data/zxdz/recommon_tuijian_${DEALDATE}_dic_suc_count.txt

### 将推荐量肯推荐订购量两个文件整理分组统计
 awk -F',' -v allfile=/data/zxdz/recommon_dingzhi_${DEALDATE}_dic_count.txt -v sucfile=/data/zxdz/recommon_dingzhi_${DEALDATE}_dic_suc_count.txt '{if(FILENAME==allfile) print $1","$2","$3","$4","$5","$6","$7",0";else if(FILENAME==sucfile) print $1","$2","$3","$4","$5","$6",0,"$7;}' /data/zxdz/recommon_dingzhi_${DEALDATE}_dic_count.txt /data/zxdz/recommon_dingzhi_${DEALDATE}_dic_suc_count.txt | awk -F',' '{ aa[$1","$2","$3","$4","$5","$6] +=$7; bb[$1","$2","$3","$4","$5","$6] +=$8}END{for (i in aa){ print i","aa[i]","bb[i]} }' > /data/zxdz/recommon_dingzhi_${DEALDATE}_dic_allcount.txt
 
 awk -F',' -v allfile=/data/zxdz/recommon_tuijian_${DEALDATE}_dic_count.txt -v sucfile=/data/zxdz/recommon_tuijian_${DEALDATE}_dic_suc_count.txt '{if(FILENAME==allfile) print $1","$2","$3","$4","$5","$6","$7",0";else if(FILENAME==sucfile) print $1","$2","$3","$4","$5","$6",0,"$7;}' /data/zxdz/recommon_tuijian_${DEALDATE}_dic_count.txt /data/zxdz/recommon_tuijian_${DEALDATE}_dic_suc_count.txt | awk -F',' '{ aa[$1","$2","$3","$4","$5","$6] +=$7; bb[$1","$2","$3","$4","$5","$6] +=$8}END{for (i in aa){ print i","aa[i]","bb[i]} }' > /data/zxdz/recommon_tuijian_${DEALDATE}_dic_allcount.txt
 
 
 #时间 省份名称 坐席工号 业务名称 推荐次数 推荐成功定制次数 业务定制次数 业务定制成功次数 
#$1 $5 $6 $3 $7 $8 
#2013-05-15,10301018,双色球开奖信息,315,851,2219,5,3
#2013-05-15,10301009,12580生活播报-生活百科短信版,108,731,3770,1,1
#2013-05-15,10301022,排列三排列五开奖信息,319,571,KF080405123,1,1

 awk -F',' -v tuijianfile=/data/zxdz/recommon_tuijian_${DEALDATE}_dic_allcount.txt  -v dingzhifile=/data/zxdz/recommon_dingzhi_${DEALDATE}_dic_allcount.txt  '{if(FILENAME==tuijianfile) print $1","$5","$6","$3","$7","$8",0,0";else if(FILENAME==dingzhifile) print $1","$5","$6","$3",0,0,"$7","$8;}' /data/zxdz/recommon_tuijian_${DEALDATE}_dic_allcount.txt /data/zxdz/recommon_dingzhi_${DEALDATE}_dic_allcount.txt | awk -F',' '{ a[$1","$2","$3","$4] +=$5; b[$1","$2","$3","$4] +=$6;c[$1","$2","$3","$4] +=$7; d[$1","$2","$3","$4] +=$8;}END{for (i in a){ print i","a[i]","b[i]","c[i]","d[i]} }' > /data/zxdz/recommon_tuijiandingzhi_${DEALDATE}_dic_allcount.txt
 
 ##匹配省份名称
 cat /data/zxdz/recommon_tuijiandingzhi_${DEALDATE}_dic_allcount.txt | awk '{if(NR==1)print "时间,省份名称,坐席工号,业务名称,推荐次数,推荐成功定制次数,业务定制次数,业务定制成功次数,省编码,推荐定制成功总和" }' > /data/zxdz/recommon_tuijiandingzhi_${DEALDATE}_dic_allcount_ok.txt 
   
awk  -F ',' -v opt_code=/data/211/PKFILTER_DIC/province_nodist.tsv    -v file_oka=/data/zxdz/recommon_tuijiandingzhi_${DEALDATE}_dic_allcount.txt   -v file_ok1=/data/zxdz/recommon_tuijiandingzhi_${DEALDATE}_dic_allcount_ok.txt   '{

         if(FILENAME == opt_code   )  o[$2]=$1 ;

         else if(FILENAME == file_oka &&  $2 in o   ) print  $1","o[$2]","$3","$4","$5","$6","$7","$8","$2","$6+$8 >> file_ok1;
    
}'   /data/211/PKFILTER_DIC/province_nodist.tsv    /data/zxdz/recommon_tuijiandingzhi_${DEALDATE}_dic_allcount.txt 

iconv -f GB2312 -t UTF-8   /data/zxdz/recommon_tuijiandingzhi_${DEALDATE}_dic_allcount_ok.txt > /data/zxdz/report.region.wireless_tjdz_${DEALDATE}.csv

scp -p /data/zxdz/report.region.wireless_tjdz_${DEALDATE}.csv  oracle@192.100.7.27:/home/oracle/etl/data/KPI_DATA/${DATEYEAR}/${DEALDATE}/report.region.wireless_recommci_province.csv
#scp -p /data/zxdz/report.region.wireless_tjdz_${DEALDATE}.csv  oracle@172.16.100.158:/home/oracle/etl/data/KPI_DATA/${DATEYEAR}/${DEALDATE}/report.region.wireless_recommci_province.csv
 

#rm /data/zxdz/*${DEALDATE}*.txt
#rm /data/zxdz/*${DEALDATE}*.bz2



