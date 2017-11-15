select * from boss_pk where sys_date>='20170919' and provid='250' and channel='umg_boss'   group by channel,sys_date
select * from boss_pk where sys_date>='20170919'
select n.addr_nation_code,servcode,mobile_sub_channel, count(*)
  from new_wireless_subscription n
 where n.addr_code = '025'
   and n.appcode = '10511052'
   and n.mobile_sub_time >= to_date('2017-09-19', 'yyyy-mm-dd')
 group by n.mobile_sub_channel,servcode,n.addr_nation_code
 
 , new_wireless_subscription

select m.province, msg, count(distinct r.sender)
  from r200904 r, mobilenodist m --,new_wireless_subscription n 
 where substr(r.sender, 1, 7) = m.beginno
   and dealtime >= '20170925000000'
   and dealtime < '20170926000000'
   --and r.sender = n.mobile_sn
  -- and n.servcode = 'FLBK_MMS'
   --and n.mobile_sub_time >= to_date('2017-09-22', 'yyyy-mm-dd')
   --and n.mobile_sub_time < to_date('2017-09-23', 'yyyy-mm-dd')
   and msg in (UPPER('fl1'), UPPER('fl2'), UPPER('fl3'))
 group by m.province, msg
    
    
     select  m.province ,msg,count(distinct r.sender)
   from r200904 r , mobilenodist m ,new_wireless_subscription n 
  where substr(r.sender,1,7)=m.beginno and dealtime >= '20170925000000' and dealtime < '20170926000000'   and r.sender=n.mobile_sn and n.servcode='FLBK_MMS' 
  and n.mobile_sub_time >= to_date('2017-09-25', 'yyyy-mm-dd')-- and n.mobile_sub_time < to_date('2017-09-23', 'yyyy-mm-dd')
    and msg in ( UPPER('fl1'), UPPER('fl2'),UPPER('fl3') )
    group by m.province ,msg
    
    
    select * from bjwz b where b.mobile_sn='15211364442'
