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
CODE_DIR=$AUTO_DATA_NODIST


if [ ! -d "$SOURCE_DIR" ]; then
  echo "$SOURCE_DIR not found"
  exit 1
fi


# 字典表文件

 code_file_1=$CODE_DIR/meiti_app_code.txt
# 数据源
 sourc_file_out=$SOURCE_DIR/MM7_OUT.txt
 sourc_file_mt=$SOURCE_DIR/MM7_MT.txt
 sourc_file_newmt=$SOURCE_DIR/NEWZZ_MM7_MT.txt
 sourc_file_newout=$SOURCE_DIR/NEWZZ_MM7_OUT.txt
# 结果文件
result_file=$SOURCE_DIR/out_mt_meiti_num.txt

ERROR=0
# 匹配记录数
awk -F\| '{
                if(FILENAME=="'$code_file_1'")
                {
                  app[$1]=$2
                }
                else 
                { 
                   city_name=$6","$8","$5","$7
                   sendstatu=$4;appcode=$3                        
                   if (appcode in app)
                   {
                      servicename=app[appcode]
                      indexstr=city_name","servicename","appcode","sendstatu
                      p[indexstr]=1
                      if((FILENAME=="'$sourc_file_out'")||(FILENAME=="'$sourc_file_newout'"))
                         {
                           city_out[indexstr]++ 
                           city_user[indexstr]++   #下行提交总量

                           # 每appcode的次数
                           if(sendstatu=="1000")
                              {
                                city_out_suss[indexstr]++
                              }
                           else
                              {
                                city_out_stau[indexstr]++
                              }
                           }
                      else if((FILENAME=="'$sourc_file_mt'")||(FILENAME=="'$sourc_file_newmt'"))
                           {
                              # 下发成功的 
                              city_user[indexstr]++
                              if(sendstatu=="1000")
                                {
                                   mt_send_city_suss[indexstr]++
                                }
                              else
                                {
                                   mt_send_city_fail[indexstr]++
                                }
               	           }
                    }
	        }
            }END{
                for(name in p)   #name is   [city_name","servicename","appcode","sendstatu]
                   {
                      MT_ALL= city_out[name]+mt_send_city_suss[name]
                      mt_num=mt_send_city_suss[name]+mt_send_city_fail[name]
                      printf("%s,%d,%d,%d,%d,%d\n",name,city_user[name],MT_ALL,city_out_suss[name],city_out_stau[name],mt_num)  
                   }
            }' $code_file_1 $sourc_file_out $sourc_file_mt $sourc_file_newmt $sourc_file_newout > $result_file
           ERROR=$?
           if [ $ERROR -gt 0 ]; then
         	  exit $ERROR
           else
         	wait $!
           fi
   
