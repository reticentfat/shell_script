select substr(t.deal_date, 0, 4),
       t.oper_name,
       sum(case
             when substr(t.deal_date, 6, 5) = '01-01' THEN
              t.on_user_num
             ELSE
              0
           END),
       sum(t.new_user_num),
       sum(t.td_user_num)
  from tb_rpt_oper_day t, opt_code o
 where t.oper_code = o.opt_type
   and o.report_class = '1'
   and t.deal_date >= '2012-01-01'
   and t.deal_date < '2015-06-11'
 group by substr(t.deal_date, 0, 4), t.oper_name
