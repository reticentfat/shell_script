先从月需求中找出河南3月新增数据87237.txt
18898119672	郑州	10511008
导入jf_2
LOAD DATA  INFILE 'C:\备份\F盘\work\wy.txt' 
BADFILE 'C:\备份\F盘\work\dingzhi.txt.bad'
truncate INTO TABLE  jf_2
FIELDS TERMINATED BY '	' OPTIONALLY ENCLOSED BY '"' 
 TRAILING NULLCOLS
( job_num,province,opt_code,opttime,mobile,subtime,serial,biz_code,city,cartype
 )
  select j.job_num,
          j.province,
          to_char(n.mobile_sub_time, 'yyyy-mm-dd hh24:mi:ss'),
          to_char(n.mobile_modify_time, 'yyyy-mm-dd hh24:mi:ss')
     from jf_2 j
     left join new_wireless_subscription n
       on j.opt_code = n.appcode
      and j.job_num = n.mobile_sn
    where n.mobile_modify_time > to_date('2016-06-01', 'yyyy-mm-dd')
    查询在6月留存的
    用excel处理
    =if(G2=" ",e2,G2)
