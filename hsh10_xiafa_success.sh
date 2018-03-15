#!/bin/bash
day3=$(date -v -4d +%Y%m%d)
hm=$(date +%H%M)
if [ $1 ];then
    day3=$1
fi
day4=$(date -v -1d -j $day3$hm +%Y%m%d)
firstday=$(date -v -0d -j $day3$hm +%Y%m01)
if [ -d "/data/chenyj/HSH10_SUCCESS/${day3}" ]; then
    rm -rf /data/chenyj/HSH10_SUCCESS/${day3}
fi
mkdir -p /data/chenyj/HSH10_SUCCESS/${day3}


if [ -f "/data/match/cmpp/${day3}/outputumessage_005_wuxian_${day3}_cmpp.out" ]; then
    cat /data/match/cmpp/${day3}/outputumessage_005_wuxian_${day3}_cmpp.out |awk -F ',' '{if($15==10120013)print $1"|"$12"|"$15"|"$19"|"$41"|"substr($43,1,8)}'|awk -F ':' '{print $4}' >/data/chenyj/HSH10_SUCCESS/${day3}/${day3}_hsh10_xiafa_success.txt 

else
    exit "未找到 /data/match/cmpp/${day3}/outputumessage_005_wuxian_${day3}_cmpp.out"
fi

cd /data/chenyj/HSH10_SUCCESS/${day3}
awk 'BEGIN{
    FS=OFS="|"
}{
    if(FILENAME==""'${day3}'"_hsh10_xiafa_success.txt"){ 
        gsub(/ /, "")
        if($1"|"$2 in datas_code){
            datas_code[$1"|"$2]++
        }else{
            datas_code[$1"|"$2]=1
        }
        if($5==0){
            if($1"|"$2 in datas_status){
                datas_status[$1"|"$2]++
            }else{
                datas_status[$1"|"$2]=1
            }
        }
    }
}
END{

    for (key in datas_code){
        if (datas_code[key] == datas_status[key]){
            split(key,a,"|")
            if (a[2] in phone_nums){
                phone_nums[a[2]]++               
            }else{
                phone_nums[a[2]]=1
            }

        }
    }
    for (detail in phone_nums){
        print detail"|"phone_nums[detail] >> "'${day3}'_hsh10_success_number.txt"
    }

}' ${day3}_hsh10_xiafa_success.txt 

if [ ${day3} = ${firstday} ];then
    cat ${day3}_hsh10_success_number.txt > hsh10_success_number.txt
else
    cat /data/chenyj/HSH10_SUCCESS/${day4}/hsh10_success_number.txt ${day3}_hsh10_success_number.txt > yesterday_hsh10_success_number.txt
fi

if [ -f "yesterday_hsh10_success_number.txt" ];then
awk 'BEGIN{
    FS=OFS="|"
}{
    if ($1 in datas){
        datas[$1] = datas[$1] + $2
    }else{
        datas[$1] = $2
    }
}
END{
    for (key in datas){
        print key"|"datas[key] >> "hsh10_success_number.txt"
    }
}' yesterday_hsh10_success_number.txt 
fi



















