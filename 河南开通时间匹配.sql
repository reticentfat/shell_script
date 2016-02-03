字段如下
健康随行	2015-10-27	新乡	13837303932	次月赠送省内100M流量	10301085
电影俱乐部	2015年11月1日	新乡	13462202512	次月赠送您100M省内流量	10511008
健康随行	2015-11-5	三门峡	15939802884	次月赠送省内100M流量	10301085


导入jf_1
LOAD DATA  INFILE 'F:\work\jiangxi_zuoxi_log_10y.txt' 
BADFILE 'F:\work\dingzhi.txt.bad'
truncate INTO TABLE  jf_1
FIELDS TERMINATED BY '\t' OPTIONALLY ENCLOSED BY '"' 
 TRAILING NULLCOLS
( opt_code,opttime,job_num,mobile,province,subtime,serial,biz_code,city,cartype
 )
sql如下
--select * from jf_1 j
select  j.opt_code "业务名称", 
        j.opttime  "地市", 
     -- b.betime   订购时间 ,
      j.job_num "外呼日期", 
       j.mobile "外呼成功号码",
       j.province "赠送政策",
       nvl(to_char(n.mobile_sub_time, 'yyyy-mm-dd hh24:mi:ss'),'未开通') 
        订购时间
   from  
 jf_1 j left join new_wireless_subscription n
              
                on j.mobile = n.mobile_sn
                  and j.subtime=n.appcode
                
