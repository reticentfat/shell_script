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
TARGET_DIR=$AUTO_DATA_TARGET/$V_YEAR/$V_DATE
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
TMP_CODE=$TARGET_DIR/tmpnodist.txt
SOURCE_FILE1=$TARGET_DIR/back_meiti_add_logs.csv     #采购单每日快照
SOURCE_FILE2=$TARGET_DIR/back_meiti_exec_logs.csv    #执行单每日快照
SOURCE_FILE3=$TARGET_DIR/back_meiti_change_logs.csv    #执行单每日快照

RESULT_FILE=$REPORT_DIR/report.region.back_sale_caiwu_meiti_province.csv  #财务报表统计

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
    yy=substr($14,1,4)
    mm=substr($14,6,2)
    dd=substr($14,9,2)
    contract_day=yy""mm""dd
    if(contract_day<="'$V_DATE'")
     {
      if(!($20=="2"))
        {   
          com[$2]=$4#代理商
          prov[$2]=$6 #省份
          discount[$2]=$15 
          type[$2]=$11 #全网地网
        }
     }
   }
 else if(FILENAME=="'$SOURCE_FILE2'")
   { 
     yy=substr($9,1,4)
     mm=substr($9,6,2)
     dd=substr($9,9,2)
     exec_day=yy""mm""dd
     if((exec_day<="'$V_DATE'")&&($13=="3"))
       {
         price[$1]=$5
         if($1 in discount)
           {
             ys_fee=discount[$1]*price[$1]/100
           }
         ysfee[$1]+=ys_fee
       }
   }
 else if(FILENAME=="'$SOURCE_FILE3'")
   {
     shishou_yy=substr($3,1,4)  
     shishou_mm=substr($3,6,2)
     shishou_dd=substr($3,9,2)
     shishou_day=shishou_yy""shishou_mm""shishou_dd  #实收日期

     kaipiao_yy=substr($5,1,4)
     kaipiao_mm=substr($5,6,2)
     kaipiao_dd=substr($5,9,2)
     kaipiao_day=kaipiao_yy""kaipiao_mm""kaipiao_dd  #开票日期

     fandian_yy=substr($11,1,4)
     fandian_mm=substr($11,6,2)
     fandian_dd=substr($11,9,2)
     fandian_day=fandian_yy""fandian_mm""fandian_dd  #返点日期
     if(!($16==2))
       {
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
         if($1 in type)
           {          
             ywtype=type[$1]
           }
         else
           {
             ywtype="其它"
           }   #全网地网
         shishou_fee=$4;fapiao_fee=$7;fandian_fee=$10
         indexstr=province","provname","company","ywtype
         if((shishou_day=="'$V_DATE'")&&($1 in ysfee))
           {
             yingshou[indexstr]+=ysfee[$1]  #应收金额
             shishou[indexstr]+=shishou_fee    #实收金额
             if(ywtype=="全网")
               {
                 yd_fee[indexstr]=yingshou[indexstr]*0.25        #移动分成全网
               }
             else if(ywtype=="地网")
               {
                 yd_fee[indexstr]=yingshou[indexstr]*0.55        #移动分成地网
               }
             fee[indexstr]=1
           }
         if(kaipiao_day=="'$V_DATE'")
           {
             fapiao[indexstr]+=fapiao_fee      #发票金额 
             fee[indexstr]=1
           }
         if(fandian_day=="'$V_DATE'")
           {
             fandian[indexstr]+=fandian_fee    #返点金额 
             fee[indexstr]=1
           }
       }
   }
}
END{
  str="省份编码,省份名称,代理商,业务属性,应收金额,实收金额,待收金额,移动分成,发票金额,返点金额"
  printf("%s\n",str)
  for(name in fee)
     {
       daishou[name]=yingshou[name]-shishou[name]   #待收金额
       printf("%s,%d,%d,%d,%d,%d,%d\n",name,yingshou[name],shishou[name],daishou[name],yd_fee[name],fapiao[name],fandian[name])
     }
}' $TMP_CODE $SOURCE_FILE1 $SOURCE_FILE2 $SOURCE_FILE3 > $RESULT_FILE

rm $TMP_CODE
