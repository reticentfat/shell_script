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
V_YEAR=$(echo $V_DATE | cut -c 1-4)
v_month=$(echo $V_DATE | cut -c 1-6)
TARGET_DIR=$AUTO_DATA_TARGET/$V_YEAR/$V_DATE
v_day=$(date -v-1d -j $v_month"010000" +%Y%m%d)
day=$(echo $v_day | cut -c 7-8)
year=$(echo $v_day | cut -c 1-4)
#包年用户名单列表
SOURCE_FILE=$AUTO_DATA_REPORT/$year/$v_day/shbb_year_user.txt
CODE_DIR=$AUTO_DATA_NODIST
NODIST_NOSVN_DIR=$AUTO_DANA_NODIST
if [ ! -d "$TARGET_DIR" ]; then
   if ! mkdir -p $TARGET_DIR
   then
     echo "mkdir $TARGET_DIR error"
     exit 1
   fi
fi
if [ ! -f "$CODE_DIR/nodist.tsv" ]; then
  echo "$CODE_DIR/nodist.tsv not found"
  exit 1
fi
# 字典文件
FILE_NODIST=$CODE_DIR/nodist.tsv
FILE_APP_CODE=$CODE_DIR/meiti_app_code.txt
FILE_CHANEL_CODE=$NODIST_NOSVN_DIR/shbb_chanel.txt
FILE_YEAR_CODE=$CODE_DIR/shbb_appcode_year.txt
shbb_outSucc_file=/logs/out/mm7/$V_DATE/stats_month.bizdev_shenghbb.1000
RESULT_FILE=$TARGET_DIR/meiti_payuser_list.txt


#判断文件是否存在，用while语法 文件不存在 则会等待，影响其他报表生成
[ -f "$FILE_NODIST" ]||{ exit 1;}
[ -f "$FILE_APP_CODE" ]||{ exit 1;}
[ -f "$FILE_CHANEL_CODE" ]||{ exit 1;}
[ -f "$FILE_YEAR_CODE" ]||{ exit 1;}
[ -f "$shbb_outSucc_file" ]||{ exit 1;}
[ -f "$SOURCE_FILE" ]||{ exit 1;}

  pbunzip2 -d -p4 -c /logs/orig/$V_DATE/data/snapshot/snapshot.txt.bz2|
  gawk -F\| 'BEGIN{
    Current_date="'${V_DATE}'235959";Month=substr(Current_date,1,6)"00000000"
    Code_File_nodist="'$CODE_DIR'/nodist.tsv"
    Code_File_appcode="'$CODE_DIR'/meiti_app_code.txt"
    while(getline var <Code_File_nodist)
    {
      split(var,v,"|")
      nodist[v[4]]=v[1]","v[5]","v[2]","v[3]
    }
    while(getline var <Code_File_appcode)
    {
      split(var,v,"|")
      if(v[6]>0)
      {
        app[v[1]]=v[6]
      }
    }
    while(getline var <"'$FILE_YEAR_CODE'")
    {
      split(var,v,"|")
      year_code[v[1]","v[2]]=1
    }
    while(getline var <"'$SOURCE_FILE'")
    {
      split(var,v,"|")
      year_user[v[1]","v[2]]=v[2]
    } 
  }
 {
    if(($2 in app)&&(!($1","$2 in year_user)))
    {
	userid=$1;appcode=$2;op_time=$4;prior_time=$5;
	last_time=$6;is_subscribed=$3;chanel1=$11;chanel2=$12;chanel3=$13
	if(substr(userid,1,7) in nodist)
	{
	  province[userid]=nodist[substr(userid,1,7)]
	}
	else if(substr(userid,1,8) in nodist)
	{
	  province[userid]=nodist[substr(userid,1,8)]
	}
	else
	{
	  province[userid]="未知,000,未知,000"
	}
	user_type=(last_time <Month) ? 1:0  # 老用户 1 新用户 0
	last_day =substr(last_time,7,2)
	prior_day=substr(prior_time,7,2)
	t=op_time
	yy=substr(t,1,4);mm=substr(t,5,2);dd=substr(t,7,2);
	hh=substr(t,9,2) ;Mi=substr(t,11,2); ss=substr(t,13,2)
	s=yy" "mm" "dd" "hh" "Mi" "ss
	a=mktime(s)  #操作时间
	t=last_time
	yy=substr(t,1,4);mm=substr(t,5,2);dd=substr(t,7,2);
	hh=substr(t,9,2) ;Mi=substr(t,11,2); ss=substr(t,13,2)
	s=yy" "mm" "dd" "hh" "Mi" "ss
	b=mktime(s)  #最后一次订阅时间
	t=Current_date
	yy=substr(t,1,4);mm=substr(t,5,2);dd=substr(t,7,2);
	hh=substr(t,9,2) ;Mi=substr(t,11,2) ;ss=substr(t,13,2)
	s=yy" "mm" "dd" "hh" "Mi" "ss
	c=mktime(s)  #当前时间
	out_list=userid","appcode","province[userid]","op_time","prior_time
	out_list=out_list","last_time","chanel1","chanel2","chanel3
	#如果是包年用户直接输出
	#取省份编码
	p_id=substr(province[userid],index(province[userid],",")+1,3)
	if(p_id","appcode in year_code)  #包年用户
	{
	  print out_list
	}
	else if (user_type==1)  #老用户
	{
 	  #老用户，当前状态为订购，当前时间-最近一次订购时间>72小时
	  if ((is_subscribed=="06")&&((c-b-259200) > 0))  
	  {
	    print out_list
	  }  
	  else if((is_subscribed=="07")&&((a-b-259200) > 0)&&(op_time>=Month))
          {
            print out_list
          }
         }
         else if (user_type==0)  #新用户
         {
           #新用户，当前状态为订购，当前时间-最近一次订购时间>72小时
           if ((is_subscribed=="06")&&(prior_time==last_time)&&((c-b-259200) > 0))  
           {
             print out_list
           } 
           else if ((is_subscribed=="07")&&(prior_time==last_time)&&((a-b-259200) > 0))        {
              print out_list
           }
           else if(prior_time<last_time)  #重复订购（当月首次订购时间<最后一次订购时间）
           {
              print out_list
           }
          }
        }
 }'|gawk -F'[|,]' 'BEGIN{
      while(getline var <"'$FILE_APP_CODE'")
      {
         split(var,v,"|")
         if(v[6]>0)
         {
           app[v[1]]=v[6]
         }
      }
      while(getline var <"'$FILE_YEAR_CODE'")
      {
         split(var,v,"|")
         year_code[v[1]","v[2]]=1
      }
      while(getline var <"'$shbb_outSucc_file'")
      {
        split(var,v,",")
        userid=v[1]
        appcode=v[2]
        # 下发次数
        sendnum=v[3]
        if(appcode in app)
        {
          USER_NUM[userid"|"appcode]=sendnum
        }
      }
 }
 {                  
    if((USER_NUM[$1"|"$2]>=(app[$2]/2))||($4","$2 in year_code))       
    {
      # 包月用户有单条过高的限制，个别省份包年用户没有单条过高限制，只要定制就要收费
      if($2 in app)
      {  
        userid=$1
        appcode=$2
        prov=$3
        prov_code=$4
        city=$5
        city_code=$6
        op_time=$7
        prior_time=$8
        last_time=$9
        chanel1=$10
        chanel2=$11
        chanel3=$12
        indexstr=userid","appcode","prov","prov_code","city 
        indexstr=indexstr","city_code","op_time","prior_time","last_time
        indexstr=indexstr","chanel1","chanel2","chanel3
        print indexstr >"'$RESULT_FILE'"
     } 
   }
 }' 
 
 
