---------包月收入---：
 select  b.oper_name,sum(t.jf_user_num*b.fee)
  from tb_theory_income t,tb_theory_income_base b
 where t.deal_date in
       ('2016-02-29', '2016-03-31', '2016-04-30', '2016-05-31', '2016-06-30',
        '2016-07-31', '2016-08-31', '2016-09-30', '2016-10-31', '2016-01-31')
       and t.appcode=b.appcode
       and b.appcode in ('10511052','10511055','10511051','10301079','10511084','10301145','10301146','10511086','10301148','10511087','10511088')
       group by b.oper_name
 -----------点播理论收入--------------
    select b.oper_name_real 业务名称,
   b.fee 资费,
       count(case
               when errordetail = '0' then
                s.receiver
             end) * b.fee 点播预估信息费
  from s200808_temp s, tb_theory_income_base_dianbo b, mobilenodist m
 where substr(s.receiver, 1, 7) = m.beginno
   and dealtime >= '20160101000000'
   and dealtime < '20161101000000'
   and s.serviceid = b.appcode
   and errordetail = '0'
   --and province='河南'
   and  b.oper_name_real like '%手机商界%'
 group by  b.oper_name_real,b.fee
 ---------------
 手机商界_商信服务	5	50657175
手机商界_商情慧眼	2	9014858
