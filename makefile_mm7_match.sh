# mms && cmpp match targets
mm7_match: $(SRC_MM7_MT) $(SRC_MM7_RE)
	@touch mm7_match_start
	/usr/bin/lockf -s -t 0 /tmp/runmm7.lock $(PDIR)/match/runmm7.sh $(day) >/dev/null
	@touch mm7_match
	---------runmm7.sh------------
	#!/bin/sh

export PDIR='/usr/local/app/dana/current'
STATSDIR='/logs/out/dana/target/stats'

d0=$1
---如果第一个参数为空字符串
[ -z "$d0" ] && d0=$(date -v-1d +%Y%m%d)
mtfile="/logs/orig/$d0/monster-mm7mt.*log.$d0.bz2"
refile="/logs/orig/$d0/monster-mm7-report.*log.$d0.bz2"
hm=$(date +%H%M)
d1=$(date -v-1d -j $d0$hm +%Y%m%d)
d2=$(date -v-2d -j $d0$hm +%Y%m%d)
d3=$(date -v-3d -j $d0$hm +%Y%m%d)

echo $(date)
$PDIR/match/mm7erase_s0.sh $d0 || exit 1

$PDIR/match/mm7p.sh $d0 || exit 1

bzcat $mtfile | $PDIR/match/mm7mt.sh $d0
[ $? -eq 0 ] || exit 1

files=$(bzcat $refile | $PDIR/match/mm7report.sh)

if [ -n "$files" ]; then
    $PDIR/match/mm7match.sh $files
    [ $? -eq 0 ] || exit 1

    for d in $d1 $d2 $d3
    do
        touch $STATSDIR/$d/mm7_match
    done
fi

$PDIR/match/mm7erase_s1.sh $d0 || exit 1

echo $(date)

	---------------mm7erase_s0.sh--------
	#!/bin/sh

LOGP='/logs/out/mm7'

d0=$1
---------如果shell第一个参数为空字符串则定义d0为前一天时间戳格式yyyymmdd--------
[ -z "$d0" ] && d0=$(date -v-1d +%Y%m%d)
hm=$(date +%H%M)

d1=$(date -v-1d -j $d0$hm +%Y%m%d)
d2=$(date -v-2d -j $d0$hm +%Y%m%d)
---------目录是否存在-------
if [ ! -d $LOGP/$d0 ]; then
    # no need to erase the old status
    exit 0
fi

nf=$(echo $LOGP/$d0/*.mt $LOGP/$d0/*.out $LOGP/$d0/*.err | awk '{ print NF }')
-------域等于3---------
if [ $nf -eq 3 ]; then
    # no need to erase the old status
    exit 0
fi

rm -f $LOGP/$d0/*.rp $LOGP/$d1/*.rp $LOGP/$d2/*.rp
rm -f $LOGP/$d0/*.mt || exit 1
---时间转化为月份日的格式例如Jan01
d0str=$(date -j $d0$hm "+%b %d")

for f in $LOGP/$d0/*.out $LOGP/$d0/*.err
do
    [ -f "$f" ] || continue

    awk -F',' "\$(NF-8) ~ /$d0str/ { next } { print }" $f > ${f}.$$ && \
    -------$$为进程标识号(Process Identifier Number, PID)--------
    mv -f ${f}.$$ $f
    -----------判断上一条语句是否成功--------
    [ $? -eq 0 ] || exit 1
done

for f in $LOGP/$d1/*.err $LOGP/$d2/*.err
do
    [ -f "$f" ] || continue

    mv -f $f ${f}.hind || exit 1
done

for f in $LOGP/$d0/*.out
do
-----------测试f文件是否为非空白文档-----------
    [ -s "$f" ] || continue
    --------只返回删除从尾部开始删除与.out匹配的最小部分，然后返回剩余部分--------
    hf=${f%.out}

    awk -F',' '{ print $27 $14 }' $f > ${hf}.hind
    [ $? -eq 0 ] || exit 1
done


	---------------------------------
	--------------mm7p.sh---------
	#!/bin/sh

LOGP='/logs/out/mm7'

d0=$1
[ -n "$d0" ] || d0=$(date '+%Y%m%d')

hm=$(date +%H%M)
d1=$(date -v-1d -j $d0$hm '+%Y%m%d')
[ $? -eq 0 ] || exit 1
d2=$(date -v-2d -j $d0$hm '+%Y%m%d')
[ $? -eq 0 ] || exit 1
d3=$(date -v-3d -j $d0$hm '+%Y%m%d')
[ $? -eq 0 ] || exit 1

for d in $d0 $d1 $d2 $d3
do
    [ -d "$LOGP/$d" ] && continue
    mkdir -p $LOGP/$d
done

	-------------------------
	---------------------mm7mt.sh---
	#!/bin/sh

LOGP='/logs/out/mm7'

defaultdir=$1

d0=$(date '+%Y %m %d')
YEAR=$(echo "$d0" | awk '{ print $1 }')
MONTH=$(echo "$d0" | awk '{ print $2 }')
LYEAR=$(date -v-1y '+%Y')
export YEAR LYEAR MONTH

cd $LOGP

awk -F"," -v ed="$defaultdir" 'BEGIN {
    LY=ENVIRON["LYEAR"]; Y=ENVIRON["YEAR"]; 
    M=ENVIRON["MONTH"];
    idx = 1;
    exceptsfile = "00000000.mt"
}
NF > 2 && length($27) <= 8 {
    file = ed "/" exceptsfile
    print $0 >> file
    next
}
NF > 2 && length($27) > 8 {
    snum = $27
    m=substr(snum,1,2)
    d=substr(snum,3,2)
    h=substr(snum,5,2)
    mm=substr(snum,7,1)

    if(m > M) { y = LY; } else { y = Y; }

    dir =  y m d
    if(!(dir in dirs)) {
        cmd = "test -d " dir
        if (system(cmd)) {
            # not exist
            dirs[dir] = 0
        } else {
            # exist
            dirs[dir] = 1
        }
    }
    if (dirs[dir] == 0) { file = ed "/" exceptsfile } else { file=y m d "/" m d h mm ".mt" }
    print $0 >> file

    if(!(file in idxs)) {
        idxs[file] = idx
        files[idx] = file
        if (idx > 7) {
            file = files[idx-7]
            close(file)
            delete idxs[file]
            delete files[idx-7]
        }
        idx += 1
    }
}'

	---------------------------------
	-----------mm7report.sh------------
	#!/bin/sh

LOGP='/logs/out/mm7'

d0=$(date '+%Y %m %d')
YEAR=$(echo "$d0" | awk '{ print $1 }')
MONTH=$(echo "$d0" | awk '{ print $2 }')
LYEAR=$(date -v-1y '+%Y')
export YEAR LYEAR MONTH

cd $LOGP

files=$(awk -F"," 'BEGIN {
    LY=ENVIRON["LYEAR"]; Y=ENVIRON["YEAR"]; 
    M=ENVIRON["MONTH"];
    idx = 1;
}
NF > 2 {
    snum = $2
    m=substr(snum,1,2)
    d=substr(snum,3,2)
    h=substr(snum,5,2)
    mm=substr(snum,7,1)

    if(m > M) { y = LY; } else { y = Y; }

    dir =  y m d
    if(!(dir in dirs)) {
        cmd = "test -d " dir
        if (system(cmd)) {
            # not exist
            dirs[dir] = 0
        } else {
            # exist
            dirs[dir] = 1
        }
    }
    if (dirs[dir] == 0) next

    filep=y m d "/" m d h mm
    file=filep ".rp"
    print $0 >> file

    if(!(file in idxs)) {
        idxs[file] = idx
        files[idx] = file
        if (idx > 7) {
            file = files[idx-7]
            close(file)
            delete idxs[file]
            delete files[idx-7]
        }
        idx += 1
    }

    nmatchs[filep] = 1
}
END {
    for (p in nmatchs) {
        print p
    }
}')

[ $? -eq 0 ] || exit 1
echo $files


	------------------------------
	--------mm7match.sh-----------
	#!/bin/sh

LOGP='/logs/out/mm7'
NODIST='/logs/out/dana/data/nodist/nodist.tsv'

cd $LOGP

for file in $@
do
    if [ ! -f "${file}.rp" ]; then
        continue
    fi

    if [ ! -f "${file}.mt" ]; then
        touch "${file}.mt"
    fi

    gawk -F'[,|]' -v filep=$file '
BEGIN {
    ofile = filep ".out"
    efile = filep ".err"
    mfile = filep ".mid"
}
FILENAME ~ /tsv$/ {
    ps[$4] = $5;
    ds[$4] = $3;
}
FILENAME ~ /rp$/ {
    phone = $4
    sub(/^+/,"",phone)
    sub(/^86/,"",phone)
    key = $2 phone
    if (key in reports) {
        print "REP, " $0 >> efile
    } else {
        reports[key] = $0
    }
    next
}
FILENAME ~ /mt$/ {
    key = $27 $14
    if (key in reports) {
        # deside province and region id
        p7 = substr($14,1,7)
        p8 = substr($14,1,8)
        if (p7 in ps) {
            p = ps[p7]
            d = ds[p7]
        } else if (p8 in ps) {
            p = ps[p8]
            d = ds[p8]
        } else {
            p = d = "000"
        }

        print $0 "," p "," d "," reports[key] >> ofile
        delete reports[key]
    } else {
        print $0 >> mfile
    }
    next
}
END {
    for (key in reports) {
        print "NO, " reports[key] >> efile
    }
}' $NODIST "${file}.rp" "${file}.mt"
    [ $? -eq 0 ] || continue
    if [ ! -f "${file}.mid" ]; then
        touch "${file}.mid"
    fi
    mv -f "${file}.mid" "${file}.mt"
    rm -f "${file}.rp"
done
----------------------------------
----------mm7erase_s1.sh ---------
#!/bin/sh

LOGP='/logs/out/mm7'

d0=$1
[ -z "$d0" ] && d0=$(date -v-1d +%Y%m%d)
hm=$(date +%H%M)

d1=$(date -v-1d -j $d0$hm +%Y%m%d)
d2=$(date -v-2d -j $d0$hm +%Y%m%d)

nf=$(echo $LOGP/$d0/*.hind $LOGP/$d1/*.hind $LOGP/$d2/*.hind | awk '{ print NF }')
if [ $nf -eq 3 ]; then
    # no need to erase the old status
    exit 0
fi

for f in $LOGP/$d0/*.hind
do
    [ -f "$f" ] || continue
    hf=${f%.hind}
    [ -f "${hf}.mt" ] || continue

    awk -F',' '
       NF == 1 {
           keys[$1] = 1
           next
       }

       {
           key = $27 $14
           if(key in keys) {
               next
           }
           print
       }
    ' $f ${hf}.mt > ${hf}.mt.$$ && \
    mv -f ${hf}.mt.$$ ${hf}.mt && \
    awk -F',' '
        NF == 1 {
            keys[$1] = 0
            next
        }
        {
            key = $27 $14
            if (key in keys) {
                keys[key]++
                if (keys[key] > 1) next
                print
            } else {
                print
            }
        }
    ' $f ${hf}.out > ${hf}.out.$$ && \
    mv -f ${hf}.out.$$ ${hf}.out && \
    rm -f $f
    [ $? -eq 0 ] || exit 1
done

for f in $LOGP/$d1/*.err $LOGP/$d2/*.err
do
    [ -f "$f" ] || continue
    
    if [ -f ${f}.hind ]; then
        mv -f ${f}.hind $f || exit 1
    else
        rm -f $f || exit 1
    fi
done
------------------------------------


	
