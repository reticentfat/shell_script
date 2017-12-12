#!/bin/sh
. /usr/local/app/dana/current/shbb/profile
#. /home/chenly/profile

usage () {
    echo "usage: $0  target_dir" 1>&2
    exit 2
}

if [ $# -lt 1 ] ; then
    usage
fi

V_DATE=$1
V_YEAR=$(echo $V_DATE | cut -c 1-4)
V_MONTH=$(echo $V_DATE | cut -c 1-6)
SOURCE_DIR_1=$AUTO_DATA_TARGET/$V_YEAR/$V_DATE
#SOURCE_DIR_1=$AUTO_DATA_REPORT/$V_YEAR/$V_DATE
SOURCE_DIR_2=$AUTO_DATA_TARGET/$V_YEAR/$V_MONTH"01"
#SOURCE_DIR_2=$AUTO_DATA_REPORT/$V_YEAR/$V_MONTH"01"
TARGET_DIR=$AUTO_DATA_REPORT/$V_YEAR/$V_DATE
CODE_FILE=$AUTO_DATA_NODIST/nodist_city.txt
CODE_FILE1=$AUTO_DATA_NODIST/ci_code.txt
if [ ! -d "$TARGET_DIR" ]; then
  if ! mkdir -p $TARGET_DIR
  then
    echo "mkdir $TARGET_DIR error"
    exit 1
  fi
fi


 ERROR=0
 sour_file_1=$SOURCE_DIR_1/shbb_agent_ci_subscribe.${V_DATE}.txt
 result_file_1=$TARGET_DIR/report.region.agent_ci_sub_province.csv

 if [ ! -f "$sour_file_1" ];then
      echo " open file $sour_file_1 fail"
      exit 1
 fi


 awk -F\| '{                
	p[$3","$5","$6]++
	}END{
	  for(name in p)	
             {
               printf("%s,%d\n",name,p[name])
             }
	}' $CODE_FILE $sour_file_1 > $result_file_1

 #话务员推荐部分
 sour_file_2=$SOURCE_DIR_2/shbb_ci_agent_meiti.txt
 result_file_2=$TARGET_DIR/report.region.agent_ci_payuser_province.csv
 if [ ! -f "$sour_file_2" ];then
 		echo " open file $sour_file_2 fail"
 		exit 1
 fi
 awk -F\| '{
    str="'$V_DATE'"
    if($13==str)
      {
    	p[$6","$8","$9]++
      }
     }END{
	for(name in p) printf("%s,%d\n",name,p[name])
    }' $sour_file_2 > $result_file_2

 #合并报表
 result_file=$TARGET_DIR/report.region.agent_ci_meiti_report_province.csv


 awk -F'[|,]' '{
   if(FILENAME=="'$CODE_FILE'")
     {
        nodist[$4]=$1
     }
   else if(FILENAME=="'$CODE_FILE1'")
     {
        servname[$1]=$5
        app[$1]=$2
     }
   else if(FILENAME=="'$result_file_1'")
     { 
       if($1 in servname)
         {  province=(length($2)>0)?$2:"000"   #省编码
            provname=(length(nodist[$2])>0)?nodist[$2]:"未知"   #省名称
            servicecode=servname[$1] #杂志名称
            servcode=app[$1]     #业务代码
            agent=$3             #座席工号
            indexstr=province","provname","agent","servicecode","servcode
            s[indexstr]=1
  	    u[indexstr]=$4
         }
     }
   else
     {  
        if($1 in servname)
          { province=(length($2)>0)?$2:"000"   #省编码
            provname=(length(nodist[$2])>0)?nodist[$2]:"未知"   #省名称
            servicecode=servname[$1]   #杂志名称
            servcode=app[$1]  #业务代码
            agent=$3          #座席工号
            indexstr=province","provname","agent","servicecode","servcode
            s[indexstr]=1
  	    p[indexstr]=$4
          }
     }
 }END{
  printf("%s,%s,%s,%s,%s,%s,%s\n","省编码","省份名称","工号","杂志名称","业务代码","订制用户数","扣费用户数")
  for(a in s)
     {
  	printf("%s,%d,%d\n",a,u[a],p[a])
     }
}' $CODE_FILE $CODE_FILE1 $result_file_1 $result_file_2 > $result_file

#rm $result_file_2;
#rm $result_file_1;


