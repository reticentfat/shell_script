 select n.mobile_sn 号码,
    to_char(n.mobile_sub_time, 'yyyy-mm-dd hh24:mi:ss') 订购时间,
    o.opt_cost 业务名称,
    case
                      when n.mobile_sub_state = 3 then
                       '订购中'
                      else
                       '已退定'
                    end 截止目前是否退订
     from new_wireless_subscription n, mobilenodist m , opt_code o
   
    where 
     substr(n.mobile_sn, 1, 7) = m.beginno
    and n.mobile_sub_time< to_date('2015-12-09', 'yyyy-mm-dd')
    and n.mobile_sub_time>= to_date('2015-12-08', 'yyyy-mm-dd')
    and m.city = '濮阳' 
   and n.appcode = o.appcode
    
