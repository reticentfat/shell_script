数据统计	（2月10日前）请帮忙提取漯河新增全能助理短信版和彩信版计费用户清单
	需求完成时间：2月10日前
	提取要求：提取1月份符合漯河移动用户新增全能助理短信版和彩信版计费用户清单，并注明订购渠道
	需求字段：用户号码 | 短信版还是彩信版 | 订购渠道
	（PS：订购渠道中坐席推荐和群发回复订购渠道请特别标明，其他渠道可用其他代替。我公司群发端口分别为：1065888057771和1065888057772）

	210下载 20110131/province_isjf/河南.txt.bz2
	awk -F',' '{if($13 == "xzyh" && substr($9,1,7) == "2011-01") print}' henan.txt | unix2dos > henan_xzyh.txt
	
	select A.mobile 用户号码,
		   A.optcode APPCODE,
		   A.PROVINCE 省份,
		   A.city 地市,
		   A.oper_name 业务名称,
		   to_char(to_date(BEGINTIME, 'yyyy-mm-dd hh24:mi:ss'),
				   'yyyy-mm-dd hh24:mi:ss') 订购时间,
		   to_char(to_date(ENDTIME, 'yyyy-mm-dd hh24:mi:ss'),
				   'yyyy-mm-dd hh24:mi:ss') 退订时间
	  from (SELECT t1.mobile,
				   t1.optcode,
				   t1.state,
				   T2.PROVINCE,
				   t2.city,
				   t3.oper_name,
				   to_char(to_date(T1.BEGINTIME, 'yyyy-mm-dd hh24:mi:ss'),
						   'yyyy-mm-dd hh24:mi:ss') begintime,
				   to_char(to_date(T1.ENDTIME, 'yyyy-mm-dd hh24:mi:ss'),
						   'yyyy-mm-dd hh24:mi:ss') endtime,
				   CASE
					 WHEN optcode in
						  ('10301037', '10301084', '10301063', '10301028',
						   '10301077', '10301079', '10301087', '10301034',
						   '10301083', '10301013', '10301015', '10301010',
						   '10301038') AND state < 2 and state > 0 THEN
					  '否'
					 WHEN optcode in ('10301091', '10301090', '10301080',
						   '10301035', '10301102', '10301039',
						   '10301052', '10301101', '10301040') AND state < 3 and
						  state > 0 THEN
					  '否'
					 WHEN optcode in ('10301041', '10301051', '10301042') AND
						  state < 4 and state > 0 THEN
					  '否'
				   
					 WHEN optcode in ('10301043', '10301044') AND state < 5 and
						  state > 0 THEN
					  '否'
					 WHEN state = 0 THEN
					  '否'
					 ELSE
					  '是'
				   END isjf
			  FROM tuiding_dz T1, NODIST T2, tb_theory_income_base t3
			 WHERE SUBSTR(T1.userid, 1, 7) = T2.BEGINNO(+)
			   and t1.optcode = t3.appcode) A
	 where A.isjf = '是'
	   and A.city = '漯河'
	   and A.optcode in ('10301009', '10511003')

	
	jf_1 : mobile,opt_code,cartype,job_num,biz_code,subtime,opttime,serial
	
	select j.mobile 用户号码,
		   j.cartype 省份,
		   j.job_num 地市,
		   j.biz_code 业务名称,
		   j.subtime 订购时间,
		   to_char(t.mobile_modify_time, 'yyyy-mm-dd hh24:mi:ss') 退订时间,
		   t.mobile_sub_channel 订购渠道
	  from new_wireless_subscription t, jf_1 j
	 where t.mobile_sn = j.mobile
	   and t.appcode = j.opt_code
	
	
	合并29日群发用户 导入jf_1 取其订购关系并核查渠道不为 SUB_SMS 的号码
	select t.*
	  from new_wireless_subscription t, jf_1 j
	 where t.mobile_sn = j.mobile
	   and t.appcode in ('10301009', '10511003')
	   and t.prior_time >= to_date('2011-01-29','yyyy-mm-dd')
