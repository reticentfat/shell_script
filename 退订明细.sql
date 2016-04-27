3.	数据统计	请协助提取9月几个产品退订明细
	需求描述：提取9月份广东营养百科短信、营养百科彩信和彩信折扣券各渠道和各情形的退订量                    
	字段：产品、地市、退订情形（“当月定免费期后退”和“老用户退订”、退订渠道、退订数量
	维度：广东二级地市
	统计周期时间：自然月

	当月定免费期后退： 定制时间超过72小时的退订
	老用户退订：9月留存用户的退订
	
	select o.opt_cost 业务名称,
		   n.city 地市,
		   substr(subcodes,
				  instr(subcodes, '|', 1, 11) + 1,
				  (instr(subcodes, '|', 1, 12) - instr(subcodes, '|', 1, 11)) - 1) 退订渠道,
		   count(distinct case
				   when substr(to_char(a.start_time, 'yyyy-mm-dd hh24:mi:ss'), 1, 7) =
						substr(to_char(a.end_time, 'yyyy-mm-dd hh24:mi:ss'), 1, 7) and
						(a.end_time - a.start_time) * 24 > 72 then
					a.mobile
				   else
					null
				 end) 当月定免费期后退,
		   count(distinct case
				   when a.start_time < to_date('2010-09-01', 'yyyy-mm-dd') then
					a.mobile
				   else
					null
				 end) 老用户退订
	  from new_archives a, opt_code o, mobilenodist n
	 where substr(a.mobile, 1, 7) = n.beginno(+)
	   and a.appcode = o.appcode
	   and n.province = '广东'
	   and a.appcode in ('10301010', '10511004', '10511024')
	   and a.end_time >= to_date('2010-09-01', 'yyyy-mm-dd')
	   and a.end_time < to_date('2010-10-01', 'yyyy-mm-dd')
	 group by o.opt_cost,
			  n.city,
			  substr(subcodes,
					 instr(subcodes, '|', 1, 11) + 1,
					 (instr(subcodes, '|', 1, 12) - instr(subcodes, '|', 1, 11)) - 1)
