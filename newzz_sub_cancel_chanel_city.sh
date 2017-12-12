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

 #创建实名管道
 if [ ! -f "$TARGET_DIR/$$_tmp" ];then
   mkfifo $TARGET_DIR/$$_tmp
 fi
   # 源文件
   sour_filename=$SOURCE_DIR/usa_action_log.${V_DATE}.txt
   # 结果文件
    target_filename=$TARGET_DIR/report.region.newzz_sub_cancel_chanel_city.csv
   # 字典表文
   code_file=$CODE_DIR/shbb_chanel_code.txt
   zzcode_file_new=$CODE_DIR/news_appcode.txt

   ERROR=0


  awk -F\| '{
              if(FILENAME=="'$zzcode_file_new'")
            {
            	new_appcode[$1]=$2
            }
            else if($7 in new_appcode){
            # 订阅结构与退订结构不同，所以此处NF不能修改
            action=$2;userid=$3;servicecode=$6;appcode=$7;proviceno=$(NF-4)","$(NF-2)","$(NF-5)","$(NF-3)"|"new_appcode[$7]
            # 订阅结构与退订结构不同
            if(action=="cancel")
            {
               chanel_cancel=$11
            }
            else if(action=="subscribe")
            {
               chanel_subscribe=$12
            }
            #记录省份信息
            if(action=="cancel" || action=="subscribe")
            {
               arr_index=proviceno"|"appcode"|"userid
               p[arr_index]=1
               if(action=="subscribe")
               {
                 subcrib_user[arr_index]=$23 # 订阅次数
                 subcrib_user_chanel[arr_index]=chanel_subscribe
               }
               else
               {
                 cancel_user[arr_index]=$19  #退订次数
                 cancel_user_chanel[arr_index]=chanel_cancel
               }
               # 订阅结构与退订结构不同，所以此处NF不能修改
               flag[arr_index]=flag[arr_index]$(NF) #第一动作
            }
           }
          }END{
            for (name in p)
            {
               a=(subcrib_user[name]>0) ? subcrib_user[name]:0
               b=(cancel_user[name]>0) ? cancel_user[name]:0
               printf("%s|%d|%d|%s|%s|%s\n",name,a,b,subcrib_user_chanel[name],cancel_user_chanel[name],flag[name])
            }

  }' $zzcode_file_new $sour_filename >$TARGET_DIR/$$_tmp&
            #开始生成报表
            awk -F\| '{
            if(FILENAME=="'$code_file'")
            {
               chanel_name=$1
               is_display=$2
               if(is_display>0)
               {
                  i++
                  chanel_code[chanel_name]=is_display
                  chanel_code_order[i]=chanel_name
               }
            }
            else
            {
               proviceName=$1;servicename=$2;subcribe_num=$5;cancel_num=$6;appcode_name=$3;action_str=$9
               chanel_cancel=$8
               chanel_subscribe=$7
               if(!(chanel_cancel in chanel_code))
               {
                 chanel_cancel="OTHERS"
               }
              if(!(chanel_subscribe in chanel_code))
               {
                 chanel_subscribe="OTHERS"
               }
               p[proviceName","servicename","appcode_name]=1
               flag=subcribe_num-cancel_num
               indexstr=proviceName","servicename","appcode_name
               #定阅用户
               if(flag >=1)
               {
                 subscribe[indexstr","chanel_subscribe]++
               }
               #退订用户
               else if(flag<=-1)
               {
                  cancel[indexstr","chanel_cancel]++
               }
               else if((flag==0) &&(action_str=="subscribe"))
               {
                  subscribe_cancel[proviceName","servicename","appcode_name] ++
                }
                else if((flag==0) &&(action_str=="cancel"))
                {
                   cancel_subscribe[proviceName","servicename","appcode_name] ++
                }

            }
            }END{
            # 输出标题
            i++
            chanel_code_order[i]="OTHERS"
            for(m=1;m<=i;m++)
            {
               k=chanel_code_order[m]
               str1=str1",订阅用户("k")"
               str2=str2",退订用户("k")"
            }
            str3="省编码,地市编码,省份名称,地市名称,杂志名称,APPCODE"
            printf("%s%s%s,%s,%s\n",str3,str1,str2,"当日即订即退","当日即退即订")
            for (provi in p)
            {
               str1=""
               str2=""
               for(m=1;m<=i;m++)
               {
                    k=chanel_code_order[m]
                    subscribe_num=(subscribe[provi ","k]>0)?subscribe[provi ","k]:0
                    cancel_num=(cancel[provi ","k]>0)?cancel[provi ","k]:0
                    str1=str1","subscribe_num
                    str2=str2","cancel_num
               }
               printf("%s%s%s,%d,%d\n",provi ,str1,str2,subscribe_cancel[provi],cancel_subscribe[provi])
            }
        }' $code_file $TARGET_DIR/$$_tmp >$target_filename
        ERROR=$?
	      rm $TARGET_DIR/$$_tmp
  			if [ $ERROR -gt 0 ]; then
   				exit 1
 			 	else
					wait $!
  			fi
