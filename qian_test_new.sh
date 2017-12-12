#!/bin/sh
#执行脚本需要把脚本和需要文件report.region.qianxiang_pause_subcribe_city.csv拉取到服务器home下执行脚本即可
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
       add[$5","$6]+=$10
       add[$5","service[$6]",总计"]+=$10
       add[$5","service[$6]","$3]+=$10
       add[$5","service[$6]","$3","$4]+=$10
       reduce[$5",总计"]+=$12          #$12本月退订，数组reduce用来分维度求和
       reduce[$5","service[$6]",总计"]+=$12
       reduce[$5","$6]+=$12
       reduce[$5","service[$6]","$3]+=$12
       reduce[$5","service[$6]","$3","$4]+=$12
       retain[$5",总计"]+=$9          #$9本月留存，数组retain用来分维度求和
       retain[$5","$6]+=$9
       retain[$5","service[$6]","$3]+=$9
       retain[$5","service[$6]","$3","$4]+=$9
       retain[$5","service[$6]",总计"]+=$9
       suspend[$5",总计"]+=$23          #$23暂停用户数，数组suspend用来分维度求和
       suspend[$5","$6]+=$23
       suspend[$5","service[$6]","$3]+=$23
       suspend[$5","service[$6]","$3","$4]+=$23
       suspend[$5","service[$6]",总计"]+=$23
       begin[$5",总计"]+=$24            #$24本月开通72小时退订用户数，数组begin用来分维度求和
       begin[$5","$6]+=$24
       begin[$5","service[$6]","$3]+=$24
       begin[$5","service[$6]","$3","$4]+=$24
       begin[$5","service[$6]",总计"]+=$24
       last[$5",总计"]+=$17            #$17上月留存，数组last用来分维度求和
       last[$5","$6]+=$17
       last[$5","service[$6]","$3]+=$17
       last[$5","service[$6]","$3","$4]+=$17
       last[$5","service[$6]",总计"]+=$17
       all[$5","$6]="country.csv"
       all1[$5","service[$6]","$3]="prov.csv"
       all2[$5","service[$6]","$3","$4]="city.csv"
       all[$5",总计"]="country.csv"
       all1[$5","service[$6]",总计"]="prov.csv"
       all2[$5","service[$6]",总计"]="city.csv"
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


}' report.region.qianxiang_pause_subcribe_city.csv

#cat /home/zhaoxin/temp_guoxue > /home/zhaoxin/guoxue.txt
#cat /home/zhaoxin/temp1_guoxue |sort -k 2 >> /home/zhaoxin/guoxue.txt
#rm /home/zhaoxin/temp_guoxue
#rm /home/zhaoxin/temp1_guoxue

cat country.csv|sort -t"," -k 2|gawk 'BEGIN{
    FS=OFS=","
    title="大类名称,业务名称,本月新增,本月退订,本月开通72小时内退订,本月留存,暂停用户,环比增幅"
}
{
        service[$1]++
        if(service[$1]==1){
        print title >> $1".csv"
        print $1,$2,$3,$4,$5,$6,$7,$8 >> $1".csv"
        }else{
        print $1,$2,$3,$4,$5,$6,$7,$8 >> $1".csv"
        }
}'    
cat prov.csv|sort -t"," -k 3|gawk 'BEGIN{
    FS=OFS=","
    title_prov="大类名称,省份,本月新增,本月退订,本月开通72小时内退订,本月留存,暂停用户,环比增幅"
}
{
        service[$1]++
        if(service[$1]==1){
        print title_prov >> $1".csv"
        print $2,$3,$4,$5,$6,$7,$8,$9 >> $1".csv"
        }else{
        print $2,$3,$4,$5,$6,$7,$8,$9 >> $1".csv"
        }
}'    
cat city.csv|sort -t"," -k 3|gawk 'BEGIN{
    FS=OFS=","
    title_city="大类名称,省份,城市,本月新增,本月退订,本月开通72小时内退订,本月留存,暂停用户,环比增幅"
}
{
        service[$1]++
        if(service[$1]==1){
        print title_city >> $1".csv"
        print $2,$3,$4,$5,$6,$7,$8,$9,$10 >> $1".csv"
        }else{
        print $2,$3,$4,$5,$6,$7,$8,$9,$10 >> $1".csv"
        }
}'    
