select m.city               号码归属地,
       n.mobile_sn          用户号码,
       to_char(n.mobile_sub_time,'yyyy-mm-dd hh24:mi:ss')    订购时间,
       to_char(n.mobile_modify_time,'yyyy-mm-dd hh24:mi:ss') 退定时间,--n.mobile_sub_channel,
       o.opt_cost 业务名称
  from  new_wireless_subscription n, opt_code o, mobilenodist m
 where n.appcode = o.appcode
   and substr(n.mobile_sn, 1, 7) = m.beginno
   and n.mobile_sub_time >= to_date('2015-06-01', 'yyyy-mm-dd')
   and n.mobile_sub_time < to_date('2015-07-01', 'yyyy-mm-dd')
   and o.appcode in ( '10301009', '10511003','10301010','10511004','10301079','10511051')
   and m.province = '新疆'
   and n.mobile_sub_channel='SUB_ZUOXI'
   ------------------上边6月下边5月------------
   bzcat /data0/match/orig/20150531/snapshot.txt.bz2 | awk -F'|' '{if ($8=="0991"&&($2=="10511051"||$2=="10301079"||$2=="10511004"||$2=="10301010"||$2=="10511003"||$2=="10301009")&&$5>=20150501000000&&$5<20150601000000&&$11=="SUB_ZUOXI") print  }' >xj5.txt
      bzcat /data0/match/orig/20150630/snapshot.txt.bz2 | awk -F'|' '{if ($8=="0991"&&($2=="10511051"||$2=="10301079"||$2=="10511004"||$2=="10301010"||$2=="10511003"||$2=="10301009")&&$5>=20150601000000&&$5<20150701000000&&$11=="SUB_ZUOXI") print  }' >xj6.txt
