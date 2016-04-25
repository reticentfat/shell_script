select A.opt_code,
       A.mobile,
       A.cartype,
       A.subtime
    from (select j.subtime, j.mobile, j.opt_code, j.cartype
        from jf_1 j
       ) A
    left join (select t.mobile_sn, t.prior_time, o.opt_cost
           from new_wireless_subscription t, opt_code o
          where t.appcode = o.appcode
          and t.appcode in
            ('10511050')) B on B.mobile_sn =
                                   A.mobile
  where B.mobile_sn is null
