#!/bin/sh
. /usr/local/app/dana/current/shbb/profile
usage () {
    echo "usage: $0  target_dir" 1>&2
    exit 2
}

if [ $# -lt 1 ] ; then
  usage
fi
V_DATE=$1

TIME_FLAG="week"
WEEKNUM=$(date -j ${V_DATE}"0000" +%u )
[ $TIME_FLAG = 'week' -a $WEEKNUM -ne 2 ] && exit 0
#结束日期
ENDDATE=$V_DATE
#开始日期
STARTDATE=$(date -v-6d -j ${V_DATE}"0000" +%Y%m%d )
LOOPVAL=6

while [ $LOOPVAL -ge 0 ]
	do
	   OUTDATE=$(date -v-${LOOPVAL}d -j ${ENDDATE}"0000" +%Y%m%d )
       V_YEAR=$(echo $OUTDATE | cut -c 1-4)
##定义所有用户文件列表,追加到相应变量中
#数据文件  
       #一周的usa
       usa_log=`echo "$usa_log ${AUTO_SRC_DATA}/${OUTDATE}/usa2-biz.log.*${OUTDATE}.bz2"`
       LOOPVAL=`expr $LOOPVAL - 1`
	done

#startdate的前1天
Last_day=$(date -v-1d -j ${STARTDATE}"0000" +%Y%m%d )
REPORT_DIR=$AUTO_DATA_REPORT/$V_YEAR/week_${STARTDATE}_${ENDDATE}
[ -d "${REPORT_DIR}" ]||{ mkdir -p ${REPORT_DIR};}||{ exit 1;}
CODE_DIR=$AUTO_DATA_NODIST
NODIST_NOSVN_DIR=$AUTO_DANA_NODIST
# dict
NODIST=$CODE_DIR/nodist.tsv
APP_CODE=$CODE_DIR/meiti_app_code.txt
shbb_chanel=$NODIST_NOSVN_DIR/shbb_chanel.txt
[ -f "$NODIST" ]||{ exit 1;}
[ -f "$APP_CODE" ]||{ exit 1;}
[ -f "$shbb_chanel" ]||{ exit 1;}
#report file
REPORT_DAY=${REPORT_DIR}/report.region.meiti_cancel_rate_city.csv
snapshot=${AUTO_SRC_DATA}/${Last_day}/data/snapshot/snapshot.txt.bz2
#data deal
 { pbunzip2 -d -p4 -c $usa_log;echo "snapshot";pbunzip2 -d -p4 -c $snapshot;}|
 gawk -F'|' 'BEGIN{
   while(getline var <"'$NODIST'")
   {
     split(var,v,"|")
     nodist[v[4]]=v[5]","v[1]","v[3]","v[2]
   }
   while(getline var <"'$APP_CODE'")
   {
     split(var,v,"|")
     app[v[1]]=v[2]      
   }
   while(getline var <"'$shbb_chanel'")
   { split(var,v,"|")
     chanel_name1[v[1]]=v[1]
     chanel_name2[v[2]]=v[2]
     chanel_name3[v[3]]=v[3]              
   }
   flag="usa"
 }
 {
 if(flag=="usa")
 {
   stat=$2
   userid=$3
   appcode=$7
   index_str=userid","appcode
   if(stat=="pause" || stat=="activate")
   {
     pau_act[index_str]=stat
   }
   else if(stat=="cancel")
   {
     chanel1=$11
     chanel2=$12
     chanel3=$13
     if ((chanel1 in chanel_name1)&&(length(chanel1)>0))
     {
       if((chanel2 in chanel_name2)&&(length(chanel2)>0))
       {
         if ((!(chanel3 in chanel_name3))||(length(chanel3)==0))
         {
           chanel3="None"
         }
       }
       else 
       {
         chanel2="None"
         chanel3="None"
       }
     }
     else
     {
       chanel1="None"
       chanel2="None"
       chanel3="None"                    
     }
     ch3=chanel1","chanel2","chanel3
     if((!(index_str in pau_act)) || (pau_act[index_str]=="activate"))   
     {
       act_can[index_str]=ch3 
     }
     if((!(index_str in pau_act)) || (pau_act[index_str]=="pause"))
     {
       pau_can[index_str]=ch3
     }
     cancel_user[index_str]=ch3
   }
 }
 if($0=="snapshot")
 {
   flag="snapshot"
   next
 }
 if((flag=="snapshot") && ($2 in app) &&($3=="06"))
 { 
     userid=$1
     appcode=$2
     is_active=$7
     h7=substr(userid,1,7)
     h8=substr(userid,1,8)
     if( h7 in nodist){
       index_str=nodist[h7]
     }
     else if(h8 in nodist)
     {
       index_str=nodist[h8]     
     }
     else
     {
       index_str="000,未知,000,未知"
     }
     index_str=index_str","appcode","app[appcode]
     a[index_str]=1
     ind=userid","appcode
     #正常退订用户,周期正常用户数
     if(is_active>0)
     {
        active_user[index_str]++
        if(ind in act_can)
        {
          active_can_user[index_str","act_can[ind]]++
          kk[index_str","act_can[ind]]=index_str
        }
     }
     else #暂停退订用户,周期暂停用户数
     {
       pau_user[index_str]++
       if(ind in pau_can)
       {
         pau_can_user[index_str","pau_can[ind]]++
         kk[index_str","pau_can[ind]]=index_str
       }
     }
     if(ind in cancel_user) #综合退订用户
     {
       cancel_user[index_str","cancel_user[ind]]++
       kk[index_str","cancel_user[ind]]=index_str
     }
  }
}END{
    title="省份编码,省份名称,地市编码,地市名称,APPCODE,杂志名称,渠道1,渠道2,渠道3"
    title=title",正常退订用户,周期正常用户数,正常退订率,暂停退订用户,周期暂停用户数"
    title=title",暂停退订率,综合退订用户数,周期总用户数,综合退订率"
    print title
    for(name in kk)
    {
       a1=active_user[kk[name]]
       a2=(length(active_can_user[name])>0)?active_can_user[name]:0
       b1=pau_user[kk[name]]
       b2=(length(pau_can_user[name])>0)?pau_can_user[name]:0
       c1=cancel_user[name]
       c2=a1+b1
       b=(a1>0)?(a2*100/a1):0
       c=(b1>0)?(b2*100/b1):0
       d=c1*100/c2
       printf("%s,%d,%d,%.4f%s,%d,%d,%.4f%s,%d,%d,%.4f%s\n",name,a2,a1,b,"%",b2,b1,c,"%",c1,c2,d,"%")
    }
  }' >$REPORT_DAY
