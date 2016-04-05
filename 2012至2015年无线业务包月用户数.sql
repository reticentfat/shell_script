select A.省份，A.大类，A.年份,sum(A.在线),sum(A.新增) from (select t.prov_name 省份,

       o.optbigclass 大类,
       substr(t.deal_date, 1, 4) 年份,
       sum(t.on_user_num) 在线,
       0 新增
  from tb_rpt_oper_day t, opt_code o
 where  substr(t.deal_date, 6, 9) = '01-01' 
 and o.opt_type = t.oper_code
 and t.deal_date>='2012-01-01'
 and  t.deal_date<'2016-01-01'
 group by t.prov_name, o.optbigclass, substr(t.deal_date, 1, 4)
 union all
 select t.prov_name 省份,

       o.optbigclass 大类,
       substr(t.deal_date, 1, 4) 年份,
       0 在线,
       sum(t.new_user_num) 新增
  from tb_rpt_oper_day t, opt_code o
 where  t.deal_date>='2012-01-01'
 and  t.deal_date<'2016-01-01'
 and o.opt_type = t.oper_code
 group by t.prov_name, o.optbigclass, substr(t.deal_date, 1, 4))A
 group by A.省份，A.大类，A.年份
--select * from tb_rpt_oper_day t
--select * from opt_code o
-------------电影俱乐部---------------
select A.省份，A.大类，A.年份,sum(A.在线),sum(A.新增) from (select t.prov_name 省份,

       o.optbigclass 大类,
       substr(t.deal_date, 1, 4) 年份,
       sum(t.on_user_num) 在线,
       0 新增
  from tb_rpt_oper_day t, opt_code o
 where  substr(t.deal_date, 6, 9) = '01-01' 
 and o.opt_type = t.oper_code
 and t.deal_date>='2012-01-01'
 and  t.deal_date<'2016-01-01'
 and o.appcode in ('10301013','10511008')
 group by t.prov_name, o.optbigclass, substr(t.deal_date, 1, 4)
 union all
 select t.prov_name 省份,

       o.optbigclass 大类,
       substr(t.deal_date, 1, 4) 年份,
       0 在线,
       sum(t.new_user_num) 新增
  from tb_rpt_oper_day t, opt_code o
 where  t.deal_date>='2012-01-01'
 and  t.deal_date<'2016-01-01'
 and o.opt_type = t.oper_code
  and o.appcode in ('10301013','10511008')
 group by t.prov_name, o.optbigclass, substr(t.deal_date, 1, 4))A
 group by A.省份，A.大类，A.年份
