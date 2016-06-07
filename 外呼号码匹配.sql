附件是此前订购关系同步期间让省移动帮助外呼的成功客户数据（让我们在平台上加了订购关系），现在他们需要对外呼合作伙伴的工作成果进行评估，因此，需要我们统计一下这些重新确认的订购关系截止4月1日零时在我平台的留订情况。

	需求描述：对附件号码所订业务核实截止4月1日零时在我平台的订退情况

	匹配字段：直接在附件表格最后一列加两个字段，即：“订购时间”、“退订时间”

	jf_1 : opttime,mobile,opt_code,serial,biz_code,cartype,job_num,subtime
	
	select A.opttime 日期,
		   A.mobile 开户号码,
		   A.opt_code 开通业务,
		   A.serial 地市ＩＤ,
		   A.biz_code 外呼商,
		   A.cartype 受理月份,
		   to_char(t.prior_time, 'yyyy-mm-dd hh24:mi:ss') 订制时间,
		   to_char(t.mobile_modify_time, 'yyyy-mm-dd hh24:mi:ss') 取消时间
	  from (select j.opttime,
				   j.mobile,
				   j.opt_code,
				   j.serial,
				   j.biz_code,
				   j.cartype,
				   o.appcode
			  from jf_1 j
			  left join opt_code o on j.opt_code = o.opt_cost) A
	  left join new_wireless_subscription t on A.MOBILE = t.mobile_sn
										   and A.APPCODE = t.appcode
