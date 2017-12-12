#!/bin/sh

. /usr/local/app/dana/current/shbb/profile

v_work_dir=$AUTO_WORK_BIN
v_data_src=$AUTO_SRC_CI
v_data_des=$AUTO_DATA_REPORT

find ${v_data_src} -name "report.*" | awk -F/ '{print $NF}' | while read sfile
do
    day=$(echo $sfile | awk -F'_' '{ print $2 }')
    if [ -z "$day" ] || echo $day | grep -q '[^0-9]' || [ "$(echo $day | awk '{ print length($1) }')" -ne 8 ]; then
        continue
    fi
    year=$(echo $day | cut -c 1-4)
    if [ ! -d "${v_data_des}/${year}/${day}" ] ; then
        mkdir -p ${v_data_des}/${year}/${day}
    fi

    dfile=`echo $sfile | awk -F. '{print $1".region."$2"_"substr($3,0,length($3)-9)}'`
    scsum=$(md5 ${v_data_src}/${sfile} 2>&1 | awk '{ print $NF }')
    dcsum=$(md5 ${v_data_des}/${year}/${day}/${dfile}.csv 2>&1 | awk '{ print $NF }')
    [ "$scsum" != "$dcsum" ] && cp ${v_data_src}/${sfile} ${v_data_des}/${year}/${day}/${dfile}.csv && touch ${v_data_des}/${year}/${day}
done

find ${v_data_src} -name "week.*"|awk -F/ '{print $NF}' | while read sfile
do
    weekday=$(echo $sfile | awk -F'_' '{ print $2 }')
    day=$(echo $sfile | awk -F'_' '{ print $3 }')
    if [ -z "$weekday" ] || echo $weekday | grep -q '[^0-9]' || [ "$(echo $weekday | awk '{ print length($1) }')" -ne 8 ]; then
        continue
    fi
    if [ -z "$day" ] || echo $day | grep -q '[^0-9]' || [ "$(echo $day | awk '{ print length($1) }')" -ne 8 ]; then
        continue
    fi
    year=$(echo $day | cut -c 1-4)

    if [ ! -d ${v_data_des}/${year}/week_${weekday}_${day} ];then
        mkdir -p ${v_data_des}/${year}/week_${weekday}_${day}
    fi

    dfile=`echo $sfile | awk -F. '{print "report.region."$2"_"substr($3,0,length($3)-18)}'`
    scsum=$(md5 ${v_data_src}/${sfile} 2>&1 | awk '{ print $NF }')
    dcsum=$(md5 ${v_data_des}/${year}/week_${weekday}_${day}/${dfile}.csv 2>&1 | awk '{ print $NF }')
    [ "$scsum" != "$dcsum" ] && cp ${v_data_src}/${sfile} ${v_data_des}/${year}/week_${weekday}_${day}/${dfile}.csv && touch ${v_data_des}/${year}/week_${weekday}_${day}
done

find ${v_data_src} -name "month.*"|awk -F/ '{print $NF}' | while read sfile
do
    month=$(echo $sfile | awk -F'_' '{ print $2 }')
    if [ -z "$month" ] || echo $month | grep -q '[^0-9]' || [ "$(echo $month | awk '{ print length($1) }')" -ne 6 ]; then
        continue
    fi
    year=$(echo $month | cut -c 1-4)

    if [ ! -d ${v_data_des}/${year}/month_${month} ];then
        mkdir -p ${v_data_des}/${year}/month_${month}
    fi

    dfile=$(echo "$sfile" | awk -F. '{print "report.region."$2"_"substr($3,0,length($3)-7)}')
    scsum=$(md5 ${v_data_src}/${sfile} 2>&1 | awk '{ print $NF }')
    dcsum=$(md5 ${v_data_des}/${year}/month_${month}/${dfile}.csv 2>&1 | awk '{ print $NF }')
    [ "$scsum" != "$dcsum" ] && cp ${v_data_src}/${sfile} ${v_data_des}/${year}/month_${month}/${dfile}.csv && touch ${v_data_des}/${year}/month_${month}
done

exit 0
