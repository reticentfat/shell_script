#!/bin/sh
. /usr/local/app/dana/current/shbb/profile
#. /home/chenly/profile
usage () {
    echo "usage: $0  REPORT_DIR" 1>&2
    exit 2
}

if [ $# -lt 1 ] ; then
    usage
fi
# 每月第一天执行该程序，第一天生成上月数据，放在上月最后一天的目录下
#判断是不是每月的第一天
V_DATE=$1
V_DAY=$(echo $V_DATE|cut -c 7-8)

if [ $V_DAY -eq '01' ] ; then

V_MONTH=$(echo $V_DATE|cut -c 1-6)
DAY=$(gawk 'BEGIN{
             t="'$V_MONTH'01000000"
             yy=substr(t,1,4);mm=substr(t,5,2);dd=substr(t,7,2);hh=substr(t,9,2) ;Mi=substr(t,11,2); ss=substr(t,13,2)
             s=yy" "mm" "dd" "hh" "Mi" "ss
             a=mktime(s)-86400
             print strftime("%Y%m%d",a)
           }'
      )
LAST_DAY=$(echo $DAY | cut -c 1-8)  #上月最后一天
LAST_MONTH=$(echo $DAY | cut -c 1-6)  #上月
LAST_YEAR=$(echo $DAY | cut -c 1-4)  #年
SOURCE_DIR=$AUTO_DATA_TARGET/$LAST_YEAR
REPORT_DIR=$AUTO_DATA_REPORT/$LAST_YEAR/month_$LAST_MONTH
CODE_DIR=$AUTO_DATA_NODIST
NODIST_NOSVN_DIR=$AUTO_DANA_NODIST

if [ ! -d "$SOURCE_DIR" ]; then
  echo "$SOURCE_DIR not found"
  exit 1
fi

if [ ! -d "$REPORT_DIR" ]; then
  if ! mkdir -p $REPORT_DIR
  then
    echo "mkdir $REPORT_DIR error"
    exit 1
  fi
fi


#创建实名管道
if [ ! -f "$SOURCE_DIR/$LAST_DAY/$$_tmp" ];then
   mkfifo $SOURCE_DIR/$LAST_DAY/$$_tmp
fi
# 源文件
SOUR_FILENAME=$SOURCE_DIR/${LAST_MONTH}*/usa_action_log.${LAST_MONTH}*.txt
# 结果文件
REPORT_RESULT_FILE=$REPORT_DIR/report.region.mon_subscribe_cancel_meiti_city.csv
# 字典表文
CODE_FILE=$NODIST_NOSVN_DIR/shbb_chanel.txt
FILE_APP_CODE=$CODE_DIR/meiti_app_code.txt
ERROR=0


awk -F\| '{action=$2;userid=$3;appcode=$7;
    #处理版本信息
    if (index($6,"SHBB")>0){
         if(index($9,"MLQFW")>0){
              version="生活播报女版"
         }else{ 
              version="生活播报男版"
         }
    }else if(index($6,"YYHK")>0) {
         if(index($9,"YYYK")>0) {
             version="月刊"
         }else{
             version="普刊"
         }
    }else{
         version="其它"
    }
    proviceno=$(NF-4)","$(NF-2)","$(NF-5)","$(NF-3)                
    # 订阅结构与退订结构不同,此处NF不能进行修改
   
    if(action=="cancel"){
       chanel1=$11
       chanel2=$12
       chanel3=$13
    }else if(action=="subscribe"){
       chanel1=$12
       chanel2=$13
       chanel3=$14
    }
    #记录省份信息
    if (action=="cancel" || action=="subscribe"){
       arr_index=proviceno"|"appcode"|"userid       
       p[arr_index]=1
       if(action=="subscribe"){
           subcrib_user[arr_index]+=$23 #订阅次数
           user_chanel[arr_index]=version"|"chanel1"|"chanel2"|"chanel3
       }else{
         cancel_user[arr_index]+=$19  #退订次数
         user_chanel[arr_index]=version"|"chanel1"|"chanel2"|"chanel3
       }
       flag[arr_index]=flag[arr_index]$(NF) #第一动作
       #订阅结构与退订结构不同,此处NF不可进行修改
    }
}END{
    for (name in p){
       a=(subcrib_user[name]>0) ? subcrib_user[name]:0
       b=(cancel_user[name]>0) ? cancel_user[name]:0
       printf("%s|%d|%d|%s|%s\n",name,a,b,user_chanel[name],flag[name])
    }
}' $SOUR_FILENAME > $SOURCE_DIR/$LAST_DAY/$$_tmp&

#开始生成报表
awk -F\| '{
             if (FILENAME=="'$FILE_APP_CODE'")
             {
                 app[$1]=$2
             }
             else if(FILENAME=="'$CODE_FILE'")
             {
                 chanel_name1[$1]=$1
                 chanel_name2[$2]=$2
                 chanel_name3[$3]=$3              
             }
             else if ($2 in app)
             {
               proviceName=$1;appcode_name=$2;version=$6;subcribe_num=$4;cancel_num=$5;chanel1=$7;chanel2=$8;chanel3=$9;action_str=$10;
               servicecode=app[$2]
               if ((chanel1 in chanel_name1)&&(length(chanel1)>0))
                   {
                   if((chanel2 in chanel_name2)&&(length(chanel2)>0))
                       {
                       if ((!(chanel3 in chanel_name3))||(length(chanel3)==0))
                          {
                           chanel3="None"
                          }
                       }
                   else 
                       {
                       chanel2="None"
                       chanel3="None"
                       }
                   }
               else
                   {
                   chanel1="None"
                   chanel2="None"
                   chanel3="None"                    
                   }         
               flag=subcribe_num-cancel_num
               indexstr=proviceName","appcode_name","servicecode","version","chanel1","chanel2","chanel3
               p[indexstr]=1
               #订阅用户数
               if(flag >=1)
               {
                 subscribe[indexstr]++
               }
               #退订用户数
               else if(flag<=-1)
               {
                  cancel[indexstr]++
               }
               #即订即退用户数
               else if((flag==0)&&(action_str=="subscribe"))
               {
                  subscribe_cancel[indexstr] ++
               }
               #即退即订用户数
               else if((flag==0) &&(action_str=="cancel"))
               {
                   cancel_subscribe[indexstr] ++
               }
            }
        }END{
                # 输出标题
               str1="订阅用户数"
               str2="退订用户数"
             str3="省编码,地市编码,省份名称,地市名称,APPCODE,杂志名称,杂志版本,渠道1,渠道2,渠道3"
             printf("%s,%s,%s,%s,%s\n",str3,str1,str2,"即订即退用户数","即退即订用户数")
             for (provi in p)
             {
             printf("%s,%d,%d,%d,%d\n",provi,subscribe[provi],cancel[provi],subscribe_cancel[provi],cancel_subscribe[provi])
             }
          }' $FILE_APP_CODE $CODE_FILE $SOURCE_DIR/$LAST_DAY/$$_tmp >$REPORT_RESULT_FILE
          ERROR=$?
          rm $SOURCE_DIR/$LAST_DAY/$$_tmp
          if [ $ERROR -gt 0 ]; then
         	  exit $ERROR
           else
         	wait $!
           fi
 fi    
 
