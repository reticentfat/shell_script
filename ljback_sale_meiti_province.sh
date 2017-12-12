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
CODE_DIR=$AUTO_DATA_NODIST
CODE_FILE=$CODE_DIR/nodist_city.txt
TARGET_DIR=$AUTO_DATA_TARGET/snapshot
   if [ ! -d "$TARGET_DIR" ]; then
    if ! mkdir -p $TARGET_DIR
      then
       echo "mkdir $TARGET_DIR error"
       exit 1
    fi
  fi
REPORT_DIR=$AUTO_DATA_REPORT/$V_YEAR/$V_DATE
   if [ ! -d "$REPORT_DIR" ]; then
    if ! mkdir -p $REPORT_DIR
      then
       echo "mkdir $REPORT_DIR error"
       exit 1
    fi
  fi
#增量日志结果文件
TMP_CODE=$TARGET_DIR/tmpnodist_lj_back_meiti.txt
SOURCE_FILE1=$TARGET_DIR/back_meiti_add_logs.csv     #采购单每日快照
SOURCE_FILE2=$TARGET_DIR/back_meiti_exec_logs.csv    #执行单每日快照

RESULT_FILE=$REPORT_DIR/report.region.ljback_sale_meiti_province.csv  # 媒体后向销售报表统计

awk -F'|' '{
    prov=$1"`"$4
    printf("%s\n",prov)     
   }' $CODE_FILE > $TMP_CODE

awk -F'`' '{
 if(FILENAME=="'$TMP_CODE'")
   {
      nodist[$2]=$1
   }
 else if(FILENAME=="'$SOURCE_FILE1'")
   {
    if(!($20=="2"))
       {
         prov[$2]=$6
         contract=$16;discount[$2]=$15 
         type[$2]=$11 
         yy=substr($14,1,4)
         mm=substr($14,6,2)
         dd=substr($14,9,2)
         contract_day=yy""mm""dd
         start_day="'$V_YEAR'""01""01"
         #处理代理商信息
        if(length($4)>0)
           {
             company=$4
           }
         else
           {
             company="未知"
           } 
         com[$2]=company
         #处理省份编码信息 
         if($6 in nodist)
           {
             province=$6
             provname=nodist[$6]
           }
         else
           {
             province="000"
             provname="未知"
           }
         prov[$2]=province
         ywtype=type[$2]
         indexstr=province","provname","company","ywtype
         if((contract_day<="'$V_DATE'")&&(contract_day>=start_day))
           {
             buycount[indexstr]++    #累计采购单量
             contractfee[indexstr]+=contract  #累计签约金额
             fee[indexstr]=1
           }
       }
   }
 else if(FILENAME=="'$SOURCE_FILE2'")
    {
      if($13==3)
        {
          price=$5
          yy=substr($9,1,4)
          mm=substr($9,6,2)
          dd=substr($9,9,2)
          exec_day=yy""mm""dd
          start_day="'$V_YEAR'""01""01"
         if($1 in com)
            {
              company=com[$1]
            }
          else
            {
              company="未知"
            }
          if($1 in prov)
            {
              province=prov[$1]
            }
          else
            {
              province="000"
            }
          if(province in nodist)
            {
              provname=nodist[province]
            }
          else
            {
              provname="未知"            
            }
          if($1 in discount)
            {
              done=price*discount[$1]/100
            }
          if($1 in type)
            {          
              ywtype=type[$1]
            }
          else
            {
              ywtype="其它"
            }
          indexstr=province","provname","company","ywtype
          if((exec_day<="'$V_DATE'")&&(exec_day>=start_day))
            {
              donecount[indexstr]++  #累计执行单量
              donefee[indexstr]+=done  #累计执行金额
              fee[indexstr]=1
            }
        }
    }
}
END{         
    str="省份编码,省份名称,代理商,业务类型,累计采购单量,累计执行单量,累计签约金额,累计执行金额"
    printf("%s\n",str)
 for(name in fee)
    {
      printf("%s,%d,%d,%d,%d\n",name,buycount[name],donecount[name],contractfee[name],donefee[name])
    }
}' $TMP_CODE $SOURCE_FILE1 $SOURCE_FILE2 > $RESULT_FILE

rm $TMP_CODE



