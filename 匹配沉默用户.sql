导入jf_2查看在线情况（分前向和生活播报两个库）
select j.mobile,n.appcode from jf_2 j ,new_wireless_subscription n
where j.mobile=n.mobile_sn
and j.job_num=n.appcode
and n.mobile_sub_state='3'
-------匹配下发条数-------------
---25上------------------------
-------前向彩信--------------------------
awk  -F',' -v CODE_DIR=/data/match/mm7/20160628/stats_month.wuxian_qianxiang.1000 -v fileok=pipei_mms_6yue_ok.txt -v fileno=pipei_mms_6yue_0.txt '{
	if( FILENAME == CODE_DIR  )  d[$1$2]=$1","$2","$3;
	 else if ( FILENAME != CODE_DIR    &&  $1$2 in d ) print d[$1$2] >> fileok ;
	 else if ( FILENAME != CODE_DIR    && !($1$2 in d )) print $1","$2",0" >> fileno ;
	}' /data/match/mm7/20160628/stats_month.wuxian_qianxiang.1000 pipei_mms.txt
	cat pipei_mms_6yue_ok.txt | head -5
		cat pipei_mms_6yue_0.txt | head -5
		awk  -F',' -v CODE_DIR=/data/match/mm7/20160531/stats_month.wuxian_qianxiang.1000 -v fileok=pipei_mms_6yue_0_5yueok.txt -v fileno=pipei_mms_6yue_0_5yue0.txt '{
	if( FILENAME == CODE_DIR  )  d[$1$2]=$1","$2","$3;
	 else if ( FILENAME != CODE_DIR    &&  $1$2 in d ) print d[$1$2] >> fileok ;
	 else if ( FILENAME != CODE_DIR    && !($1$2 in d )) print $1","$2",0" >> fileno ;
	}' /data/match/mm7/20160531/stats_month.wuxian_qianxiang.1000 pipei_mms_6yue_0.txt
			awk  -F',' -v CODE_DIR=/data/match/mm7/20160430/stats_month.wuxian_qianxiang.1000 -v fileok=pipei_mms_6yue_0_5yue0_4yueok.txt -v fileno=pipei_mms_6yue_0_5yue0_4yue0.txt '{
	if( FILENAME == CODE_DIR  )  d[$1$2]=$1","$2","$3;
	 else if ( FILENAME != CODE_DIR    &&  $1$2 in d ) print d[$1$2] >> fileok ;
	 else if ( FILENAME != CODE_DIR    && !($1$2 in d )) print $1","$2",0" >> fileno ;
	}' /data/match/mm7/20160430/stats_month.wuxian_qianxiang.1000 pipei_mms_6yue_0_5yue0.txt
	-------前向短信--------------------------
	awk  -F',' -v CODE_DIR=/data/match/cmpp/20160628/stats_month.wuxian_qianxiang.0 -v fileok=pipei_sms_6yueok.txt -v fileno=pipei_sms_6yue0.txt '{
	if( FILENAME == CODE_DIR  )  d[$1$2]=$1","$2","$3;
	 else if ( FILENAME != CODE_DIR    &&  $1$2 in d ) print d[$1$2] >> fileok ;
	 else if ( FILENAME != CODE_DIR    && !($1$2 in d )) print $1","$2",0" >> fileno ;
	}' /data/match/cmpp/20160628/stats_month.wuxian_qianxiang.0 pipei_sms.txt
	awk  -F',' -v CODE_DIR=/data/match/cmpp/20160531/stats_month.wuxian_qianxiang.0 -v fileok=pipei_sms_6yue0.txt_5yueok.txt -v fileno=pipei_sms_6yue0_5yue0.txt '{
	if( FILENAME == CODE_DIR  )  d[$1$2]=$1","$2","$3;
	 else if ( FILENAME != CODE_DIR    &&  $1$2 in d ) print d[$1$2] >> fileok ;
	 else if ( FILENAME != CODE_DIR    && !($1$2 in d )) print $1","$2",0" >> fileno ;
	}' /data/match/cmpp/20160531/stats_month.wuxian_qianxiang.0 pipei_sms_6yue0.txt
	--------------------生活播报彩信匹配-----------------------
	awk  -F',' -v CODE_DIR=/data/match/mm7/20160628/stats_month.bizdev_shenghbb.1000 -v fileok=pipei_shbb_6yue_ok.txt -v fileno=pipei_shbb_6yue_0.txt '{
	if( FILENAME == CODE_DIR  )  d[$1$2]=$1","$2","$3;
	 else if ( FILENAME != CODE_DIR    &&  $1$2 in d ) print d[$1$2] >> fileok ;
	 else if ( FILENAME != CODE_DIR    && !($1$2 in d )) print $1","$2",0" >> fileno ;
	}' /data/match/mm7/20160628/stats_month.bizdev_shenghbb.1000 pipei_shbb.txt
	awk  -F',' -v CODE_DIR=/data/match/mm7/20160531/stats_month.bizdev_shenghbb.1000 -v fileok=pipei_shbb_6yue0_5yueok.txt -v fileno=pipei_shbb_6yue0_5yue0.txt '{
	if( FILENAME == CODE_DIR  )  d[$1$2]=$1","$2","$3;
	 else if ( FILENAME != CODE_DIR    &&  $1$2 in d ) print d[$1$2] >> fileok ;
	 else if ( FILENAME != CODE_DIR    && !($1$2 in d )) print $1","$2",0" >> fileno ;
	}' /data/match/mm7/20160531/stats_month.bizdev_shenghbb.1000 pipei_shbb_6yue_0.txt
		awk  -F',' -v CODE_DIR=/data/match/mm7/20160430/stats_month.bizdev_shenghbb.1000 -v fileok=pipei_shbb_6yue0_5yue0_4yueok.txt -v fileno=pipei_shbb_6yue0_5yue0_4yue0.txt '{
	if( FILENAME == CODE_DIR  )  d[$1$2]=$1","$2","$3;
	 else if ( FILENAME != CODE_DIR    &&  $1$2 in d ) print d[$1$2] >> fileok ;
	 else if ( FILENAME != CODE_DIR    && !($1$2 in d )) print $1","$2",0" >> fileno ;
	}' /data/match/mm7/20160430/stats_month.bizdev_shenghbb.1000 pipei_shbb_6yue0_5yue0.txt
	
