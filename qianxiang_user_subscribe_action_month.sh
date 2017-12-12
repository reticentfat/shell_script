#!/bin/sh
. /usr/local/app/dana/current/shbb/profile

if [ $# -eq 1 ] ; then
    V_DATE=$1
else
    echo "Usage:$0 20140101"
    exit 1
fi

V_YEAR=$(echo $V_DATE | cut -c 1-4)
V_MONTH=$(echo $V_DATE | cut -c 1-6)
V_DAY=$(echo $V_DATE | cut -c 7-8)


ORIG_DIR=$AUTO_SRC_DATA
TARGET_DIR=$AUTO_DATA_TARGET/$V_YEAR/$THIS_MONTH_DAY

code_file=$CODE_DIR/nodist.tsv
price_file=~/qx_appcode.txt



#取上个月的起止时间
while [ $V_DAY -eq 03 ]
    do
        END_DATE=$(date -v-3d -j $V_DATE"0000" +%Y%m%d)
        THIS_MONTH_DAY=$(date -v-3d -j $V_DATE"0000" +%Y%m%d)
        THIS_MONTH=$(echo $THIS_MONTH_DAY | cut -c 1-6)
        START_DATE=$(echo $THIS_MONTH_DAY | cut -c 1-6)"01"
        LAST_MONTH_DAY=$(date -v-1d -j $START_DATE"0000" +%Y%m%d)
        LAST_MONTH=$(echo $LAST_MONTH_DAY | cut -c 1-6)
        V_DAY="00"
    done

ORIG_DIR=$AUTO_SRC_DATA
TARGET_DIR=$AUTO_DATA_TARGET/$V_YEAR/$THIS_MONTH_DAY

code_file=$CODE_DIR/nodist.tsv
price_file=$CODE_DIR/qx_appcode.txt


tmp_this_snapshot_file=$TARGET_DIR/tmp_snapshot_this.txt
tmp_history_snapshot_file=$TARGET_DIR/tmp_snapshot_history.txt
tmp_report_file=$TARGET_DIR/tmp_report_subscribed.csv






#生成快照的临时文件
#存量快照
THIS_SNAP_DIR=$ORIG_DIR/$THIS_MONTH_DAY/data/snapshot
bzcat $THIS_SNAP_DIR/snapshot.txt.bz2 |awk -F\| '{print $1"|"$2"|"$3"|"$4"|"$5"|"$6}' >$tmp_history_snapshot_file
#本月快照
awk -F\| 'substr($4,1,6)=="'$THIS_MONTH'"{print $1"|"$2"|"$3"|"$4"|"$5"|"$6}' $tmp_history_snapshot_file > $tmp_this_snapshot_file







title="省编码,省名称,市编码,市名称,业务名称,业务类型,业务资费,前向订购用户数,订购用户数,点播用户数,退订用户数,计费用户数,新增包月客户留存率,存量包月客户留存率,存量点播客户留存率"

echo $title >$report_file

awk -F\| '{
    if (FILENAME=="'$code_file'"){
        nodist[$4]=$1","$5","$2","$3
    }
    else if(FILENAME=="'$price_file'"){
        sp_name=$2
        sp_type=$4
        sp_price=$6
        all_app[$3]=sp_name","sp_type","sp_price
        
        if($7=="01"){     #包月业务字典
            month[$3]=sp_name","sp_type","sp_price
        }
    }
    else{
        
        phone=$1                     #手机号码
        appcode=$2                   #APP代码
        is_subscribed=$3             #是否订阅
        op_time=$4                   #定退时间


        #号码地归属匹配
        if(substr(phone,1,7) in nodist){
            area_info=nodist[substr(phone,1,7)]
        }else if(substr(phone,1,8) in nodist){
            area_info=nodist[substr(phone,1,8)]
        }else{
            area_info="未知,000,未知,000"
        }
            
        if(appcode in all_app){
            sp_info=all_app[appcode]
            flag=area_info","sp_info
            all[flag]=1
                
            if(is_subscribed=="06"){
                #订购用户数
                do_subscribe_user[flag]++
                    
                if(appcode in month){
                    #前向包月订购用户数
                    subscribe_month_user[flag]++
                }
            }
                
            #退订用户数
            else if(is_subscribed=="07"){
                cancel_user[flag]++
                 
            }
        }
    }
}END{
    for(i in all){
        printf("%s,%d,%d,%d\n",i,subscribe_month_user[i],do_subscribe_user[i],cancel_user[i])
    }
}' $code_file $price_file $tmp_this_snapshot_file >$tmp_report_file




#rm $tmp_file $time_tmp $tmp_snapshot_file $tmp_cmpp_mm7_file $tmp_price_user_file $tmp_report_subscribed




