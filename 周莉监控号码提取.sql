 select b.mobile_sn, b.mobile_sub_time, o.opt_cost
   from (select *
           from (select t.*,
                        row_number() over(partition by t.appcode order by t.mobile_sn desc) RN
                   from new_wireless_subscription t 
                   where t.appcode in ('10301079','10511051','10511012','10301015','10301009','10511003','10511039','10511022')
                   and  t.mobile_sub_time>= to_date('2017-02-20', 'yyyy-mm-dd')
                   and t.mobile_sub_time< to_date('2017-02-25', 'yyyy-mm-dd'))
          where RN <= 5) b,
        opt_code o
  where b.appcode = o.appcode
