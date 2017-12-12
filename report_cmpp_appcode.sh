#!/bin/sh
. /usr/local/app/dana/current/shbb/profile
#. /home/shihy/bin/shbb_20090423/profile
usage () {
    echo "usage: $0  target_dir" 1>&2
    exit 2
}

if [ $# -lt 1 ] ; then
    usage
fi
V_DATE=$1
V_YEAR=$(echo $V_DATE | cut -c 1-4)
SOURCE_DIR=$AUTO_DATA_TARGET/$V_YEAR/$V_DATE
TARGET_DIR=$AUTO_DATA_REPORT/$V_YEAR/$V_DATE
CODE_DIR=$AUTO_DATA_NODIST
if [ ! -d "$TARGET_DIR" ]; then
  if ! mkdir -p $TARGET_DIR
  then
    echo "mkdir $TARGET_DIR error"
    exit 1
  fi
fi

if [ ! -d "$SOURCE_DIR" ]; then
  echo "$SOURCE_DIR not found"
  exit 1
fi

# 字典表文件
code_file=$CODE_DIR/cmpp_status.txt
# 省编码字典表
code_city_file=$CODE_DIR/nodist_city.txt
# appcode分部门字典
code_sour=$CODE_DIR/appcode.txt.bz2
code_appcode_dept=$TARGET_DIR/appcode_$$
bzcat $code_sour >$code_appcode_dept
# 数据源
 sourc_file_out=$SOURCE_DIR/cmpp_out.txt
 sourc_file_mt=$SOURCE_DIR/cmpp_mt.txt
#报表文件
report_file1=$TARGET_DIR/report.region.cmpp_service_province.csv
ERROR=0
# 匹配记录数
gawk -F\| '{
   if(FILENAME=="'$code_file'")
   {
   	if($2>0)
    {
    	i++
      staut_code[$1]=$2
      staut_code_order[i]=$1
    }
   }
   else if(FILENAME=="'$code_city_file'")
   {
   		provi[$4]=$4","$1
      p[$4","$1]=1
   }
   else if(FILENAME=="'$code_appcode_dept'")
   {
   	dept[$2]=$3
   	dept_name[$5]=$3","$6","$1
   }
   else if(FILENAME=="'$sourc_file_out'")
   {
      appcode=$8
 	if($27 in provi)
    	{
      	  service_name=(length(dept_name[appcode]))>0?dept_name[appcode]:"未知,0,未知"
     	  indexstr=provi[$27]","appcode","service_name
    	}
   	else
   	{
      	  service_name=(length(dept_name[appcode]))>0?dept_name[appcode]:"未知,0,未知"
      	  indexstr="000,未知,"appcode","service_name
    	}
      provi_out[indexstr]++
      pro_app[indexstr]=1
      #状态结果格式xx:xxxx
      stastus=$22
      if(stastus==0)
      {
        provi_succ[indexstr]++
      }
      else
      {
       	#下发失败的数据
       	if(substr(stastus,1,2) in staut_code)
       	{
           provi_re_fail[indexstr","substr(stastus,1,2)]++
       	}
       	else
       	{
       	   provi_re_fail[indexstr",OTHERS"]++
       	}
     }
     #算时间差
     t=$24 #提交时间
      yy=substr(t,1,4);mm=substr(t,5,2);dd=substr(t,7,2);hh=substr(t,9,2) ;Mi=substr(t,11,2); ss=substr(t,13,2)
      s=yy" "mm" "dd" "hh" "Mi" "ss
      a=mktime(s)
      t=$25 #移动网关处理时间
      yy=substr(t,1,4);mm=substr(t,5,2);dd=substr(t,7,2);hh=substr(t,9,2) ;Mi=substr(t,11,2); ss=substr(t,13,2)
      s=yy" "mm" "dd" "hh" "Mi" "ss
      b=mktime(s)
      t=(b-a)/60
      if(t<=1)
      {
       	wait_1[indexstr]++
      }
      else if((t>1)&&(t<=2))
      {
       	wait_2[indexstr]++
      }
      else if((t>2)&&(t<=5))
      {
       	wait_3[indexstr]++
      }
      else
      {
       	wait_other[indexstr]++
      }
      #print FILENAME
   }
  else if(FILENAME=="'$sourc_file_mt'") #未匹配的处理
  {
 		#接受状态
   stastus=$21
   appcode=$8
   if($23 in provi)
    {
      service_name=(length(dept_name[appcode]))>0?dept_name[appcode]:"未知,0,未知"
      indexstr=provi[$23]","appcode","service_name
    }
    else
    {
      service_name=(length(dept_name[appcode]))>0?dept_name[appcode]:"未知,0,未知"
      indexstr="000,未知,"appcode","service_name
    }
	 	pro_app[indexstr]=1
 		if(stastus==0)
 		{
 			provi_send_succ[indexstr]++
 		}
 		else
 		{
 			provi_send_fail[indexstr]++
 		}
 	}
}END{
     i++
     staut_code_order[i]="OTHERS"
     #形成列标题
     title="省编码,省名称,业务编号,业务名称,部门id,业务部门,下行提交总量,提交失败量,成功提交量,成功接收量,下行接收成功率%"
     title=title",延时小于1M,延时大于2M小于3M,延时大于3M小于5M,延时大于5M"
     for(a=1;a<=i;a++)
     {
     	title=title",接收失败("staut_code_order[a]")"
     }
     title=title",无状态报告条数"
		 print title > "'$report_file1'"
     for(name in pro_app)
     {
			 all_send=provi_out[name]+provi_send_succ[name]+provi_send_fail[name]
			 send_succ=provi_out[name]+provi_send_succ[name]
			 no_report=provi_send_succ[name]+provi_send_fail[name]
			 succ_rate=all_send>0?(provi_succ[name]*100/all_send):0
			 wait_rate_1=all_send>0?(wait_1[name]*100/all_send):0
			 wait_rate_2=all_send>0?(wait_2[name]*100/all_send):0
			 wait_rate_3=all_send>0?(wait_3[name]*100/all_send):0
			 wait_rate_other=all_send>0?(wait_other[name]*100/all_send):0

       str_1=""
       for(a=1;a<=i;a++)
       {
       	str_1=str_1","(provi_re_fail[name","staut_code_order[a]]>0?provi_re_fail[name","staut_code_order[a]]:0)
       }
     printf("%s,%d,%d,%d,%d,%.2f%,%.2f%,%.2f%,%.2f%,%.2f%s%s,%d\n",name,all_send,provi_send_fail[name],send_succ,provi_succ[name],succ_rate,wait_rate_1,wait_rate_2,wait_rate_3,wait_rate_other,"%",str_1,no_report)>>"'$report_file1'"
     }
  }' $code_file $code_city_file $code_appcode_dept $sourc_file_out $sourc_file_mt
if [ $? -ne 0 ];then
 rm $code_appcode_dept
 exit 1
fi
 rm $code_appcode_dept

