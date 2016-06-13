 select b.mobile_sn, o.opt_cost
   from (select *
           from (select t.*,
                        row_number() over(partition by t.appcode order by t.mobile_sn desc) RN
                   from new_wireless_subscription t 
                   where t.mobile_sub_state=3
                   and t.is_paused=1)
          where RN <= 3) b,
        opt_code o
  where b.appcode = o.appcode
