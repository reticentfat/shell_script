##进入目标目录
cd /data/match/quanliang/

##合并原过滤库 与 上月差异数据未处理部分：
bzip2 -dk filter.txt.bz2
cat filter.txt filter_qx_pay_6y.txt | sort -u > filter_pay_6y_all.txt


##取前向大订购库9月1日后订购且在线用户
bzcat /data/match/quanliang/snapshot.txt.bz2 | awk -F'|' '{if($3=="06" && $4>="20150601000000") print $1"^"$2}' > /data/match/quanliang/main_online_20150601.txt


##剔除在线用户
cat main_online_20150601.txt qx_other_online_20150601.txt > all_online_20150601.txt
sh rm_black_num.sh all_online_20150601.txt filter_pay_6y_all.txt


##剔除小库退订用户
bzip2 -dk jswzkw_cancel_20150715.txt.bz2
sh rm_black_num.sh jswzkw_cancel_20150715.txt filter_pay_6y_all_clear.txt


##拆分出小库业务
cat filter_pay_6y_all_clear_clear.txt | awk -F'^' -v other=filter_pay_6y_all_clear_clear_jswzkw.txt -v main=filter_pay_6y_all_clear_clear_main.txt '{if( $2 == "10301028" || $2 == "10301091" || $2 == "10301036" || $2 == "10301037" || $2 == "10301038" || $2 == "10301039" || $2 == "10301040" || $2 == "10301041" || $2 == "10301042" || $2 == "10301043" || $2 == "10301044" || $2 == "10301030" || $2 == "10324009" || $2 == "10324010" || $2 == "10301031" || $2 == "10301063" || $2 == "10301052" || $2 == "10301051" || $2 == "10301080" ) print >> other; else print >> main;}'


##转换大订购库过滤文件内容格式
cat filter_pay_6y_all_clear_clear_main.txt | awk -F'^' '{print $1"|"$2"|"}' | bzip2 > filter_pay_6y_clear.txt.bz2


##转换免费批次文件内容格式
cat filter_free.txt | awk -F'^' '{print $1"|"$2"|"}' | bzip2 > filter_free_style.txt.bz2


##取在线用户
bzcat /data/match/quanliang/filter_pay_6y_clear.txt.bz2 /home/oracle/etl/data/data/snapshot/snapshot.txt.bz2 | awk -F'|' '{if(NF==3) d[$1$2]=$1"^"$2; else if($3=="06" && ($1$2 in d)) print d[$1$2];}' > /data/match/quanliang/filter_pay_6y_clear_online.txt
bzcat /data/match/quanliang/filter_free_style.txt.bz2 /home/oracle/etl/data/data/snapshot/snapshot.txt.bz2 | awk -F'|' '{if(NF==3) d[$1$2]=$1"^"$2; else if($3=="06" && ($1$2 in d)) print d[$1$2];}' > /data/match/quanliang/filter_free_ok.txt
bzcat /data/match/quanliang/filter_free_style.txt.bz2 /data/match/orig/20150713/user_sn.txt.bz2 | awk -F'|' '{if(NF==3) d[$1$2]=$1"^"$2; else if($3=="06" && ($1$2 in d)) print d[$1$2];}' >> /data/match/quanliang/filter_free_ok.txt


##取订制中用户，合并小库业务
cat filter_pay_6y_clear_online.txt filter_pay_6y_all_clear_clear_jswzkw.txt > filter_pay_6y_all_online.txt


##剔除上月全量提取时合并的免费批次用户
sh rm_black_num.sh filter_free_ok_6y.txt filter_pay_6y_all_online.txt


##合并过滤收费和免费用户
cat /data/match/quanliang/filter_free_ok.txt /data/match/quanliang/filter_pay_6y_all_online_clear.txt | awk -F'^' '{print $1"|"$2"|"}' | sort -u > /data/match/quanliang/filter_final.txt


##压缩文件
bzip2 /data/match/quanliang/main_online_20150601.txt
bzip2 /data/match/quanliang/all_online_20150601.txt
bzip2 /data/match/quanliang/filter_pay_6y_all_clear_clear_jswzkw.txt
bzip2 /data/match/quanliang/filter_pay_6y_all_clear_clear_main.txt
bzip2 /data/match/quanliang/filter_pay_6y_clear_online.txt

 

###生成全量结果 (158服务器)

cp /data/match/quanliang/20150715_qxusers_style.txt /data/match/quanliang/20150715_all_users.txt
bzcat /data/match/quanliang/20150715_kwzx_user_merge_style.txt.bz2 /data/match/quanliang/20150715_wzcx_style.txt.bz2  >> /data/match/quanliang/20150715_all_users.txt

awk -F'|' -v CODE_DIR=/data/match/quanliang/filter_final.txt -v fileok=/data/match/quanliang/20150715_all_orderusers.txt -v fileno=/data/match/quanliang/20150715_all_orderusers_filter.txt '{
if( FILENAME == CODE_DIR )  d[$1$2]=$1","$2;
else if ( FILENAME != CODE_DIR && $2$1 in d ){ print $2"|"$3"|"$4"|"$5"|"$6"|"$7"|"$8"|"$9 >> fileno ; }
else if ( FILENAME != CODE_DIR && !( $2$1 in d ) ){ print $2"|"$3"|"$4"|"$5"|"$6"|"$7"|"$8"|"$9 >> fileok ; }
}' /data/match/quanliang/filter_final.txt /data/match/quanliang/20150715_all_users.txt


##校验提取的APPCODE是否全
cat /data/match/quanliang/20150715_all_orderusers.txt | awk -F'|' '{print $6;}' | sort | uniq -c  > /data/match/quanliang/20150715_all_orderusers_check.txt


bzip2 /data/match/quanliang/filter_pay_6y_all_online_clear.txt
bzip2 /data/match/quanliang/filter_final.txt


bzip2 /data/match/quanliang/20150715_*.txt
