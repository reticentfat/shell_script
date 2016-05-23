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
	11.	数据统计	为做12月短信宣传，请协助剔除已定制车务提醒或汽车宝典的用户号码
	匹配附件号码截至11月30日定制《车主业务》和《汽车宝典》业务的情况
	在号码后面增加字段： 是否定制车主业务    是否定制汽车宝典业务

	select distinct A.mobile,
					A.isWZ,
					B.isQCBD
	  from (select j.mobile,
				   case
					 when f.mobile_sn is null then
					  '未定制车主业务'
					 else
					  '已定制车主业务'
				   end isWZ
			  from jf_1 j
			  left join fswz f on j.mobile = f.mobile_sn
							  and f.mobile_sub_state = 3) A,
		   (select j.mobile,
				   case
					 when t.mobile_sn is null then
					  '未定制汽车宝典'
					 else
					  '已定制汽车宝典'
				   end isQCBD
			  from jf_1 j
			  left join new_wireless_subscription t on j.mobile = t.mobile_sn
												   and t.appcode = '10511005'
												   and t.mobile_sub_state = 3) B
	 where A.mobile = B.mobile

	
	awk -F'\t' '{if($2=="已定制车主业务"&&$3=="已定制汽车宝典") print}' gdcz.txt > gdcz_wz_bd.txt
	awk -F'\t' '{if($2=="已定制车主业务"&&$3=="未定制汽车宝典") print}' gdcz.txt > gdcz_wz.txt
	awk -F'\t' '{if($2=="未定制车主业务"&&$3=="已定制汽车宝典") print}' gdcz.txt > gdcz_bd.txt
	awk -F'\t' '{if($2=="未定制车主业务"&&$3=="未定制汽车宝典") print}' gdcz.txt > gdcz_both_not.txt
	
	
	验证：
	select j.mobile, t.mobile_sn
	from jf_1 j
	left join new_wireless_subscription t on j.mobile = t.mobile_sn
								 and t.appcode = '10511005'
								 and t.mobile_sub_state = 3 where t.mobile_sn is not null

	select j.mobile, f.mobile_sn
	from jf_1 j
	left join fswz f on j.mobile = f.mobile_sn
					 and f.mobile_sub_state = 3 where f.mobile_sn is not null
								 
