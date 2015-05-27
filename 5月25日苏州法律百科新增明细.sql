select n.mobile_sn 号码,
       to_char(n.mobile_sub_time, 'yyyy-mm-dd hh24:mi:ss') 开通时间,
       to_char(n.mobile_modify_time, 'yyyy-mm-dd hh24:mi:ss') 退订日期,
       n.mobile_sub_channel 开通渠道
  from new_wireless_subscription n, mobilenodist m
 where n.appcode = '10511051'
   and substr(n.mobile_sn, 1, 7) = m.beginno
   and n.mobile_sub_time >= to_date('2015-05-25', 'yyyy-mm-dd')
   and n.mobile_sub_time < to_date('2015-05-26', 'yyyy-mm-dd')
   and m.city = '苏州'
   ---------------接下来匹配上行-----
   bzcat /data/match/cmpp/20150525/monster-cmppmo.log.*.bz2  | grep -e ',1065888060,'  |  awk -F':' '{print $4}' | awk -F',' '{print substr($1,2,14)"^"$6"^"$10"^"$14"^"$26"^"$27"^"$28}' | bzip2  > /data/wuying/1065888060_08wy.txt.bz2
   awk -F'^' '{if (toupper(substr($7,1,1))=="F" ) print $1"^"$3"^"$4"^"$7}'  1065888060_08wy.txt> 123wy.txt
------------------------------------------------------------
select * from r200904 r where r.receiver='1065888090'
and r.msg like 'wse%'
and r.dealtime>='20140801000000'
