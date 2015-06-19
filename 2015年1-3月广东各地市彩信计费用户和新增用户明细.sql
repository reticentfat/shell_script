select n.mobile_sn 新增号码,
      m.province 省份,
       m.city 所属地市,
       to_char(n.mobile_sub_time, 'yyyy-mm-dd hh24:mi:ss') 新增时间,
       to_char(n.mobile_modify_time, 'yyyy-mm-dd hh24:mi:ss') 退订时间
  from new_wireless_subscription n, opt_code o, mobilenodist m
 where n.appcode = o.appcode
   and substr(n.mobile_sn, 1, 7) = m.beginno
   and n.mobile_sub_time >= to_date('2015-01-01', 'yyyy-mm-dd')
   and n.mobile_sub_time < to_date('2015-04-01', 'yyyy-mm-dd')
   and n.appcode = '10511051'
   and m.province = '广东'
   and n.mobile_sub_state='3'
   -------------首先查询在线和近两个月退订的，下边查询4月1日到4月4日退订的---------------
54 17 18  06 *  bzcat /home/oracle/etl/data/data/snapshot/archives.txt.bz2 | awk -F'[|^]' '{if(($6=="10511051")&&$(NF-11)>="20150101000000"&&$(NF-11)<="20150401000000"&&$3=="020") print   $2","$3","$4","$6","$5","$7","$8","$(NF-2)","$(NF-3)","$(NF-4) }' | bzip2 > /home/oracle/flbk_1011y_xinzeng_cancle.txt.bz2

cat flbk_1011y_xinzeng_cancle.txt | awk -F',' '{print $1"\t"$6"\t"$7;}'  > 1.txt
awk -F'[,\t]' -v CODE_DIR=nodist_yaoyi.txt '{ if(FILENAME==CODE_DIR) d[$4]=$1"\t"$2; else if( substr($1,1,7) in d)  print $1"\t"d[substr($1,1,7)]"\t"$2"\t"$3}'   nodist_yaoyi.txt 1.txt > 2.txt
cat zaixian.txt 2.txt >2015年1-3月广东各地市彩信新增用户明细.txt
-----------------上边取在线的。下边取已经退订的--------------
   158上crontab上写为
31 15 09  06 *  bzcat /home/oracle/etl/data/data/snapshot/archives.txt.bz2 | awk -F'[|^]' '{if(($6=="10511051"||$6=="10301079")&&$(NF-11)>="20150301000000"&&$(NF-11)<="20150401000000"&&$4=="751") print   $2","$3","$4","$6","$5","$7","$8","$(NF-2)","$(NF-3)","$(NF-4) }' | bzip2 > /home/oracle/flbk_liaoning_3yuezhijin_cancle.txt.bz2




下载到本地
cat flbk_liaoning_3yuezhijin_cancle.txt | awk -F',' '{print $1"\t"$5"\t已退定\t"$6"\t"$7;}'  > 1.txt
sed -i 's/FLBK_MMS/12580生活播报-法律百科彩信版/g;s/FLZS_SMS/12580生活播报-法律百科短信版/g;' 1.txt
--EXCEL操作函数
--DATEDIF(开始日期,结束日期,第三参数)
--DATEDIF(D2,F2,"m")
--awk -F'[,]' -v CODE_DIR=nodist_yaoyi.txt '{ if(FILENAME==CODE_DIR) d[$4]=$2; else if( substr($1,1,7) in d)  print $1"\t"d[substr($1,1,7)]"\t"$2"\t"$3"\t"$4}'   nodist_yaoyi.txt 1.txt > 2.txt
-----------------排重-----------------
导入到jf_1
ctl如下
LOAD DATA  INFILE 'F:\work\1.txt' 
BADFILE 'F:\work\dingzhi.txt.bad'
truncate INTO TABLE  jf_1
FIELDS TERMINATED BY '\t' OPTIONALLY ENCLOSED BY '"' 
 TRAILING NULLCOLS
( mobile,job_num,province,opttime,subtime,opt_code,biz_code,serial,city,cartype
 )
 然后排重
 select j.mobile, max(j.job_num),max(j.province), max(j.opttime) ,max(j.subtime)
  from jf_1 j
 group by j.mobile
最后再把退订的数据用还在线的数据排重
awk -F'[\t,]' -v CODE_DIR=在线.txt '{ if(FILENAME==CODE_DIR) d[$1]=$1 ; else if(!($1 in d))  print $0;  }' 在线.txt  退订.txt>tuiding.txt
------------计费---------
cat /data0/2015/20150131/qiangxiang_mms_pay_users.txt  | grep ',200,' | awk -F',' '{if($2=="10511051")print  $1"|"$4"|"$6}' | bzip2 > /home/oracle/gd_1y_flbkcai.txt.bz2
cat /data0/2015/20150228/qiangxiang_mms_pay_users.txt  | grep ',200,' | awk -F',' '{if($2=="10511051")print  $1"|"$4"|"$6}' | bzip2 > /home/oracle/gd_2y_flbkcai.txt.bz2
cat /data0/2015/20150331/qiangxiang_mms_pay_users.txt  | grep ',200,' | awk -F',' '{if($2=="10511051")print  $1"|"$4"|"$6}' | bzip2 > /home/oracle/gd_3y_flbkcai.txt.bz2
----然后匹配订购时间和退订时间---------------
47 10 19 6 * bzcat /home/oracle/gd_1y_flbkcai.txt.bz2  /data0/match/orig/20150131/snapshot.txt.bz2 | awk -F'|' '{if(NF==3){aa[$1]=$1"|"$2"|"$3} else {if (  $2=="10511051"&&$1 in aa&&$8=="020"&&$3== "06")  print aa[$1]"|"$4"|99991230000000";if (  $2=="10511051"&&$1 in aa&&$8=="020"&&$3=="07")  print aa[$1]"|"$5"|"$4 }}' | bzip2 > /home/oracle/gd_flbk_1yjf.txt.bz2
56 10 19 6 * bzcat /home/oracle/gd_2y_flbkcai.txt.bz2  /data0/match/orig/20150228/snapshot.txt.bz2 | awk -F'|' '{if(NF==3){aa[$1]=$1"|"$2"|"$3} else {if (  $2=="10511051"&&$1 in aa&&$8=="020"&&$3== "06")  print aa[$1]"|"$4"|99991230000000";if (  $2=="10511051"&&$1 in aa&&$8=="020"&&$3=="07")  print aa[$1]"|"$5"|"$4 }}' | bzip2 > /home/oracle/gd_flbk_2yjf.txt.bz2
56 10 19 6 * bzcat /home/oracle/gd_3y_flbkcai.txt.bz2  /data0/match/orig/20150331/snapshot.txt.bz2 | awk -F'|' '{if(NF==3){aa[$1]=$1"|"$2"|"$3} else {if (  $2=="10511051"&&$1 in aa&&$8=="020"&&$3== "06")  print aa[$1]"|"$4"|99991230000000";if (  $2=="10511051"&&$1 in aa&&$8=="020"&&$3=="07")  print aa[$1]"|"$5"|"$4 }}' | bzip2 > /home/oracle/gd_flbk_3yjf.txt.bz2
