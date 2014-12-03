#/bin/sh
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/home/wuying/;
export PATH
#####sh -x qx_month.sh 20121101 201210 20121031 20121001
#####sh -x qx_month.sh 下个月第一天  生成月报月份 生成月报月份末日 生成月报月份头日
if [ $# -eq 4 ];then
   INDATE=$1
   INDATE_1=$2
   INDATE_2=$3
   INDATE_3=$4
fi

if [ ${INDATE:=999} = 999 ];then

DEALDATE=`date -v-1d  +%Y%m%d`
DEALDATE_M=`date -v-1d  +%Y%m`

DEALDATE_D=`date -v-0d  +%d`
DEALDATE3=`date -v-4d  +%Y%m%d`
DEALDATE_1=`date -v-1d  +%Y-%m-%d`
DEALDATE3_1=`date -v-4d  +%Y-%m-%d`

else
 
DEALDATE=$INDATE
DEALDATE_M=$INDATE_1
DEALDATE_D=$INDATE_2
DEALDATE3_1=$INDATE_1
###DEALDATE_NM=$INDATE_3

fi

##需求描述一：每月6日前提取江西交通小秘书截止月初0时的在线数据
##字段：手机号码、地市、车牌、坐席工号（有工号就填，无就空）、订购时间
##纬度：江西二级地市
##统计时间周期：月初0时
##数据提供时间：5月数据8日提供，后续每月6日
sed 's/\\N/ /g' /data/wxlog/wxsub/${DEALDATE}/BJWZNEW*_first.txt | iconv -f utf-8 -t gb2312 -c > /data/wuying/qqyxq/BJWZNEW_ok.txt
cat /data/wuying/qqyxq/BJWZNEW_ok.txt | awk -F'^' '{if(length($0)>1 && NF>1 && $(NF-2) == "JIANGXI" && $8 == 3) print $2"|"$11"|"$(NF-4)"|"$7"|"$9"|"$1; }' > /data/wuying/qqyxq/jiangxi_wz_online_${DEALDATE_M}_src.txt



awk -F'|' -v NODIST_DIR=/home/chensm/nodist.tsv 'BEGIN{print "手机号码,地市,车牌,坐席工号,订购时间,退定时间,codeid";}{
if(FILENAME == NODIST_DIR) nodist[$4] = $2;
else if(FILENAME != NODIST_DIR && substr($1, 1, 7) in nodist) {pre = substr($1, 1, 7); print $1","nodist[pre]","$2","$3","$4","$5","$6};
}' /home/chensm/nodist.tsv /data/wuying/qqyxq/jiangxi_wz_online_${DEALDATE_M}_src.txt | awk 'sub("$", "\r")' > /data/wuying/qqyxq/jiangxi_wz_online_${DEALDATE_M}.csv
   
##需求描述二：每月6日前提取健康管家截止月初0时的在线数据
#字段：用户号码、业务名称、地市、坐席工号（有工号就填，无就空）、订购时间
#纬度：江西二级地市
#统计时间周期：月初0时
#数据提供时间：5月数据8日提供，后续每月6日
                                        
bzcat /data/match/mm7/${DEALDATE_D}/outputumessage_001_wuxian_*_snapshot.bz2 | awk -F'|' '{
if($8 == "0791" && $3 == "06" && ($2 == "10301051" || $2 == "10301052")) {
subtime=substr($4,1,4)"-"substr($4,5,2)"-"substr($4,7,2)" "substr($4,9,2)":"substr($4,11,2)":"substr($4,13,2);
if($2 == "10301051") optcost = "健康顾问"; else if($2 == "10301052") optcost = "健康助理";
print $1"|"optcost"|"subtime;}}' > /data/wuying/qqyxq/jiangxi_jkgj_online_${DEALDATE_D}_src.txt

awk -F'|' -v NODIST_DIR=/home/chensm/nodist.tsv 'BEGIN{print "用户号码,业务名称,地市,订购时间";}{
if(FILENAME == NODIST_DIR) nodist[$4] = $2;
else if(FILENAME != NODIST_DIR && substr($1, 1, 7) in nodist) {pre = substr($1, 1, 7); print $1","$2","nodist[pre]","$3};
}' /home/chensm/nodist.tsv /data/wuying/qqyxq/jiangxi_jkgj_online_${DEALDATE_D}_src.txt | awk 'sub("$", "\r")' > /data/wuying/qqyxq/jiangxi_jkgj_online_${DEALDATE_M}.csv


###-黑龙江全省上月新增用户明细
bzcat /data/match/mm7/${DEALDATE_D}/*snapshot.bz2 | awk -F '|' -v start_date=${DEALDATE3_1}01000000    -v end_date=${DEALDATE}000000  '{ if ( $8=="0451" && $3 == "06" && $4 >= start_date && $4 < end_date  ) print $1","$2","$3","$4",99991230000000,"$7","$11 ; else if ( $8=="0451" && $3 == "07" &&  $5 >= start_date && $5 < end_date ) print $1","$2","$3","$5","$4","$7","$11 }'  > /data/wuying/qqyxq/hlj_xzyh.txt
##13503631199	哈尔滨	2012-9-25 10:26	9999-12-30 00:00	国学堂彩信	5	125823
##13503600700,22200040,06,20110712194213,99991230000000,0,QUNFA
 
 awk -F'[,|]' -v CODE_DIR=/data/wuying/PKFILTER_DIC/nodist.tsv  -v OPT_CODE=/data/wuying/opt_code_all.txt -v ok_nodist=/data/wuying/qqyxq/hlj_xzyh_style_${DEALDATE_M}.csv '{ 
        if(FILENAME == CODE_DIR  )  d[$4]=$1","$2  ;
        else if (FILENAME == OPT_CODE )  o[$1]=$5","$3","$2 ;
        else if ( FILENAME != CODE_DIR &&  FILENAME != OPT_CODE && $2 in o && substr($1,1,7) in d ) print d[substr($1,1,7)]","o[$2]","substr($4,1,4)"-"substr($4,5,2)"-"substr($4,7,2)" "substr($4,9,2)":"substr($4,11,2)":"substr($4,13,2)","substr($5,1,4)"-"substr($5,5,2)"-"substr($5,7,2)" "substr($5,9,2)":"substr($5,11,2)":"substr($5,13,2) >> ok_nodist  ;
       }' /data/wuying/PKFILTER_DIC/nodist.tsv /data/wuying/opt_code_all.txt  /data/wuying/qqyxq/hlj_xzyh.txt  

####--四川全省上月新增用户明细
 
bzcat /data/match/mm7/${DEALDATE_D}/*snapshot.bz2 | awk -F '|'  -v start_date=${DEALDATE3_1}01000000    -v end_date=${DEALDATE}000000  '{ if ( $8=="028" && $3 == "06" && $4 >= start_date && $4 < end_date  ) print $1","$2","$3","$4",99991230000000,"$7","$11 ; else if ( $8=="028" && $3 == "07" &&  $5 >= start_date && $5 < end_date ) print $1","$2","$3","$5","$4","$7","$11 }'  > /data/wuying/qqyxq/sichuan_xzyh.txt

##13402300006,22200030,06,20111109152624,99991230000000,0,BOSS
##13402300044,22200030,06,20101122111854,99991230000000,1,BOSS
##13402300441	自贡	2012-9-7 10:41	9999-12-30 00:00	12580生活播报优旅行（免费）	125859

 awk -F'[,|]' -v CODE_DIR=/data/wuying/PKFILTER_DIC/nodist.tsv  -v OPT_CODE=/data/wuying/opt_code_all.txt -v ok_nodist=/data/wuying/qqyxq/sichuan_xzyh_style_${DEALDATE_M}.txt '{ 
        if(FILENAME == CODE_DIR  )  d[$4]=$1","$2  ;
        else if (FILENAME == OPT_CODE )  o[$1]=$5","$2 ;
        else if ( FILENAME != CODE_DIR &&  FILENAME != OPT_CODE && $2 in o && substr($1,1,7) in d ) print d[substr($1,1,7)]","o[$2]","substr($4,1,4)"-"substr($4,5,2)"-"substr($4,7,2)" "substr($4,9,2)":"substr($4,11,2)":"substr($4,13,2)","substr($5,1,4)"-"substr($5,5,2)"-"substr($5,7,2)" "substr($5,9,2)":"substr($5,11,2)":"substr($5,13,2) >> ok_nodist  ;
       }' /data/wuying/PKFILTER_DIC/nodist.tsv /data/wuying/opt_code_all.txt  /data/wuying/qqyxq/sichuan_xzyh.txt 


awk -F',' -v NODIST_DIR=/data0/match/orig/profile/nodist.tsv -v OPTCODE_DIR=/home/oracle/etl/data/opt_code_all.txt '{
if(FILENAME == NODIST_DIR){split($0,tmp,"|");if(tmp[5]=="280"){p=tmp[1];c=tmp[2];m=tmp[4];nodist[m]=p","c;}}
else if(FILENAME == OPTCODE_DIR) optcode[$1] = $5","$3","$2;
else{nod=substr($1,1,7);if($2 in optcode && nod in nodist){split(nodist[nod],t1,",");province=t1[1];city=t1[2];
split(optcode[$2],t2,",");optcost=t2[1];fee=t2[2];jfcode=t2[3];
subtime=substr($4,1,4)"-"substr($4,5,2)"-"substr($4,7,2)" "substr($4,9,2)":"substr($4,11,2)":"substr($4,13,2);
unsubtime=substr($5,1,4)"-"substr($5,5,2)"-"substr($5,7,2)" "substr($5,9,2)":"substr($5,11,2)":"substr($5,13,2);
print $1","city","subtime","unsubtime","optcost","jfcode;}}
}'  /data/wuying/PKFILTER_DIC/nodist.tsv   /data/wuying/opt_code_all.txt   /data/wuying/qqyxq/sichuan_xzyh.txt | bzip2 > /data/wuying/qqyxq/sichuan_xzyh_style_${DEALDATE_M}.txt.bz2

##-四川上行SCYC到10658880890所有上行内容
##--字段：号码、二级地市、上行内容
##--维度：四川二级地市
 ###/data/match/cmpp/2012102[3-9]/monster-cmppmo.log.201210*.bz2    /data/match/cmpp/2012102[3-9]/monster-cmppmo.log.fengtai.log.201210*.bz2 
bzcat /data/match/cmpp/${DEALDATE_M}*/monster-cmppmo.log.*.bz2 /data/match/cmpp/${DEALDATE_M}*/monster-cmppmo.log.fengtai.log.*.bz2 | grep ',10658880890,'  |  awk -F':' '{print $4}' | awk -F',' '{if( substr(toupper($28),1,4)=="SCYC" )print substr($1,2,14)"^"$6"^"$10"^"$14"^"$26"^"$27"^"$28}' > /data/wuying/qqyxq/sichuan_up_${DEALDATE_M}_10658880890.txt
###20120901000040^09010000370200137547^13929981774^10658880890^0^2^WE

###20120901060119	13568182762	达州	SCYC+123456789+13568182762

awk -F'[|^]' -v CODE_DIR=/data/wuying/PKFILTER_DIC/nodist.tsv  -v ok_nodist=/data/wuying/qqyxq/sichuan_up_${DEALDATE_M}_10658880890_ok.txt '{ 
      if ( FILENAME == CODE_DIR  )  d[$4]=$1"\t"$2  ;
       else if ( FILENAME != CODE_DIR &&  substr($3,1,7) in d ) print d[substr($3,1,7)]"\t"$1"\t"$3"\t"$7 >> ok_nodist  ;
      }' /data/wuying/PKFILTER_DIC/nodist.tsv  /dvata/wuying/qqyxq/sichuan_up_${DEALDATE_M}_10658880890.txt

###提取优惠券短信增刊9月1日至9月30日用户发R1、R2、R3（均模糊）到 1065888080 的下行清单
##字段：	手机号码、下行时间、号码归属地、下行内容
###维度：	浙江二级地市
 bzcat /data/match/cmpp/${DEALDATE_M}*/monster-cmppmo.log.*.bz2 | grep ',1065888080,' |  awk -F':' '{print $4}' | iconv -f utf-8 -t gb2312 |awk -F',' '{if(substr(toupper($28),1,2)=="R1" ||substr(toupper($28),1,2)=="R2" ||substr(toupper($28),1,2)=="R3" )print substr($1,2,14)"^"$6"^"$10"^"$14"^"$26"^"$27"^"$28}' >  /data/wuying/qqyxq/up_${DEALDATE_M}_1065888080.txt
 
 ##20121001000946^10010009459510112333^18795282913^1065888080^0^2^KT

 awk -F'[|^]' -v CODE_DIR=/data/wuying/PKFILTER_DIC/nodist.tsv  -v ok_nodist=/data/wuying/qqyxq/zhejiang_up_${DEALDATE_M}_1065888080.txt '{ 
      if ( FILENAME == CODE_DIR  && $5=="571" )  d[$4]=$1"\t"$2  ;
       else if ( FILENAME != CODE_DIR &&  substr($3,1,7) in d ) print d[substr($3,1,7)]"\t"$1"\t"$3"\t"$7 >> ok_nodist  ;
      }' /data/wuying/PKFILTER_DIC/nodist.tsv  /data/wuying/qqyxq/up_${DEALDATE_M}_1065888080.txt
