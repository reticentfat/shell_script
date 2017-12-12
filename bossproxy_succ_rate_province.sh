#!/bin/sh
. /usr/local/app/dana/current/ETL/profile

# The exit codes returned are:
# 0 - operation completed successfully
# 1 -
# 2 - usage error

#
# When multiple arguments are given, only the error from the _last_
# one is reported.  Run "gen_goodno help" for usage info
#
ARGV="$@"

# --------------------                              --------------------
# ||||||||||||||||||||   END CONFIGURATION SECTION  ||||||||||||||||||||

usage () {
    echo "usage: $0  target_dir report_dir code_dir" 1>&2
    exit 2
}

if [ $# -lt 1 ] ; then
    usage
fi


V_DATE=$1
V_YEAR=$(echo $V_DATE | cut -c 1-4)
TARGET_DIR=$AUTO_DATA_TARGET/$V_YEAR/$V_DATE
REPORT_DIR=$AUTO_DATA_REPORT/$V_YEAR/$V_DATE
#REPORT_DIR=~
CODE_DIR=$AUTO_DATA_NODIST




if [ ! -d "$TARGET_DIR" ]; then
  echo "$TARGET_DIR not found"
  exit 1
fi

if [ ! -d "$CODE_DIR" ]; then
  echo "$CODE_DIR not found"
  exit 1
fi


if [ ! -d "$REPORT_DIR" ]; then
  if ! mkdir -p $REPORT_DIR
  then
    echo "mkdir $REPORT_DIR error"
    exit 1
  fi
fi

 # 数据文件

DATA_FILE=$TARGET_DIR/bossproxy_fengtai_province.txt
RESULT_FILE=$REPORT_DIR/report.region.bossproxy_succ_rate_province.csv
PROXY_CODE=$CODE_DIR/proxy_error_code.txt    #请求结果错误代码
NODIST_CITY=$CODE_DIR/nodist_city.txt

bzcat $AUTO_SRC_DATA/$V_DATE/bossproxy.log.fengtai.log.$V_DATE.bz2 |grep 'BIP2B247,' > $DATA_FILE

awk -F'[,|]' '{
     if(FILENAME=="'$PROXY_CODE'"){
         i++
         d[$1]=0
         e[i]=$1
     }else if(FILENAME=="'$NODIST_CITY'"){
         province[$4]=$1
     }else{ 
         all[$11]+=1;          #总量
         if($14=="0000"){
             succ[$11]+=1      #成功量
         }else{
             fail[$11","$14]+=1
         }
         res_time[$11]+=$15   #响应时间
         
     }
}END{
    #生成表头
    str="省编码,省份名称,请求总量,请求成功量,请求失败量,Boss平台相应时间,成功率"
    for(m=1;m<=i;m++){
        str=str",接收失败("e[m]")"
    }
    print str
    for(name in all){
        if(name in province){                      #匹配省市ID
            provname = province[name]
            provid = name
        }
        else{
            provname = "未知"
            provid = "000"
        }
        type = ""
        for(m=1;m<=i;m++){
            f = (length(fail[name","e[m]])!=0) ? fail[name","e[m]]:0
            type = type","f
        }
        printf("%s,%s,%d,%d,%d,%.3f,%.2f%s%s\n",provid,provname,all[name],succ[name],all[name]-succ[name],all[name]!=0 ? res_time[name]/all[name]*100:0,all[name]!=0 ? succ[name]/all[name]*100:0,"%",type)
    }
}' $PROXY_CODE $NODIST_CITY $DATA_FILE > $RESULT_FILE

rm $DATA_FILE









