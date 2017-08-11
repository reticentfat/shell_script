15199831723|00|20170803145550|02|801174|125823|0|20170801021627
15099445263|00|20170809163018|02|801174|125823|0|20170807214815
导入jf_1
Load DATA  INFILE 'C:\备份\F盘\work\BOS_SUB_20170811000000_0042991.0000002288' 
BADFILE 'C:\备份\F盘\work\dingzhi.txt.bad'
truncate INTO TABLE  jf_1
FIELDS TERMINATED BY '|' OPTIONALLY ENCLOSED BY '"' 
 TRAILING NULLCOLS
(mobile,city,opttime,cartype,province,appcode,job_num,subtime,serial,opt_cost,biz_code,opt_code)
---------新疆没有违章业务所以只核对前向媒体业务即可-----
 --select b.mobile_sn, o.appcode, o.opt_cost,j.appcode,b.mobile_sub_time,b.mobile_modify_time
 -- from bjwz b , jf_1  j,opt_code o --,mobilenodist m 
-- where b.mobile_sn = j.mobile    and j.appcode=o.jfcode 
 --and b.opt_type=o.opt_type 
  union all 
 
 select n.mobile_sn, o.appcode, o.opt_cost,j.appcode,n.mobile_sub_time,n.mobile_modify_time
  from new_wireless_subscription n, jf_1  j,opt_code o --,mobilenodist m 
 where n.mobile_sn = j.mobile    and j.appcode=o.jfcode
 and n.appcode=o.appcode 
  
  -- and j.opt_code like '违章%'
 --order by n.mobile_sn
 union all 
  select n.mobile_sn, o.appcode, o.opt_cost,j.appcode,mobile_sub_time,n.mobile_modify_time
  from new_wireless_subscription_shbb n, jf_1  j,opt_code o --,mobilenodist m 
 where n.mobile_sn = j.mobile    and j.appcode=o.jfcode 
 and n.appcode=o.appcode
  
