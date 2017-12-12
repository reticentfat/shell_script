#!/bin/sh
. /usr/local/app/dana/current/shbb/profile

if [ $# -eq 1 ] ; then
    V_DATE=$1
else
    echo "Usage:$0 20140101"
    exit 1
fi

V_YEAR=$(echo $V_DATE | cut -c 1-4)
WEEKNUM=$(date -v-0d -j ${V_DATE}0000 +%w)
[ $WEEKNUM -ne 2 ] && exit 
END_DATE=$(date -v-0d -j $V_DATE"0000" +%Y%m%d)
BEGIN_DATE=$(date -v-6d -j $V_DATE"0000" +%Y%m%d)
LAST_END_DATE=$(date -v-7d -j $V_DATE"0000" +%Y%m%d)
LAST_BEGIN_DATE=$(date -v-13d -j $V_DATE"0000" +%Y%m%d)



CODE_DIR=$AUTO_DATA_NODIST
price_file=$CODE_DIR/qx_appcode_new.txt
code_file=$CODE_DIR/nodist.tsv
ORIG_DIR=$AUTO_SRC_DATA
TARGET_DIR=$AUTO_DATA_TARGET/$V_YEAR/$END_DATE
REPORT_DIR=/logs/out/dana/report/$V_YEAR/week_${BEGIN_DATE}_${END_DATE}
tmp_week_subsrib=$TARGET_DIR/tmp_week_subsrib.txt
tmp_report_week_subscribe=$TARGET_DIR/tmp_report_week_subscribe.txt
tmp_current_time_week_list=$TARGET_DIR/tmp_current_time_week_list.txt
tmp_last_time_week_list=$TARGET_DIR/tmp_last_time_week_list.txt
tmp_current_week_user_list_file=$TARGET_DIR/tmp_current_week_user_list.txt
tmp_new_week_user_list_file=$TARGET_DIR/tmp_new_week_user_list.txt
tmp_last_week_user_list_file=$TARGET_DIR/tmp_last_week_user_list.txt
last_snapshot=$TARGET_DIR/last_snapshot.txt
tmp_stock_user_file=$TARGET_DIR/tmp_stok_user.txt
time_tmp=$TARGET_DIR/time_week_tmp_user.txt
report_file=$REPORT_DIR/email.report.region.qianxiang_subscribe_city.csv

#判断目录是不正确
if [ ! -d "$REPORT_DIR" ]; then
    if ! mkdir -p $REPORT_DIR
	then
		echo "$REPORT_DIR not found"
		exit
	fi
fi

####################################################################################################
#周订购退订指标
loop=6

while [ $loop -ge 0 ] 
do
  day=$(date -v-${loop}d -j $END_DATE"0000" +%Y%m%d)
  V_YEAR=$(echo $day | cut -c 1-4)
  cat $AUTO_DATA_REPORT/$V_YEAR/$day/report.region.qianxiang_subscribe_city.csv >>$tmp_week_subsrib
  loop=`expr $loop - 1`
done

awk -F\, '{
    flag=$1","$2","$3","$4","$5","$6","$7","$8
    all[flag]=1
    a[flag]+=$10
    b[flag]+=$12
}END{for(i in all){
    printf("%s,%d,%d\n",i,a[i],b[i])
}}' $tmp_week_subsrib >$tmp_report_week_subscribe


################################################################################
#周点播存量指标
loop=6

while [ $loop -ge 0 ] 
do
  day=$(date -v-${loop}d -j $END_DATE"0000" +%Y%m%d)
  V_YEAR=$(echo $day | cut -c 1-4)
  cat $AUTO_DATA_TARGET/$V_YEAR/$day/time_list.txt >>$tmp_current_time_week_list
  loop=`expr $loop - 1`
done

loop=6

while [ $loop -ge 0 ] 
do
  day=$(date -v-${loop}d -j $LAST_END_DATE"0000" +%Y%m%d)
  V_YEAR=$(echo $day | cut -c 1-4)
  cat $AUTO_DATA_TARGET/$V_YEAR/$day/time_list.txt >>$tmp_last_time_week_list
  loop=`expr $loop - 1`
done


#点播用户数
awk -F\| '{
    if(FILENAME=="'$price_file'"){
        if($7=="02"){
        sp_class=$8
        sp_name=$2
        sp_type=$4
        sp_price=$6
        time[$3]=sp_class","sp_name","sp_type","sp_price  		
        }
    }
    else if (FILENAME=="'$code_file'"){
        nodist[$4]=$5","$3","$1","$2
    }
    else if(FILENAME=="'$tmp_last_time_week_list'"){

            appcode=$2
            phone=$1
            mark=phone","appcode

            last_month_time_user_list[mark]=1

            if(substr(phone,1,8) in nodist){
                area_info=nodist[substr(phone,1,8)]    
            }else if(substr(phone,1,7) in nodist){
                area_info=nodist[substr(phone,1,7)]
            }else{
                area_info="000,000,未知,未知"
            }

            if(appcode in time){
                sp_info=time[appcode]
                flag=area_info","sp_info
                all[flag]=1

                flag=area_info","sp_info
                last_month_time_user[flag]++
            }                  
        }
      else if(FILENAME=="'$tmp_current_time_week_list'"){
                appcode=$2
            phone=$1
            mark=phone","appcode

            if(substr(phone,1,8) in nodist){
                area_info=nodist[substr(phone,1,8)]    
            }else if(substr(phone,1,7) in nodist){
                area_info=nodist[substr(phone,1,7)]
            }else{
                area_info="000,000,未知,未知"
            }

            if(appcode in time){
                sp_info=time[appcode]
                flag=area_info","sp_info
                all[flag]=1

                flag=area_info","sp_info
                current_month_time_user[flag]++
            }
            if(mark in last_month_time_user_list){
                current_last_month_time_user[flag]++
            }
      }
    
}
    END{
        for(i in all){
            printf ("%s,%d,%d,%d\n",i,last_month_time_user[i],current_month_time_user[i],current_last_month_time_user[i])
        }
    }' $price_file $code_file $tmp_last_time_week_list $tmp_current_time_week_list >$time_tmp



################################################################################################
#周存量指标

SNAP_DIR=$ORIG_DIR
#本周在订的用户
bzcat $SNAP_DIR/$END_DATE/data/snapshot/snapshot.txt.bz2 |awk -F\| '$3=="06"{print $1"|"$2"|current_subscribe"}' >$tmp_current_week_user_list_file
#上周新增订购用户
bzcat $SNAP_DIR/$LAST_END_DATE/data/snapshot/snapshot.txt.bz2 >$last_snapshot

awk -F\| 'substr($4,1,8)<="'$LAST_END_DATE'"&&substr($4,1,8)>="'$LAST_BEGIN_DATE'"&&$3=="06"{print $1"|"$2"|new_subscribe"}' $last_snapshot>$tmp_new_week_user_list_file
#上周在订用户
awk -F\| '$3=="06"{print $1"|"$2"|last_subscribe"}' $last_snapshot>$tmp_last_week_user_list_file




awk -F '[,|]' '{
    if (FILENAME=="'$code_file'"){
        nodist[$4]=$5","$3","$1","$2
    }else if(FILENAME=="'$price_file'"){
        sp_name=$2
        sp_type=$4
        sp_price=$6
        app[$3]=$NF","sp_name","sp_type","sp_price

    }else if(FILENAME=="'$tmp_new_week_user_list_file'"){
        ##上周新增订购用户
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
        

        #本周新增包月用户数 --上周新增的包月用户数
        new_subscribe_month_user[flag]++

    }else if(FILENAME=="'$tmp_current_week_user_list_file'"){
        #上周在订&本周在订的用户
        phone=$1                     #手机号码
        appcode=$2                   #APP代码
        mark=phone"|"appcode        
        
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
        last_month_user_list[mark]=1
        current_month_user[flag]++

        #新增包月存量用户数 --上周新增且本周扔在订的用户数
        if(mark in new_subscribe_list){
            
            last_current_subscribe_month_user[flag]++

        }
        #存量包月用户数   --上周在订且本周依旧在订的用户数
        


    }else if(FILENAME=="'$tmp_last_week_user_list_file'"){
        #上周用户留存
        phone=$1                     #手机号码
        appcode=$2                   #APP代码
        mark=phone"|"appcode
        

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
        
        last_month_user[flag]++


        if(mark in last_month_user_list){

            final_subscribe[flag]++

        }  

    }          
}END{for (i in all){
        #上周新增包月用户数，上周新增且本周扔在订的用户数，上周在订且本周依旧在订的用户数，上个周状态为订购的用户数

        printf("%s,%d,%d,%d,%d,%d\n",i,new_subscribe_month_user[i],last_current_subscribe_month_user[i],final_subscribe[i],last_month_user[i],current_month_user[i])
}}' $code_file $price_file $tmp_new_week_user_list_file $tmp_current_week_user_list_file $tmp_last_week_user_list_file >$tmp_stock_user_file



#整合成结果文件
awk -F\, '{
    flag=$1","$2","$3","$4","$5","$6","$7","$8
    all[flag]=1
    if(FILENAME=="'$tmp_report_week_subscribe'"){        
        #订阅用户数
        dy[flag]=$9
        #退订用户数
        dt[flag]=$10

    }else if(FILENAME=="'$time_tmp'"){
        #上周点播用户数
        last_db[flag]=$9
        #本周点播用户数
        current_db[flag]=$10
        #本周点播留存用户数
        last_current_db[flag]=$11
    }else{

        #上周新增的包月用户数
        last_new_month[flag]=$9
        #新增留存包月用户数
        last_current_month[flag]=$10
        #留存包月用户数
        last_stock_month[flag]=$11
        #上周包月用户数
        stock_month[flag]=$12
		#前向包月订购用户数
		current_month[flag]=$13
    }

}END{
    for(i in all){
        printf ("%s,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\n",i,current_month[i],dy[i],current_db[i],dt[i],0,last_new_month[i],last_current_month[i],last_stock_month[i],stock_month[i],last_current_db[i],last_db[i])
    }

}' $tmp_report_week_subscribe $time_tmp $tmp_stock_user_file>$REPORT_DIR/qianxiang_subscribe_city_tmp.csv

#以上是按照全国报表配置的字典文件
#按照四川需求配置出不加序号的小类业务名称与分短信彩信业务类型
echo "省编码,省名称,市编码,市名称,业务主类,业务名称,业务类型,业务资费,前向包月订购用户数,订购用户数,点播用户数,退订用户数,付费用户数,上周新增包月用户数,上周新增留存用户数,本周留存包月用户数,上周包月用户数,本周留存点播用户数,上周点播用户数,四川业务类型,四川业务名称,四川业务资费" > $report_file

awk -F"[|,]" '{
    if(FILENAME=="'$CODE_DIR'/qx_sichuan_appcode.txt"){
        add_type[$2]=$12","$11
    }else{
        if($6 in add_type){
            print $0","add_type[$6]","$8
        }else{
            print $0",,,"
        }
    }

}' $CODE_DIR/qx_sichuan_appcode.txt $REPORT_DIR/qianxiang_subscribe_city_tmp.csv >>$report_file
rm $tmp_week_subsrib
rm $tmp_current_time_week_list
rm $tmp_last_time_week_list
rm -rf $REPORT_DIR/qianxiang_subscribe_city_tmp.csv
#rm $AUTO_DATA_REPORT/$V_YEAR/week_${BEGIN_DATE}_${END_DATE}/qianxiang_subscribe_city_tmp.csv
