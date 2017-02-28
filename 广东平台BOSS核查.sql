LOAD DATA  INFILE 'C:\备份\F盘\work\BOSS_20170215_0042.MORE' 
BADFILE 'C:\备份\F盘\work\dingzhi.txt.bad'
truncate INTO TABLE  jf_1
FIELDS TERMINATED BY '|' OPTIONALLY ENCLOSED BY '"' 
 TRAILING NULLCOLS
(mobile,city,opttime,cartype,province,appcode,job_num,subtime,biz_code,opt_code,serial,opt_cost)
13411259046|00|20170212124953|02|901808|-UMGWZJS|0|20170212124953
13413903477|00|20090628191106|02|801174|125820|0|20090628191106
--------------
select f.mobile_sn, o.appcode, o.opt_cost,j.appcode
  from fswz f, jf_1  j,opt_code o --,mobilenodist m 
 where f.mobile_sn = j.mobile    and j.appcode=o.jfcode 
 and 'F' || f.fee_app_code = o.opt_type 
  and f.mobile_sub_state = 3
  -- and j.opt_code like '违章%'
 order by f.mobile_sn
 union all 
  select n.mobile_sn, o.appcode, o.opt_cost,j.appcode
  from new_wireless_subscription n, jf_1  j,opt_code o --,mobilenodist m 
 where n.mobile_sn = j.mobile    and j.appcode=o.jfcode
 and n.appcode=o.appcode 
  and n.mobile_sub_state = 3
  -- and j.opt_code like '违章%'
 order by n.mobile_sn
 union all 
  select n.mobile_sn, o.appcode, o.opt_cost,j.appcode
  from new_wireless_subscription_shbb n, jf_1  j,opt_code o --,mobilenodist m 
 where n.mobile_sn = j.mobile    and j.appcode=o.jfcode 
 and n.appcode=o.appcode
  and n.mobile_sub_state = 3
  -- and j.opt_code like '违章%'
 order by n.mobile_sn
