#!/bin/sh
#. /home/chenly/profile
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
TARGET_DIR=$AUTO_DATA_TARGET/$V_YEAR/$V_DATE
REPORT_DIR=$AUTO_DATA_REPORT/$V_YEAR/$V_DATE
CODE_DIR=$AUTO_DATA_NODIST

  ERROR=0
  if [ ! -d "$TARGET_DIR" ]; then
    if ! mkdir -p $TARGET_DIR
    then
      echo "mkdir $TARGET_DIR error"
      exit 1
    fi
  fi
  
    if [ ! -d "$REPORT_DIR" ]; then
    if ! mkdir -p $REPORT_DIR
    then
      echo "mkdir $REPORT_DIR error"
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
  FILE_CHANEL_CODE=$CODE_DIR/area_manager_chanel.txt
  # 数据文件
  DATA_FILE=$TARGET_DIR/snapshot_deal.txt
  
 if [ ! -f "$DATA_FILE" ]; then
  echo "$DATA_FILE not found"
  exit 1
 fi
  
  # 结果文件
  RESULT_FILE=$REPORT_DIR/report.region.area_manager_sales_meiti_city.csv
     gawk -F\| '{
      if(FILENAME=="'$FILE_NODIST'")
      {
         nodist_city[$4]=$5","$1","$3","$2
      }
      else if(FILENAME=="'$FILE_APP_CODE'")
      {
         app[$1]=$6
      }
      else if(FILENAME=="'$FILE_CHANEL_CODE'")
      {
         if($2=="")
           {
             chanel[$1]=1
           }
         else if($3=="")
           {
             chanel11[$1]=1
             chanel22[$2]=1
           }
         else
           {
             chanel1[$1]=1
             chanel2[$2]=1
             chanel3[$3]=1
           }
      }
      else if (($2 in app)&&($3==06)) 
      {
         chanle_name1=$11;chanle_name2=$12;chanle_name3=$13
         if(((chanle_name1 in chanel1)&&(chanle_name2 in chanel2)&&(chanle_name3 in chanel3))||(chanle_name1 in chanel)||((chanle_name1 in chanel11)&&(chanle_name2 in chanel22)))
         {
			         userid=$1
			         #处理省市信息  
			         if(substr(userid,1,7) in nodist_city)
			         {
			            province=nodist_city[substr(userid,1,7)]
			         }
			         else if(substr(userid,1,8) in nodist_city)
			         {
			            province=nodist_city[substr(userid,1,8)]                     
			         }
			         else
			         {
			            province="000,未知,000,未知"
			         }			                  
			         if(app[$2]>0)   #计费杂志
			         {
			            indexstr1=province
			            allfee[indexstr1]++   #总用户数
			            if($7>0)
			            {
			               norfee[indexstr1]++   #正常用户数
			            }          
			         }         
			         else    #免费杂志
			         {
			            indexstr2=province"|"userid
			            allunfee[indexstr2]++
			            if($7>0)
			            {
			               norunfee[indexstr2]++
			            }
			         }
			      }
     }                          
}END{
str="省编码,省名称,地市编码,地市名称,正常指标用户数,总指标用户数"
  printf("%s\n",str)
for (name in allunfee)
  {
    split(name,a,"|")
    if(allunfee[name]>2)
    { 
      allfee[a[1]]+= 2
    }
    else if(allunfee[name]==2)
    { 
      allfee[a[1]]+=1.5
    }
    else if(allunfee[name]==1)
    { 
      allfee[a[1]]+=1
    }  
    
    if(norunfee[name]>2)
    { 
      norfee[a[1]]+= 2
    }
    else if(norunfee[name]==2)
    { 
      norfee[a[1]]+=1.5
    }
    else if(norunfee[name]==1)
    { 
      norfee[a[1]]+=1
    }  
 }
	for (provi in allfee)
  {  
    printf("%s,%.1f,%.1f\n",provi,norfee[provi],allfee[provi]) 
  }
}' $FILE_NODIST $FILE_APP_CODE $FILE_CHANEL_CODE $DATA_FILE > $RESULT_FILE

   if [ $ERROR -gt 0 ]; then
 	  exit $ERROR
   else
 	wait $!
   fi
