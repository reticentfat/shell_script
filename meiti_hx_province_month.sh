#!/bin/sh
. /usr/local/app/dana/current/ETL/profile

usage () {
    echo "usage: $0  target_dir  report_dir code_dir" 1>&2
    exit 2
}

if [ $# -lt 1 ] ; then
    usage
fi


DATE=$1

#判断是否为月报
TEMPDAY=`echo $DATE|cut -c 7-8`
[ $TEMPDAY != '01' ] && exit 0


V_DATE=$(date -v-1d -j $DATE"0000"  +%Y%m%d)

V_YEAR=$(echo $V_DATE | cut -c 1-4)

V_MONTH=$(echo $V_DATE | cut -c 1-6)

NODIST_DIR=$AUTO_DATA_NODIST

TARGET_DIR=$AUTO_DATA_TARGET/snapshot

ORIG_DIR=$AUTO_SRC_DATA

REPORT_DIR=$AUTO_DATA_REPORT/$V_YEAR/month_${V_MONTH}



#数据文件

DATA_FILE=$ORIG_DIR/$V_MONTH*/media/sms_cut.log.*
    
#字典文件:

NODIST=$NODIST_DIR/nodist_city.txt

ORDER_INFO=$TARGET_DIR/back_meiti_add_logs.csv

#临时文件
TMP_FILE=$REPORT_DIR/report.region.meiti_hx_province.tmp


#输出文件：
RESULT=$REPORT_DIR/report.region.meiti_hx_province.csv


#过滤无效的核减单

bzcat $DATA_FILE|piconv -f GBK -t UTF-8| awk -F': ' '{
    print $2
}' |awk -F ',' 'NF!=1{
    a[$1] = $0
    c[$1] = $9
    }END{
       for(i in a){
          if(c[i]!=1){
             print a[i]
          }   
       }        
    }' > $TMP_FILE

awk 'BEGIN{
         FS = "," 
         OFS = "," 
         print "省编码,省名称,代理商名称,合同ID,业务类型,核减金额"
         while(getline vars <"'$NODIST'"){
            split(vars,keys,"|")                               
            city_id[keys[4]] = keys[4]","keys[1]                       #省信息
         }
         while(getline var <"'$ORDER_INFO'"){
             split(var,key,"`")
             if(key[6] in city_id){
                 cname = city_id[key[6]]
             }
             else{
                 cname = "000,未知"
             }
             indent[key[2]] = cname","key[7]","key[2]","key[11]       #合同信息:省编码,省名称,代理商名称,合同ID,业务类型
             money[key[2]] = key[16]                                     #金额
         }
     }
     {
         indent_id = $2               #核减合同ID
         agent_id = $6                #原合同ID
         change_money = $3            #核减金额
         if((indent_id in indent)&&(agent_id in indent)){
             original_money = money[indent_id]                      
             print indent[indent_id]","original_money*(-1)
             print indent[agent_id]","original_money+change_money     
         }
         else{          
             print "000,未知,未知,0000,未知,"change_money          
         }
     }' $TMP_FILE > $RESULT
     
rm $TMP_FILE


