#!/bin/sh
. /usr/local/app/dana/current/shbb/profile

if [ $# -eq 1 ] ; then
    V_DATE=$1
else
    echo "Usage:$0 20140101"
    exit 1
fi

V_DAY=$(echo $V_DATE | cut -c 7-8)
#判断是否是2号，否：退出
if [ $V_DAY -eq 02 ];then
	echo "如果是2号,继续执行，否则退出,避免再生资源"
else
	exit 1
fi
#取上个月的起止时间
while [ $V_DAY -eq 02 ]
    do
        END_DATE=$(date -v-2d -j $V_DATE"0000" +%Y%m%d)
		  V_YEAR=$(echo $END_DATE | cut -c 1-4)
        THIS_MONTH=$(echo $END_DATE | cut -c 1-6)
        START_DATE=$(echo $END_DATE | cut -c 1-6)"01"
        LAST_MONTH_DAY=$(date -v-1d -j $START_DATE"0000" +%Y%m%d)
        LAST_MONTH=$(echo $LAST_MONTH_DAY | cut -c 1-6)
        LAST_YEAR=$(echo $LAST_MONTH_DAY | cut -c 1-4)
        V_DAY="00"
    done

ORIG_DIR=$AUTO_SRC_DATA
#REPORT_DIR=$AUTO_DATA_REPORT/$V_YEAR/$V_MONTH
REPORT_DIR=$AUTO_DATA_REPORT
CODE_DIR=$AUTO_DATA_NODIST


code_file=$CODE_DIR/nodist.tsv

price_file=$CODE_DIR/qx_appcode_new.txt


ORIG_DIR=$AUTO_SRC_DATA
TARGET_DIR=$AUTO_DATA_TARGET/$V_YEAR/$END_DATE
REPORT_DIR=$AUTO_DATA_REPORT
CODE_DIR=$AUTO_DATA_NODIST


code_file=$CODE_DIR/nodist.tsv

tmp_month_subsrib=$TARGET_DIR/tmp_month_subsrib.txt
tmp_report_month_subscribe=$TARGET_DIR/tmp_report_month_subscribe.txt
tmp_current_time_month_list=$TARGET_DIR/tmp_current_time_month_list.txt
tmp_last_time_month_list=$TARGET_DIR/tmp_last_time_month_list.txt

tmp_current_month_user_list_file=$TARGET_DIR/tmp_current_month_user_list.txt
tmp_new_month_user_list_file=$TARGET_DIR/tmp_new_month_user_list.txt
tmp_last_month_user_list_file=$TARGET_DIR/tmp_last_month_user_list.txt
last_snapshot=$TARGET_DIR/last_snapshot.txt
tmp_stock_user_file=$TARGET_DIR/tmp_stok_user.txt

time_tmp=$TARGET_DIR/time_month_tmp_user.txt

report_file=$AUTO_DATA_REPORT/$V_YEAR/month_$THIS_MONTH/report.region.qianxiang_subscribe_city.csv

####################################################################################################
#月订购退订指标
cat $AUTO_DATA_REPORT/$V_YEAR/$THIS_MONTH*/report.region.qianxiang_subscribe_city.csv >$tmp_month_subsrib


awk -F\, '{
    flag=$1","$2","$3","$4","$5","$6","$7","$8
    all[flag]=1
    a[flag]+=$10
    b[flag]+=$12
}END{for(i in all){
    printf("%s,%d,%d\n",i,a[i],b[i])
}}' $tmp_month_subsrib >$tmp_report_month_subscribe


################################################################################
#月点播存量指标

cat $AUTO_DATA_TARGET/$V_YEAR/$THIS_MONTH*/time_list.txt >$tmp_current_time_month_list

cat $AUTO_DATA_TARGET/$LAST_YEAR/$LAST_MONTH*/time_list.txt >$tmp_last_time_month_list

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
    else if(FILENAME=="'$tmp_last_time_month_list'"){

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
      else if(FILENAME=="'$tmp_current_time_month_list'"){
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
    }' $price_file $code_file $tmp_last_time_month_list $tmp_current_time_month_list >$time_tmp



################################################################################################
#月存量指标

SNAP_DIR=$ORIG_DIR
#本月在订的用户
bzcat $SNAP_DIR/$END_DATE/data/snapshot/snapshot.txt.bz2 |awk -F\| '(substr($5,1,6)=="'$THIS_MONTH'"&&$3=="07")||(substr($4,1,6)=="'$THIS_MONTH'"&&$3=="06"){print $1"|"$2"|current_subscribe"}' >$tmp_current_month_user_list_file
#上月新增订购用户
bzcat $SNAP_DIR/$LAST_MONTH_DAY/data/snapshot/snapshot.txt.bz2 >$last_snapshot

awk -F\| 'substr($4,1,6)=="'$LAST_MONTH'"&&$3=="06"{print $1"|"$2"|new_subscribe"}' >$tmp_new_month_user_list_file
#上月在订用户
awk -F\| '$3=="06"{print $1"|"$2"|last_subscribe"}' $last_snapshot>$tmp_last_month_user_list_file




awk -F '[,|]' '{
    if (FILENAME=="'$code_file'"){
        nodist[$4]=$5","$3","$1","$2
    }else if(FILENAME=="'$price_file'"){
        sp_name=$2
        sp_type=$4
        sp_price=$6
        app[$3]=$NF","sp_name","sp_type","sp_price

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
        

        #本月新增包月用户数 --上月新增的包月用户数
        new_subscribe_month_user[flag]++

    }else if(FILENAME=="'$tmp_current_month_user_list_file'"){
        #上月在订&本月在订的用户
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

        #新增包月存量用户数 --上月新增且本月扔在订的用户数
        if(mark in new_subscribe_list){
            
            last_current_subscribe_month_user[flag]++

        }
        #存量包月用户数   --上月在订且本月依旧在订的用户数
        


    }else if(FILENAME=="'$tmp_last_month_user_list_file'"){
        #上月用户留存
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
        #上月新增包月用户数，上月新增且本月扔在订的用户数，上月在订且本月依旧在订的用户数，上个月状态为订购的用户数

        printf("%s,%d,%d,%d,%d,%d\n",i,new_subscribe_month_user[i],last_current_subscribe_month_user[i],final_subscribe[i],last_month_user[i],current_month_user[i])
}}' $code_file $price_file $tmp_new_month_user_list_file $tmp_current_month_user_list_file $tmp_last_month_user_list_file >$tmp_stock_user_file


##############################################################################################
#月计费用户数指标

# sh qx_detal_day.sh $END_DATE

# pbunzip2 -d -p4 -c /logs/orig/$V_DATE/data/snapshot/snapshot.txt.bz2|
# gawk -F\| 'BEGIN{
#   Current_date="'${V_DATE}'235959";Month=substr(Current_date,1,6)"00000000"
#   Code_File_nodist="'$CODE_DIR'/nodist.tsv"
#   Code_File_appcode="'$FILE_APP_CODE'"
#   while(getline var <Code_File_nodist)
#   {
#      split(var,v,"|")
#      nodist[v[4]]=v[5]","v[3]","v[1]","v[2]
#   }
#   while(getline var <Code_File_appcode)
#   {
#      split(var,v,"|")

#        app[v[3]]=v[8]","v[2]","v[4]","v[6]

#   }
#  }
#  {
#    if ($2 in app)
#      {
#        op_time=$4;prior_time=$5;last_time=$6;
#        appcode=$2;is_subscribed=$3;userid=$1
#        if(substr(userid,1,8) in nodist)
#        {
#     province[userid]=nodist[substr(userid,1,8)]
#        }
#        else if(substr(userid,1,7) in nodist)
#        {
#          province[userid]=nodist[substr(userid,1,7)]
#        }
#        else
#        {
#      province[userid]="000,000,未知,未知"
#        }
#        user_type=(last_time <Month) ? 1:0  # 老用户 1 新用户 0
#        last_day =substr(last_time,7,2)
#        prior_day=substr(prior_time,7,2)
#        t=op_time
#        yy=substr(t,1,4);mm=substr(t,5,2);dd=substr(t,7,2);
#        hh=substr(t,9,2) ;Mi=substr(t,11,2); ss=substr(t,13,2)
#        s=yy" "mm" "dd" "hh" "Mi" "ss
#        a=mktime(s)
#        t=last_time
#        yy=substr(t,1,4);mm=substr(t,5,2);dd=substr(t,7,2);
#        hh=substr(t,9,2) ;Mi=substr(t,11,2); ss=substr(t,13,2)
#        s=yy" "mm" "dd" "hh" "Mi" "ss
#        b=mktime(s)
#        t=Current_date
#        yy=substr(t,1,4);mm=substr(t,5,2);dd=substr(t,7,2);
#        hh=substr(t,9,2) ;Mi=substr(t,11,2) ;ss=substr(t,13,2)
#        s=yy" "mm" "dd" "hh" "Mi" "ss
#        c=mktime(s)
#        out_list=userid","appcode","app[appcode]","province[userid]
       
  
#        if (user_type==1)  #老用户
#        {
#          #老用户，当前状态为订购，当前时间-最近一次订购时间>72小时
#          if ((is_subscribed=="06")&&((c-b-259200) > 0))  
#          {
#            print out_list
#          }  
#          else if((is_subscribed=="07")&&((a-b-259200) > 0)&&(op_time>=Month))
#          {
#            print out_list
#          }
#        }
#        else if (user_type==0)  #新用户
#        {
#            #老用户，当前状态为订购，当前时间-最近一次订购时间>72小时
#          if ((is_subscribed=="06")&&(prior_time==last_time)&&((c-b-259200) > 0)) 
#          {
#            print out_list
#          } 
#          else if ((is_subscribed=="07")&&(prior_time==last_time)&&((a-b-259200) > 0)) 
#          {
#            print out_list
#          }
#          else if(prior_time<last_time)  #重复订购（当月首次订购时间<最后一次订购时间）
#          {
#            print out_list
#          }
#        }
#    }
#  }' >$tmp_file

#  gawk -F'[|,]' 'BEGIN{
#       while(getline var <"'$FILE_APP_CODE'")
#       {
#          split(var,v,"|")
#          if(v[5]>0)
#          {
#             app[v[3]]=v[5]/100
#          }
#       }
#       while(getline var <"'$shbb_outSucc_file'")
#       {
#         split(var,v,",")
#         userid=v[1]
#         appcode=v[2]
#         # 下发次数
#         sendnum=v[3]
#         if(appcode in app)
#         {
#           USER_NUM[userid"|"appcode]=sendnum
#         }
#       }
#       while(getline var <"'$FILE_UNPRICE_CODE'")
#       {
#             split(var,v,"|")
#             un_app[v[3]]=1

#       }
#     }
#     {   
#       if ($2 in un_app){

#         city_appcode[prov_code","city_code","prov_name","city","appcode]++
      
#       }

#       else if((!($2 in un_app))&&(USER_NUM[$1"|"$2]>=(app[$2]/2)))
#       {
#         prov_name=$7
#         prov_code=$8
#         appcode=$3","$4","$5","$6
#         city=$9
#         city_code=$10
#         city_appcode[prov_code","city_code","prov_name","city","appcode]++
#       }  
#    }END{

#    for(name in city_appcode)
#    {
#      printf("%s,%d\n",name,city_appcode[name]) 
#    }
#   }' $tmp_file > $TARGET_DIR/tmp_pay_user.csv

#echo "省编码,省名称,市编码,市名称,业务主类,业务名称,业务类型,业务资费,前向包月订购用户数,订购用户数,点播用户数,退订用户数,付费用户数,上月新增包月用户数,上月新增留存用户数,本月留存包月用户数,上月包月用户数,本月留存点播用户数,上月点播用户数" > $report_file

#整合成结果文件
awk -F\, '{
    flag=$1","$2","$3","$4","$5","$6","$7","$8
    all[flag]=1
    if(FILENAME=="'$tmp_report_month_subscribe'"){        
        #订阅用户数
        dy[flag]=$9
        #退订用户数
        dt[flag]=$10

    }else if(FILENAME=="'$time_tmp'"){
        #上月点播用户数
        last_db[flag]=$9
        #本月点播用户数
        current_db[flag]=$10
        #本月点播留存用户数
        last_current_db[flag]=$11
    }else{

        #上月新增的包月用户数
        last_new_month[flag]=$9
        #新增留存包月用户数
        last_current_month[flag]=$10
        #留存包月用户数
        last_stock_month[flag]=$11
        #上月包月用户数
        stock_month[flag]=$12
		#前向包月订购用户数
		current_month[flag]=$13
    }

}END{
    for(i in all){
        printf ("%s,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\n",i,current_month[i],dy[i],current_db[i],dt[i],0,last_new_month[i],last_current_month[i],last_stock_month[i],stock_month[i],last_current_db[i],last_db[i])
    }

}' $tmp_report_month_subscribe $time_tmp $tmp_stock_user_file>$AUTO_DATA_REPORT/$V_YEAR/month_$THIS_MONTH/qianxiang_subscribe_city_tmp.csv

#以上是按照全国报表配置的字典文件
#按照四川需求配置出不加序号的小类业务名称与分短信彩信业务类型
echo "省编码,省名称,市编码,市名称,业务主类,业务名称,业务类型,业务资费,前向包月订购用户数,订购用户数,点播用户数,退订用户数,付费用户数,上月新增包月用户数,上月新增留存用户数,本月留存包月用户数,上月包月用户数,本月留存点播用户数,上月点播用户数,四川业务类型,四川业务名称,四川业务资费" > $report_file

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
}' $CODE_DIR/qx_sichuan_appcode.txt $AUTO_DATA_REPORT/$V_YEAR/month_$THIS_MONTH/qianxiang_subscribe_city_tmp.csv >>$report_file

rm $AUTO_DATA_REPORT/$V_YEAR/month_$THIS_MONTH/qianxiang_subscribe_city_tmp.csv
