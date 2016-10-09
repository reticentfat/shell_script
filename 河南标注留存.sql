添加appcode，转换格式
18839577080,10511050,漯河12580健康宝典,300M
导入
LOAD DATA  INFILE 'C:\备份\F盘\work\sichuan_09y_zuoxidingzhi.txt' 
BADFILE 'C:\备份\F盘\work\dingzhi.txt.bad'
truncate INTO TABLE  jf_2
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' 
 TRAILING NULLCOLS
(   job_num,province,opt_code,opttime,mobile,subtime,serial,biz_code,city,cartype
 )
  select j.job_num 号码,
                       j.opt_code "9月外呼业务",
                       j.opttime 需返还流量,
                      NVL( to_char(n.mobile_sub_time, 'yyyy-mm-dd '),'无订购关系') 订购时间,
                      --NVL(to_char(n.mobile_modify_time, 'yyyy-mm '),'2011-01'） 退订时间, 
                       case  
         when  to_char(n.mobile_modify_time, 'yyyy-mm')='2016-10' then
         '是'
         when  to_char(n.mobile_modify_time, 'yyyy-mm')='9999-12' then
         '是'
         else '否'
          end "十月是否留存"
                  from jf_2 j
                  left join new_wireless_subscription n
                    on j.job_num = n.mobile_sn
                   and j.province = n.appcode
                   
               ----------------------------------
                     select j.job_num 号码,
                       j.opt_code 业务,
                       j.opttime 外呼日期,
                       j.mobile 需返还流量,
                      NVL( to_char(n.mobile_sub_time, 'yyyy-mm-dd '),'无订购关系') 订购时间,
                      NVL(to_char(n.mobile_modify_time, 'yyyy-mm '),'2011-01'） 退订时间, 
                       case  
         when  to_char(n.mobile_modify_time, 'yyyy-mm')='2016-10' then
         '是'
         when  to_char(n.mobile_modify_time, 'yyyy-mm')='9999-12' then
         '是'
         else '否'
          end "十月是否留存"
                  from jf_2 j
                  left join new_wireless_subscription n
                    on j.job_num = n.mobile_sn
                   and j.province = n.appcode
