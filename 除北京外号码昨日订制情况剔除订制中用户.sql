	select j.mobile, j.opt_code, t.mobile_sub_state
	  from new_wireless_subscription t, jf_1 j
	 where t.mobile_sn = j.mobile
	   and t.appcode = j.opt_code
	   and t.mobile_sub_state = 0
	   and not exists (select 1
			  from mobilenodist n
			 where n.beginno = substrb(j.mobile, 1, 7)
			   and n.city = '北京')
