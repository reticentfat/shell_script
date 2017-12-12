#!/bin/sh
. /usr/local/app/dana/current/shbb/profile

V_DATE=$(date -v-1d +%Y%m%d)
current_date=$(date +%Y%m%d)
#sour_171=http://172.16.80.171:9999/data/snapshot/
#sour_190=http://172.16.80.190:9999/data/snapshot/
sour_171=http://10.1.32.116:9999/data/snapshot/
sour_190=http://10.1.32.115:9999/data/snapshot/

target_dir=/logs/orig/${V_DATE}/data/snapshot
snapshot_time=/logs/orig/${V_DATE}/data/snapshot/travelsnapshot.txt.bz2.timestamp

cd $target_dir || mkdir -p $target_dir
# 先拉时间戳文件
fetch -o $snapshot_time -mq $sour_171/snapshot.txt.bz2.timestamp 
#取数据生成时间
a=$(date -v-1d +%Y%m%d)
if [ -f $snapshot_time ];then
  a=$(cat $snapshot_time|awk '{str=substr($0,1,10); gsub(/[^0-9]/,"",str);print str}')
fi
#如果时间戳在当天，为最新文件，就一直用229,此时如果228比229时间更新，也不再从228拉取
if [ $a -ge $current_date ];then
  fetch -o $target_dir/travelsnapshot.txt.bz2 -mq $sour_171/snapshot.txt.bz2
  exit 0
fi

#只有229上文件不是最新才到228上拉取
if [ "$current_date" -gt $a ];then
  fetch -o $snapshot_time -mq $sour_190/snapshot.txt.bz2.timestamp 
  if [ -f $snapshot_time ];then  
    a=$(cat $snapshot_time|awk '{str=substr($0,1,10); gsub(/[^0-9]/,"",str);print str}')
  fi
  #228上也为旧文件，则不拉取 
  if [ $a -lt $current_date ];then
    rm $snapshot_time
  else
    fetch -o $target_dir/travelsnapshot.txt.bz2 -mq $sour_190/snapshot.txt.bz2 
  fi
else
  fetch -o $target_dir/travelsnapshot.txt.bz2 -mq $sour_171/snapshot.txt.bz2 
fi

#如果数据没有更新，则报警。
if [ $(date +%H) -gt "05" ];then
  item="商旅订阅库快照没有拉取到最新文件，请及时处理"
  [ `find $target_dir -type f -name 'travelsnapshot.txt.bz2' -mtime -1` ] ||{ sh /usr/local/app/dana/current/vgop2/fetch_data_warm.sh "${item};this warn from:'$(hostname -s)'" "13771165670,13466473169";}
fi
