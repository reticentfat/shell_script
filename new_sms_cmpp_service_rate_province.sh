#!/bin/sh
. /usr/local/app/dana/current/shbb/profile
#. /home/chenly/profile
usage () {
    echo "usage: $0  target_dir" 1>&2
    exit 2
}

if [ $# -lt 1 ] ; then
    usage
fi
V_DATE=$1
V_YEAR=$(echo $V_DATE | cut -c 1-4)
TARGET_DIR=$AUTO_DATA_TARGET/$V_YEAR/$V_DATE
REPORT_DIR=$AUTO_DATA_REPORT/$V_YEAR/$V_DATE
CODE_DIR=$AUTO_DATA_NODIST

if [ ! -d "$TARGET_DIR" ]; then
  echo "$TARGET_DIR not found"
  exit 1
fi

if [ ! -d "$REPORT_DIR" ]; then
  if ! mkdir -p $REPORT_DIR
  then
    echo "mkdir $REPORT_DIR error"
    exit 1
  fi
fi



# 字典表文件
code_file=$CODE_DIR/cmpp_status.txt
code_file_area=$CODE_DIR/cmpp_area_code.txt
#code_file_area=/home/chenly/cmpp_area_code.txt
# 省编码字典表
code_city_file=$CODE_DIR/nodist_city.txt
# appcode分部门字典
bzcat $CODE_DIR/appcode.txt.bz2 > $TARGET_DIR/tmp_new_sms_appcode.txt
code_appcode_dept=$TARGET_DIR/tmp_new_sms_appcode.txt

# 数据源
sourc_file_out=$TARGET_DIR/cmpp_out.txt
sourc_file_mt=$TARGET_DIR/cmpp_mt.txt
 
TMP_RESULT_MTOUT=$TARGET_DIR/tmp_new_sms_mtout.txt
TMP_RESULT=$TARGET_DIR/tmp_new_sms_cmpp.txt
#报表文件
report_file=$REPORT_DIR/report.region.new_sms_cmpp_service_rate_province.csv
ERROR=0




#对mt文件进行排重，同一条$5","$NF只有一条信息
gawk -F'|' '{
  if(FILENAME=="'$code_file_area'")
  {
    area[$1]=1
  }
  else
  {
			 indexstr=$5","$24
			 all[indexstr]=1
			 if($23 in area)  #长短新拆分，有一条失败即算失败的处理方法
			 {
						 if($21!=0)
						 {
						 		c[indexstr]=1
						   a[1]=1
						   if(!(indexstr in a))
						   {
						     #手机号，流水号，省编码，appcode，提交状态，接收状态，接收时间
						     p[indexstr]=$5"|"$24"|"$23"|"$8"|"$21"|""未知""|"0"|"
						     a[indexstr]=1
						   }
						 }
						 else   
						 {
						   b[1]=1
						   if(!(indexstr in b))
						   {
						     q[indexstr]=$5"|"$24"|"$23"|"$8"|"$21"|""未知""|"0"|"
						     b[indexstr]=1
						   }
						 }
			 }
			 else  #非有一条失败计算失败，而是有一条有成功状态报告计算成功
			 {
						 if($21==0)
						 {
						 		c[indexstr]=1
						   ca[1]=1
						   if(!(indexstr in ca))
						   {
						     #手机号，流水号，省编码，appcode，提交状态，接收状态，接收时间
						     p[indexstr]=$5"|"$24"|"$23"|"$8"|"$21"|""未知""|"0"|"
						     ca[indexstr]=1
						   }
						 }
						 else
						 {			 
						   cb[1]=1
						   if(!(indexstr in cb))
						   {
						     q[indexstr]=$5"|"$24"|"$23"|"$8"|"$21"|""未知""|"0"|"
						     cb[indexstr]=1
						   }
						 }			   
			 }
  }
}END{
  for(name in all)
  {
		  if(name in c)
		  {
		    print p[name]
		  }    
		  else
		  {
		    print q[name]
		  }
  }
}' $code_file_area $sourc_file_mt > $TMP_RESULT_MTOUT

#对out文件进行排重，同一条$5","$NF只有一条信息
gawk -F'|' '{
  if(FILENAME=="'$code_file_area'")
  {
    area[$1]=1
  }
  else
  {
		  indexstr=$5","$28
		  c[indexstr]=1
		  if($27 in area)  #长短新拆分，有一条失败即算失败的处理方法
		  {
					  if($22!=0)
					  {
					    aa[1]=1
					    if(!(indexstr in aa))
					    { #手机号，流水号，省编码，appcode，提交状态，接收状态，接收时间
					      t=$24 #提交时间
									  yy=substr(t,1,4);mm=substr(t,5,2);dd=substr(t,7,2);hh=substr(t,9,2) ;Mi=substr(t,11,2); ss=substr(t,13,2)
									  s=yy" "mm" "dd" "hh" "Mi" "ss
									  a=mktime(s)
									  t=$25 #移动网关处理时间
									  yy=substr(t,1,4);mm=substr(t,5,2);dd=substr(t,7,2);hh=substr(t,9,2) ;Mi=substr(t,11,2); ss=substr(t,13,2)
									  s=yy" "mm" "dd" "hh" "Mi" "ss
									  b=mktime(s)
									  #算时间差
									  t=(b-a)/60
					      p[indexstr]=$5"|"$28"|"$27"|"$8"|"0"|"$22"|"t"|"
					      aa[indexstr]=1
							    ac[indexstr]=1
					    }
					  }
					  else
					  {
					    bb[1]=1
					    if(!(indexstr in bb))
					    {
					      t=$24 #提交时间
									  yy=substr(t,1,4);mm=substr(t,5,2);dd=substr(t,7,2);hh=substr(t,9,2) ;Mi=substr(t,11,2); ss=substr(t,13,2)
									  s=yy" "mm" "dd" "hh" "Mi" "ss
									  a=mktime(s)
									  t=$25 #移动网关处理时间
									  yy=substr(t,1,4);mm=substr(t,5,2);dd=substr(t,7,2);hh=substr(t,9,2) ;Mi=substr(t,11,2); ss=substr(t,13,2)
									  s=yy" "mm" "dd" "hh" "Mi" "ss
									  b=mktime(s)
									  #算时间差
									  t=(b-a)/60    
					      q[indexstr]=$5"|"$28"|"$27"|"$8"|"0"|"$22"|"t"|"
					      bb[indexstr]=1
					    }
					  }
				}
		  else
		  {
					  if($22==0)
					  {					  
					    cc[1]=1
					    if(!(indexstr in cc))
					    { #手机号，流水号，省编码，appcode，提交状态，接收状态，接收时间
					      t=$24 #提交时间
									  yy=substr(t,1,4);mm=substr(t,5,2);dd=substr(t,7,2);hh=substr(t,9,2) ;Mi=substr(t,11,2); ss=substr(t,13,2)
									  s=yy" "mm" "dd" "hh" "Mi" "ss
									  a=mktime(s)
									  t=$25 #移动网关处理时间
									  yy=substr(t,1,4);mm=substr(t,5,2);dd=substr(t,7,2);hh=substr(t,9,2) ;Mi=substr(t,11,2); ss=substr(t,13,2)
									  s=yy" "mm" "dd" "hh" "Mi" "ss
									  b=mktime(s)
									  #算时间差
									  t=(b-a)/60
					      p[indexstr]=$5"|"$28"|"$27"|"$8"|"0"|"$22"|"t"|"
					      cc[indexstr]=1
						     ac[indexstr]=1
					    }
					  }
					  else
					  {
					    ee[1]=1
					    if(!(indexstr in ee))
					    {
					      t=$24 #提交时间
									  yy=substr(t,1,4);mm=substr(t,5,2);dd=substr(t,7,2);hh=substr(t,9,2) ;Mi=substr(t,11,2); ss=substr(t,13,2)
									  s=yy" "mm" "dd" "hh" "Mi" "ss
									  a=mktime(s)
									  t=$25 #移动网关处理时间
									  yy=substr(t,1,4);mm=substr(t,5,2);dd=substr(t,7,2);hh=substr(t,9,2) ;Mi=substr(t,11,2); ss=substr(t,13,2)
									  s=yy" "mm" "dd" "hh" "Mi" "ss
									  b=mktime(s)
									  #算时间差
									  t=(b-a)/60    
					      q[indexstr]=$5"|"$28"|"$27"|"$8"|"0"|"$22"|"t"|"
					      ee[indexstr]=1
					    }
					  }
					}
		}
}END{
  for(name in c)
  {
    if(name in ac)
    {
      print p[name]    
    }
    else
    {
      print q[name]
    }
  }
}' $code_file_area $sourc_file_out >> $TMP_RESULT_MTOUT


#将mt文件和out文件的排重结果放在一起再排重，按照不同的业务规则，如北京的长短信拆分后有一条失败即算失败
gawk -F'|' '{
   if(FILENAME=="'$code_file_area'")
   {
     area[$1]=1
   }
   else
   {
			  indexstr=$1","$2
			  c[indexstr]=1
			  if($3 in area)
			  {  
				    #a[1]=1  #如果是area中的省份，则取第一条数据(由于$TMP_RESULT_MTOUT中打印数据时是先打印mt的数据，所以mt数据优先)
				    if(!(indexstr in a))
				    { 
				      #省编码，appcode，提交状态，接收状态，接收时间
				      p[indexstr]=$3"|"$4"|"$5"|"$6"|"$7"|"
				      a[indexstr]=1
				    }
			  }
			  else
			  {  #如果不是area中的省份，则以最后一条数据为准(由于$TMP_RESULT_MTOUT中打印数据时是先打印mt的数据，所以取最后一条数据实际上是以out数据为准)
			     #省编码，appcode，提交状态，接收状态，接收时间
		      q[indexstr]=$3"|"$4"|"$5"|"$6"|"$7"|"
		      b[indexstr]=1
			  }
			}
}END{
    for(name in a)
    {
      print p[name]    
    }
    for(name in b)
    {
      print q[name]    
    }    
}' $code_file_area $TMP_RESULT_MTOUT > $TMP_RESULT


gawk -F\| '{
   if(FILENAME=="'$code_file'")
   {
      if($2>0)
      {
         status_code[$1]=1
      }
   }
   else if(FILENAME=="'$code_city_file'")
   {
      provi[$4]=$4","$1
   }
   else if(FILENAME=="'$code_appcode_dept'")
   {
      dept_name[$5]=$1","$4    #无线|wuxian_qianxiang|无线-通用产品|帮助信息|10101000|0|UMGYWCXX|2
   }
   else
   { 
      appcode=$2
      service_name=(length(dept_name[appcode]))>0?dept_name[appcode]:"未知,未知"
      #接受状态
      if(($4!=0)&&($4!="未知"))
      {
        if(substr($4,1,2) in status_code)
          {
            status=substr($4,1,2)
          }
        else
         {
           status="OTHERS"
         }
      }
      else
      {
        status=$4
      }
      if($1 in provi)
      {
     	  indexstr=provi[$1]","appcode","service_name","status
      }
      else
      {
      	 indexstr="000,未知,"appcode","service_name","status
      }
      pro[indexstr]=1         
      provi_out[indexstr]++ #下行提交总量
      if($3==0)
      {
        submit_succ[indexstr]++ #成功提交量
      }
      if(status==0)
			   {
			     provi_succ[indexstr]++   #成功接收量
			     if($5<=1)
			     {
			        wait_1[indexstr]++    #延时小于1分钟
			     }
			     else if(($5>1)&&($5<=2))
			     {
			        wait_2[indexstr]++
			     }
			     else if(($5>2)&&($5<=5))
			     {
				       wait_3[indexstr]++
			     }
			     else
			     {
				       wait_other[indexstr]++
			     }
			   }
			   if(($3==0)&&(status=="未知"))
			   {
			     mt[indexstr]++
			   }
   }
}END{
     #形成列标题
     title="省编码,省名称,业务编号,业务部门,业务名称,接收状态,下行提交总量,提交失败量,成功提交量,成功接收量,延时小于1M,延时大于1M小于2M,延时大于2M小于5M,延时大于5M,无状态报告条数,扩展字段1，扩展字段2，扩展字段3"
     print title > "'$report_file'"
     for(name in pro)  #打印返回一条状态报告省份的指标信息
     {  
		      send_fail=provi_out[name]-submit_succ[name]                            #提交失败量									
        printf("%s,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\n",name,provi_out[name],send_fail,submit_succ[name],provi_succ[name],wait_1[name],wait_2[name],wait_3[name],wait_other[name],mt[name],0,0,0)>>"'$report_file'"
     }
  }' $code_file $code_city_file $code_appcode_dept $TMP_RESULT
rm $code_appcode_dept
rm $TMP_RESULT_MTOUT
rm $TMP_RESULT
