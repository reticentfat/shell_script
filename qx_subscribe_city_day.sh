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

#路径
ORIG_DIR=$AUTO_SRC_DATA
TMP_MM7_CMPP_DIR=$AUTO_DATA_TARGET/$V_YEAR
TARGET_DIR=$AUTO_DATA_TARGET/$V_YEAR/$V_DATE
REPORT_DIR=$AUTO_DATA_REPORT/$V_YEAR/$V_DATE
CODE_DIR=$AUTO_DATA_NODIST

#字典
FILE_NODIST=$CODE_DIR/nodist.tsv
code_file=$CODE_DIR/nodist.tsv
price_file=$CODE_DIR/qx_appcode_new.txt
#price_file=$CODE_DIR/qx_appcode.txt
FILE_UNPRICE_CODE=$CODE_DIR/qx_ten_appcode.txt
#FILE_APP_CODE=$CODE_DIR/qx_appcode.txt
FILE_APP_CODE==$CODE_DIR/qx_appcode_new.txt
#结果文件
#report_file=~/report.region.qianxiang_subscribed_city_day.csv
report_file=$REPORT_DIR/report.region.qianxiang_subscribe_city.csv


CMPP_OUT=$TARGET_DIR/cmpp_out.txt
TIME_LIST=$TARGET_DIR/time_list.txt

#快照临时文件
tmp_snapshot_file=$TARGET_DIR/tmp_snapshot_today_txt
#订购退订用户数中间文件
tmp_report_file=$TARGET_DIR/tmp_report_subscribed.csv
#计费用户列表
tmp_pay_list_file=$TARGET_DIR/tmp_pay_user_list.txt
#计费用户数中间结果文件
tmp_pay_user_file=$TARGET_DIR/tmp_pay_user.csv
#点播用户数中间结果文件
time_tmp=$TARGET_DIR/tmp_time_user.txt


FILE_NODIST=$CODE_DIR/nodist.tsv



#计费用户数下发次数
shbb_outSucc_file=$TARGET_DIR/qx_detail_$V_DATE.txt




#生成每日计费用户数下发列表
#sh qx_detal_day.sh $V_DATE



# #生成快照的临时文件
SNAP_DIR=$ORIG_DIR/$V_DATE/data/snapshot
bzcat $SNAP_DIR/snapshot.txt.bz2 |awk -F\| '{print $1"|"$2"|"$3"|"$4"|"$5"|"$6"|"$7}' >$tmp_snapshot_file
        
#生成短信点播用户数列表
awk -F\| '{
    if(FILENAME=="'$price_file'"){
        if($7=="02"){
        time[$3]=1   
        }
    }else{
    if($8 in time&&$22=="0"){
    b[$NF]=$5"|"$8
        }
    }
}END{for(i in b){
        print b[i]
    }
}' $price_file $CMPP_OUT > $TIME_LIST

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
    else if(FILENAME=="'$TIME_LIST'"){
        #统计当日点播用户数
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
                current_day_time_user[flag]++
            }                  
        }

}
    END{
        for(i in all){
            printf ("%s,%d\n",i,current_day_time_user[i])
        }
    }' $price_file $code_file $TIME_LIST >$time_tmp




#生成计费用户数列表
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
#  }' $tmp_snapshot_file >$tmp_pay_list_file

# #统计计费用户数
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
#   }' $tmp_pay_list_file > $tmp_pay_user_file



#生成新增退订用户数
awk -F\| '{
    if (FILENAME=="'$code_file'"){
        nodist[$4]=$5","$3","$1","$2
    }
    else if(FILENAME=="'$price_file'"){
        sp_class=$NF
        sp_name=$2
        sp_type=$4
        sp_price=$6
        all_app[$3]=sp_class","sp_name","sp_type","sp_price
        
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
            area_info="000,000,未知,未知"
        }
            
        if(appcode in all_app){
            sp_info=all_app[appcode]
            flag=area_info","sp_info
            all[flag]=1
            
            if(is_subscribed=="06"){
                #存量订购用户数
                subscribe_user[flag]++

            }

            if(is_subscribed=="06"&&substr($4,1,8)=="'$V_DATE'"){
                #新增订购用户数
                do_subscribe_user[flag]++

            }else if(is_subscribed=="07"&&substr($5,1,8)=="'$V_DATE'"){
                do_subscribe_user[flag]++
            }
                
                
            if(is_subscribed=="07"&&substr($4,1,8)=="'$V_DATE'"){
                #退订用户数
                cancel_user[flag]++
                 
            }
        }
    }
}END{
    for(i in all){
        printf("%s,%d,%d,%d\n",i,subscribe_user[i],do_subscribe_user[i],cancel_user[i])
    }
}' $code_file $price_file $tmp_snapshot_file >$tmp_report_file

#整合成结果文件
awk -F\, '{
    flag=$1","$2","$3","$4","$5","$6","$7","$8
    all[flag]=1
    if(FILENAME=="'$tmp_report_file'"){        
        #存量用户数
        qx[flag]=$9
        #订阅用户数
        dy[flag]=$10
        #退订用户数
        dt[flag]=$11

    }else{
        #点播用户数
        db[flag]=$9
    }

}END{
    for(i in all){
        printf ("%s,%d,%d,%d,%d,%d\n",i,qx[i],dy[i],db[i],dt[i],0)
    }

}' $tmp_report_file $time_tmp>>$AUTO_DATA_REPORT/$V_YEAR/$V_DATE/qianxiang_subscribe_city_tmp.csv
#}' $tmp_report_file $tmp_pay_user_file $time_tmp>>$report_file


#rm $tmp_report_file $tmp_cmpp_mm7_file $time_tmp $tmp_cmpp_mm7_file $tmp_price_user_file $tmp_snapshot_file $tmp_cmpp_mm7_file_1

echo "省编码,省名称,市编码,市名称,业务主类,业务名称,业务类型,业务资费,前向订购用户数,订购用户数,点播用户数,退订用户数,计费用户数,四川业务类型,四川业务名称,四川业务资费" > $report_file

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

}' $CODE_DIR/qx_sichuan_appcode.txt $AUTO_DATA_REPORT/$V_YEAR/$V_DATE/qianxiang_subscribe_city_tmp.csv >>$report_file

rm $AUTO_DATA_REPORT/$V_YEAR/$V_DATE/qianxiang_subscribe_city_tmp.csv




