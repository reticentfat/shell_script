#!/bin/sh
Usage()
{
        echo "paramter: fromdate days regionid"
        echo "20130101 7 28"
        echo "print one week XS message user information"
}
CheckInLaw()
{
        if [ `echo $FROMDATE_OF_WEEK | awk '{if(length($0) !=8 || $0 !~/^20/){print 0}else{print 1}}'` -eq 0 ]; then
                Usage
                exit
        fi
}

if [ $# -ne 4 ]; then
        Usage
        exit
fi

FROMDATE_OF_WEEK=$1
DAYS=$2
PROV=$3
CHANNEL=$4

data=`dirname $0`/data
[ -d $data ] || mkdir -p $data
vmonth=`echo $FROMDATE_OF_WEEK | cut -c 1-6`

date2seconds()
{
        echo "$*" | awk '{ z=int((14-$2)/12); y=$1+4800-z; m=$2+12*z-3; j=int((153*m+2)/5)+$3+y*365+int(y/4)-int(y/100)+int(y/400)-2472633; j=j*86400+$4*3600+$5*60+$6; printf("%d",j)}'
}

GetMultiDays()
{
        FROM_DAY=$1
        OUT_DAYS=$2
        DEAL_YEAR=`echo $FROMDATE_OF_WEEK | cut -c 1-4`
        DEAL_MONTH=`echo $FROMDATE_OF_WEEK | cut -c 5-6`
        DEAL_DAY=`echo $FROMDATE_OF_WEEK | cut -c 7-8`
        #echo "$DEAL_YEAR $DEAL_MONTH $DEAL_DAY"

        CUR_TIME_SECONDS=`date2seconds "$DEAL_YEAR $DEAL_MONTH $DEAL_DAY 00 00 00"`
        x=0
        until [ $x -eq $OUT_DAYS ]
        do
                #echo $x
                SECOND=`echo "$CUR_TIME_SECONDS $x" | awk '{ret=$1+$2*86500;printf("%d", ret)}' `
                date -r $SECOND +%Y%m%d
                t=`let x=$x+1`
        done
}



do_bzcat_file()
{
        [ -f $data/${PROV}.$vmonth.mx.txt ] && rm $data/${PROV}.$vmonth.mx.txt
        files=`GetMultiDays $FROMDATE_OF_WEEK $DAYS | awk '{printf("/logs/out/ci/%s/buss_base_sear_Msg_split.txt.bz2 ",$0)}'`
        for f in `echo $files`
        do 
                bzcat $f |awk -F"|" -v path=$data -v prov=$PROV -v month=$vmonth -v channel=$CHANNEL 'BEGIN{OFS="|";mx=path "/" prov "." month ".mx.txt"}
                {
                        if($26==100) 
                        print $1,$6,$5,$11,$12,$22,$24,$25,$27,$26 >> mx }'
        done
        cat $data/${PROV}.$vmonth.mx.txt |awk -F'|' 'BEGIN{OFS="|"}{print $1,$4,$5}' |sort -u > $data/${PROV}.$vmonth.mx.txt.list
        cat $data/${PROV}.$vmonth.mx.txt.list |awk -F'|' '{print "|"$3}' |sort |uniq -c |sort -r -n > $data/${PROV}.$vmonth.mx.txt.list.count 
#        awk -F'|' 'BEGIN{OFS="|"}NR<=FNR {a[$4]=$1"|"$2}NR>FNR&&a[b=substr($2,1,7)]{print $1,$2,$3,$4,$5,$6,a[substr($2,1,7)],$7,$8}' /logs/dict/public/nodist.tsv $data/${PROV}.mx.txt  > $data/${PROV}.list_${FROMDATE_OF_WEEK}_${DAYS}.txt

        #cat $data/${PROV}.$vmonth.mx.txt |awk -F'|' 'BEGIN{OFS="|"} {print $5,$1,$2}' |sort -u  |awk -F'|' '{print "|"$1}' |sort |uniq -c >$data/${PROV}.list_${FROMDATE_OF_WEEK}_${DAYS}.txt.count
        #awk -F'|' 'NR==FNR{a[$2]=$1}NR>FNR{print $1"|"($1 in a?a[$1]:0)}' $data/${PROV}.list_${FROMDATE_OF_WEEK}_${DAYS}.txt.count ./ah_shanghu_id.txt  >$data/${PROV}.list_${FROMDATE_OF_WEEK}_${DAYS}.txt.count.done

}

do_bzcat_file_yuyin()
{
        [ -f $data/${PROV}.${CHANNEL}.${vmonth}.mx.txt.cx ] && rm $data/${PROV}.${CHANNEL}.${vmonth}.mx.txt.cx
        [ -f $data/${PROV}.${CHANNEL}.${vmonth}.mx.txt.hz ] && rm $data/${PROV}.${CHANNEL}.${vmonth}.mx.txt.hz
        files=`GetMultiDays $FROMDATE_OF_WEEK $DAYS | awk '{printf("/logs/out/ci/%s/buss.goodno.txt.bz2 ",$0)}'`
        for f in `echo $files`
        do
                bzcat $f |awk -F"|" -v path=$data -v prov=$PROV -v month=$vmonth  -v channel=$CHANNEL 'BEGIN{OFS="|";cx=path "/" prov "." channel"." month ".mx.txt.cx";hz=path "/" prov "." channel"." month ".mx.txt.hz"}
                {
                if($8=="JC0001"){print $1,$5,$6,$8,substr($11,1,4),$16,$13,$22,$23,$25 >> cx}
                else if($8=="JC0005"){print $1,$5,$6,$8,substr($11,1,4),$16,$13,$22,$23,$25>>hz}
                else {next}
                 }'
        done
        cat $data/${PROV}.${CHANNEL}.${vmonth}.mx.txt.cx |awk -F'|' 'BEGIN{OFS="|"} {print $8,$1,$3}' |sort -u  | awk -F'|' '$1!="0"{print $1}' | awk -F',' '{for(i=1;i<=NF;i++) print "|"$i}' |sort |uniq -c >$data/${PROV}.${CHANNEL}.${vmonth}.mx.txt.cx.count
        awk -F'|' 'NR==FNR{a[$2]=$1}NR>FNR{print $2"|"$1"|"($2 in a?a[$2]:0)}' $data/${PROV}.${CHANNEL}.${vmonth}.mx.txt.cx.count  $data/${PROV}.$vmonth.mx.txt.list.count  >$data/${PROV}.${CHANNEL}.${vmonth}.mx.txt.cx.count.done
        cat $data/${PROV}.${CHANNEL}.${vmonth}.mx.txt.hz |awk -F'|' 'BEGIN{OFS="|"} {print $8,$1,$3}' |sort -u  | awk -F'|' '$1!="0"{print $1}' | awk -F',' '{for(i=1;i<=NF;i++) print "|"$i}' |sort |uniq -c >$data/${PROV}.${CHANNEL}.${vmonth}.mx.txt.hz.count
        awk -F'|' 'NR==FNR{a[$2]=$1}NR>FNR{print $2"|"$1"|"($2 in a?a[$2]:0)}' $data/${PROV}.${CHANNEL}.${vmonth}.mx.txt.hz.count $data/${PROV}.$vmonth.mx.txt.list.count  >$data/${PROV}.${CHANNEL}.${vmonth}.mx.txt.hz.count.done

        #cat $data/${PROV}.${CHANNEL}.${vmonth}.mx.txt |awk -F'|' '$7!~/^$/{print $1,$2,$3,$7}' |sort -u >$data/${PROV}.${CHANNEL}.${vmonth}.mx.txt.done
        #awk -F"|" 'BEGIN{OFS="|"} NR<=FNR{a[substr($6,1,4)]=$1"|"$2"|"$3}NR>FNR{print $1,$2,$3,$4,$5,a[$5],$6,$7,$8,$9}' /logs/dict/public/nodist.tsv $data/${PROV}.${CHANNEL}.${vmonth}.mx.txt > $data/${PROV}.${CHANNEL}.${vmonth}.mx.txt.city
        
        #cat $data/${PROV}.${CHANNEL}.${vmonth}.mx.txt.city |awk -F'|' '{a[$3"|"$6"|"$7]++} END{for(k in a) print k"|"a[k]}' |awk -F'|' '$4>1{print $0}' |sort -t"|" -k 4 -n -r > $data/${PROV}.${CHANNEL}.${vmonth}.mx.txt.city.count
        #awk -F'|' 'BEGIN{OFS="|"}NR<=FNR {a[$4]=$1"|"$2}NR>FNR&&a[b=substr($6,1,7)]{print $1,$2,$3,$4,$5,$6,a[substr($6,1,7)],$7,$8,$9}' /logs/dict/public/nodist.tsv $data/${PROV}.${CHANNEL}.${vmonth}.mx.txt   > $data/${PROV}.${CHANNEL}.${vmonth}.mx.txt.city.txt  
        #
        #awk -F'|' 'BEGIN{OFS="|"}NR<=FNR {a[substr($6,1,4)]=$1"|"$2}NR>FNR&&a[$5]{print $1,$2,$3,$4,$5,a[$5],$6,$7,$8,$9}' /logs/dict/public/nodist.tsv $data/${PROV}.${CHANNEL}.mx.txt   > ./${PROV}.${CHANNEL}.list.regionid.txt
        #awk -F'|' 'NR<=FNR {a[$4]=$2}NR>FNR&&a[b=substr($6,1,7)]{print $2"|"a[substr($2,1,7)]}' /logs/dict/public/nodist.tsv $data/${PROV}.${CHANNEL}.mx.txt  | sort | uniq -c | sort -n -r > ./${PROV}.${CHANNEL}.list.count.txt
}




go()
{
        CheckInLaw
        do_bzcat_file
        do_bzcat_file_yuyin
}
go
