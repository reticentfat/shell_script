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
SOURCE_DIR=$AUTO_SRC_DATA/$V_DATE
TARGET_DIR=$AUTO_DATA_TARGET/$V_YEAR/$V_DATE
CODE_DIR=$AUTO_DATA_NODIST

if [ ! -d "$TARGET_DIR" ]; then
  if ! mkdir -p $TARGET_DIR
  then
    echo "mkdir $TARGET_DIR error"
    exit 1
  fi
fi

ERROR=0

 #程序记录了每个用户的每个action的请求次数以及每个action最后一次的记录
 #创建实名管道
 if [ ! -f "$TARGET_DIR/$$_TEMP" ];then
   mkfifo $TARGET_DIR/$$_TEMP
 fi

 source_file=$TARGET_DIR/$$_TEMP
 target_file=$TARGET_DIR/usa_action_log.${V_DATE}.txt
 code_file=$CODE_DIR/nodist.tsv
 bzcat ${SOURCE_DIR}/usa2-biz.log.*${V_DATE}.bz2>$source_file&
 awk -F\| '{
           		if (FILENAME=="'${code_file}'")
           		{
             		nodist[$4]=$1"|"$5"|"$2"|"$3
           		}
	         		else
	         		{
                action=$2;userid=$3;proveno=$4;servicecode=$7
                if((action=="cancel"||action=="subscribe"||action=="pause"||action=="activate"))
                {
                  SHBB[userid"|"servicecode"|"action]=$0;
                  if (action=="cancel"||action=="subscribe")
                  {
	                  flag[userid"|"servicecode]++
                    if(flag[userid"|"servicecode]==1)
  	                {
    	                action_str[userid"|"servicecode"|"action] = action
                    }
                  }
              		if (action=="pause"||action=="activate")
              		{
                  	flag_action[userid"|"servicecode]++
                		if(flag_action[userid"|"servicecode]==1)
                 		{
                      action_str[userid"|"servicecode"|"action] = action
                 		}
               		}
                  #动作次数
                  action_num[userid"|"servicecode"|"action]++
                  if(substr(userid,1,7) in nodist)
                  {
                   	c[userid"|"servicecode"|"action]=nodist[substr(userid,1,7)]
                  }
                  else if(substr(userid,1,8) in nodist)
                  {
                   	c[userid"|"servicecode"|"action]=nodist[substr(userid,1,8)]
                  }
                  else
                  {
                    c[userid"|"servicecode"|"action]="未知|000|未知|000"
                  }
                }
              }
           }
          END{
            for(name in SHBB) print SHBB[name]"|"c[name]"|"action_num[name]"|"action_str[name]
        }' $code_file $source_file > $target_file
    rm $source_file
    wait $!
