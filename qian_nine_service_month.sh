#!/bin/sh

. /usr/local/app/dana/current/ETL/profile

usage () {
    echo "usage: $0" 1>&2
    exit 2
}

if [ $# -lt 1 ] ; then
    usage
fi

V_DATE=$1
flag=$2
STARTDATE=`date -v-4d -j ${V_DATE}0000 +%Y%m%d`
V_YEAR=`echo $STARTDATE | cut -c 1-4`
V_MONTH=`echo $STARTDATE | cut -c 1-6`
REPORT_DIR=/logs/out/dana/wire/$V_YEAR/month_${V_MONTH}/wire_service
DATA_DIR=/logs/out/dana/wire/$V_YEAR/month_${V_MONTH}
#判断目录是不正确
if [ ! -d "$REPORT_DIR" ]; then
    if ! mkdir -p $REPORT_DIR
	then
		echo "$REPORT_DIR not found"
		exit
	fi
fi
TIME_FLAG="month"
TEMPDAY=`echo $V_DATE|cut -c 7-8`

[ $TIME_FLAG = 'month' -a $TEMPDAY != '02' ] && exit 0

rm $REPORT_DIR/*

awk 'BEGIN{
    FS=OFS=","
    while(getline var < "/usr/local/app/dana/current/shbb/qx_distinct_service.txt"){
         split(var,a,"|")
         service[a[1]]=a[2]
    }
}{
    if($5!=""&&$5!="其他"&&$5!="优惠券"){
       if($6 in service){
       add[$5",总计"]+=$10            #$10本月新增，数组add用来分维度求和
       add[$5","service[$6]]+=$10
       add[$5","service[$6]",总计"]+=$10
       add[$5","service[$6]","$3]+=$10
       add[$5","service[$6]","$3","$4]+=$10
       reduce[$5",总计"]+=$12          #$12本月退订，数组reduce用来分维度求和
       reduce[$5","service[$6]",总计"]+=$12
       reduce[$5","service[$6]]+=$12
       reduce[$5","service[$6]","$3]+=$12
       reduce[$5","service[$6]","$3","$4]+=$12
       retain[$5",总计"]+=$9          #$9本月留存，数组retain用来分维度求和
       retain[$5","service[$6]]+=$9
       retain[$5","service[$6]","$3]+=$9
       retain[$5","service[$6]","$3","$4]+=$9
       retain[$5","service[$6]",总计"]+=$9
       suspend[$5",总计"]+=$23          #$23暂停用户数，数组suspend用来分维度求和
       suspend[$5","service[$6]]+=$23
       suspend[$5","service[$6]","$3]+=$23
       suspend[$5","service[$6]","$3","$4]+=$23
       suspend[$5","service[$6]",总计"]+=$23
       begin[$5",总计"]+=$24            #$24本月开通72小时退订用户数，数组begin用来分维度求和
       begin[$5","service[$6]]+=$24
       begin[$5","service[$6]","$3]+=$24
       begin[$5","service[$6]","$3","$4]+=$24
       begin[$5","service[$6]",总计"]+=$24
       last[$5",总计"]+=$17            #$17上月留存，数组last用来分维度求和
       last[$5","service[$6]]+=$17
       last[$5","service[$6]","$3]+=$17
       last[$5","service[$6]","$3","$4]+=$17
       last[$5","service[$6]",总计"]+=$17
       all[$5","service[$6]]="'$REPORT_DIR'/country.csv"
       all1[$5","service[$6]","$3]="'$REPORT_DIR'/prov.csv"
       all2[$5","service[$6]","$3","$4]="'$REPORT_DIR'/city.csv"
       all[$5",总计"]="'$REPORT_DIR'/country.csv"
       all1[$5","service[$6]",总计"]="'$REPORT_DIR'/prov.csv"
       all2[$5","service[$6]",总计"]="'$REPORT_DIR'/city.csv"
       }
     }
}
END{

  for(i in all){
    if(i in last){
      if(last[i]<=0){
        huanbi=0
      }else{
        huanbi=((retain[i]-last[i])/last[i])
      }
    }else{
      huanbi=1
    }
     printf("%s,%d,%d,%d,%d,%d,%.2f%s\n",i,add[i],reduce[i],begin[i],retain[i],suspend[i],huanbi*100,"%") >all[i]
  }
  for(i in all1){
    if(i in last){
     if(last[i]<=0){
        huanbi=0
     }else{
        huanbi=(retain[i]-last[i])/last[i]
     }
    }else{
      huanbi=1
    }
     printf("%s,%d,%d,%d,%d,%d,%.2f%s\n",i,add[i],reduce[i],begin[i],retain[i],suspend[i],huanbi*100,"%") > all1[i]
  }for(i in all2){
    if(i in last){
     if(last[i]<=0){
        huanbi=0
     }else{
        huanbi=(retain[i]-last[i])/last[i]
     }
    }else{
     huanbi=1
    }
     printf("%s,%d,%d,%d,%d,%d,%.2f%s\n",i,add[i],reduce[i],begin[i],retain[i],suspend[i],huanbi*100,"%") > all2[i]
  }


}' $DATA_DIR/report.region.qianxiang_pause_subcribe_extend_city.csv

#cat /home/zhaoxin/temp_guoxue > /home/zhaoxin/guoxue.txt
#cat /home/zhaoxin/temp1_guoxue |sort -k 2 >> /home/zhaoxin/guoxue.txt
#rm /home/zhaoxin/temp_guoxue
#rm /home/zhaoxin/temp1_guoxue

cat $REPORT_DIR/country.csv|sort -t"," -k 2|awk -F \, '{if($2=="总计"){a[$1","$2","$3","$4","$5","$6","$7","$8]=1}else if($2!="总计"){b[$1","$2","$3","$4","$5","$6","$7","$8]=1}}END{for(i in b){print i};for(j in a){print j}}'|gawk 'BEGIN{
    FS=OFS=","
    title="大类名称,业务名称,本月新增,本月退订,本月开通72小时内退订,本月留存,暂停用户,环比增幅"
}
{
        service[$1]++
        if(service[$1]==1){
        print title >>"'$REPORT_DIR/'"$1
        print $1,$2,$3,$4,$5,$6,$7,$8 >> "'$REPORT_DIR/'"$1
        }else{
        print $1,$2,$3,$4,$5,$6,$7,$8 >> "'$REPORT_DIR/'"$1
        }
}'

cat $REPORT_DIR/prov.csv|sort -t"," -k 3|awk -F \, '{if($3=="总计"){a[$1","$2","$3","$4","$5","$6","$7","$8","$9]=1}else if($3!="总计"){b[$1","$2","$3","$4","$5","$6","$7","$8","$9]=1}}END{for(i in b){print i};for(j in a){print j}}'|gawk 'BEGIN{
    FS=OFS=","
    title_prov="大类名称,省份,本月新增,本月退订,本月开通72小时内退订,本月留存,暂停用户,环比增幅"
}
{
        service[$1]++
        if(service[$1]==1){
        print title_prov >> "'$REPORT_DIR/'"$1
        print $2,$3,$4,$5,$6,$7,$8,$9 >> "'$REPORT_DIR/'"$1
        }else{
        print $2,$3,$4,$5,$6,$7,$8,$9 >> "'$REPORT_DIR/'"$1
        }
}'    

cat $REPORT_DIR/city.csv|sort -t"," -k 3|awk -F \, '{if($3=="总计"){a[$1","$2","$3","$4","$5","$6","$7","$8","$9","$10]=1}else if($3!="总计"){b[$1","$2","$3","$4","$5","$6","$7","$8","$9","$10]=1}}END{for(i in b){print i};for(j in a){print j}}'|gawk 'BEGIN{
    FS=OFS=","
    title_city="大类名称,省份,城市,本月新增,本月退订,本月开通72小时内退订,本月留存,暂停用户,环比增幅"
}
{
        service[$1]++
        if(service[$1]==1){
        print title_city >> "'$REPORT_DIR/'"$1
        print $2,$3,$4,$5,$6,$7,$8,$9,$10 >> "'$REPORT_DIR/'"$1
        }else{
        print $2,$3,$4,$5,$6,$7,$8,$9,$10 >> "'$REPORT_DIR/'"$1
        }
}'    
rm $REPORT_DIR/country.csv
rm $REPORT_DIR/prov.csv
rm $REPORT_DIR/city.csv
python /usr/local/app/dana/current/shbb/change_xls_mail.py $REPORT_DIR $V_MONTH $flag

