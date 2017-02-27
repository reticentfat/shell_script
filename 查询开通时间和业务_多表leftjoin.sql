select j.mobile, b.id, b.mobile_sub_time, o.opt_cost
  from jf_1 j
  left join bjwz b
    on j.mobile = b.mobile_sn
  left join  opt_code_all o on b.opt_type = o.opt_type
