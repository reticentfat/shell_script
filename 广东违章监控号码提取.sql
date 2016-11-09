select --f.id codeId, 
f.mobile_sn 手机号码, 
m.city 地市, 
f.car_no 车牌, 
o.opt_type
from fswz f, opt_code o,mobilenodist m 
where 'F' || f.fee_app_code = o.opt_type 
and f.mobile_sub_state = 3 
and substr(f.mobile_sn,1,7)=m.beginno 
and m.province='广东' 
and m.city='广州' 
and o.opt_type='F3'
--------------F几就是几元-----------
