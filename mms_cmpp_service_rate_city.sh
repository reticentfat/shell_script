#!/bin/sh
. /usr/local/app/dana/current/shbb/profile
#. /home/chenly/profile
#彩信网关及时率 分地市
usage () {
		echo "usage: $0	target_dir" 1>&2
		exit 2
}

if [ $# -lt 1 ] ; then
		usage
fi
V_DATE=$1
V_YEAR=$(echo $V_DATE | cut -c 1-4)
TARGET_DIR=$AUTO_DATA_TARGET/$V_YEAR/$V_DATE
REPORT_DIR=$AUTO_DATA_REPORT/$V_YEAR/$V_DATE
#REPORT_DIR=~
if [ ! -d "$TARGET_DIR" ]; then
	echo "$TARGET_DIR not found"
	exit 1
fi

CODE_DIR=$AUTO_DATA_NODIST
if [ ! -d "$REPORT_DIR" ]; then
	if ! mkdir -p $REPORT_DIR
	then
		echo "mkdir $REPORT_DIR error"
		exit 1
	fi
fi

# appcode分部门字典
if [ ! -f $CODE_DIR/appcode.txt.bz2 ];then
	exit 1
fi
code_appcode_dept=$TARGET_DIR/tmp_mm7_city.txt
bzcat $CODE_DIR/appcode.txt.bz2 > $code_appcode_dept
# 数据源
sourc_file_out=$TARGET_DIR/mm7_out.txt
sourc_file_mt=$TARGET_DIR/mm7_mt.txt
#报表文件
report_file=$REPORT_DIR/report.region.mms_cmpp_service_rate_byport_city.csv

gawk -F\| '{
	if(FILENAME=="'$code_appcode_dept'")
	{
		dept_name[$5]=$1","$4	 #无线|wuxian_qianxiang|无线-通用产品|帮助信息|10101000|0|UMGYWCXX|2
	}
	else if(FILENAME=="'$sourc_file_out'")
	{  
		stastus=$3
		port_id=$11
		appcode=$2
		province=$5
		provname=$7
		city=$4
		cityname=$6
		userid=$1
		flowno=$8
		service_name=(length(dept_name[appcode]))>0?dept_name[appcode]:"未知,未知"
		indexstr=province","provname","city","cityname","port_id","appcode","service_name","stastus
		t=$9 #提交时间
		yy=substr(t,1,4);mm=substr(t,5,2);dd=substr(t,7,2);hh=substr(t,9,2) ;Mi=substr(t,11,2); ss=substr(t,13,2)
		s=yy" "mm" "dd" "hh" "Mi" "ss
		a=mktime(s)
		t=$10 #移动网关处理时间
		yy=substr(t,1,4);mm=substr(t,5,2);dd=substr(t,7,2);hh=substr(t,9,2) ;Mi=substr(t,11,2); ss=substr(t,13,2)
		s=yy" "mm" "dd" "hh" "Mi" "ss
		b=mktime(s)
		#算时间差
		time=(b-a)/60
		pro[indexstr]=1 
		out_succ[userid","flowno]=1
		provi_out[indexstr]++
		if((stastus==1000) || (stastus==2000)||(stastus==4446))
		{
			provi_succ[indexstr]++	#成功接收量
			if(time<=1)
			{
				wait_1[indexstr]++
			}
			else if((time>1)&&(time<=2))
			{
				wait_2[indexstr]++
			}
			else if((time>2)&&(time<=5))
			{
				wait_3[indexstr]++
			}
			else
			{
				wait_other[indexstr]++
			}
		}
	}
	else if(FILENAME=="'$sourc_file_mt'") #未匹配的处理
	{ 
		#接受状态
		stastus=$3
		port_id=$9
		appcode=$2
		province=$5
		provname=$7
		city=$4
		cityname=$6
		userid=$1
		flowno=$8
		service_name=(length(dept_name[appcode]))>0 ? dept_name[appcode] : "未知,未知"  
		indexstr=province","provname","city","cityname","port_id","appcode","service_name",未知"

		pro[indexstr]=1 
		mt_all[indexstr]++
		if((stastus==1000)||(stastus==2000)||(stastus==4446))
		{
			provi_send_succ[indexstr]++	  #提交成功量但没有返回状态报告
		}

	}
}END{
		#形成列标题
		title="省编码,省名称,市编码,市名称,端口号,业务编号,业务部门,业务名称,发送状态,下行提交总量,提交失败量,成功提交量,成功接收量,接收失败量"
		title=title",延时小于1M,延时大于1M小于2M,延时大于2M小于5M,延时大于5M,无状态报告条数,扩展字段1,扩展字段2,扩展字段3"
		print title > "'$report_file'"
		for(name in pro) #打印特殊省份的指标信息
		{  
			all_send=provi_out[name]+mt_all[name]							#下行提交总量
			send_succ=provi_out[name]+provi_send_succ[name]					#成功提交量
			send_fail=all_send-send_succ									#提交失败量 === mt_all[name]-provi_send_succ[name]
			provi_fail=send_succ-(provi_succ[name]+provi_send_succ[name])	#接收失败量=成功提交量-(成功接收量+提交成功量但没有返回状态报告量) === provi_out[name]-provi_succ[name] 接收总量 - 接收成功量
			printf("%s,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\n",name,all_send,send_fail,send_succ,provi_succ[name],provi_fail,wait_1[name],wait_2[name],wait_3[name],wait_other[name],provi_send_succ[name],0,0,0)>>"'$report_file'"
		}
	}' $code_appcode_dept $sourc_file_out $sourc_file_mt

if [ $? -ne 0 ];then
	rm $code_appcode_dept
	exit 1
else
	exit 0
fi

