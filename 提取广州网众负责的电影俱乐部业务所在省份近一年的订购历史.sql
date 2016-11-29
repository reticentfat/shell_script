----截取至今在线----------
select  n.mobile_sn  手机号码,
 m.province 省份，
       o.opt_cost 业务名称,
to_char(n.mobile_sub_time, 'yyyy-mm-dd hh24:mi:ss') 开通时间,
                    to_char(n.mobile_modify_time, 'yyyy-mm-dd hh24:mi:ss') 退订时间,
                    n.mobile_sub_channel 开通渠道,
                        'null'             退订渠道,
                          '订购中'            当前订购状态
                     
  from new_wireless_subscription n, opt_code o, mobilenodist m
 where n.appcode = o.appcode
   and substr(n.mobile_sn, 1, 7) = m.beginno
   --and n.mobile_sub_time >= to_date('2014-01-01', 'yyyy-mm-dd')
  -- and n.mobile_sub_time < to_date('2015-01-01', 'yyyy-mm-dd')
   and n.appcode in ('10301013', '10511008')
   and n.mobile_sub_state='3'
   ----------------截取不在线----------------------
   27上crontab上写为
41 14 29  11 *  bzcat /home/oracle/etl/data/data/snapshot/archives.txt.bz2 | awk -F'[|^]' '($6=="10511008"||$6=="10301013") {print   $2","$3","$6","$7","$8","$(NF-2)","$(NF-8) }' | bzip2 > /home/oracle/dyjlb_cancle.txt.bz2
下载到本地后用cygwin处理步骤如下
awk -F',' -v CODE_DIR=nodist_yaoyi.txt '{ if(FILENAME==CODE_DIR) d[$4]=$1; else if( substr($1,1,7) in d)  print $1"\t"d[substr($1,1,7)]"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7}'   nodist_yaoyi.txt dyjlb_cancle.txt > 2.txt
sed -i 's/FLBK_MMS/12580生活播报-法律百科彩信版/g;s/10301013/12580生活播报-法律百科短信版/g;' 2.txt
$ cat 2.txt | sort -u > tuiding.txt
$ cat tuiding.txt | awk -F',' '{print $1","$2","$3","$4","$5","$7","$6",已退订"}' > 3.txt

$ cat dyjlb_all.txt | awk -F',' '($2=="山东"||$2=="河南"||$2=="辽宁"||$2=="黑龙 江"||$2=="陕西"||$2=="甘肃"||$2=="青海"||$2=="宁夏"||$2=="新疆"||$2=="吉林"){print $0}' >dyljb_10.txt
导入到jf_1
ctl如下
LOAD DATA  INFILE 'C:\备份\F盘\work\dyljb_10.txt' 
BADFILE 'C:\备份\F盘\work\dingzhi1.txt.bad'
truncate INTO TABLE mobile.jf_1 
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'  
 TRAILING NULLCOLS
( province,mobile,cartype,opttime,job_num,biz_code,opt_code,serial,subtime
 )
 然后排重
 select  j.province,j.cartype,max(j.mobile), max(j.opttime), max(j.job_num),max(j.biz_code) ,max(j.opt_code),max(j.serial)
  from jf_1 j
 group by j.province,j.cartype
