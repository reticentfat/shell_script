 ----上月订购号码---------
 select b.mobile_sn, b.addr_code,to_char(b.mobile_sub_time, 'yyyy-mm-dd hh24:mi:ss') 订购时间 ,o.opt_cost
   from (select *
           from (select t.*,
                        row_number() over(partition by t.appcode,t.addr_code order by t.mobile_sn desc) RN
                   from new_wireless_subscription t 
                   where t.mobile_sub_time>= to_date('2017-01-01', 'yyyy-mm-dd')
                   and t.mobile_sub_time< to_date('2017-02-01', 'yyyy-mm-dd'))
          where RN <= 2) b,
        opt_code o
  where b.appcode = o.appcode
  union all
   select b.mobile_sn, b.addr_code,to_char(b.mobile_sub_time, 'yyyy-mm-dd hh24:mi:ss') 订购时间 ,o.opt_cost
   from (select *
           from (select t.*,
                        row_number() over(partition by t.appcode,t.addr_code order by t.mobile_sn desc) RN
                   from new_wireless_subscription_shbb t 
                   where t.mobile_sub_time>= to_date('2017-01-01', 'yyyy-mm-dd')
                   and t.mobile_sub_time< to_date('2017-02-01', 'yyyy-mm-dd'))
          where RN <= 2) b,
        opt_code o
  where b.appcode = o.appcode
  union all 
  select b.mobile_sn, b.addr_code,to_char(b.mobile_sub_time, 'yyyy-mm-dd hh24:mi:ss') 订购时间 ,o.opt_cost
   from (select *
           from (select t.*,
                        row_number() over(partition by t.opt_type,t.addr_code order by t.mobile_sn desc) RN
                   from bjwz t 
                   where t.mobile_sub_time>= to_date('2017-01-01', 'yyyy-mm-dd')
                   and t.mobile_sub_time< to_date('2017-02-01', 'yyyy-mm-dd'))
          where RN <= 2) b,
        opt_code o
  where b.opt_type = o.opt_type 
   union all 
  select b.mobile_sn, b.addr_code,to_char(b.mobile_sub_time, 'yyyy-mm-dd hh24:mi:ss') 订购时间 ,o.opt_cost
   from (select *
           from (select t.*,
                        row_number() over(partition by t.fee_app_code,t.addr_code order by t.mobile_sn desc) RN
                   from fswz t 
                   where t.mobile_sub_time>= to_date('2017-01-01', 'yyyy-mm-dd')
                   and t.mobile_sub_time< to_date('2017-02-01', 'yyyy-mm-dd'))
          where RN <= 2) b,
        opt_code o
  where 'F' || b.fee_app_code = o.opt_type  
  ---------------上月退订号码--------------
   select b.mobile_sn, b.addr_code,to_char(b.mobile_modify_time, 'yyyy-mm-dd hh24:mi:ss') 退订时间 ,o.opt_cost
   from (select *
           from (select t.*,
                        row_number() over(partition by t.appcode,t.addr_code order by t.mobile_sn desc) RN
                   from new_wireless_subscription t 
                   where t.mobile_modify_time>= to_date('2017-01-01', 'yyyy-mm-dd')
                   and t.mobile_modify_time< to_date('2017-02-01', 'yyyy-mm-dd'))
          where RN <= 2) b,
        opt_code o
  where b.appcode = o.appcode
  union all
   select b.mobile_sn, b.addr_code,to_char(b.mobile_modify_time, 'yyyy-mm-dd hh24:mi:ss') 退订时间 ,o.opt_cost
   from (select *
           from (select t.*,
                        row_number() over(partition by t.appcode,t.addr_code order by t.mobile_sn desc) RN
                   from new_wireless_subscription_shbb t 
                   where t.mobile_modify_time>= to_date('2017-01-01', 'yyyy-mm-dd')
                   and t.mobile_modify_time< to_date('2017-02-01', 'yyyy-mm-dd'))
          where RN <= 2) b,
        opt_code o
  where b.appcode = o.appcode
  union all 
  select b.mobile_sn, b.addr_code,to_char(b.mobile_modify_time, 'yyyy-mm-dd hh24:mi:ss') 退订时间 ,o.opt_cost
   from (select *
           from (select t.*,
                        row_number() over(partition by t.opt_type,t.addr_code order by t.mobile_sn desc) RN
                   from bjwz t 
                   where t.mobile_modify_time>= to_date('2017-01-01', 'yyyy-mm-dd')
                   and t.mobile_modify_time< to_date('2017-02-01', 'yyyy-mm-dd'))
          where RN <= 2) b,
        opt_code o
  where b.opt_type = o.opt_type 
   union all 
  select b.mobile_sn, b.addr_code,to_char(b.mobile_modify_time, 'yyyy-mm-dd hh24:mi:ss') 退订时间 ,o.opt_cost
   from (select *
           from (select t.*,
                        row_number() over(partition by t.fee_app_code,t.addr_code order by t.mobile_sn desc) RN
                   from fswz t 
                   where t.mobile_modify_time>= to_date('2017-01-01', 'yyyy-mm-dd')
                   and t.mobile_modify_time< to_date('2017-02-01', 'yyyy-mm-dd'))
          where RN <= 2) b,
        opt_code o
  where 'F' || b.fee_app_code = o.opt_type  
 ----------------------------留存到至今激活的-------------------
  select b.mobile_sn, b.addr_code,to_char(b.mobile_sub_time, 'yyyy-mm-dd hh24:mi:ss') 订购时间 , b.addr_code,to_char(b.mobile_modify_time, 'yyyy-mm-dd hh24:mi:ss') 退订时间,o.opt_cost
   from (select *
           from (select t.*,
                        row_number() over(partition by t.appcode,t.addr_code order by t.mobile_sn desc) RN
                   from new_wireless_subscription t 
                   where t.mobile_sub_time>= to_date('2016-12-01', 'yyyy-mm-dd')
                   and t.mobile_sub_time< to_date('2017-01-01', 'yyyy-mm-dd')
                   and t.mobile_modify_time>= to_date('2017-02-01', 'yyyy-mm-dd')
                   and t.is_paused='1')
          where RN <= 2) b,
        opt_code o
  where b.appcode = o.appcode
  union all
   select b.mobile_sn, b.addr_code,to_char(b.mobile_sub_time, 'yyyy-mm-dd hh24:mi:ss') 订购时间 ,b.addr_code,to_char(b.mobile_modify_time, 'yyyy-mm-dd hh24:mi:ss') 退订时间,o.opt_cost
   from (select *
           from (select t.*,
                        row_number() over(partition by t.appcode,t.addr_code order by t.mobile_sn desc) RN
                   from new_wireless_subscription_shbb t 
                   where t.mobile_sub_time>= to_date('2016-12-01', 'yyyy-mm-dd')
                   and t.mobile_sub_time< to_date('2017-01-01', 'yyyy-mm-dd')
                   and t.mobile_modify_time>= to_date('2017-02-01', 'yyyy-mm-dd')
                   and t.is_paused='1')
          where RN <= 2) b,
        opt_code o
  where b.appcode = o.appcode
  union all 
  select b.mobile_sn, b.addr_code,to_char(b.mobile_sub_time, 'yyyy-mm-dd hh24:mi:ss') 订购时间 ,b.addr_code,to_char(b.mobile_modify_time, 'yyyy-mm-dd hh24:mi:ss') 退订时间,o.opt_cost
   from (select *
           from (select t.*,
                        row_number() over(partition by t.opt_type,t.addr_code order by t.mobile_sn desc) RN
                   from bjwz t 
                   where t.mobile_sub_time>= to_date('2016-12-01', 'yyyy-mm-dd')
                   and t.mobile_sub_time< to_date('2017-01-01', 'yyyy-mm-dd')
                   and t.mobile_modify_time>= to_date('2017-02-01', 'yyyy-mm-dd')
                   )
          where RN <= 2) b,
        opt_code o
  where b.opt_type = o.opt_type 
   union all 
  select b.mobile_sn, b.addr_code,to_char(b.mobile_sub_time, 'yyyy-mm-dd hh24:mi:ss') 订购时间 ,b.addr_code,to_char(b.mobile_modify_time, 'yyyy-mm-dd hh24:mi:ss') 退订时间,o.opt_cost
   from (select *
           from (select t.*,
                        row_number() over(partition by t.fee_app_code,t.addr_code order by t.mobile_sn desc) RN
                   from fswz t 
                   where t.mobile_sub_time>= to_date('2016-12-01', 'yyyy-mm-dd')
                   and t.mobile_sub_time< to_date('2017-01-01', 'yyyy-mm-dd')
                   and t.mobile_modify_time>= to_date('2017-02-01', 'yyyy-mm-dd')
                   )
          where RN <= 2) b,
        opt_code o
  where 'F' || b.fee_app_code = o.opt_type 
