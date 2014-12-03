#! /usr/bin/ksh
export PATH=/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/usr/X11R6/bin:/home/oracle/bin:/data0/app/ora11g/product/11.2.0/db_1/bin/
export ORACLE_HOME=/data0/app/ora11g/product/11.2.0/db_1

export ORACLE_SID=wxtjdb;
export LANG="SIMPLIFIED CHINESE_CHINA.ZHS16GBK";
ORACLE_NLS=$ORACLE_HOME/ocommon/nls/admin/data ;
export ORACLE_NLS

##每月2日执行 30 20 2 * * sh /home/oracle/etl/bin/guangdong_month.sh
##输入参数执行	25 17 10 1 * sh /home/oracle/etl/bin/guangdong_month.sh 20111231 2011-12-01 2012-01-01 20111231240000 20111201000000 20111231999999

usage () {
    echo "usage: $0 SNAPSHOT_DATE BEGINDATE ENDDATE NEWMONTH NEWADD_STARTDATE NEWADD_ENDDATE " 1>&2
    exit 2
}

if [ $# -ne 6 ] && [ $# -gt 0 ] ; then
    usage
fi



if [ $# -eq 6 ] ; then
	DEALDATE=$1		###20110930
	BEGINDATE=$2	###2011-09-01
	ENDDATE=$3		###2011-10-01
	NEWMONTH=$4		###20110930240000
	NEWADD_STARTDATE=$5	###20110901000000
	NEWADD_ENDDATE=$6	###20111001000000
fi

if [ ${DEALDATE:=999} = 999 ];then
	BEGINDATE=`date --date='3 days ago' "+%Y-%m"`-01
	ENDDATE=`date "+%Y-%m"`-01
	DEALDATE=`date --date='2 days ago' "+%Y%m%d"`
	NEWMONTH=`date --date='2 days ago' "+%Y%m%d"`240000
	NEWADD_STARTDATE=`date --date='3 days ago' "+%Y%m"`01000000
	NEWADD_ENDDATE=`date "+%Y%m"`01000000
fi


echo $DEALDATE
echo $BEGINDATE
echo $ENDDATE
echo $NEWMONTH

rm /home/oracle/etl/data/guangdong/month/guangdong_snapshot*.txt
rm /home/oracle/etl/data/guangdong/month/guangdong_snapshot*.txt.bz2
rm /home/oracle/etl/data/guangdong/month/guangdong_online*.txt
rm /home/oracle/etl/data/guangdong/month/guangdong_online*.txt.bz2
rm /home/oracle/etl/data/guangdong/month/guangdong_cancel*.txt
rm /home/oracle/etl/data/guangdong/month/guangdong_cancel*.txt.bz2
rm /home/oracle/etl/data/guangdong/month/guangdong_new*.txt
rm /home/oracle/etl/data/guangdong/month/guangdong_new*.txt.bz2
rm /home/oracle/etl/data/guangdong/month/online/optcost/*
rm /home/oracle/etl/data/guangdong/month/online/city/*
rm /home/oracle/etl/data/guangdong/month/cancel/optcost/*
rm /home/oracle/etl/data/guangdong/month/cancel/city/*
rm /home/oracle/etl/data/guangdong/month/new/optcost/*
rm /home/oracle/etl/data/guangdong/month/new/city/*

function splitFiles(){
	##echo $1
	cd $1
	files="`ls *.csv`" 
	for File in $files 
	do 
		file_name_arr=($(echo $File | tr '.' ' ' | tr -s ' '))
		filename=`echo ${file_name_arr[0]}`
		##echo $filename
		
		count=`cat $File | wc -l`
		##echo $count
		
		if [ $count -ge 800000 ];then
			half=$(($count/3+1))
			##echo $half
			split -l $half $File ${filename}_
			
			tfiles="`ls *_a[a-z]`" 
			for tFile in $tfiles 
			do 
				
				tf=($(echo $tFile | tr '_' ' ' | tr -s ' '))
				tfilename=${tf[0]}
				flag=${tf[1]}
				outfile=`echo ${tfilename}_${flag}.csv | sed 's/ //g'`

				cp $tFile $outfile
				rm $tFile

			done
			
			rm $File
		fi
	done
}

##在线用户明细：即截止上月月底的在线用户明细，按产品和按地市各提供一份，字段要求：手机号码|业务名称|业务下发条数|省份|地市|开通时间|开通渠道|退订时间|是否满足计费(|违章业务归属地)

bzcat /data0/match/orig/${DEALDATE}/snapshot.txt.bz2 | grep -e'|10301063|'  -e '|10301009|' -e '|10511003|' -e '|10301010|' -e '|10511004|' -e '|10301083|' -e '|10511014|' -e '|10511005|' -e '|10301085|' -e '|10511024|' -e '|10511050|' -e '|10301018|' -e '|10301019|' -e '|10301020|' -e '|10301021|' -e '|10301022|' -e '|10301023|' -e '|10301024|' -e '|10511019|' -e '|10511020|' -e '|10301013|' -e '|10511008|' | awk -F'|' '{if($8=="020" && $3=="06")print $1","$2","$3","$4",99991230000000,"$7","$11","}' > /home/oracle/etl/data/guangdong/month/guangdong_snapshot_online.txt

##合并违章
cat /home/oracle/etl/data/guangdong/month/guangdong_snapshot_online.txt /home/oracle/etl/data/guangdong/month/guangdong_wz_online.txt > /home/oracle/etl/data/guangdong/month/guangdong_online.txt

awk -F'[|,]' -v NODIST_DIR=/data0/match/orig/profile/nodist.tsv -v OPTCODE_DIR=/home/oracle/etl/data/optcode.txt '{
if(FILENAME == NODIST_DIR && $5==200){split($0,tmp,"|");p=tmp[1];c=tmp[2];m=tmp[4];nodist[m]=p","c;}
else if(FILENAME == OPTCODE_DIR){if($1~/^W/) optcode[$3] = "违章业务,"$4","$5; else optcode[$3] = $7","$4","$5;}
else{nod=substr($1,1,7);if(nod in nodist){split(nodist[nod],nodtmp,",");province=nodtmp[1];city=nodtmp[2];
split(optcode[$2],opttmp,",");optcost=opttmp[1];jfcode=opttmp[2];fee=opttmp[3];
print $1","optcost","province","city","$4","$7","$5","jfcode","$2","fee","$8;}}
}' /data0/match/orig/profile/nodist.tsv /home/oracle/etl/data/optcode.txt /home/oracle/etl/data/guangdong/month/guangdong_online.txt > /home/oracle/etl/data/guangdong/month/guangdong_online_final.txt

##匹配接收成功条数
awk  -F',' -v CODE_DIR=/data0/match/orig/mm7/${DEALDATE}/stats_month.wuxian_qianxiang.0 -v fileok=/home/oracle/etl/data/guangdong/month/guangdong_online_final_ok.txt '{
if( FILENAME == CODE_DIR  )  d[$1$2]=$1","$2","$3;
 else if ( FILENAME != CODE_DIR &&  substr($9,1,3) == "103"   &&  $1$9 in d ) print d[$1$9]","$0 >> fileok ;
 else if ( FILENAME != CODE_DIR &&  substr($9,1,3) == "103"   && !($1$9 in d )) print $1","$9",0,"$0 >> fileok ;
}' /data0/match/orig/mm7/${DEALDATE}/stats_month.wuxian_qianxiang.0     /home/oracle/etl/data/guangdong/month/guangdong_online_final.txt

awk  -F',' -v CODE_DIR=/data0/match/orig/mm7/${DEALDATE}/stats_month.wuxian_qianxiang.1000 -v fileok=/home/oracle/etl/data/guangdong/month/guangdong_online_final_ok.txt '{
if( FILENAME == CODE_DIR  )  d[$1$2]=$1","$2","$3;
 else if ( FILENAME != CODE_DIR &&  substr($9,1,3) == "105"   &&  $1$9 in d ) print d[$1$9]","$0 >> fileok ;
 else if ( FILENAME != CODE_DIR &&  substr($9,1,3) == "105"   && !($1$9 in d )) print $1","$9",0,"$0 >> fileok ;
}' /data0/match/orig/mm7/${DEALDATE}/stats_month.wuxian_qianxiang.1000     /home/oracle/etl/data/guangdong/month/guangdong_online_final.txt

##是否符合计费条件
cat /home/oracle/etl/data/guangdong/month/guangdong_online_final_ok.txt | awk -F',' -v new_month=${NEWMONTH} '{
if((new_month-$8) <= 3000000) isjf="否";else if(substr($2,1,3)=="105" && $3>0) isjf="是";else if(substr($2,1,3)=="103" && $3>=($13/2)) isjf="是";else isjf="否";
subtime=substr($8,1,4)"-"substr($8,5,2)"-"substr($8,7,2)" "substr($8,9,2)":"substr($8,11,2)":"substr($8,13,2);
endtime=substr($10,1,4)"-"substr($10,5,2)"-"substr($10,7,2)" "substr($10,9,2)":"substr($10,11,2)":"substr($10,13,2);
print $1","$5","$3","$6","$7","subtime","$9","endtime","$11","$12","$13","$14;}' > /home/oracle/etl/data/guangdong/month/guangdong_online_final_ok_jf.txt

cat /home/oracle/etl/data/guangdong/month/guangdong_online_final_ok_jf.txt | awk 'sub("$", "\r")' | awk -F',' '{d="/home/oracle/etl/data/guangdong/month/online/optcost/"$2".csv";print>>d;}'
cat /home/oracle/etl/data/guangdong/month/guangdong_online_final_ok_jf.txt | awk 'sub("$", "\r")' | awk -F',' '{d="/home/oracle/etl/data/guangdong/month/online/city/"$5".csv";print>>d;}'

splitFiles /home/oracle/etl/data/guangdong/month/online/optcost/
splitFiles /home/oracle/etl/data/guangdong/month/online/city/


##退订用户明细：即上月的退订用户明细，按产品和按地市各提供一份，字段要求：手机号码|业务名称|业务下发条数|省份|地市|开通时间|开通渠道|退订时间|退订渠道|退订情形|是否满足计费(|违章业务归属地)

bzcat /home/oracle/etl/data/data/snapshot/archives.txt.bz2 | grep -e'\^10301063\^'  -e '\^10301009\^' -e '\^10511003\^' -e '\^10301010\^' -e '\^10511004\^' -e '\^10301083\^' -e '\^10511014\^' -e '\^10511005\^' -e '\^10301085\^' -e '\^10511024\^' -e '\^10511050\^' -e '\^10301018\^' -e '\^10301019\^' -e '\^10301020\^' -e '\^10301021\^' -e '\^10301022\^' -e '\^10301023\^' -e '\^10301024\^' -e '\^10511019\^' -e '\^10511020\^' -e '\^10301013\^' -e '\^10511008\^' | awk -F'^' -v begin=${BEGINDATE} -v end=${ENDDATE} '{
if($3 == "020" && $8 >= begin && $8 < end) {
split($NF,tmp,"|"); sub_channel=tmp[6]; unsub_channel=tmp[12];
print $2","$6","$7","sub_channel","$8","unsub_channel",";}}' > /home/oracle/etl/data/guangdong/month/guangdong_snapshot_cancel.txt

##合并违章
cat /home/oracle/etl/data/guangdong/month/guangdong_snapshot_cancel.txt /home/oracle/etl/data/guangdong/month/guangdong_wz_cancel.txt > /home/oracle/etl/data/guangdong/month/guangdong_cancel.txt

awk -F'[|,]' -v NODIST_DIR=/data0/match/orig/profile/nodist.tsv -v OPTCODE_DIR=/home/oracle/etl/data/optcode.txt '{
if(FILENAME == NODIST_DIR && $5==200){split($0,tmp,"|");p=tmp[1];c=tmp[2];m=tmp[4];nodist[m]=p","c;}
else if(FILENAME == OPTCODE_DIR){if($1~/^W/) optcode[$3] = "违章业务,"$4","$5; else optcode[$3] = $7","$4","$5;}
else{nod=substr($1,1,7);if(nod in nodist){split(nodist[nod],nodtmp,",");province=nodtmp[1];city=nodtmp[2];
split(optcode[$2],opttmp,",");optcost=opttmp[1];jfcode=opttmp[2];fee=opttmp[3];
print $1","optcost","province","city","$3","$4","$5","$6","jfcode","$2","fee","$7;}}
}' /data0/match/orig/profile/nodist.tsv /home/oracle/etl/data/optcode.txt /home/oracle/etl/data/guangdong/month/guangdong_cancel.txt > /home/oracle/etl/data/guangdong/month/guangdong_cancel_final.txt

##匹配接收成功条数
awk  -F',' -v CODE_DIR=/data0/match/orig/mm7/${DEALDATE}/stats_month.wuxian_qianxiang.0 -v fileok=/home/oracle/etl/data/guangdong/month/guangdong_cancel_final_ok.txt '{
if( FILENAME == CODE_DIR  )  d[$1$2]=$1","$2","$3;
 else if ( FILENAME != CODE_DIR &&  substr($10,1,3) == "103"   &&  $1$10 in d ) print d[$1$10]","$0 >> fileok ;
 else if ( FILENAME != CODE_DIR &&  substr($10,1,3) == "103"   && !($1$10 in d )) print $1","$10",0,"$0 >> fileok ;
}' /data0/match/orig/mm7/${DEALDATE}/stats_month.wuxian_qianxiang.0     /home/oracle/etl/data/guangdong/month/guangdong_cancel_final.txt

awk  -F',' -v CODE_DIR=/data0/match/orig/mm7/${DEALDATE}/stats_month.wuxian_qianxiang.1000 -v fileok=/home/oracle/etl/data/guangdong/month/guangdong_cancel_final_ok.txt '{
if( FILENAME == CODE_DIR  )  d[$1$2]=$1","$2","$3;
 else if ( FILENAME != CODE_DIR &&  substr($10,1,3) == "105"   &&  $1$10 in d ) print d[$1$10]","$0 >> fileok ;
 else if ( FILENAME != CODE_DIR &&  substr($10,1,3) == "105"   && !($1$10 in d )) print $1","$10",0,"$0 >> fileok ;
}' /data0/match/orig/mm7/${DEALDATE}/stats_month.wuxian_qianxiang.1000     /home/oracle/etl/data/guangdong/month/guangdong_cancel_final.txt

##整理退订情形
cat /home/oracle/etl/data/guangdong/month/guangdong_cancel_final_ok.txt | sed 's/[- :]//g' | awk -F',' '{
if(substr($8,1,8)==substr($10,1,8)) state="即订即退";else if(($10-$8)<=3000000) state="免费期退订";
else if(substr($8,1,6)==substr($10,1,6)) state="当月订当月退";else if(substr($8,1,6)!=substr($10,1,6)) state="跨月退订";
subtime=substr($8,1,4)"-"substr($8,5,2)"-"substr($8,7,2)" "substr($8,9,2)":"substr($8,11,2)":"substr($8,13,2);
endtime=substr($10,1,4)"-"substr($10,5,2)"-"substr($10,7,2)" "substr($10,9,2)":"substr($10,11,2)":"substr($10,13,2);
if($12~/^[0-9]+$/) jfcode=$12; else jfcode="-"$12;
print $1","$5","$3","$6","$7","subtime","$9","endtime","$11","state","jfcode","$13","$14","$15;
}' > /home/oracle/etl/data/guangdong/month/guangdong_cancel_final_ok_state.txt

cat /home/oracle/etl/data/guangdong/month/guangdong_cancel_final_ok_state.txt | awk 'sub("$", "\r")' | awk -F',' '{d="/home/oracle/etl/data/guangdong/month/cancel/optcost/"$2".csv";print>>d;}'
cat /home/oracle/etl/data/guangdong/month/guangdong_cancel_final_ok_state.txt | awk 'sub("$", "\r")' | awk -F',' '{d="/home/oracle/etl/data/guangdong/month/cancel/city/"$5".csv";print>>d;}'


##新增用户明细：即当月截止前一日新增用户明细，按产品和按地市各提供一份，字段要求：手机号码|业务名称|业务下发条数|省份|地市|开通时间|开通渠道|退订时间|是否满足计费(|违章业务归属地)

bzcat /home/oracle/etl/data/data/snapshot/snapshot.txt.bz2 | grep  -e'|10301063|' -e '|10301009|' -e '|10511003|' -e '|10301010|' -e '|10511004|' -e '|10301083|' -e '|10511014|' -e '|10511005|' -e '|10301085|' -e '|10511024|' -e '|10511050|' -e '|10301018|' -e '|10301019|' -e '|10301020|' -e '|10301021|' -e '|10301022|' -e '|10301023|' -e '|10301024|' -e '|10511019|' -e '|10511020|' -e '|10301013|' -e '|10511008|' | awk -F'|' -v begin=${NEWADD_STARTDATE} -v end=${NEWADD_ENDDATE} '{
if($8=="020" && $3=="06" && $4>=begin && $4<end) print $1","$2","$4",99991230000000,"$7","$11",";
else if($8=="020" && $3=="07" && $5>=begin && $5<end)print $1","$2","$5","$4","$7","$11","}' > /home/oracle/etl/data/guangdong/month/guangdong_snapshot_new.txt

##合并违章
cat /home/oracle/etl/data/guangdong/month/guangdong_snapshot_new.txt /home/oracle/etl/data/guangdong/month/guangdong_wz_new.txt > /home/oracle/etl/data/guangdong/month/guangdong_new.txt

awk -F'[|,]' -v NODIST_DIR=/data0/match/orig/profile/nodist.tsv -v OPTCODE_DIR=/home/oracle/etl/data/optcode.txt '{
if(FILENAME == NODIST_DIR && $5==200){split($0,tmp,"|");p=tmp[1];c=tmp[2];m=tmp[4];nodist[m]=p","c;}
else if(FILENAME == OPTCODE_DIR){if($1~/^W/) optcode[$3] = "违章业务,"$4","$5; else optcode[$3] = $7","$4","$5;}
else{nod=substr($1,1,7);if(nod in nodist){split(nodist[nod],nodtmp,",");province=nodtmp[1];city=nodtmp[2];
split(optcode[$2],opttmp,",");optcost=opttmp[1];jfcode=opttmp[2];fee=opttmp[3];
print $1","optcost","province","city","$3","$6","$4","jfcode","$2","fee","$7;}}
}' /data0/match/orig/profile/nodist.tsv /home/oracle/etl/data/optcode.txt /home/oracle/etl/data/guangdong/month/guangdong_new.txt > /home/oracle/etl/data/guangdong/month/guangdong_new_final.txt

##匹配接收成功条数
awk  -F',' -v CODE_DIR=/data0/match/orig/mm7/${DEALDATE}/stats_month.wuxian_qianxiang.0 -v fileok=/home/oracle/etl/data/guangdong/month/guangdong_new_final_ok.txt '{
if( FILENAME == CODE_DIR  )  d[$1$2]=$1","$2","$3;
 else if ( FILENAME != CODE_DIR &&  substr($9,1,3) == "103"   &&  $1$9 in d ) print d[$1$9]","$0 >> fileok ;
 else if ( FILENAME != CODE_DIR &&  substr($9,1,3) == "103"   && !($1$9 in d )) print $1","$9",0,"$0 >> fileok ;
}' /data0/match/orig/mm7/${DEALDATE}/stats_month.wuxian_qianxiang.0     /home/oracle/etl/data/guangdong/month/guangdong_new_final.txt

awk  -F',' -v CODE_DIR=/data0/match/orig/mm7/${DEALDATE}/stats_month.wuxian_qianxiang.1000 -v fileok=/home/oracle/etl/data/guangdong/month/guangdong_new_final_ok.txt '{
if( FILENAME == CODE_DIR  )  d[$1$2]=$1","$2","$3;
 else if ( FILENAME != CODE_DIR &&  substr($9,1,3) == "105"   &&  $1$9 in d ) print d[$1$9]","$0 >> fileok ;
 else if ( FILENAME != CODE_DIR &&  substr($9,1,3) == "105"   && !($1$9 in d )) print $1","$9",0,"$0 >> fileok ;
}' /data0/match/orig/mm7/${DEALDATE}/stats_month.wuxian_qianxiang.1000     /home/oracle/etl/data/guangdong/month/guangdong_new_final.txt

##是否符合计费条件
cat /home/oracle/etl/data/guangdong/month/guangdong_new_final_ok.txt | awk -F',' -v new_month=${NEWMONTH} '{
if((new_month-$8) <= 3000000 || ($10-$8) <= 3000000) isjf="否";else if(substr($2,1,3)=="105" && $3>0) isjf="是";else if(substr($2,1,3)=="103" && $3>=($13/2)) isjf="是";else isjf="否";
subtime=substr($8,1,4)"-"substr($8,5,2)"-"substr($8,7,2)" "substr($8,9,2)":"substr($8,11,2)":"substr($8,13,2);
endtime=substr($10,1,4)"-"substr($10,5,2)"-"substr($10,7,2)" "substr($10,9,2)":"substr($10,11,2)":"substr($10,13,2);
print $1","$5","$3","$6","$7","subtime","$9","endtime","$11","$12","$13","$14;}' > /home/oracle/etl/data/guangdong/month/guangdong_new_final_ok_jf.txt

cat /home/oracle/etl/data/guangdong/month/guangdong_new_final_ok_jf.txt | awk 'sub("$", "\r")' | awk -F',' '{d="/home/oracle/etl/data/guangdong/month/new/optcost/"$2".csv";print>>d;}'
cat /home/oracle/etl/data/guangdong/month/guangdong_new_final_ok_jf.txt | awk 'sub("$", "\r")' | awk -F',' '{d="/home/oracle/etl/data/guangdong/month/new/city/"$5".csv";print>>d;}'


bzip2 /home/oracle/etl/data/guangdong/month/online/optcost/*
bzip2 /home/oracle/etl/data/guangdong/month/online/city/*
bzip2 /home/oracle/etl/data/guangdong/month/cancel/optcost/*
bzip2 /home/oracle/etl/data/guangdong/month/cancel/city/*
bzip2 /home/oracle/etl/data/guangdong/month/new/optcost/*
bzip2 /home/oracle/etl/data/guangdong/month/new/city/*


ftp -i -v -n IP <<EOF
user xunqi ZM3C61wR
binary
cd /month/online/
mkdir $DEALDATE
cd $DEALDATE
lcd /home/oracle/etl/data/guangdong/month/online/optcost/
mput *
EOF

ftp -i -v -n IP <<EOF
user xunqi ZM3C61wR
binary
cd /month/online/
cd $DEALDATE
lcd /home/oracle/etl/data/guangdong/month/online/city/
mput *
EOF

ftp -i -v -n IP <<EOF
user xunqi ZM3C61wR
binary
cd /month/cancel/
mkdir $DEALDATE
cd $DEALDATE
lcd /home/oracle/etl/data/guangdong/month/cancel/optcost/
mput *
EOF

ftp -i -v -n IP <<EOF
user xunqi ZM3C61wR
binary
cd /month/cancel/
cd $DEALDATE
lcd /home/oracle/etl/data/guangdong/month/cancel/city/
mput *
EOF

ftp -i -v -n IP <<EOF
user xunqi ZM3C61wR
binary
cd /month/new/
mkdir $DEALDATE
cd $DEALDATE
lcd /home/oracle/etl/data/guangdong/month/new/optcost/
mput *
EOF

ftp -i -v -n IP <<EOF
user xunqi ZM3C61wR
binary
cd /month/new/
cd $DEALDATE
lcd /home/oracle/etl/data/guangdong/month/new/city/
mput *
EOF

ftp -i -v -n IP <<EOF
user xunqi ZM3C61wR
cd /month/guangzhou/
mkdir $DEALDATE
cd $DEALDATE
lcd /home/oracle/etl/data/guangdong/month/
put guangzhou_wz_online.txt
EOF

