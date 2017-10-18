select o.optbigclass, sum(t.new_user_num) - sum(t.td_user_num) xzyh
  from tb_rpt_oper_day t, opt_code o
 where deal_date = '2017-10-17'
   and t.oper_code = o.opt_type
   and o.report_class >= 1
   and o.report_class <= 4
 group by o.optbigclass
