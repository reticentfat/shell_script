#!/bin/sh
. /usr/local/app/dana/current/shbb/profile

V_DATE=$(date -v-1d +%Y%m%d)
current_date=$(date +%Y%m%d)
#sour_229=http://miscweb2.intra.umessage.com.cn:9999/data/snapshot
#sour_228=http://miscweb1.intra.umessage.com.cn:9999/data/snapshot
sour_229=http://192.100.6.33:9999/data/snapshot
sour_228=http://192.100.6.31:9999/data/snapshot

target_dir=/logs/orig/${V_DATE}/data/snapshot/
snapshot_time=/logs/orig/${V_DATE}/data/snapshot/snapshot.txt.bz2.timestamp

cd $target_dir || mkdir -p $target_dir
# 先拉时间戳文件
fetch -mq $sour_228/snapshot.txt.bz2.timestamp $target_dir
#取数据生成时间
a=$(date -v-1d +%Y%m%d)
if [ -f $snapshot_time ];then
  a=$(cat $snapshot_time|awk '{str=substr($0,1,10); gsub(/[^0-9]/,"",str);print str}')
fi
#如果时间戳在当天，为最新文件，就一直用229,此时如果228比229时间更新，也不再从228拉取
if [ $a -ge $current_date ];then
  fetch -mq $sour_228/snapshot.txt.bz2 $target_dir
  exit 0
fi

#只有229上文件不是最新才到228上拉取
if [ "$current_date" -gt $a ];then
  fetch -mq $sour_228/snapshot.txt.bz2.timestamp $target_dir
  if [ -f $snapshot_time ];then  
    a=$(cat $snapshot_time|awk '{str=substr($0,1,10); gsub(/[^0-9]/,"",str);print str}')
  fi
  #228上也为旧文件，则不拉取 
  if [ $a -lt $current_date ];then
    rm $snapshot_time
  else
    fetch -mq $sour_228/snapshot.txt.bz2 $target_dir
  fi
else
  fetch -mq $sour_229/snapshot.txt.bz2 $target_dir  
fi

#如果数据没有更新，则报警。
if [ $(date +%H) -gt "05" ];then
  item="订阅库快照没有拉取到最新文件，请及时处理"
  [ `find $target_dir -type f -name 'snapshot.txt.bz2' -mtime -1` ] ||{ sh /usr/local/app/dana/current/vgop2/fetch_data_warm.sh "${item};this warn from:'$(hostname -s)'" "13771165670,13466473169";}
fi
