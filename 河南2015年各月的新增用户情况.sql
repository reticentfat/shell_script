九月的在pl/sql上做
select o.opt_cost 业务名称,
       m.city 所属地市,
       
       count(n.mobile_sn) 当月新增数量,
       sum(case
         when (n.mobile_modify_time - n.mobile_sub_time) * 24 <= 72 then
          1
         when (n.mobile_modify_time - n.mobile_sub_time) * 24 > 72 then
          0
           end ) "72小时内退订量",
      sum(case  
         when to_char(n.mobile_modify_time, 'YYYY-MM')='2015-10' then
         1
         when to_char(n.mobile_modify_time, 'YYYY-MM')='9999-12' then
         1
         else 0
         end ) 次月留存量
          
         
  from new_wireless_subscription n, opt_code o, mobilenodist m
 where n.appcode = o.appcode
   and substr(n.mobile_sn, 1, 7) = m.beginno
   and n.mobile_sub_time >= to_date('2015-09-01', 'yyyy-mm-dd')
   and n.mobile_sub_time < to_date('2015-10-01', 'yyyy-mm-dd')
   and n.appcode in ('10511008','10511050','10511055','10511051','10301085')
   and m.province = '河南'
   group by  o.opt_cost ,m.city 
       -------------------8月的如下-----------------
 bzcat /data/match/orig/20150930/snapshot.txt.bz2|awk -F'|' '$8=="0371"&&($2=="10511050"||$2=="10511008"||$2=="10511051"||$2=="10511055"||$2=="10301085") {if ($3=="06") print $1"|"$2"|"$9"|"$4"|99999999999999|8yue";else if ($3=="07") print $1"|"$2"|"$9"|"$5"|"$4"|8yue"}' > henan9yue.txt
 --27上
 cat  henan8yue.txt | awk -F'|' '{print $2}' | sort | uniq -c
00 21 29 10 * bzcat /data/match/orig/20150831/snapshot.txt.bz2|awk -F'|' '$8=="0371"&&($2=="10511050"||$2=="10511008"||$2=="10511051"||$2=="10511055"||$2=="10301085") {if ($3=="06") print $1"|"$2"|"$9"|"$4"|99999999999999|8yue";else if ($3=="07") print $1"|"$2"|"$9"|"$5"|"$4"|8yue"}' > henan8yue.txt
00 21 29 10 * bzcat /data/match/orig/20150731/snapshot.txt.bz2|awk -F'|' '$8=="0371"&&($2=="10511050"||$2=="10511008"||$2=="10511051"||$2=="10511055"||$2=="10301085") {if ($3=="06") print $1"|"$2"|"$9"|"$4"|99999999999999|7yue";else if ($3=="07") print $1"|"$2"|"$9"|"$5"|"$4"|7yue"}' > henan7yue.txt
00 21 29 10 * bzcat /data/match/orig/20150630/snapshot.txt.bz2|awk -F'|' '$8=="0371"&&($2=="10511050"||$2=="10511008"||$2=="10511051"||$2=="10511055"||$2=="10301085") {if ($3=="06") print $1"|"$2"|"$9"|"$4"|99999999999999|6yue";else if ($3=="07") print $1"|"$2"|"$9"|"$5"|"$4"|6yue"}' > henan6yue.txt 
00 21 29 10 * bzcat /data/match/orig/20150531/snapshot.txt.bz2|awk -F'|' '$8=="0371"&&($2=="10511050"||$2=="10511008"||$2=="10511051"||$2=="10511055"||$2=="10301085") {if ($3=="06") print $1"|"$2"|"$9"|"$4"|99999999999999|5yue";else if ($3=="07") print $1"|"$2"|"$9"|"$5"|"$4"|5yue"}' > henan5yue.txt
00 21 29 10 * bzcat /data/match/orig/20150430/snapshot.txt.bz2|awk -F'|' '$8=="0371"&&($2=="10511050"||$2=="10511008"||$2=="10511051"||$2=="10511055"||$2=="10301085") {if ($3=="06") print $1"|"$2"|"$9"|"$4"|99999999999999|4yue";else if ($3=="07") print $1"|"$2"|"$9"|"$5"|"$4"|4yue"}' > henan4yue.txt
00 21 29 10 * bzcat /data/match/orig/20150331/snapshot.txt.bz2|awk -F'|' '$8=="0371"&&($2=="10511050"||$2=="10511008"||$2=="10511051"||$2=="10511055"||$2=="10301085") {if ($3=="06") print $1"|"$2"|"$9"|"$4"|99999999999999|3yue";else if ($3=="07") print $1"|"$2"|"$9"|"$5"|"$4"|3yue"}' > henan3yue.txt
00 21 29 10 * bzcat /data/match/orig/20150228/snapshot.txt.bz2|awk -F'|' '$8=="0371"&&($2=="10511050"||$2=="10511008"||$2=="10511051"||$2=="10511055"||$2=="10301085") {if ($3=="06") print $1"|"$2"|"$9"|"$4"|99999999999999|2yue";else if ($3=="07") print $1"|"$2"|"$9"|"$5"|"$4"|2yue"}' > henan2yue.txt
00 21 29 10 * bzcat /data/match/orig/20150131/snapshot.txt.bz2|awk -F'|' '$8=="0371"&&($2=="10511050"||$2=="10511008"||$2=="10511051"||$2=="10511055"||$2=="10301085") {if ($3=="06") print $1"|"$2"|"$9"|"$4"|99999999999999|1yue";else if ($3=="07") print $1"|"$2"|"$9"|"$5"|"$4"|1yue"}' > henan1yue.txt
cat henan?yue.txt>henanall.txt
LOAD DATA  INFILE 'F:\work\henanall.txt' 
BADFILE 'F:\work\dingzhi.txt.bad'
truncate INTO TABLE  jf_1
FIELDS TERMINATED BY '|' OPTIONALLY ENCLOSED BY '"' 
 TRAILING NULLCOLS
( mobile,opt_code,cartype,subtime,opttime,serial,job_num,biz_code
 )
 ------------查一月报表如下
 select o.opt_cost 业务名称,
       m.city 所属地市,
       
       count(case when j.serial='2yue' then j.mobile else null end ) 当月新增数量,
       sum(case
         when (j.serial='2yue' and (j.opttime - j.subtime)  <= 3000000) then
          1
         when (j.serial='2yue' and (j.opttime - j.subtime)  >  3000000 ) then
          0
           end ) "72小时内退订量",
      sum(case  
         when (j.serial='2yue' and substr(j.opttime,1, 6)>='201502') then
         1
         
         else 0
         end ) 次月留存量 ,
      sum(case  
         when (j.serial='3yue' and substr(j.opttime,1, 6)>='201503') then
         1
       
         else 0
         end ) 次次月留存量    
         
  from jf_1 j, opt_code o, mobilenodist m
 where j.opt_code = o.appcode
   and substr(j.mobile, 1, 7) = m.beginno
   and SUBSTR(j.subtime,1,8) >= '20150101'
   and  SUBSTR(j.subtime,1,8) < '20150201'
  
   group by  o.opt_cost ,m.city 
-------------------查8月新增下下月是否留存字段---------------
 select o.opt_cost 业务名称,
       m.city 所属地市,
     
      sum(case  
         when to_char(n.mobile_modify_time, 'YYYY-MM')='2015-09' then
         1
         when to_char(n.mobile_modify_time, 'YYYY-MM')='9999-12' then
         1
         else 0
         end ) 次次月留存量
          
         
  from new_wireless_subscription n, opt_code o, mobilenodist m
 where n.appcode = o.appcode
   and substr(n.mobile_sn, 1, 7) = m.beginno
   and n.mobile_sub_time >= to_date('2015-08-01', 'yyyy-mm-dd')
   and n.mobile_sub_time < to_date('2015-09-01', 'yyyy-mm-dd')
   and n.appcode in ('10511008','10511050','10511055','10511051','10301085')
   and m.province = '河南'
   group by  o.opt_cost ,m.city 
