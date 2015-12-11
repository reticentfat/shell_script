select substr(deal_date, 0, 7) 日期,
      -- t.oper_name 业务名称,
       sum(t.new_user_num) 新增用户数,
       sum(t.mftd_user_num) "72小时退定量"
  from tb_rpt_oper_day t, opt_code o
 where t.oper_code = o.opt_type
   --and o.report_class = '1'
   and t.deal_date >= '2014-10-01'
   and t.deal_date < '2015-12-01'
   and t.prov_name = '河南'
   and o.appcode = '10511008'
 group by substr(deal_date, 0, 7)
 order by substr(deal_date, 0, 7)
