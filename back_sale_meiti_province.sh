#!/bin/sh
. /usr/local/app/dana/current/shbb/profile
  usage ()
  {
       echo "usage: $0  target_dir" 1>&2
       exit 2
  }
  if [ $# -lt 1 ] ; then
    usage
  fi    
NEW_YEAR=$(date +%Y)
V_DATE=$1
V_YEAR=$(echo $V_DATE | cut -c 1-4)
CODE_DIR=$AUTO_DATA_NODIST
nodist_city=$CODE_DIR/nodist_city.txt

TARGET_DIR=$AUTO_DATA_TARGET/snapshot
[ -d "$TARGET_DIR" ]||{ mkdir -p $TARGET_DIR; }||{ exit 1;}
REPORT_DIR=$AUTO_DATA_REPORT/$V_YEAR/$V_DATE
[ -d "$REPORT_DIR" ]||{ mkdir -p $REPORT_DIR; }||{ exit 1;}
[ -f $nodist_city ]||{ exit 1;}
#增量日志结果文件
back_meiti_add_logs=$TARGET_DIR/back_meiti_add_logs.csv    #采购单每日快照
back_meiti_exec=$TARGET_DIR/back_meiti_exec_logs.csv       #执行单每日快照
back_sale_meiti=$REPORT_DIR/report.region.back_sale_meiti_province.csv  # 媒体后向销售报表统计

gawk 'BEGIN{
   FS = "`"
   OFS = ","
   while(getline var <"'$nodist_city'"){
     split(var,v,"|")
     prov_city[v[4]]=v[1]
   }
 }
 {
   if(FILENAME=="'$back_meiti_add_logs'"){
     opttype=$20                        #操作类型（0：新增 1：修改 2:删除）
     log_date=$18                       #写日志时间
     yy=substr(log_date,1,4)
     mm=substr(log_date,6,2)
     dd=substr(log_date,9,2)
     contract_day=yy""mm""dd
     if(opttype!="2"){                   #按照日志记录时间统计订单采购量
         contract = $16                      #签约金额
         saleid = $2                         #采购单号
         contract_price[saleid] = contract   #直接从签约单里取签约价格
         type[saleid] = $11                  #业务属性
         company = length($4)>0?$4:"未知"    #代理商信息
         com[saleid] = company             
         province = $6
         if(province in prov_city){
             provname=prov_city[province]
         }else{
             province = "000"
             provname = "未知"
         }
         prov[saleid] = province
         ywtype = type[saleid]
         indexstr = province","provname","company","ywtype
         if(contract_day=="'$V_DATE'"){
             fee[indexstr] = 1
             buycount[indexstr]++             #采购单量
             contractfee[indexstr] += contract  #签约金额           
         } 
         
     }
   }else if(FILENAME=="'$back_meiti_exec'"){ #执行单处理  
      opttype=$13                  #操作类型(０:新增　１:修改　２:删除  3：执行)
      exec_day=$9                  #投放日期
      yy=substr(exec_day,1,4)
      mm=substr(exec_day,6,2)
      dd=substr(exec_day,9,2)
      exec_day=yy""mm""dd
      if(opttype=="3"){             #按投放日期统计执行单
         saleid=$1                 #采购单号
         company = length(com[saleid])>0?com[saleid]:"未知"  #执行的的单号在采购单号中，取采购单对应代理
         province = length(prov[saleid])>0?prov[saleid]:"000"  # 取订单号对应的省份信息
         provname = length(prov_city[province])>0?prov_city[province]:"未知"
         done = length(contract_price[saleid])>0?contract_price[saleid]:0   #执行金额=签约金额求和
         ywtype = length(type[saleid])>0?type[saleid]:"其它"    #业务类型
         indexstr=province","provname","company","ywtype
         if(exec_day=="'$V_DATE'"){
             fee[indexstr]=1
             donecount[indexstr]++  #执行单量
             donefee[indexstr]+=done  #执行金额 
         }         
      }
   }
}END{
    str="省份编码,省份名称,代理商,业务类型,采购单量,执行单量,签约金额,执行金额"
    printf("%s\n",str)
    for(name in fee){
       printf("%s,%d,%d,%d,%d\n",name,buycount[name],donecount[name],contractfee[name],donefee[name])
    }
}' $back_meiti_add_logs $back_meiti_exec > $back_sale_meiti


