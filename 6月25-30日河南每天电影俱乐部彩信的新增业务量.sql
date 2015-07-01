select substr(t.deal_date, 6, 6) 日期,
      -- t.oper_name 业务名称,
       sum(t.new_user_num) 新增用户数
  from tb_rpt_oper_day t, opt_code o
 where t.oper_code = o.opt_type
   --and o.report_class = '1'
   and t.deal_date >= '2015-06-25'
   and t.deal_date < '2015-07-01'
   and t.prov_name = '河南'
   and o.appcode = '10511008'
 group by substr(t.deal_date, 6, 6) 
