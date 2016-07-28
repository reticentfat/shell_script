select  j.mobile 手机号,
        b.opt_cost 业务名称,
       b.betime   订购时间,
       b.endtime  退订时间,
       b.mobile_sub_cmd 开通指令,
        b.mobile_sub_channel  开通渠道
  from (select j.mobile, j.opt_code, m.province, m.city
          from jf_1 j, mobilenodist m
         where substr(j.mobile, 1, 7) = m.beginno
          ) j
  left join (select mobile_sn,
                    case
                      when n.mobile_sub_state = 3 then
                       '订购中'
                      else
                       '已退定'
                    end state,
                    o.opt_cost,
                    o.jfcode,
                    to_char(n.mobile_sub_time, 'yyyy-mm-dd hh24:mi:ss') betime,
                    to_char(n.mobile_modify_time, 'yyyy-mm-dd hh24:mi:ss') endtime,
                      n.mobile_sub_cmd ,
        n.mobile_sub_channel  
               from new_wireless_subscription n, opt_code o
              where n.appcode = o.appcode
                and o.appcode = '10511050') b on j.mobile = b.mobile_sn
