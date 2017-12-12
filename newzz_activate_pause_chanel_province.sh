#!/bin/sh
. /usr/local/app/dana/current/shbb/profile
#. /home/shihy/bin/shbb_20090423/profile
    usage ()
    {
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
    target_filename=$TARGET_DIR/report.region.newzz_activate_pause_province.csv

    target_filename_1=$TARGET_DIR/report.region.newzz_activate_pause_country.csv

    target_filename_2=$TARGET_DIR/report.region.newzz_activate_pause_noappcode_province.csv
   # 字典表文
    code_file=$CODE_DIR/shbb_pause_reason.txt
    zzcode_file_new=$CODE_DIR/news_appcode.txt

   ERROR=0

awk -F\| '{
            if(FILENAME=="'$zzcode_file_new'")
            {
            	new_appcode[$1]=$2
            }
            else
            {
              # 订阅结构与退订结构不同，所以此处NF不能修改
              action=$2 ;userid=$3;servicecode=$6;appcode=$7;proviceno=$(NF-4)","$(NF-5);pause_reason=$10
              #记录省份信息
              if((appcode in new_appcode) && (action=="pause" || action=="activate"))
              {
                  arr_index=proviceno"|"appcode"|"userid
                  p[arr_index]=1

                  if(action=="activate")
                  {
                     activate_user[arr_index]=$15 #激活次数
                  }
                  else
                  {
                     pause_user[arr_index]=$16 #暂停次数
                  }
                  # 订阅结构与退订结构不同，所以此处NF不能修改
                  flag[arr_index]=flag[arr_index]$(NF) #第一动作是暂停还是激活
                  p_reason[arr_index]=p_reason[arr_index]pause_reason
            	}
           	}
          }END{
            for (name in p)
            {
              printf("%s|%d|%d|%s|%s\n",name,(activate_user[name]>0) ? activate_user[name]:0,(pause_user[name]>0) ? pause_user[name]:0,p_reason[name],flag[name])
            }
          }' $zzcode_file_new $sour_filename >$TARGET_DIR/$$_tmp&
          #开始生成报表
          awk -F\| '{
          if(FILENAME=="'$code_file'")
          {
               i++
               pause_reason[$2]=$1
               pause_reason_order[i]=$1 #显示顺序
          }
          else if(FILENAME=="'$zzcode_file_new'")
          {
            	new_appcode[$1]=$2
          }
          else
          {
               proviceName=$1;activate_num=$4;pause_num=$5;appcode_name=$2;pausereason=$6;action_str=$7
               servicename=new_appcode[appcode_name]
               if(!(pausereason in pause_reason))
               {
                  pausereason="OTHERS"
               }
               else
               {
                 pausereason=pause_reason[pausereason]
               }

               flag=activate_num-pause_num
               indexstr=proviceName","servicename","appcode_name
               indexstr_1=servicename","appcode_name
               indexstr_2=proviceName","servicename
               p[indexstr]=1
               p_1[indexstr_1]=1
               p_2[indexstr_2]=1
               #激活用户
               activate_opnum[indexstr]+=activate_num #激活次数
               pause_opnum[indexstr]+=pause_num #暂停次数
               activate_opnum_1[indexstr_1]+=activate_num #激活次数
               pause_opnum_1[indexstr_1]+=pause_num #暂停次数
               activate_opnum_2[indexstr_2]+=activate_num #激活次数
               pause_opnum_2[indexstr_2]+=pause_num #暂停次数
               if(flag>=1)
               {
                 activate[indexstr]++ #激活用户数
                 activate_1[indexstr_1]++ #全国激活用户
                 activate_2[indexstr_2]++ #不分appcode
               }
               #暂停用户
               else if(flag<=-1)
               {
                  pause[indexstr]++ #暂停用户数
                  pause_1[indexstr_1]++ #全国暂停用户数
                  pause_2[indexstr_2]++ #无appcode暂停用户数
                  pause_reason_num[indexstr","pausereason]++ #每暂停原因用户数
                  pause_reason_num_1[indexstr_1","pausereason]++ #每暂停原因用户数
                  pause_reason_num_2[indexstr_2","pausereason]++ #每暂停原因用户数
               }
               else if((flag==0) &&(action_str=="activate"))
               {
                  activate_pause[indexstr] ++
	    					  activate_pause_1[indexstr_1] ++
	      					activate_pause_2[indexstr_2] ++
               }
               else if((flag==0) &&(action_str=="pause"))
               {
                	pause_activate[indexstr] ++
                 	pause_activate_1[indexstr_1] ++
                 	pause_activate_2[indexstr_2] ++
               }
          }
        }END{
        # 输出标题
        i++
        pause_reason_order[i]="OTHERS"
        for(m=1;m<=i;m++)
        {
            k=pause_reason_order[m]
            str1=str1",暂停用户数("k")"
        }
        str2="省编码,省份名称,杂志名称,APPCODE,激活请求次数,暂停请求次数,激活用户总量"
        printf("%s%s,%s\n",str2,str1,"暂停用户总量,当日即激活即暂停,当日即暂停即激活")>"'$target_filename'"
        str2="合计,杂志名称,APPCODE,激活请求次数,暂停请求次数,激活用户总量"
        printf("%s%s,%s\n",str2,str1,"暂停用户总量,当日即激活即暂停,当日即暂停即激活")>"'$target_filename_1'"
        str2="省编码,省份名称,杂志名称,激活请求次数,暂停请求次数,激活用户总量"
        printf("%s%s,%s\n",str2,str1,"暂停用户总量,当日即激活即暂停,当日即暂停即激活")>"'$target_filename_2'"
        #分省分appcode
        for (provi in p)
        {
               str1=""
               for(m=1;m<=i;m++)
                {
                     k=pause_reason_order[m]
                     s=(pause_reason_num[provi ","k]>0)?pause_reason_num[provi ","k]:0
                     str1=str1","s
                }
                printf("%s,%d,%d,%d%s,%d,%d,%d\n",provi ,activate_opnum[provi],pause_opnum[provi],activate[provi],str1,pause[provi],activate_pause[provi],pause_activate[provi])>>"'$target_filename'"
        }
      # 全国合计
        for (provi in p_1)
        {
               str1=""
               for(m=1;m<=i;m++)
                {
                     k=pause_reason_order[m]
                     s=(pause_reason_num_1[provi","k]>0)?pause_reason_num_1[provi","k]:0
                     str1=str1","s
                }
         printf("%s,%s,%d,%d,%d%s,%d,%d,%d\n","合计",provi,activate_opnum_1[provi],pause_opnum_1[provi],activate_1[provi],str1,pause_1[provi],activate_pause_1[provi],pause_activate_1[provi])>>"'$target_filename_1'"

        }
       #分省
        for (provi in p_2)
        {
               str1=""
               for(m=1;m<=i;m++)
                {
                     k=pause_reason_order[m]
                     s=(pause_reason_num_2[provi","k]>0)?pause_reason_num_2[provi","k]:0
                     str1=str1","s
                }
               printf("%s,%d,%d,%d%s,%d,%d,%d\n",provi,activate_opnum_2[provi],pause_opnum_2[provi],activate_2[provi],str1,pause_2[provi],activate_pause_2[provi],pause_activate_2[provi])>>"'$target_filename_2'"

        }
      }' $code_file $zzcode_file_new $TARGET_DIR/$$_tmp
      rm $TARGET_DIR/$$_tmp
      wait $!



