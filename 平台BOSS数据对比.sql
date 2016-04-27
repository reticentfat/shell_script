新疆提给平台的数据是截止10月22日17点在线用户，格式分别为手机号码，企业代码，业务代码，状态代码，用户首次订购时间，用户订购时间
	请分别比对出BOSS侧有，平台侧没有；BOSS侧没有，平台侧有；BOSS侧和平台侧都有，但状态不一致的三类用户

	BOSS有平台没有：
	select j.serial   序号,
		   j.mobile   用户号码,
		   j.job_num  企业代码,
		   j.opt_code 业务代码,
		   j.cartype  状态代码,
		   j.opttime  首次订购时间,
		   j.subtime  订购时间
	  from (select t.mobile_sn, o.jfcode, t.mobile_sub_time
			  from new_wireless_subscription t, opt_code o, mobilenodist n
			 where substr(t.mobile_sn, 1, 7) = n.beginno
			   and t.appcode = o.appcode
			   and n.province = '新疆'
			   and t.mobile_sub_time <
				   to_date('2010-10-22 17:00:00', 'yyyy-mm-dd hh24:mi:ss')
			   and t.mobile_modify_time >
				   to_date('2010-10-22 17:00:00', 'yyyy-mm-dd hh24:mi:ss')) A
	 right join jf_1 j on A.mobile_sn = j.mobile
					  and A.jfcode = j.opt_code
	 where A.mobile_sn is null
	
	BOSS没有平台有：
	select A.*
	  from (select t.mobile_sn 用户号码,
				   case
					 when substr(t.appcode, 1, 3) = '105' then
					  '801174'
					 when substr(t.appcode, 1, 3) = '103' then
					  '901808'
				   end 企业代码,
				   o.jfcode 业务代码,
				   to_char(t.prior_time, 'yyyy-mm-dd hh24:mi:ss') 首次订购时间,
				   to_char(t.mobile_sub_time, 'yyyy-mm-dd hh24:mi:ss') 订购时间
			  from new_wireless_subscription t, opt_code o, mobilenodist n
			 where substr(t.mobile_sn, 1, 7) = n.beginno
			   and t.appcode = o.appcode
			   and n.province = '新疆'
			   and t.mobile_sub_time <
				   to_date('2010-10-22 17:00:00', 'yyyy-mm-dd hh24:mi:ss')
			   and t.mobile_modify_time >
				   to_date('2010-10-22 17:00:00', 'yyyy-mm-dd hh24:mi:ss')) A
	  left join jf_1 j on A.用户号码 = j.mobile
					  and A.业务代码 = j.opt_code
	 where j.mobile is null
