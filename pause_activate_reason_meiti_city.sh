#!/bin/sh
#. /home/chenly/profile
. /usr/local/app/dana/current/shbb/profile

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
 target_filename=$TARGET_DIR/report.region.pause_activate_reason_meiti_city.csv
 # 字典表文
  FILE_APP_CODE=$CODE_DIR/meiti_app_code.txt 
  CODE_FILE=$CODE_DIR/pause_activate_reason.txt
  #CODE_FILE=$AUTO_DATA_REPORT/pause_activate_reason.txt
 ERROR=0
awk -F\| '{
           if(FILENAME=="'$CODE_FILE'")
              {
                 rea[$2]=$1
              } 
           else 
              {
                 # 订阅结构与退订结构不同，所以此处NF不能修改
                 action=$2 ;userid=$3;servicecode=$6;appcode=$7;proviceno=$(NF-4)","$(NF-2)","$(NF-5)","$(NF-3)
                 #记录省份信息
                 if (action=="pause" || action=="activate")
                 {    
                      if(action=="activate")
                      {
                         if ($9 in rea)
                            {
                               reason=rea[$9]
                            }
                         else
                            {
                               reason="其他"
                            }
                         arr_index=proviceno"|"appcode"|"servicecode"|"reason"|"userid
                         p[arr_index]=1
                         activate_user[arr_index]=$15 #激活次数                        
                      }
                      else
                      {                        
                         if ($10 in rea)
                            {
                               reason=rea[$10]
                            }
                         else
                            {
                               reason="其他"
                            }
                         arr_index=proviceno"|"appcode"|"servicecode"|"reason"|"userid
                         p[arr_index]=1
                         pause_user[arr_index]=$16 #暂停次数
                      }
                      # 订阅结构与退订结构不同，所以此处NF不能修改
                      flag[arr_index]=flag[arr_index]$(NF) #第一动作是暂停还是激活
                }
             }
         } END{
                for (name in p)
                {
                   printf("%s|%d|%d|%s\n",name,(activate_user[name]>0) ? activate_user[name]:0,(pause_user[name]>0) ? pause_user[name]:0,flag[name])
                }
              }' $CODE_FILE $sour_filename >$TARGET_DIR/$$_tmp&
              #开始生成报表
  awk -F\| '{
               if(FILENAME=="'$FILE_APP_CODE'")
               {
                   app[$1]=$2
               }
               else if ($2 in app)
               {
                   proviceName=$1;appcode_name=$2;reason=$4;activate_num=$6;pause_num=$7;action_str=$8
                   servicename=app[$2]
                   indexstr=proviceName","appcode_name","servicename","reason
                   p[indexstr]=1
                   flag=activate_num-pause_num
                   activate_opnum[indexstr]+=activate_num #激活请求次数
                   pause_opnum[indexstr]+=pause_num #暂停请求次数
                   #激活用户
                   if(flag>=1)
                   {
                      activate[indexstr]++ #激活用户数
                   }
                   #暂停用户
                   else if(flag<=-1)
                   {
                      pause[indexstr]++ #暂停用户数
                   }
                   else if((flag==0) &&(action_str=="activate"))
                   {
                      activate_pause[indexstr] ++    #即激活即暂停用户数
                   }
                   else if((flag==0) &&(action_str=="pause"))
                   {
                     pause_activate[indexstr] ++     #即暂停即激活用户数
                   }
              }
        }END{
                # 输出标题 
                str1="激活用户数"
                str2="暂停用户数"
                str3="省编码,地市编码,省名称,地市名称,APPCODE,杂志名称,暂停激活原因,激活请求次数,暂停请求次数"
                printf("%s,%s,%s,%s,%s\n",str3,str1,str2,"当日即激活即暂停","当日即暂停即激活")              
                for (provi in p)
                {              
                   printf("%s,%d,%d,%d,%d,%d,%d\n",provi,activate_opnum[provi],pause_opnum[provi],activate[provi],pause[provi],activate_pause[provi],pause_activate[provi])
                }
      }' $FILE_APP_CODE $TARGET_DIR/$$_tmp >$target_filename
         ERROR=$?
       rm $TARGET_DIR/$$_tmp
         if [ $ERROR -gt 0 ]; then
         	exit $ERROR
         else
         	wait $!
         fi
