#!/bin/sh
. /usr/local/app/dana/current/shbb/profile
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
 code_file_2=$CODE_DIR/news_appcode.txt
# 数据源
 sourc_file_out=$SOURCE_DIR/NEWZZ_MM7_OUT.txt
 sourc_file_mt=$SOURCE_DIR/NEWZZ_MM7_MT.txt
# 结果文件
result_file_province=$TARGET_DIR/report.region.newzz_out_mt_rate_province.csv
result_file_country=$TARGET_DIR/report.region.newzz_out_mt_rate_country.csv
result_file_city=$TARGET_DIR/report.region.newzz_out_mt_rate_city.csv
result_file_noappcode=$TARGET_DIR/report.region.newzz_out_mt_rate_noappcode_province.csv

ERROR=0
# 匹配记录数
awk -F\| '{

                if(FILENAME=="'$code_file'")
                { if($2>0)
                   {
                     i++
                     staut_code[$1]=$2
                     staut_code_order[i]=$1

                   }
                }
                else if(FILENAME=="'$code_file_2'")
                {
                  e[$1]=$2
                }
                else {
                	provicename=$6","$5;city_name=$6","$8","$5","$7
                	sendstatu=$4;appcode=$3;servicename=e[appcode]
                	indexstr=provicename","servicename","appcode
                	indexstr_1=city_name","servicename","appcode
                	indexstr_2=servicename","appcode
                	indexstr_3=provicename","servicename

                if(FILENAME=="'$sourc_file_out'")
                {
                  provice_out[indexstr]++
                  provice_user[indexstr]++
                  city_out[indexstr_1]++
                  city_user[indexstr_1]++
                  country_out[indexstr_2]++
                  country_user[indexstr_2]++
                  noappcode_out[indexstr_3]++
                  noappcode_user[indexstr_3]++
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
                stat_str=indexstr","arr_stau
                stat_str_1=indexstr_1","arr_stau
                stat_str_2=indexstr_2","arr_stau
                stat_str_3=indexstr_3","arr_stau

                # 每appcode的次数
                if(arr_stau=="1000")
                {
                    out_suss[indexstr]++
                    city_out_suss[indexstr_1]++
                    country_out_suss[indexstr_2]++
                    noappcode_out_suss[indexstr_3]++
                }
                else
                {
                   out_stau[stat_str]++
                   city_out_stau[stat_str_1]++
                   country_out_stau[stat_str_2]++
                   noappcode_out_stau[stat_str_3]++
                }
               }
               else if(FILENAME=="'$sourc_file_mt'")
               {
                     # 下发成功的
                     provice_user[indexstr]++
                     city_user[indexstr_1]++
                     country_user[indexstr_2]++
                     noappcode_user[indexstr_3]++

                     if(sendstatu=="1000")
                     {
                          mt_send_suss[indexstr]++
                          mt_send_city_suss[indexstr_1]++
                          mt_send_country_suss[indexstr_2]++
                          mt_send_noappcode_suss[indexstr_3]++
                     }
                     else
                     {
                          mt_send_fail[indexstr]++
                          mt_send_city_fail[indexstr_1]++
                          mt_send_country_fail[indexstr_2]++
                          mt_send_noappcode_fail[indexstr_3]++
                     }
               		}
							}
            }END{
                # 生成表头
                i++
                staut_code_order[i]="OTHERS"
                str="省编码,省份名称,杂志名称,APPCODE,下行提交总量,提交失败量,成功提交量,成功接收量,下行接收成功率%"
                for(m=1;m<=i;m++)
                {
                   str=str",接收失败("staut_code_order[m]")"
                }
                printf("%s,%s\n",str,"无状态报告条数") >"'$result_file_province'"

                str="省编码,地区编码,省份名称,地区名称,杂志名称,APPCODE,下行提交总量,提交失败量,成功提交量,成功接收量,下行接收成功率%"
                for(m=1;m<=i;m++)
                {
                   str=str",接收失败("staut_code_order[m]")"
                }
                printf("%s,%s\n",str,"无状态报告条数") >"'$result_file_city'"
                str="合计,杂志名称,APPCODE,下行提交总量,提交失败量,成功提交量,成功接收量,下行接收成功率%"
                for(m=1;m<=i;m++)
                {
                   str=str",接收失败("staut_code_order[m]")"
                }
                printf("%s,%s\n",str,"无状态报告条数") >"'$result_file_country'"
                str="省编码,省份名称,杂志名称,下行提交总量,提交失败量,成功提交量,成功接收量,下行接收成功率%"
                for(m=1;m<=i;m++)
                {
                   str=str",接收失败("staut_code_order[m]")"
                }
                printf("%s,%s\n",str,"无状态报告条数") >"'$result_file_noappcode'"

                for(name in provice_user)
                {
                   MT_ALL= provice_out[name]+mt_send_suss[name]
                   str3=""
                   for(m=1;m<=i;m++)
                   {
                    sta_str_num=staut_code_order[m]
                     aa=(length(out_stau[name","sta_str_num])>0)? out_stau[name","sta_str_num]:0
                     str3=str3","aa
                   }
                   Succ_rate=(MT_ALL>0) ? out_suss[name] * 100 / MT_ALL :0
                   mt_num=mt_send_suss[name]+mt_send_fail[name]
                   printf("%s,%d,%d,%d,%d,%.2f%s%s,%d\n",name,provice_user[name],mt_send_fail[name],MT_ALL,out_suss[name],Succ_rate,"%",str3,mt_num)  >> "'$result_file_province'"
                }
                for(name in city_user)
                {
                   MT_ALL= city_out[name]+mt_send_city_suss[name]
                   str3=""
                   for(m=1;m<=i;m++)
                   {
                    sta_str_num=staut_code_order[m]
                     aa=(length(city_out_stau[name","sta_str_num])>0)? city_out_stau[name","sta_str_num]:0
                     str3=str3","aa
                   }
                   Succ_rate=(MT_ALL>0) ? city_out_suss[name] * 100 / MT_ALL :0
                   mt_num=mt_send_city_suss[name]+mt_send_city_fail[name]
                   printf("%s,%d,%d,%d,%d,%.2f%s%s,%d\n",name,city_user[name],mt_send_city_fail[name],MT_ALL,city_out_suss[name],Succ_rate,"%",str3,mt_num)  >> "'$result_file_city'"
                }
                for(name in country_user)
                {
                   MT_ALL= country_out[name]+mt_send_country_suss[name]
                   str3=""
                   for(m=1;m<=i;m++)
                   {
                    sta_str_num=staut_code_order[m]
                     aa=(length(country_out_stau[name","sta_str_num])>0)? country_out_stau[name","sta_str_num]:0
                     str3=str3","aa
                   }
                   Succ_rate=(MT_ALL>0) ? country_out_suss[name] * 100 / MT_ALL :0
                   mt_num=mt_send_country_suss[name]+mt_send_country_fail[name]
                   printf("%s,%s,%d,%d,%d,%d,%.2f%s%s,%d\n","合计",name,country_user[name],mt_send_country_fail[name],MT_ALL,country_out_suss[name],Succ_rate,"%",str3,mt_num)  >> "'$result_file_country'"
                }
                for(name in noappcode_user)
                {
                   MT_ALL= noappcode_out[name]+mt_send_noappcode_suss[name]
                   str3=""
                   for(m=1;m<=i;m++)
                   {
                    sta_str_num=staut_code_order[m]
                     aa=(length(noappcode_out_stau[name","sta_str_num])>0)? noappcode_out_stau[name","sta_str_num]:0
                     str3=str3","aa
                   }
                   Succ_rate=(MT_ALL>0) ? noappcode_out_suss[name] * 100 / MT_ALL :0
                   mt_num=mt_send_noappcode_suss[name]+mt_send_noappcode_fail[name]
                   printf("%s,%d,%d,%d,%d,%.2f%s%s,%d\n",name,noappcode_user[name],mt_send_noappcode_fail[name],MT_ALL,noappcode_out_suss[name],Succ_rate,"%",str3,mt_num)  >> "'$result_file_noappcode'"
                }

            }' $code_file $code_file_2 $sourc_file_out $sourc_file_mt

