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
TARGET_DIR=$AUTO_DATA_TARGET/$V_YEAR/$V_MONTH
#REPORT_DIR=$AUTO_DATA_REPORT/$V_YEAR/$V_MONTH
REPORT_DIR=$AUTO_DATA_REPORT
CODE_DIR=$AUTO_DATA_NODIST


code_file=$CODE_DIR/nodist.tsv

#app_file=~/app_dic.txt
price_file=~/qx_appcode.txt


ORIG_DIR=$AUTO_SRC_DATA
TARGET_DIR=$AUTO_DATA_TARGET/$V_YEAR/20140301
#REPORT_DIR=$AUTO_DATA_REPORT/$V_YEAR/$V_MONTH
REPORT_DIR=$AUTO_DATA_REPORT
CODE_DIR=$AUTO_DATA_NODIST


code_file=$CODE_DIR/nodist.tsv

#app_file=~/app_dic.txt
price_file=~/qx_appcode.txt



report_file=~/report_qianxiang_city_day.csv
#report_file=$REPORT_DIR/
tmp_report_file=~/qianxiang_day.csv
tmp_current_month_user_list_file=$TARGET_DIR/tmp_current_month_user_list.txt
tmp_new_month_user_list_file=$TARGET_DIR/tmp_new_month_user_list.txt
tmp_last_month_user_list_file=$TARGET_DIR/tmp_last_month_user_list.txt
last_snapshot=$TARGET_DIR/last_snapshot.txt
tmp_stock_user_file=$TARGET_DIR/tmp_stok_user.txt

SNAP_DIR=$ORIG_DIR
#本月在订的用户
bzcat $SNAP_DIR/$END_DATE/data/snapshot/snapshot.txt.bz2 |awk -F\| '$3=="06"{print $1"|"$2"|current_subscribe"}' >$tmp_current_month_user_list_file
#上月新增订购用户
bzcat $SNAP_DIR/$LAST_MONTH_DAY/data/snapshot/snapshot.txt.bz2 >$last_snapshot

awk -F\| 'substr($4,1,8)=="'$LAST_MONTH'"&&$3=="06"{print $1"|"$2"|new_subscribe"}' last_snapshot>$tmp_new_month_user_list_file
#上月在订用户
awk -F\| '$3=="06"{print $1"|"$2"|last_subscribe"}' $last_snapshot>$tmp_last_month_user_list_file



#生成本月和上月的包月用户列表临时文件
awk -F '[,|]' '{
    if (FILENAME=="'$code_file'"){
        nodist[$4]=$5","$3","$1","$2
    }else if(FILENAME=="'$price_file'"){
        sp_name=$2
        sp_type=$4
        sp_price=$6
        app[$3]=sp_name","sp_type","sp_price

    }else if(FILENAME=="'$tmp_new_month_user_list_file'"){
        ##上月新增订购用户
        phone=$1                     #手机号码
        appcode=$2                   #APP代码
        mark=phone"|"appcode
        new_subscribe_list[mark]=1

        if(substr(phone,1,8) in nodist){
            area_info=nodist[substr(phone,1,8)]
        }else if(substr(phone,1,7) in nodist){
            area_info=nodist[substr(phone,1,7)]
        }else{
            area_info="000,000,未知,未知"
        }
        sp_info=app[appcode]
        flag=area_info","sp_info
        all[flag]=1
        new_subscribe_month_user[flag]++
    }else if(FILENAME=="'$tmp_current_month_user_list_file'"){
        #本月在订的用户
        phone=$1                     #手机号码
        appcode=$2                   #APP代码
        mark=phone"|"appcode        
        
        if(mark in new_subscribe_list){
            if(substr(phone,1,8) in nodist){
                area_info=nodist[substr(phone,1,8)]
            }else if(substr(phone,1,7) in nodist){
                area_info=nodist[substr(phone,1,7)]
            }else{
                area_info="000,000,未知,未知"
            }

        sp_info=app[appcode]
        flag=area_info","sp_info
        current_subscribe_month_user[flag]++
        }
    }else if(FILENAME=="'$tmp_last_month_user_list_file'"){
        #tmp_last_month_user_list_file
        phone=$1                     #手机号码
        appcode=$2                   #APP代码
        mark=phone"|"appcode

        if(mark in new_subscribe_list){
            if(substr(phone,1,8) in nodist){
                area_info=nodist[substr(phone,1,8)]
            }else if(substr(phone,1,7) in nodist){
                area_info=nodist[substr(phone,1,7)]
            }else{
                area_info="000,000,未知,未知"
            }

        sp_info=app[appcode]
        flag=area_info","sp_info
        last_subscribe[flag]++

        }  
    }          
}END{for (i in all){
        printf("%s,%d,%d,%d\n",i,new_subscribe_month_user[i],current_subscribe_month_user[i],last_subscribe[i])
}}' $code_file $price_file $tmp_new_month_user_list_file $tmp_current_month_user_list_file $tmp_last_month_user_list_file  >$tmp_stock_user_file



