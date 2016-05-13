PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/home/gateway/;
export PATH


DIR=$1
DATE_mm5=`date -v-3d  +%Y%m%d`
DATE_mm3=`date -v-5d  +%Y%m%d`
DATE_mm1=`date -v-7d  +%Y%m%d`
DATE_DAY=`date -v-1d  +%Y%m%d`
DATE_NAME=`date -v-0d  +%Y-%m-%d`
###或者三个数值其中最小的两个值
declare min1=100
declare min2=200
function get_min2()
{ echo "test";
x1=`echo $1`
x2=`echo $2`
x3=`echo $3`
 

echo $x1
echo $x2
echo $x3
 
if [ $x1 -ge $x2 ] && [ $x1 -ge $x3 ]; then
    min1=$x2;
    min2=$x3;
fi
if [ $x2 -ge $x1 ] && [ $x2 -ge $x3 ]; then
    min1=$x1;
    min2=$x3;
fi
if [ $x3 -ge $x2 ] && [ $x3 -ge $x1 ]; then
    min1=$x1;
    min2=$x2;
fi
}
##get_min2 1 6 4
##echo $min1
##echo $min2

###判断运行返回完整状态报告的最晚日为星期几
 

###获取当前日期为周几的方法（周日输出0周一输出1周六输出6）
function get_week()
{
YMD=$1;
YEAR=`echo ${YMD} | cut -c1-4`
MONTH=`echo ${YMD} | cut -c5-6`
DAY=`echo ${YMD} | cut -c7-9`
# Adjust Month such that March becomes 1 month of
# year and Jan/Feb become 11/12 of previous year
# =============================================
if [ $MONTH -ge 3 ]
then
  MONTH=`expr $MONTH - 2`
else
  MONTH=`expr $MONTH + 10`
fi
if [ $MONTH -eq 11 ] || [ $MONTH -eq 12 ] ; then
  YEAR=`expr $YEAR - 1`
fi
# ==============================================
# Split YEAR into YEAR and CENTURY
# ================================
CENTURY=`expr $YEAR / 100`
YEAR=`expr $YEAR % 100`
# ================================
# Black Magic Time
# ================
#Z=(( 26*$MONTH - 2 ) / 10) + $DAY + $YEAR + ( $YEAR/4 ) + ( $CENTURY/4 ) - (2 * $CENTURY) + 77) % 7
Z=`expr \( $MONTH \* 26 - 2 \) / 10`
Z=`expr ${Z} + $DAY + $YEAR`
Z=`expr ${Z} + $YEAR / 4`
Z=`expr ${Z} + $CENTURY / 4`
Z=`expr ${Z} - $CENTURY - $CENTURY + 77`
Z=`expr ${Z} % 7`
if [ ${Z} -le 0 ] ; then
  Z=`expr ${Z} + 7`
fi

# ================
echo ${Z}
}
DATE_APPCODE_mm7_1=-1
DATE_APPCODE_mm7_2=-1
log_day=-1
province_style=-1
work_all=-1
Row_id_a=-1
CLASS_FILE="/data/211/PKFILTER_DIC/mms_sms_dic.txt"
DATE_mm7=`date -v-4d  +%Y%m%d`
log_day=1
Z=-1
get_week ${DATE_mm7} 
echo ${Z}
log_date_dir="/data/mms_sms_data/log/"
log_date=`date -v-4d  +%Y%m%d`
####cat /data/211/PKFILTER_DIC/mms_sms_dic.txt

####HSH_05_MMS,10511055,2|5,025|0851|021|022|010,250|851|210|220
####HSH_MMS,10511052,2|5,025|0851|021|022,250|851|210|220
####QNZL_MMS,10511003,1|3|5,025|0851|021|022,250|851|210|220
####YYBK_MMS,10511004,1|3,025|0851|021|022,250|851|210|220
####YYBS_MMS,10511050,1|5,025|0851|021|022,250|851|210|220
####QCBD_MMS,10511005,1|5,025|0851|021|022,250|851|210|220
####FCTC_MMS,10511019,1|2|3|4|5|6|7,025|0851|021|022,250|851|210|220
####TCTC_MMS,10511020,1|2|3|4|5|6|7,025|0851|021|022,250|851|210|220
####SZXT_MMS,10511022,4|7,025|0851|021|022,250|851|210|220
####FLBK_MMS,10511051,2|5,025|0851|021|022,250|851|210|220

##整理省编码匹配格式
 

function get_province ()
{ 
Row_id_a=$1;
CLASS_FILE_a=$2;

count=1
## cat   ${CLASS_FILE_a} |  awk -F ','  -v rowid=$Row_id_a '{if(NR==rowid) print $4 }'  | sed 's/.*/&|/' | 
 ##while  read  row;  
 ##do
  ##if [ ${count} == 1 ] ; then 
			    InfoSting_pro=($(echo ${row}  |  awk -F ','  -v rowid=${Row_id_a}  '{ if ( NR == rowid ) print $4 }'   ${CLASS_FILE_a} ))
          P=($(echo ${InfoSting_pro} | tr '|' ' ' | tr -s '^'))  
          length3=${#P[@]}
          echo "length3="${length3}
          province_style_tmp=0;
    for ((j=0; j<=${length3}-1; j++))
     do  
          if [ ${length3} -eq 1  ]; then
           province_style="-e ,"${P[0]}", " 
          fi
 
          if [ ${length3} -gt 1  ]; then
 
            if  [ $j -eq 0  ]; then 
             province_style="-e ,"${P[0]}", " 
             else
            province_style=${province_style}" -e ,"${P[j]}", "
           fi
    
          fi
   
    done  
  
   echo ${province_style}
  
 echo  "province_style="${province_style} 
}





##将下发周期的内容取出 获得对应的日期   

get_period()
{ 
Row_id_a=$1
CLASS_FILE_a=$2
##  获取当前业务发行最近两期都失败的用户详单
###${Z}当前返回完整状态报告的最晚日期是星期几   
local Z=$3 
 
			     InfoSting_period=($(echo ${row}  |  awk -F ','  -v rowid=${Row_id_a}  '{ if ( NR == rowid ) print $3 }'   ${CLASS_FILE_a} ))
       
          F=($(echo ${InfoSting_period} | tr '|' ' ' | tr -s ' '))  
          length2=${#F[@]}
          echo "length2="${length2}
##每行数的列值赋值到数组循环获取
                                                                                                                       
 if [ ${length2} == 1  ]; then  
      K1=` expr ${Z} - ${F[0]} ` 
      if [ ${K1} -lt 0 ]; then
        abs=`echo ${K1#-} `
         M1=` expr 7 - ${abs} ` 
      else 
         M1=${K1}
      fi
      M1=` expr ${M1} + 4 `
      DATE_APPCODE_mm7_1=$(date -v-${M1}d +%Y%m%d) 
      M2=`expr ${M1} + 7 `
      DATE_APPCODE_mm7_2=$(date -v-${M2}d +%Y%m%d) 
      
      log_day_t=` expr ${M2} - ${M1} ` 
      if [ ${log_day_t} -lt 0 ]; then
         abs=` echo ${log_day_t#-} `
         log_day=` expr 7 - ${abs} ` 
      else 
         log_day=${log_day_t}
      fi
    
 fi
 if [ ${length2} == 2  ]; then  
      K1=`expr ${Z} - ${F[0]} ` 
      if [ ${K1} -lt 0 ]; then
         abs=` echo ${K1#-} `
         M1=` expr 7 - ${abs} + 4 ` 
      else 
         M1=` expr ${K1} + 4 `
      fi
    
      DATE_APPCODE_mm7_1=$(date -v-${M1}d +%Y%m%d) 
      K2=`expr ${Z} - ${F[1]} ` 
      if [ ${K2} -lt 0 ]; then
        abs=` echo ${K2#-} `
        M2=`expr 7 - ${abs} + 4 ` 
      else 
        M2=` expr ${K2} + 4 `
      fi
       
      DATE_APPCODE_mm7_2=$(date -v-${M2}d +%Y%m%d) 
      log_day_t=` expr ${M2} - ${M1} ` 
      if [ ${log_day_t} -lt 0 ]; then
          abs=` echo ${log_day_t#-} `
         log_day=` expr  7 - ${abs} ` 
      else 
         log_day=${log_day_t}
      fi
 fi    
 if [ ${length2} == 3  ] ; then  
      a=`expr ${Z} - ${F[0]} `
      if [ ${a} -lt 0 ]; then
        abs=` echo ${a#-} `
         a1=`expr   7  -  ${abs}`
      else
         a1=${a}
      fi
      b=`expr ${Z} - ${F[1]} `
       if [ ${b} -lt 0 ]; then
           abs=` echo ${b#-} `
         b1=`expr   7  -  ${abs}`
       
       else
         b1=${b}
       fi
      c=`expr ${Z} - ${F[2]}`
       if [ ${c} -lt 0 ]; then
         abs=` echo ${c#-} `
         c1=`expr   7  -  ${abs}`
       else
         c1=${c}
       fi
      get_min2 ${a1} ${b1} ${c1}
       
      echo ${min1}","${min2}
 
      M1=`expr ${min1}  + 4 ` 
      DATE_APPCODE_mm7_1=$(date -v-${M1}d +%Y%m%d) 
      M2=`expr ${min2}  + 4 `
      DATE_APPCODE_mm7_2=$(date -v-${M2}d +%Y%m%d) 
       log_day_t=` expr ${M2} - ${M1} ` 
      if [ ${log_day_t} -lt 0 ]; then
         abs=` echo ${c#-} `
         log_day=` expr 7 - ${abs}  ` 
      else 
         log_day=${log_day_t}
      fi
 fi
  
 if [ ${length2} == 7  ]; then    
 
      DATE_APPCODE_mm7_1=$(date -v-4d +%Y%m%d) 
     
      DATE_APPCODE_mm7_2=$(date -v-5d +%Y%m%d) 
      log_day=1
 fi 
 
 
		echo  ${DATE_APPCODE_mm7_1}														   
		echo  ${DATE_APPCODE_mm7_2}
		echo  ${log_day}
 
}

##获得起始天数时间之后的所有时间函数

get_date()
{
 d=$1
 for(( f=${d}; f>0; f-- ))
 do
 
   log_day_old=` echo $(date -v-${f}d +%Y-%m-%d) | cut -c3-10  | sed  's/-/_/g'  `
   
  if [ ${f} -eq ${d} ] ; then
  
    log_date=` echo ${log_date_dir}*${log_day_old}*   ` 
    
    else 
    
    log_date_tmp=` echo  ${log_date_dir}*${log_day_old}*  `
    log_date=${log_date}"  "${log_date_tmp}
 
   fi
 
 done
 echo "log_date="${log_date}
}


 ##判断当前星期是否是下发周期的星期
 
 
get_work()
{
Row_id_a=$1
CLASS_FILE_a=$2
Z=$3
 
		 Infostring_work=($(echo ${row}  |   awk -F ',' -v week=${Z} -v rowid=${Row_id_a} '{if(NR==rowid)  printf("%d\n",match($3,week)) }'   ${CLASS_FILE_a} ))
     W=($(echo ${Infostring_work} | tr '|' ' ' | tr -s ' '))  ;
     length4=${#W[@]};
     
   ##每行数的列值赋值到数组循环获取
 
			if [ ${length4} == 1  ]; then
			   work_all=${W[0]} 
	    fi
   echo  ${work_all}
}
###主程序开始
row_id=1
 cat   ${CLASS_FILE} |  awk -F ',' '{print $1"\t"$2"\t"$3"\t"$4"\t"$5 }'  |  
			while  read  row; 
			do 
			    echo "first_row_id="${row_id}
			    InfoSting=` echo ${row} `
				  bl=($(echo ${InfoSting} | tr '\t' ' ' | tr -s '^'))
				  length=${#bl[@]}
				    ##每行数的列值赋值到数组循环获取
                
						     
if [ ${length} == 5  ]; then
   ##servcdoe
  servcode=`echo ${bl[0]}`
   ##appcode
  appcode=`echo ${bl[1]}`
                    ##下发周期
                    period=`echo ${bl[2]}`
                    ##省编码
                    province_num=`echo ${bl[3]}`
                   ##CCID编码
                    ccid_num=`echo ${bl[4]}`
    echo ${row_id}
    echo ${CLASS_FILE}
    echo ${Z}
    get_period ${row_id} ${CLASS_FILE} ${Z} 
    get_province ${row_id} ${CLASS_FILE}  
    get_work  ${row_id} ${CLASS_FILE} ${Z}     
 ##if [[ ${length} -ge 1 ]] && [[ ${work_all} -gt 0 ]] ;  then 
  if [[ ${length} -ge 1 ]]  ;  then 
    cat /data/match/mm7/${DATE_APPCODE_mm7_1}/*wuxian*.out /data/match/mm7/${DATE_APPCODE_mm7_2}/*wuxian*.out | grep ${province_style} | grep  ","${appcode}"," | awk -F',' -v src=${servcode} '{ if($(NF-2) != "1000" && $(NF-2) != "2000" && $(NF-2) != "4446" ) print $12","$15","src }'  | sort | uniq -c | awk '{if($1>=2) print $2 }' | awk -F',' '{print "http://192.100.6.33:8888/modify?id="$1"&servcode="$3"&ext2=jf_on" }' >>  /data/mms_sms_data/mms_sms_url_${DATE_mm7}.txt  
    log_day_f=` expr ${log_day} + 3 `
 
    ##获取log_day天前的恢复彩信用户详细
   ##http://192.100.6.33:8888/modify?id=18862105387&servcode=FLBK_MMS&ext2=jf_on
   ## cat modify_13_12_04.log | grep true |  awk -F'[ |]' '{print $5","$6}'  
   get_date ${log_day_f}
   cat ${log_date} | grep true |  awk -F'[ |]' '{print $5","$6}' | sort -u  >> ${log_date_dir}mms_log_data${DATE_mm7}.txt
  
  fi             
fi
row_id=` expr ${row_id} + 1 `
echo "last_row_id="${row_id}
###成功
done 

 ###过滤log_day_f天前回复恢复彩信的用户号码
  awk -F'[,=&]' -v CODE_DIR=${log_date_dir}mms_log_data${DATE_mm7}.txt '{
     if( FILENAME == CODE_DIR )  d[$1]=$1"\t"$2;
      else if ( FILENAME != CODE_DIR && !($2$4 in d) ){ print $0; }
}' ${log_date_dir}mms_log_data${DATE_mm7}.txt  /data/mms_sms_data/mms_sms_url_${DATE_mm7}.txt | sort -u > /data/mms_sms_data/mms_sms_url_${DATE_mm7}_ok.txt

cp /data/mms_sms_data/mms_sms_url_${DATE_mm7}_ok.txt  /home/gateway/bin/neimeng_dzyhjpk_update/mms_sms_url_${DATE_NAME}.txt
 
