---导入数据----
|13761103179|801174|100|20160711153726|46241|12580地产客互动
|13761103179|801174|125849|20160711153940|46241|12580生活播报优旅行
LOAD DATA  INFILE 'C:\备份\F盘\work\九月12580差异需平台比对反馈的数据.txt' 
BADFILE 'C:\备份\F盘\work\dingzhi.txt.bad'
truncate INTO TABLE  jf_1
FIELDS TERMINATED BY '|' OPTIONALLY ENCLOSED BY '"' 
 TRAILING NULLCOLS
( opttime,mobile,job_num,cartype,biz_code,opt_code,serial,subtime,appcode,opt_cost)
 ----sql-------------
 select  j.mobile,j.job_num,j.cartype,j.biz_code,j.opt_code,j.serial
  from new_wireless_subscription t, opt_code o, jf_1 j
 where t.appcode = o.appcode
   and t.mobile_sn = j.mobile
   and o.jfcode = j.cartype
   and t.mobile_sub_state = 3
   

       union all 
     select j.mobile,j.job_num,j.cartype,j.biz_code,j.opt_code,j.serial
  from new_wireless_subscription_shbb t, opt_code_shbb o, jf_1 j
 where t.appcode = o.appcode
   and t.mobile_sn = j.mobile
   and o.jfcode = j.cartype
   and t.mobile_sub_state = 3
