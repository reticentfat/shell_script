	11.	数据统计	匹配需求：请协助匹配一批号码的《营养百科彩信版》+《彩信折扣券》开通退订状况及过滤仍在在订号码
	需求描述：匹配附件号码截止11月29日24时是否开通了《营养百科彩信》、《彩信折扣券》
	字段：在原有字段列中，增加两列字段，即增加“是否开通了营养百科彩信”、“是否开通了彩折业务”
	统计周期时间：截止11月29日24时

	ps.使用当前订购状态
	jf_1 : opt_code,subtime,mobile,opttime,cartype,job_num,serial,biz_code
	
	select distinct A.opt_code,
					A.subtime,
					A.mobile,
					A.opttime,
					A.isYYBK,
					B.isYHQ
	  from (select j.opt_code, j.subtime, j.mobile, j.opttime, case
					  when t.mobile_sn is null then
					   '未开通营养百科彩信'
					  else
					   '已开通营养百科彩信'
					end isYYBK
			  from jf_1 j
			  left join new_wireless_subscription t on j.mobile = t.mobile_sn
												   and t.appcode = '10511004'
												   and t.mobile_sub_state = 3) A,
		   (select j.opt_code, j.subtime, j.mobile, j.opttime, case
					  when t.mobile_sn is null then
					   '未开通彩折业务'
					  else
					   '已开通彩折业务'
					end isYHQ
			  from jf_1 j
			  left join new_wireless_subscription t on j.mobile = t.mobile_sn
												   and t.appcode = '10511024'
												   and t.mobile_sub_state = 3) B
	 where A.mobile = B.mobile
	 
	测试各自已开通的是否正确
	select * from new_wireless_subscription where appcode = '10511004' and mobile_sub_state = 3
	and mobile_sn in ()
	测试均未开通的是否正确
	select j.mobile, t.mobile_sn
	from jf_1 j
	left join new_wireless_subscription t on j.mobile = t.mobile_sn
								 and t.appcode in ('10511004', '10511024')
								 and t.mobile_sub_state = 3 where t.mobile_sn is not null
