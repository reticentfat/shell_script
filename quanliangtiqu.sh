#!/bin/sh
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/home/gateway/;
export PATH
DEALDATE=`date -d "-1 day" +%Y%m%d` 
DEALDATE_1=`date -d "-2 day" +%Y%m%d`
DEALDATE_2=`date +%Y%m%d`
DEALDATE_3=`date -d "-1 month" +%Y%m01000000`
DEALDATE_4=`date -d "-1 month" +%Y%m01`
DEALDATE_5=`date -d "-1 month" +%m`
echo $DEALDATE
echo $DEALDATE_1
echo $DEALDATE_2
echo $DEALDATE_3
echo $DEALDATE_4
echo $DEALDATE_5
##进入目标目录
cd /data/match/quanliang/
##生成大库全量
##//从快照中取出相关列	订购中的用户
bzcat /data/match/orig/${DEALDATE_1}/snapshot.txt.bz2 | awk -F'|' '{if($3=="06") print $1","$2","$3","$5","$7","$20}' > /data/match/quanliang/${DEALDATE_2}_qxusers.txt

##//生成最终的格式:
##13603644745|00|20101108111912|02|801174|125899|0|20101108111912

awk -F',' -v OPTCODE_DIR=/home/oracle/etl/data/jfcode_all.txt '{
if(FILENAME == OPTCODE_DIR) optcode[$1] = $2","$3;
else{if($2 in optcode){print $1","$2","$3","$4","$5","$6","optcode[$2]",";}}
}' /home/oracle/etl/data/jfcode_all.txt /data/match/quanliang/${DEALDATE_2}_qxusers.txt | bzip2 > /data/match/quanliang/${DEALDATE_2}_qxusers_appcode.txt.bz2


bzcat /data/match/quanliang/${DEALDATE_2}_qxusers_appcode.txt.bz2 | awk -F',' '{ if($2~/^1/ && $5==0 && $6==1) state="01"; else if($2~/^2/ && $5==0 && $6~/boss/) state="01"; else state="00";
if(substr($7,1,1)=="-") bizcode="901808"; else bizcode="801174";
if($8=="0") fee="00"; else fee="02";
print $2"|"$1"|"state"|"$4"|"fee"|"bizcode"|"$7"|0|"$4;}' > /data/match/quanliang/${DEALDATE_2}_qxusers_style.txt

##生成小库全量
bzcat /data/match/orig/${DEALDATE_1}/user_sn.txt.bz2 |awk -F'|' -v begin=${DEALDATE_2}000000 '$1~/^1/&&$4!="00000000000000"&&$3=="06"&&$4<begin&&$2~/^1/{print $2"|"$1"|00|"$4"|02|901808|0|"$4}' >wzkw_style.txt
#bzcat /data/match/orig/20160123/user_sn.txt.bz2 |awk -F'|' '$1~/^1/&&$4!="00000000000000"&&$3=="06"&&$2~/^1/&&$4<20160125000000{print $2"|"$1"|00|"$4"|02|901808|0|"$4}' >wzkw_style.txt
awk -F'[,|]' -v CODE_DIR=/data/homeoracle/etl/data/opt_code_all.txt     '{
     if( FILENAME == CODE_DIR  )  d[$1]=$2 ;
         else if ( FILENAME != CODE_DIR && ($1 in d) ) print   $1"|"$2"|"$3"|"$4"|"$5"|"$6"|"d[$1]"|"$7"|"$8 ;      
        }'     /data/homeoracle/etl/data/opt_code_all.txt  wzkw_style.txt > wzkw_style1.txt
##取小库12月1日后订购且在线用户
bzcat /data/match/orig/${DEALDATE_1}/user_sn.txt.bz2 |awk -F'|' -v begin=${DEALDATE_3} '$1~/^1/&&$4!="00000000000000"&&$3=="06"&&$2~/^1/&&$4>=begin{print $2"|"$1}' >qx_other_online_${DEALDATE_4}.txt
#    bzcat /data/match/orig/20160123/user_sn.txt.bz2 |awk -F'|' '$1~/^1/&&$4!="00000000000000"&&$3=="06"&&$2~/^1/&&$4>=20151201000000{print $2"|"$1}' >qx_other_online_20151201.txt  
#技术部提供的日增量差异过滤数据
wget -N http://192.100.6.31:9999/data/filter/filter.txt.bz2 
#小库近一个月退订用户
scp gateway@192.100.7.25:/data/wxlog/jswzkw_cancel_${DEALDATE_2}.txt.bz2 /data/match/quanliang/
##合并原过滤库 与 上月差异数据未处理部分：
bzip2 -dk filter.txt.bz2
cat filter.txt filter_qx_pay_${DEALDATE_5}y.txt | sort -u > filter_pay_${DEALDATE_5}y_all.txt
##取前向大订购库9月1日后订购且在线用户
bzcat /data/match/orig/${DEALDATE_1}/snapshot.txt.bz2 | awk -F'|' -v begin=${DEALDATE_3} '{if($3=="06" && $4>=begin) print $1"^"$2}' > /data/match/quanliang/main_online_${DEALDATE_4}.txt

##剔除在线用户
cat main_online_${DEALDATE_4}.txt qx_other_online_${DEALDATE_4}.txt > all_online_${DEALDATE_4}.txt
sh rm_black_num.sh all_online_${DEALDATE_4}.txt filter_pay_${DEALDATE_5}y_all.txt

##剔除小库退订用户
bzip2 -dk jswzkw_cancel_${DEALDATE_2}.txt.bz2
sh rm_black_num.sh jswzkw_cancel_${DEALDATE_2}.txt filter_pay_${DEALDATE_5}y_all_clear.txt

##拆分出小库业务
cat filter_pay_${DEALDATE_5}y_all_clear_clear.txt | awk -F'^' -v other=filter_pay_${DEALDATE_5}y_all_clear_clear_jswzkw.txt -v main=filter_pay_${DEALDATE_5}y_all_clear_clear_main.txt '{if( $2 == "10301028" || $2 == "10301091" || $2 == "10301036" || $2 == "10301037" || $2 == "10301038" || $2 == "10301039" || $2 == "10301040" || $2 == "10301041" || $2 == "10301042" || $2 == "10301043" || $2 == "10301044" || $2 == "10301030" || $2 == "10324009" || $2 == "10324010" || $2 == "10301031" || $2 == "10301063" || $2 == "10301052" || $2 == "10301051" || $2 == "10301080" ) print >> other; else print >> main;}'

##转换大订购库过滤文件内容格式
cat filter_pay_${DEALDATE_5}y_all_clear_clear_main.txt | awk -F'^' '{print $1"|"$2"|"}' | bzip2 > filter_pay_${DEALDATE_5}y_clear.txt.bz2

##转换免费批次文件内容格式
cat filter_free.txt | awk -F'^' '{print $1"|"$2"|"}' | bzip2 > filter_free_style.txt.bz2


##取在线用户
bzcat /data/match/quanliang/filter_pay_${DEALDATE_5}y_clear.txt.bz2 /home/oracle/etl/data/data/snapshot/snapshot.txt.bz2 | awk -F'|' '{if(NF==3) d[$1$2]=$1"^"$2; else if($3=="06" && ($1$2 in d)) print d[$1$2];}' > /data/match/quanliang/filter_pay_${DEALDATE_5}y_clear_online.txt
bzcat /data/match/quanliang/filter_free_style.txt.bz2 /data/match/orig/${DEALDATE_1}/snapshot.txt.bz2 | awk -F'|' '{if(NF==3) d[$1$2]=$1"^"$2; else if($3=="06" && ($1$2 in d)) print d[$1$2];}' > /data/match/quanliang/filter_free_ok.txt
bzcat /data/match/quanliang/filter_free_style.txt.bz2 /data/match/orig/${DEALDATE_1}/user_sn.txt.bz2 | awk -F'|' '{if(NF==3) d[$1$2]=$1"^"$2; else if($3=="06" && ($1$2 in d)) print d[$1$2];}' >> /data/match/quanliang/filter_free_ok.txt

##取订制中用户，合并小库业务
cat filter_pay_${DEALDATE_5}y_clear_online.txt filter_pay_${DEALDATE_5}y_all_clear_clear_jswzkw.txt > filter_pay_${DEALDATE_5}y_all_online.txt


##剔除上月全量提取时合并的免费批次用户
sh rm_black_num.sh filter_free_ok_${DEALDATE_5}y.txt filter_pay_${DEALDATE_5}y_all_online.txt


##合并过滤收费和免费用户
cat /data/match/quanliang/filter_free_ok.txt /data/match/quanliang/filter_pay_${DEALDATE_5}y_all_online_clear.txt | awk -F'^' '{print $1"|"$2"|"}' | sort -u > /data/match/quanliang/filter_final.txt


##压缩文件
bzip2 /data/match/quanliang/main_online_${DEALDATE_4}.txt
bzip2 /data/match/quanliang/all_online_${DEALDATE_4}.txt
bzip2 /data/match/quanliang/filter_pay_${DEALDATE_5}y_all_clear_clear_jswzkw.txt
bzip2 /data/match/quanliang/filter_pay_${DEALDATE_5}y_all_clear_clear_main.txt
bzip2 /data/match/quanliang/filter_pay_${DEALDATE_5}y_clear_online.txt
bzip2 /data/match/quanliang/wzkw_style1.txt

###生成全量结果 

cp /data/match/quanliang/${DEALDATE_2}_qxusers_style.txt /data/match/quanliang/${DEALDATE_2}_all_users.txt
bzcat /data/match/quanliang/wzkw_style1.txt.bz2  >> /data/match/quanliang/${DEALDATE_2}_all_users.txt

awk -F'|' -v CODE_DIR=/data/match/quanliang/filter_final.txt -v fileok=/data/match/quanliang/${DEALDATE_2}_all_orderusers.txt -v fileno=/data/match/quanliang/${DEALDATE_2}_all_orderusers_filter.txt '{
if( FILENAME == CODE_DIR )  d[$1$2]=$1","$2;
else if ( FILENAME != CODE_DIR && $2$1 in d ){ print $2"|"$3"|"$4"|"$5"|"$6"|"$7"|"$8"|"$9 >> fileno ; }
else if ( FILENAME != CODE_DIR && !( $2$1 in d ) ){ print $2"|"$3"|"$4"|"$5"|"$6"|"$7"|"$8"|"$9 >> fileok ; }
}' /data/match/quanliang/filter_final.txt /data/match/quanliang/${DEALDATE_2}_all_users.txt

##校验提取的APPCODE是否全
cat /data/match/quanliang/${DEALDATE_2}_all_orderusers.txt | awk -F'|' '{print $6;}' | sort | uniq -c | sort -rn | awk '{print $2" "$1}' > /data/match/quanliang/${DEALDATE_2}_all_orderusers_check.txt
##删除临时文件
rm -f `ls *.*|egrep -v "(*.sh|filter_free_ok_y.txt|filter_free.txt|filter_qx_pay_y.txt|${DEALDATE_2}_all_orderusers.txt|${DEALDATE_2}_all_orderusers_check.txt)"`
bzip2 ${DEALDATE_2}_all_orderusers.txt
