10.	数据统计	BOSS与其他6个平台全量订购关系比对差异数据
	片区反馈，按照山东移动账务中心要求，需我们对附件压缩包中的boss_0083_ntc.txt文件（BOSS比平台多的非套餐类差异数据），进行数据进行核对确认，核对是否在平台侧没有订购关系。
    将核对出在平台侧已有订购关系的数据，将有订购关系的数据提出，格式不变，将文件名标为boss_平台代码_ntc_report.txt

	select A.MOBILE, A.BIZ_CODE, A.OPT_CODE
	  from (select j.mobile, j.biz_code, j.opt_code, o.appcode
			  from jf_1 j, opt_code o
			 where j.opt_code = o.jfcode) A
	  left join new_wireless_subscription t on A.MOBILE = t.mobile_sn
										   and A.APPCODE = t.appcode
										   and t.mobile_sub_state = 3
	 where t.mobile_sn is not null

11.	数据统计	请确认泰安移动提供前向业务无效号码业务状态
    附件是泰安移动提供的前向业务无效用户号码（共21个），需我们匹配一下订购情况，需求为：

	需求描述：匹配附件号码的订购情况
	匹配字段：在附表中增加三个字段，即所订业务、订购时间、退订时间 

	select A.MOBILE 号码,
		   o.opt_cost 所订业务,
		   to_char(A.PRIOR_TIME, 'yyyy-mm-dd hh24:mi:ss') 订购时间,
		   to_char(A.MOBILE_MODIFY_TIME, 'yyyy-mm-dd hh24:mi:ss') 取消时间
	  from (select j.mobile, t.appcode, t.prior_time, t.mobile_modify_time
			  from jf_1 j
			  left join new_wireless_subscription t on j.mobile = t.mobile_sn) A left join
		   opt_code o
	 on A.APPCODE = o.appcode
