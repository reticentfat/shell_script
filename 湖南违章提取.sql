select id codeid,
       
       car_no 车牌,
       
       car_type 车型,
       
       car_sn 驾驶证,
       to_char(mobile_sub_time, 'yyyy-mm-dd hh24:mi:ss') 订购时间

  from bjwz b, mobilenodist m, opt_code o --,jf_1 j 
 where b.opt_type = o.opt_type --and j.mobile=b.mobile_sn 
   and substr(b.mobile_sn, 1, 7) = m.beginno
   and m.province = '湖南'
   and b.mobile_sub_state = '3'
   and  (car_no is not null or car_sn is not null)
----------------------------
select id codeid,
       
       car_no 车牌,
       
       car_type 车型,
       
       car_sn 驾驶证,
       to_char(mobile_sub_time, 'yyyy-mm-dd hh24:mi:ss') 订购时间

  from bjwz b, mobilenodist m, opt_code o --,jf_1 j 
 where b.opt_type = o.opt_type --and j.mobile=b.mobile_sn 
   and substr(b.mobile_sn, 1, 7) = m.beginno
   and m.province = '湖南'
   and b.mobile_sub_state = '3'
   and car_no is not null
union 
select id codeid,
       
       car_no 车牌,
       
       car_type 车型,
       
       car_sn 驾驶证,
       to_char(mobile_sub_time, 'yyyy-mm-dd hh24:mi:ss') 订购时间

  from bjwz b, mobilenodist m, opt_code o --,jf_1 j 
 where b.opt_type = o.opt_type --and j.mobile=b.mobile_sn 
   and substr(b.mobile_sn, 1, 7) = m.beginno
   and m.province = '湖南'
   and b.mobile_sub_state = '3'
   and car_sn is not null
      
    ---- select b.car_sn from bjwz b
