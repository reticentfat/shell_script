   select 
    count(n.mobile_sn), o.opt_cost                
  from new_wireless_subscription n, opt_code o, mobilenodist m
 where n.appcode = o.appcode
   and substr(n.mobile_sn, 1, 7) = m.beginno
   and o.opt_cost like '%手机%'
   
   and n.mobile_sub_state='3'
   group by o.opt_cost 
   --------------------------------------
select substr(s.dealtime, 1, 8) 点播日期,
       m.province 省份,
       b.oper_name_real 业务名称,
       b.fee 资费,
       count(distinct s.receiver) 点播用户数,
       count(case
               when errordetail = '0' then
                s.receiver
             end) 点播成功条数,
       count(case
               when errordetail = '0' then
                s.receiver
             end) * b.fee 点播预估信息费
  from s200808_temp s, tb_theory_income_base_dianbo b, mobilenodist m
 where substr(s.receiver, 1, 7) = m.beginno
   and dealtime >= '20160211000000'
   and dealtime < '20160218000000'
   and s.serviceid = b.appcode
   and errordetail = '0'
   --and province='河南'
   --and  b.oper_name_real like '%手机医疗%'
 group by m.province, b.oper_name_real, b.fee, substr(s.dealtime, 1, 8)
   
--------------
select count(distinct s.receiver) 点播用户数,
count(case
               when errordetail = '0' then
                s.receiver
             end) 点播成功条数
from s200808_temp s, tb_theory_income_base_dianbo b
where  errordetail = '0'
  and dealtime >= '20160201000000'
   and dealtime < '20160218000000'
   and s.serviceid = b.appcode
   --and  b.oper_name_real like '%手机%'
