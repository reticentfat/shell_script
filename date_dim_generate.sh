#!/bin/bash
date1="$1"
date2="$2"
tempdate=`date -d "$date1" +%F`
tempdateSec=`date -d "$date1" +%s`
enddateSec=`date -d "$date2" +%s`
min=1
max=`expr \( $enddateSec - $tempdateSec \) / \( 24 \* 60 \* 60 \) + 1`
cat /dev/null > ./date_dim.csv

while [ $min -le $max ]
do  
  month=`date -d "$tempdate" +%m`
  month_name=`date -d "$tempdate" +%B`
  quarter=`echo $month | awk '{print int(($0-1)/3)+1}'`
  year=`date -d "$tempdate" +%Y`
  echo ${min}","${tempdate}","${month}","${month_name}","${quarter}","${year} >> ./date_dim.csv
  tempdate=`date -d "+$min day $date1" +%F`
  tempdateSec=`date -d "+$min day $date1" +%s`
  min=`expr $min + 1`
done

hdfs dfs -put -f date_dim.csv /user/hive/warehouse/dw.db/date_dim/
