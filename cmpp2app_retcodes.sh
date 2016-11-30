[gateway@wtraffic ~]$ cat /data/211/bin/cmpp2app_retcodes.sh
#!/bin/sh

STATSDIR='/data/match'
echo $(date)

bpath='/data/match/cmpp'
s3str='stats_month'
--如果有第二个参数就是本身，第二参数为空的的话缺省值为wuxian_qianxiang
filter=${2:-"wuxian_qianxiang"}
code=${3:-"0"}

d0=$1
[ -z "$d0" ] && d0=$(date -v-1d +%Y%m%d)
hm=$(date +%H%M)

d1=$(date -v-1d -j $d0$hm +%Y%m%d)
d2=$(date -v-1d -j $d1$hm +%Y%m%d)
d3=$(date -v-1d -j $d2$hm +%Y%m%d)

outfile="$s3str.$filter.$code"
ld=$d3
for d in $d2 $d1 $d0
do
    day0ofmonth=$(echo $d | awk '/01$/ { print }')
    bfile="$bpath/$ld/$outfile"
    if [ -n "$day0ofmonth" -o ! -f $bfile ]; then
        bfile=""
    fi
    ld=$d

    [ -d "$bpath/$d" ] || continue

    cat $bpath/$d/*.out $bfile | awk -v of="$filter" -v co="$code" '
        BEGIN { FS = ","; OFS = "," }
        NF == 3 { ps[$1 "," $2] += $3; next }
        $(NF-3) == co && $8 == of {
            ps[$12 "," $15] += 1
            next
        }
        END { for(p in ps) { print p, ps[p] } }
    ' > $bpath/$d/$outfile
    [ $? -eq 0 ] || exit 1
done

#for d in $d2 $d1
#do
#    touch $STATSDIR/$d/mm7_shbb
#done

echo $(date)
