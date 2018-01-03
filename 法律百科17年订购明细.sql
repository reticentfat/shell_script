-----先提取在线的
 select  n.mobile_sn  手机号码,
 m.province 省份，
       m.city 地市，
o.opt_cost 业务名称,
 to_char(n.mobile_sub_time, 'yyyy-mm-dd hh24:mi:ss') 开通时间,
                    to_char(n.mobile_modify_time, 'yyyy-mm-dd hh24:mi:ss') 退订时间
                     
  from new_wireless_subscription n, opt_code o, mobilenodist m
 where n.appcode = o.appcode
   and substr(n.mobile_sn, 1, 7) = m.beginno
   and n.mobile_sub_time >= to_date('2017-01-01', 'yyyy-mm-dd')
   and n.mobile_sub_time < to_date('2018-01-01', 'yyyy-mm-dd')
   and n.appcode in ('10301079', '10511051')
   and n.mobile_sub_state='3'
 ------
   ----------------下边取1月1日至今订购的退订用户---------
bzcat /home/oracle/etl/data/data/snapshot/archives.txt.bz2 | awk -F'[|^]' '{if(($6=="10301079" || $6=="10511051")&&$(NF-11)>="20170101000000"&&$(NF-11)<="20180101000000") print $2","$3","$4","$6","$5","$7","$8 }' | bzip2 > /home/oracle/flbk_all_cancle.txt.bz2 
awk -F',' -v CODE_DIR=nodist_yaoyi.txt '{ if(FILENAME==CODE_DIR) d[$4]=$1"\t"$2; else if( substr($1,1,7) in d)  print $1"\t"d[substr($1,1,7)]"\t"$5"\t"$6"\t"$7}'   nodist_yaoyi.txt flbk_all_cancle.txt> 2.txt
sed -i 's/FLBK_MMS/12580生活播报-法律百科彩信版/g;s/FLZS_SMS/12580生活播报-法律百科短信版/g;' 2.txt
 -----------------排重-----------------
cat 1.txt 2.txt | sort -u > tuiding.txt
----------脱敏---
cat tuiding.txt | awk '{print substr($1,1,3)"****"substr($1,8,4),$2,$3,$4,$5,$6,$7,$8}' | bzip2> flbk_17nian_xinzeng.txt.bz2

------排重----
然后吧15157063923	2014-01-13 16:46:17	2014-03-09 09:16:09	10301079
导入jf_1排重
LOAD DATA  INFILE 'F:\work\wy.txt' 
BADFILE 'F:\work\dingzhi.txt.bad'
truncate INTO TABLE  jf_1
FIELDS TERMINATED BY '	' OPTIONALLY ENCLOSED BY '"' 
 TRAILING NULLCOLS
( mobile,job_num,opttime,subtime,province,opt_code,biz_code,serial,city,cartype
 )
select j.mobile,j.job_num,max(j.opttime),max(j.subtime) from jf_1 j
 group by j.mobile,j.job_num
