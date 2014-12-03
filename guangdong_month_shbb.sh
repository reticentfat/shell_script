#! /usr/bin/ksh
export PATH=/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/usr/X11R6/bin:/home/oracle/bin:/data0/app/ora11g/product/11.2.0/db_1/bin/
export ORACLE_HOME=/data0/app/ora11g/product/11.2.0/db_1

export ORACLE_SID=wxtjdb;
export LANG="SIMPLIFIED CHINESE_CHINA.ZHS16GBK";
ORACLE_NLS=$ORACLE_HOME/ocommon/nls/admin/data ;
export ORACLE_NLS


##每天执行 30 21 1 * * sh /home/oracle/etl/bin/guangdong_month_shbb.sh
##输入参数执行	25 14 8 3 * sh /home/oracle/etl/bin/guangdong_month_shbb.sh 20120228 2012-02-01 2012-03-01 20120201000000 20120301000000


usage () {
    echo "usage: $0 SNAPSHOT_DATE BEGINDATE ENDDATE NEWADD_STARTDATE NEWADD_ENDDATE " 1>&2
    exit 2
}

if [ $# -ne 5 ] && [ $# -gt 0 ] ; then
    usage
fi



if [ $# -eq 5 ] ; then
	DEALDATE=$1		###20120228
	BEGINDATE=$2	###2012-02-01
	ENDDATE=$3		###2012-03-01
	NEWADD_STARTDATE=$4	###20120201000000
	NEWADD_ENDDATE=$5	###20120301000000
fi

if [ ${DEALDATE:=999} = 999 ];then
	DEALDATE=`date --date='2 days ago' +%Y%m%d` ##月末前一天
	BEGINDATE=`date --date='1 days ago' +%Y-%m`-01
	ENDDATE=`date "+%Y-%m-%d"`
	NEWADD_STARTDATE=`date --date='1 days ago' +%Y%m`01000000
	NEWADD_ENDDATE=`date +%Y%m%d`000000
fi



rm /home/oracle/etl/data/guangdong/month/media/guangdong_snapshot*.txt
rm /home/oracle/etl/data/guangdong/month/media/guangdong_snapshot*.txt.bz2
rm /home/oracle/etl/data/guangdong/month/media/online/optcost/*
rm /home/oracle/etl/data/guangdong/month/media/online/city/*
rm /home/oracle/etl/data/guangdong/month/media/cancel/optcost/*
rm /home/oracle/etl/data/guangdong/month/media/cancel/city/*
rm /home/oracle/etl/data/guangdong/month/media/new/optcost/*
rm /home/oracle/etl/data/guangdong/month/media/new/city/*

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

		if [ $count -ge 5000000 ];then
			half=$(($count/7+1))
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
		
		elif [ $count -ge 3000000 ];then
			half=$(($count/5+1))
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
		
		elif [ $count -ge 800000 ];then
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

##媒体业务	在线：号码|业务名称|省份|地市|开通时间|开通渠道|退订时间|业务代码|状态（正常/暂停）
bzcat /data0/match/orig/${DEALDATE}/snapshot.txt.bz2 | awk -F'|' '{if($8=="020" && $3=="06" && $2~/^2/)print $1","$2","$3","$4",99991230000000,"$7","$11","}' > /home/oracle/etl/data/guangdong/month/media/guangdong_snapshot_shbb_online.txt

awk -F'[|,]' -v NODIST_DIR=/data0/match/orig/profile/nodist.tsv -v OPTCODE_DIR=/home/oracle/etl/data/opt_code_all.txt '{
if(FILENAME == NODIST_DIR && $5==200){split($0,tmp,"|");p=tmp[1];c=tmp[2];m=tmp[4];nodist[m]=p","c;}
else if(FILENAME == OPTCODE_DIR) optcode[$1] = $5","$2;
else{nod=substr($1,1,7);if(nod in nodist){split(nodist[nod],nodtmp,",");province=nodtmp[1];city=nodtmp[2];
split(optcode[$2],opttmp,",");optcost=opttmp[1];jfcode=opttmp[2];
subtime=substr($4,1,4)"-"substr($4,5,2)"-"substr($4,7,2)" "substr($4,9,2)":"substr($4,11,2)":"substr($4,13,2);
endtime=substr($5,1,4)"-"substr($5,5,2)"-"substr($5,7,2)" "substr($5,9,2)":"substr($5,11,2)":"substr($5,13,2);
if($6==1) state = "正常"; else if($6==0) state = "暂停";
print $1","optcost","province","city","subtime","$7","endtime","jfcode","$2","state;}}
}' /data0/match/orig/profile/nodist.tsv /home/oracle/etl/data/opt_code_all.txt /home/oracle/etl/data/guangdong/month/media/guangdong_snapshot_shbb_online.txt > /home/oracle/etl/data/guangdong/month/media/guangdong_snapshot_shbb_online_final.txt

cat /home/oracle/etl/data/guangdong/month/media/guangdong_snapshot_shbb_online_final.txt | awk 'sub("$", "\r")' | awk -F',' '{d="/home/oracle/etl/data/guangdong/month/media/online/optcost/"$2".csv";print>>d;}'
cat /home/oracle/etl/data/guangdong/month/media/guangdong_snapshot_shbb_online_final.txt | awk 'sub("$", "\r")' | awk -F',' '{d="/home/oracle/etl/data/guangdong/month/media/online/city/"$4".csv";print>>d;}'

splitFiles /home/oracle/etl/data/guangdong/month/media/online/optcost/
splitFiles /home/oracle/etl/data/guangdong/month/media/online/city/


##媒体业务	退订：号码|业务名称|省份|地市|开通时间|开通渠道|退订时间|退订渠道|业务代码
bzcat /home/oracle/etl/data/data/snapshot/archives.txt.bz2 | awk -F'^' -v begin=${BEGINDATE} -v end=${ENDDATE} '{
if($3 == "020" && $6~/^2/ && $8 >= begin && $8 < end) {
split($NF,subcodes,","); for(t in subcodes) count=t; split(subcodes[t],tmp,"|"); sub_channel=tmp[6]; unsub_channel=tmp[12];
print $2","$6","$7","sub_channel","$8","unsub_channel",";}}' > /home/oracle/etl/data/guangdong/month/media/guangdong_snapshot_shbb_cancel.txt

awk -F'[|,]' -v NODIST_DIR=/data0/match/orig/profile/nodist.tsv -v OPTCODE_DIR=/home/oracle/etl/data/opt_code_all.txt '{
if(FILENAME == NODIST_DIR && $5==200){split($0,tmp,"|");p=tmp[1];c=tmp[2];m=tmp[4];nodist[m]=p","c;}
else if(FILENAME == OPTCODE_DIR) optcode[$1] = $5","$2;
else{nod=substr($1,1,7);if(nod in nodist){split(nodist[nod],nodtmp,",");province=nodtmp[1];city=nodtmp[2];
split(optcode[$2],opttmp,",");optcost=opttmp[1];jfcode=opttmp[2];
print $1","optcost","province","city","$3","$4","$5","$6","jfcode","$2","$7;}}
}' /data0/match/orig/profile/nodist.tsv /home/oracle/etl/data/opt_code_all.txt /home/oracle/etl/data/guangdong/month/media/guangdong_snapshot_shbb_cancel.txt > /home/oracle/etl/data/guangdong/month/media/guangdong_snapshot_shbb_cancel_final.txt

cat /home/oracle/etl/data/guangdong/month/media/guangdong_snapshot_shbb_cancel_final.txt | awk 'sub("$", "\r")' | awk -F',' '{d="/home/oracle/etl/data/guangdong/month/media/cancel/optcost/"$2".csv";print>>d;}'
cat /home/oracle/etl/data/guangdong/month/media/guangdong_snapshot_shbb_cancel_final.txt | awk 'sub("$", "\r")' | awk -F',' '{d="/home/oracle/etl/data/guangdong/month/media/cancel/city/"$4".csv";print>>d;}'


##新增用户明细：即当月截止前一日新增用户明细，按产品和按地市各提供一份，字段要求分别为：手机号码|业务名称|省份|地市|开通时间|开通渠道|退订时间(|违章业务归属地)

bzcat /data0/match/orig/${DEALDATE}/snapshot.txt.bz2 | awk -F'|' -v begin=${NEWADD_STARTDATE} -v end=${NEWADD_ENDDATE} '{
if($8=="020" && $3=="06" && $2~/^2/ && $4>=begin && $4<end) print $1","$2","$4",99991230000000,"$7","$11",";
else if($8=="020" && $3=="07" && $2~/^2/ && $5>=begin && $5<end)print $1","$2","$5","$4","$7","$11","}' > /home/oracle/etl/data/guangdong/month/media/guangdong_snapshot_shbb_new.txt

awk -F'[|,]' -v NODIST_DIR=/data0/match/orig/profile/nodist.tsv -v OPTCODE_DIR=/home/oracle/etl/data/opt_code_all.txt '{
if(FILENAME == NODIST_DIR && $5==200){split($0,tmp,"|");p=tmp[1];c=tmp[2];m=tmp[4];nodist[m]=p","c;}
else if(FILENAME == OPTCODE_DIR) optcode[$1] = $5","$2;
else{nod=substr($1,1,7);if(nod in nodist){split(nodist[nod],nodtmp,",");province=nodtmp[1];city=nodtmp[2];
split(optcode[$2],opttmp,",");optcost=opttmp[1];jfcode=opttmp[2];
subtime=substr($3,1,4)"-"substr($3,5,2)"-"substr($3,7,2)" "substr($3,9,2)":"substr($3,11,2)":"substr($3,13,2);
endtime=substr($4,1,4)"-"substr($4,5,2)"-"substr($4,7,2)" "substr($4,9,2)":"substr($4,11,2)":"substr($4,13,2);
print $1","optcost","province","city","subtime","$6","endtime","jfcode","$2","$7;}}
}' /data0/match/orig/profile/nodist.tsv /home/oracle/etl/data/opt_code_all.txt /home/oracle/etl/data/guangdong/month/media/guangdong_snapshot_shbb_new.txt > /home/oracle/etl/data/guangdong/month/media/guangdong_snapshot_shbb_new_final.txt

cat /home/oracle/etl/data/guangdong/month/media/guangdong_snapshot_shbb_new_final.txt | awk 'sub("$", "\r")' | awk -F',' '{d="/home/oracle/etl/data/guangdong/month/media/new/optcost/"$2".csv";print>>d;}'
cat /home/oracle/etl/data/guangdong/month/media/guangdong_snapshot_shbb_new_final.txt | awk 'sub("$", "\r")' | awk -F',' '{d="/home/oracle/etl/data/guangdong/month/media/new/city/"$4".csv";print>>d;}'


bzip2 /home/oracle/etl/data/guangdong/month/media/online/optcost/*
bzip2 /home/oracle/etl/data/guangdong/month/media/online/city/*
bzip2 /home/oracle/etl/data/guangdong/month/media/cancel/optcost/*
bzip2 /home/oracle/etl/data/guangdong/month/media/cancel/city/*
bzip2 /home/oracle/etl/data/guangdong/month/media/new/optcost/*
bzip2 /home/oracle/etl/data/guangdong/month/media/new/city/*


ftp -i -v -n 172.16.24.23 <<EOF
user gdadmin 1234qwer
binary
cd /month/media/online/
mkdir $DEALDATE
cd $DEALDATE
lcd /home/oracle/etl/data/guangdong/month/media/online/optcost/
mput *
EOF

ftp -i -v -n 172.16.24.23 <<EOF
user gdadmin 1234qwer
binary
cd /month/media/online/
cd $DEALDATE
lcd /home/oracle/etl/data/guangdong/month/media/online/city/
mput *
EOF

ftp -i -v -n 172.16.24.23 <<EOF
user gdadmin 1234qwer
binary
cd /month/media/cancel/
mkdir $DEALDATE
cd $DEALDATE
lcd /home/oracle/etl/data/guangdong/month/media/cancel/optcost/
mput *
EOF

ftp -i -v -n 172.16.24.23 <<EOF
user gdadmin 1234qwer
binary
cd /month/media/cancel/
cd $DEALDATE
lcd /home/oracle/etl/data/guangdong/month/media/cancel/city/
mput *
EOF

ftp -i -v -n 172.16.24.23 <<EOF
user gdadmin 1234qwer
binary
cd /month/media/new/
mkdir $DEALDATE
cd $DEALDATE
lcd /home/oracle/etl/data/guangdong/month/media/new/optcost/
mput *
EOF

ftp -i -v -n 172.16.24.23 <<EOF
user gdadmin 1234qwer
binary
cd /month/media/new/
cd $DEALDATE
lcd /home/oracle/etl/data/guangdong/month/media/new/city/
mput *
EOF

