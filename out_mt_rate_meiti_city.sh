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
code_file=$CODE_DIR/shbb_status_code.txt
# 数据源
SOURCE_FILE=$SOURCE_DIR/out_mt_meiti_num.txt
# 结果文件
RESULT_FILE=$TARGET_DIR/report.region.out_mt_rate_meiti_city.csv

ERROR=0
# 匹配记录数
 awk -F'[|,]' '{
              if(FILENAME=="'$code_file'")
                { if($2>0)
                   {
                     i++
                     staut_code[$1]=$2
                     staut_code_order[i]=$1
                   }
                }
              else 
                { 
                   province=$1;provname=$3;city=$2;cityname=$4;
                   servicename=$5;appcode=$6;sendstatu=$7;sub_all=$8;sub_succ=$9;accept_succ=$10;fail=$11;no_num=$12               
                   indexstr=province","city","provname","cityname","servicename","appcode
                   all[indexstr]+=sub_all
                   subsucc[indexstr]+=sub_succ
                   acceptsucc[indexstr]+=accept_succ
                   nonum[indexstr]+=no_num #无状态报告条数
                   p[indexstr]=1
                   # 需要显示的状态
                   if(sendstatu in staut_code)
                      {
                           arr_stau=sendstatu
                      }
                   else
                      {
                           if(sendstatu=="1000")
                             {
                                 arr_stau="1000"
                             }
                           else
                             {
                                 arr_stau="OTHERS"
                             }
                      }
                    
                   if(arr_stau=="1000")
                      {
                           city_out_suss[indexstr]+=accept_succ
                      }
                   else
                      {
                           city_out_stau[indexstr","arr_stau]+=fail
                      }
                }
            }END{
                # 生成表头
                i++
                staut_code_order[i]="OTHERS"

                str="省编码,地区编码,省份名称,地区名称,杂志名称,APPCODE,下行提交总量,成功提交量,成功接收量,到达率"
                for(m=1;m<=i;m++)
                   {
                      str=str",接收失败("staut_code_order[m]")"
                   }
                printf("%s,%s\n",str,"无状态报告条数")

                for(name in p)
                {
                   str3=""
                   for(m=1;m<=i;m++)
                   {
                     sta_str_num=staut_code_order[m]
                     aa=(length(city_out_stau[name","sta_str_num])>0)? city_out_stau[name","sta_str_num]:0
                     str3=str3","aa
                   }
                   Succ_rate=(subsucc[name]>0) ? acceptsucc[name] * 100 / subsucc[name] :0
                   printf("%s,%d,%d,%d,%.2f%s%s,%d\n",name,all[name],subsucc[name],acceptsucc[name],Succ_rate,"%",str3,nonum[name]) 
                }

            }' $code_file $SOURCE_FILE > $RESULT_FILE
           ERROR=$?
           if [ $ERROR -gt 0 ]; then
         	  exit $ERROR
           else
         	wait $!
           fi
   
       
