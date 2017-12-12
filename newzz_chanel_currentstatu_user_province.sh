#!/bin/sh
. /usr/local/app/dana/current/shbb/profile
#. /home/shihy/bin/shbb_20090423/profile

usage () {
    echo "usage: $0  target_dir" 1>&2
    exit 2
}

  if [ $# -lt 1 ] ; then
     usage
  fi
V_DATE=$1
V_YEAR=$(echo $V_DATE | cut -c 1-4)
TARGET_DIR=$AUTO_DATA_REPORT/$V_YEAR/$V_DATE
CODE_DIR=$AUTO_DATA_NODIST

  ERROR=0
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

  if [ ! -f "$TARGET_DIR/$$_tmp" ];then
    mkfifo $TARGET_DIR/$$_tmp
  fi

  # 字典文件
  FILE_NODIST=$CODE_DIR/nodist.tsv
  FILE_APP_CODE=$CODE_DIR/news_appcode.txt
  FILE_CHANEL_CODE=$CODE_DIR/shbb_chanel_code.txt

  # 数据文件
  bzcat /logs/orig/${V_DATE}/data/snapshot/snapshot.txt.bz2 > $TARGET_DIR/$$_tmp&
  DATA_FILE=$TARGET_DIR/$$_tmp

 #目标文件
  TARGET_FILE=$TARGET_DIR/report.region.newzz_chanel_currentstat_province.csv
  TARGET_FILE_1=$TARGET_DIR/report.region.newzz_chanel_currentstat_country.csv
  TARGET_FILE_2=$TARGET_DIR/report.region.newzz_chanel_currentstat_city.csv
  gawk -F\| 'BEGIN{
                   Code_File_nodist="'$CODE_DIR'/nodist.tsv"
                   Code_File_appcode="'$CODE_DIR'/news_appcode.txt"
                 }
                 {
                 if(FILENAME==Code_File_nodist)
                 {
                   nodist[$4]=$5","$1
                   nodist_city[$4]=$5","$1","$3","$2
                 }
                 else if(FILENAME==Code_File_appcode)
                 {
                     app[$1]=$2
                 }
                 else if(FILENAME=="'$FILE_CHANEL_CODE'")
                 {
                 	 i++;ch[$1]=$2;ch_order[i]=$1
                 }
                 else if (($2 in app) && ($3=="06") )
                 {
                    appcode=$2;is_subscribed=$3;userid=$1;is_succ=$7;chanel=$11;servicename=app[$2]
                    flag=(is_succ>0) ? "正常发送":"暂停发送"
                    if(substr(userid,1,7) in nodist)
                    {
                      province[userid]=nodist[substr(userid,1,7)]
                      province_1[userid]=nodist_city[substr(userid,1,7)]
                      prov_city[nodist[substr(userid,1,7)]]=1
                      prov_city_1[nodist_city[substr(userid,1,7)]]=1

                    }
                    else if(substr(userid,1,8) in nodist)
                    {
                      province[userid]=nodist[substr(userid,1,8)]
                      province_1[userid]=nodist_city[substr(userid,1,8)]
                      prov_city[nodist[substr(userid,1,8)]]=1
                      prov_city_1[nodist_city[substr(userid,1,8)]]=1
                    }
                    else
                    {
                       province[userid]="000,未知"
                       prov_city["000,未知"]=1
                       province_1[userid]="000,000,未知,未知"
                       prov_city_1["000,000,未知,未知"]=1
                    }
                    #处理appcode
                    if(chanel in ch)
                    {
                        str=province[userid]","servicename","appcode","chanel""flag #在显示的配置表中
                        str_1=servicename","appcode","chanel""flag
                        str_2=province_1[userid]","servicename","appcode","chanel""flag #在显示的配置表中
                    }
                    else
                    {
                       str=province[userid]","servicename","appcode",OTHERS"flag #不在配置表中显示其它
                       str_1=servicename","appcode",OTHERS"flag
                       str_2=province_1[userid]","servicename","appcode",OTHERS"flag #不在配置表中显示其它

                    }
                    ch_str[province[userid]","servicename","appcode]=1
                    ch_str1[servicename","appcode]=1
                    ch_str2[province_1[userid]","servicename","appcode]=1
                    p[str]++
                    p_1[str_1]++
                    p_2[str_2]++
                 }
            }END{
                 i++
                 ch_order[i]="OTHERS"
                 pau=""
                 suc=""
                 for(m=1;m<=i;m++)
                 {
                       s=ch_order[m]
                       suc=suc",正常发送("s")"
                       pau=pau",暂停发送("s")"
                 }
                 appcodeList=suc""pau
                 list="省份编码,省份名称,杂志名称,APPCODE"appcodeList
                 print list >"'$TARGET_FILE'"
                 list="合计,杂志名称,APPCODE"appcodeList
                 print list >"'$TARGET_FILE_1'"
                 list="省份编码,省份名称,地区编码,地区名称,杂志名称,APPCODE"appcodeList
                 print list >"'$TARGET_FILE_2'"
                 for(s in ch_str)
                 {
                        row_data1=""
                        row_data2=""
                        for(m=1;m<=i;m++)
                        {
                            k=ch_order[m]
                            str1=s","k"正常发送"
                            str2=s","k"暂停发送"
                            suss_send=(p[str1]>0)?p[str1]:0
                            pause_send=(p[str2]>0)?p[str2]:0

                            row_data1=row_data1","suss_send
                            row_data2=row_data2","pause_send
                        }
                        printf("%s%s%s\n",s,row_data1,row_data2) >>"'$TARGET_FILE'"
                 }
                 for(s in ch_str2)
                 {
                        row_data1=""
                        row_data2=""
                        for(m=1;m<=i;m++)
                        {
                            k=ch_order[m]
                            str1=s","k"正常发送"
                            str2=s","k"暂停发送"
                            suss_send=(p_2[str1]>0)?p_2[str1]:0
                            pause_send=(p_2[str2]>0)?p_2[str2]:0
                            row_data1=row_data1","suss_send
                            row_data2=row_data2","pause_send
                        }
                        printf("%s%s%s\n",s,row_data1,row_data2) >>"'$TARGET_FILE_2'"
                 }

                 for(s in ch_str1)
                 {

                        row_data1=""
                        row_data2=""
                        for(m=1;m<=i;m++)
                        {
                            k=ch_order[m]
                            str1=k"正常发送"
                            str2=k"暂停发送"
                            suss_send=(p_1[s","str1]>0)?p_1[s","str1]:0
                            pause_send=(p_1[s","str2]>0)?p_1[s","str2]:0
                            row_data1=row_data1","suss_send
                            row_data2=row_data2","pause_send
                        }
                        printf("%s,%s%s%s\n","合计",s,row_data1,row_data2) >>"'$TARGET_FILE_1'"
								}
             }' $FILE_NODIST $FILE_APP_CODE $FILE_CHANEL_CODE $DATA_FILE
						ERROR=$?
            rm $DATA_FILE
  if [ $ERROR -gt 0 ]; then
   	exit 1
  else
		wait $!
  fi

