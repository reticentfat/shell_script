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

#RIZHI_DIR=/logs/orig/$V_DATE/media
RIZHI_DIR=/logs/orig/$V_DATE
TARGET_DIR=$AUTO_DATA_TARGET/snapshot
   if [ ! -d "$TARGET_DIR" ]; then
    if ! mkdir -p $TARGET_DIR
      then
       echo "mkdir $TARGET_DIR error"
       exit 1
    fi
  fi

SOURCE_FILE1=$TARGET_DIR/do_sms_contract.log   #采购单接口日志
SOURCE_FILE2=$TARGET_DIR/do_sms_execute.log    #执行单接口日志
SOURCE_FILE3=$TARGET_DIR/do_sms_finance.log    #财务变更接口日志

SOURCE1=$TARGET_DIR/meiti_add_logs.csv    #采购单全量表
SOURCE2=$TARGET_DIR/meiti_exec_logs.csv   #执行单全量表
SOURCE3=$TARGET_DIR/meiti_change_logs.csv #财务变更全量表

if [ ! -f "$SOURCE1" ];then
    touch $SOURCE1
fi

if [ ! -f "$SOURCE2" ];then
    touch $SOURCE2
fi

if [ ! -f "$SOURCE3" ];then
    touch $SOURCE3
fi

#全量日志结果文件
RESULT_FILE1=$TARGET_DIR/tmp_meiti_add_logs.csv 
RESULT_FILE2=$TARGET_DIR/tmp_meiti_exec_logs.csv    
RESULT_FILE3=$TARGET_DIR/tmp_meiti_change_logs.csv   

# 字典表文
ERROR=0
#以"］"和"："和空格共同作为分隔符
#bzcat ${RIZHI_DIR}/sms_contract.log.*.bz2 | awk -F']: ' '{$1=substr($1,8,2)""substr($1,11,2)""substr($1,14,2);print $1" :] "$2 }' |sort -n |awk -F' :] ' '{print $2}'|iconv -f gb2312 -t utf-8 -c > $SOURCE_FILE1
#以下3行bzcat，均调整为先转换字符，再传输运算
bzcat ${RIZHI_DIR}/sms_contract.log.*.bz2 | awk -F']: ' '{$1=substr($1,8,2)""substr($1,11,2)""substr($1,14,2);print $1" :] "$2 }' |iconv -f gb2312 -t utf-8 -c|sort -n |awk -F' :] ' '{print $2}' > $SOURCE_FILE1


#日志记录到不同服务器,需要对所有日志的记录时间排序.
#bzcat ${RIZHI_DIR}/sms_execute.log.*.bz2 | awk -F']: ' '{$1=substr($1,8,2)""substr($1,11,2)""substr($1,14,2);print $1" :] "$2 }' |sort -n |awk -F' :] ' '{print $2}'|iconv -f gb2312 -t utf-8 -c > $SOURCE_FILE2
bzcat ${RIZHI_DIR}/sms_execute.log.*.bz2 | awk -F']: ' '{$1=substr($1,8,2)""substr($1,11,2)""substr($1,14,2);print $1" :] "$2 }' |iconv -f gb2312 -t utf-8 -c|sort -n |awk -F' :] ' '{print $2}' > $SOURCE_FILE2

#bzcat ${RIZHI_DIR}/sms_finance.log.*.bz2 | awk -F']: ' '{$1=substr($1,8,2)""substr($1,11,2)""substr($1,14,2);print $1" :] "$2 }' |sort -n |awk -F' :] ' '{print $2}'|iconv -f gb2312 -t utf-8 -c > $SOURCE_FILE3
bzcat ${RIZHI_DIR}/sms_finance.log.*.bz2 | awk -F']: ' '{$1=substr($1,8,2)""substr($1,11,2)""substr($1,14,2);print $1" :] "$2 }' |iconv -f gb2312 -t utf-8 -c|sort -n |awk -F' :] ' '{print $2}' > $SOURCE_FILE3
#采购单全量表
awk -F'`' '{ 
 if(FILENAME=="'$SOURCE1'")
   {  
    yy=substr($18,1,4)
    mm=substr($18,6,2)
    dd=substr($18,9,2)
    log_day=yy""mm""dd
    log_list=$1"`"$2"`"$3"`"$4"`"$5"`"$6"`"$7"`"$8"`"$9"`"$10"`"$11"`"$12"`"$13"`"$14"`"$15"`"$16"`"$17"`"$18"`"$19"`"$20
    if(log_day < "'$V_DATE'")
      {
        printf("%s\n",log_list) > "'$RESULT_FILE1'"
      }
   }
 else if(FILENAME=="'$SOURCE_FILE1'")
   {
    yy=substr($18,1,4)
    mm=substr($18,6,2)
    dd=substr($18,9,2)
    log_day=yy""mm""dd
    if(log_day == "'$V_DATE'")
      {
        log_list=$1"`"$2"`"$3"`"$4"`"$5"`"$6"`"$7"`"$8"`"$9"`"$10"`"$11"`"$12"`"$13"`"$14"`"$15"`"$16"`"$17"`"$18"`"$19"`"$20
        printf("%s\n",log_list) >> "'$RESULT_FILE1'"
      }
   }
}' $SOURCE1 $SOURCE_FILE1

#执行单全量表
awk -F'`' '{ 
 if(FILENAME=="'$SOURCE2'")
   {  
    yy=substr($11,1,4)
    mm=substr($11,6,2)
    dd=substr($11,9,2)
    log_day=yy""mm""dd
    log_list=$1"`"$2"`"$3"`"$4"`"$5"`"$6"`"$7"`"$8"`"$9"`"$10"`"$11"`"$12"`"$13
    if(log_day < "'$V_DATE'")
      {
        printf("%s\n",log_list) > "'$RESULT_FILE2'"
      }
   }
 else if(FILENAME=="'$SOURCE_FILE2'")
   {
      yy=substr($11,1,4)
      mm=substr($11,6,2)
      dd=substr($11,9,2)
      log_day=yy""mm""dd
      if(log_day == "'$V_DATE'")
        {
           log_list=$1"`"$2"`"$3"`"$4"`"$5"`"$6"`"$7"`"$8"`"$9"`"$10"`"$11"`"$12"`"$13
           printf("%s\n",log_list) >> "'$RESULT_FILE2'"
        }
   }
}' $SOURCE2 $SOURCE_FILE2

#财务变更全量表
awk -F'`' '{ 
 if(FILENAME=="'$SOURCE3'")
   {  
     yy=substr($13,1,4)
     mm=substr($13,6,2)
     dd=substr($13,9,2)
     log_day=yy""mm""dd
     log_list=$1"`"$2"`"$3"`"$4"`"$5"`"$6"`"$7"`"$8"`"$9"`"$10"`"$11"`"$12"`"$13"`"$14"`"$15"`"$16
     if(log_day < "'$V_DATE'")
       {
         printf("%s\n",log_list) > "'$RESULT_FILE3'"
       }
   }
 else if(FILENAME=="'$SOURCE_FILE3'")
   { yy=substr($13,1,4)
     mm=substr($13,6,2)
     dd=substr($13,9,2)
     log_day=yy""mm""dd
     if(log_day == "'$V_DATE'")
       {
         log_list=$1"`"$2"`"$3"`"$4"`"$5"`"$6"`"$7"`"$8"`"$9"`"$10"`"$11"`"$12"`"$13"`"$14"`"$15"`"$16
         printf("%s\n",log_list) >> "'$RESULT_FILE3'"
       }
   }
}' $SOURCE3 $SOURCE_FILE3


if [ -f "$RESULT_FILE1" ];then
   cat $TARGET_DIR/tmp_meiti_add_logs.csv > $TARGET_DIR/meiti_add_logs.csv
   rm $TARGET_DIR/tmp_meiti_add_logs.csv
fi

if [ -f "$RESULT_FILE2" ];then
   cat $TARGET_DIR/tmp_meiti_exec_logs.csv > $TARGET_DIR/meiti_exec_logs.csv
   rm $TARGET_DIR/tmp_meiti_exec_logs.csv
fi

if [ -f "$RESULT_FILE3" ];then
   cat $TARGET_DIR/tmp_meiti_change_logs.csv> $TARGET_DIR/meiti_change_logs.csv
   rm $TARGET_DIR/tmp_meiti_change_logs.csv
fi

if [ -f "$SOURCE_FILE1" ];then
   rm $SOURCE_FILE1
fi

if [ -f "$SOURCE_FILE2" ];then
   rm $SOURCE_FILE2
fi

if [ -f "$SOURCE_FILE3" ];then
   rm $SOURCE_FILE3
fi

    
 
 
