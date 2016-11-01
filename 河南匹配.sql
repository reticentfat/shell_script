                           
LOAD DATA  INFILE 'C:\备份\F盘\work\zuoxi_merge.txt' 
BADFILE 'C:\备份\F盘\work\dingzhi.txt.bad'
truncate INTO TABLE  jf_1
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' 
 TRAILING NULLCOLS
( opt_code,opttime,job_num,mobile,province,subtime,serial,biz_code,city,cartype)

  　2016/10/18,13403864451,当月生效,周口,健康宝典,10511050
2016/10/18,13403868999,当月生效,周口,健康宝典,10511050
-------------sql------------------
select  j.opt_code "回访日期", 
        j.opttime  "手机号码", 
      j.job_num "业务生效时间", 
       j.mobile "备注",
       j.province "业务名称",
       nvl(to_char(n.mobile_sub_time, 'yyyy-mm-dd hh24:mi:ss'),'未开通') 
        订购时间,
        case  
         when to_char(n.mobile_modify_time, 'YYYY-MM')='2016-11' then
         '是'
         when to_char(n.mobile_modify_time, 'YYYY-MM')='9999-12' then
         '是'
         else '否'
          end "次月是否留存"
   from  
 jf_1 j left join new_wireless_subscription n
              
                on j.opttime = n.mobile_sn
                  and j.subtime=n.appcode
