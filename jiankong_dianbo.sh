#!/bin/bash

yesterday=`date -v -1d "+%Y%m%d"`

if [ -d "/data/chenyj/QWDianBo/${yesterday}" ]; then
    rm -rf /data/chenyj/QWDianBo/${yesterday}
fi
mkdir -p /data/chenyj/QWDianBo/${yesterday}

if [ -f "/data/match/cmpp/${yesterday}/monster-cmppmo.log.fengtai.log.${yesterday}.bz2" ]; then
    bzcat /data/match/cmpp/${yesterday}/monster-cmppmo.log.fengtai.log.${yesterday}.bz2 |awk -F ':' '{print $4}'|awk -F ',' '{print substr($1,2,14)"|"$6"|"$10"|"$14"|"$26"|"$27"|"$28"|"}' > /data/chenyj/QWDianBo/${yesterday}/${yesterday}_sx_mms.txt
else
    exit "未找到/data/match/cmpp/${yesterday}/monster-cmppmo.log.fengtai.log.${yesterday}.bz2"
fi


cd /data/chenyj/QWDianBo/${yesterday}
awk 'BEGIN{
    FS=OFS="|"
}{
    if(FILENAME==""'${yesterday}'"_sx_mms.txt"){
        date=substr($1,1,8)
        if(date=="'$yesterday'"){
            if ($4 == 1065888018 && (toupper($7)~/^HY/ || toupper($7)~/^ZK/ || toupper($7)~/^DM/)){
                if($3"|"toupper(substr($7,1,2)) in datas){
                    datas[$3"|"toupper(substr($7,1,2))]+=1
                }else{
                    datas[$3"|"toupper(substr($7,1,2))]=1
                }
            }
            if ($4 == 1065888016 && (toupper($7)~/^G/ || toupper($7)~/^V/ || toupper($7)~/^P/ || toupper($7)~/^O/)){
                if($3"|"toupper(substr($7,1,1)) in datas){
                    datas[$3"|"toupper(substr($7,1,1))]+=1
                }else{
                    datas[$3"|"toupper(substr($7,1,1))]=1
                }
            }
        }
    }
}
END{
    all_nums=0
    some_nums=0
    sj_num=0
    for (num in datas){
        split(num,a,"|")
        if (a[2]~/^HY/ || a[2]~/^ZK/ || a[2]~/^DM/){
            sj_num++
        }
        all_nums++
        print num"|"datas[num] >> "/data/chenyj/QWDianBo/'${yesterday}'/'${yesterday}'_sx_detail.txt"
        if (datas[num] <= 3){
            some_nums++
        }
    } 
    print '${yesterday}',some_nums,all_nums,some_nums/all_nums > "/data/chenyj/QWDianBo/'${yesterday}'/'${yesterday}'_sx_frequency.txt"
    #print '${yesterday}',sj_num,some_nums,all_nums
}' ${yesterday}_sx_mms.txt
