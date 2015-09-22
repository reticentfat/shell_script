#! /usr/bin/ksh
export PATH=/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/usr/X11R6/bin:/home/oracle/bin:/data/app/ora11g/product/11.2.0/db_1/bin/
export ORACLE_HOME=/data/app/ora11g/product/11.2.0/db_1
export ORACLE_SID=wxtjdb;
export LANG="SIMPLIFIED CHINESE_CHINA.ZHS16GBK";
ORACLE_NLS=$ORACLE_HOME/ocommon/nls/admin/data ;
export ORACLE_NLS

##每月1日执行 20 14 1 * * sh /home/oracle/etl/bin/guangdong_month_fenkan.sh
##输入参数执行	25 14 8 3 * sh /home/oracle/etl/bin/guangdong_month_fenkan.sh 20120228 201202

usage () {
    echo "usage: $0 SNAPSHOT_DATE DEALMONTH " 1>&2
    exit 2
}

if [ $# -ne 2 ] && [ $# -gt 0 ] ; then
    usage
fi



if [ $# -eq 2 ] ; then
	DEALDATE=$1		###20120228
	DEALMONTH=$2	###201202
fi

if [ ${DEALDATE:=999} = 999 ];then
	DEALDATE=`date --date='2 days ago' "+%Y%m%d"`	##月末前一天
	DEALMONTH=`date --date='2 days ago' "+%Y%m"`
fi


echo $DEALDATE
echo $DEALMONTH

rm /home/oracle/etl/data/guangdong/month/fenkan/online/*.txt
rm /home/oracle/etl/data/guangdong/month/fenkan/online/*.txt.bz2
##rm /home/oracle/etl/data/guangdong/month/fenkan/online/optcost/*
rm /home/oracle/etl/data/guangdong/month/fenkan/online/JKXGJ_SMS/city/*
rm /home/oracle/etl/data/guangdong/month/fenkan/online/ZJYHJ_MMS/city/*


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

cd /home/oracle/etl/data/guangdong/month/fenkan/online/
rm -Rf data/

##健康小管家
wget -m -nH  "http://192.100.6.247:9999/data/dump/YYZL_SMS/users.txt.bz2"
cp /home/oracle/etl/data/guangdong/month/fenkan/online/data/dump/JKXGJ_SMS/users.txt.bz2 /home/oracle/etl/data/guangdong/month/fenkan/online/JKXGJ_SMS_users.txt.bz2

bzcat /home/oracle/etl/data/guangdong/month/fenkan/online/JKXGJ_SMS_users.txt.bz2 | awk 'BEGIN{cates["1"] = "家庭保健"; cates["2"] = "吃出健康"; cates["3"] = "心灵之窗"; cates["4"] = "国学养生"; cates["5"] = "儿童保健"; cates["6"] = "青少年保健"; cates["7"] = "中老年保健"; cates["8"] = "女性常保健"; cates["9"] = "男性常保健"; cates["10"] = "孕妇保健"; cates["11"] = "产妇和婴幼儿保健"; cates["12"] = "大众保健";}{if($2=="020") print $1"|"$4"|"cates[$5]"|"$5}' | bzip2 > /home/oracle/etl/data/guangdong/month/fenkan/online/JKXGJ_SMS_users_guangdong.txt.bz2

bzcat /home/oracle/etl/data/guangdong/month/fenkan/online/JKXGJ_SMS_users_guangdong.txt.bz2 /data/match/orig/${DEALDATE}/snapshot.txt.bz2 | awk -F'|' '{if(NF==4){d[$1]=$3;}else if($8=="020" && $3=="06" && $2=="10301063" && $1 in d)print $1","$2","$3","$4",99991230000000,"$7","$11","d[$1]}' > /home/oracle/etl/data/guangdong/month/fenkan/online/JKXGJ_SMS_users_guangdong_snapshot.txt

awk -F'[|,]' -v NODIST_DIR=/data/match/orig/profile/nodist.tsv -v OPTCODE_DIR=/home/oracle/etl/data/optcode.txt '{
if(FILENAME == NODIST_DIR && $5==200){split($0,tmp,"|");p=tmp[1];c=tmp[2];m=tmp[4];nodist[m]=p","c;}
else if(FILENAME == OPTCODE_DIR){if($1~/^W/) optcode[$3] = "违章业务,"$4","$5; else optcode[$3] = $7","$4","$5;}
else{nod=substr($1,1,7);if(nod in nodist){split(nodist[nod],nodtmp,",");province=nodtmp[1];city=nodtmp[2];
split(optcode[$2],opttmp,",");optcost=opttmp[1];jfcode=opttmp[2];fee=opttmp[3];
subtime=substr($4,1,4)"-"substr($4,5,2)"-"substr($4,7,2)" "substr($4,9,2)":"substr($4,11,2)":"substr($4,13,2);
endtime=substr($5,1,4)"-"substr($5,5,2)"-"substr($5,7,2)" "substr($5,9,2)":"substr($5,11,2)":"substr($5,13,2);
print $1","optcost","province","city","subtime","$7","endtime","jfcode","$2","fee","$8;}}
}' /data/match/orig/profile/nodist.tsv /home/oracle/etl/data/optcode.txt /home/oracle/etl/data/guangdong/month/fenkan/online/JKXGJ_SMS_users_guangdong_snapshot.txt > /home/oracle/etl/data/guangdong/month/fenkan/online/JKXGJ_SMS_users_guangdong_final.txt

##cat /home/oracle/etl/data/guangdong/month/fenkan/online/JKXGJ_SMS_users_guangdong_final.txt | awk 'sub("$", "\r")' | awk -F',' '{d="/home/oracle/etl/data/guangdong/month/fenkan/online/JKXGJ_SMS/optcost/"$NF".csv";print>>d;}'
cat /home/oracle/etl/data/guangdong/month/fenkan/online/JKXGJ_SMS_users_guangdong_final.txt | awk 'sub("$", "\r")' | awk -F',' '{d="/home/oracle/etl/data/guangdong/month/fenkan/online/JKXGJ_SMS/city/"$4".csv";print>>d;}'

##splitFiles /home/oracle/etl/data/guangdong/month/fenkan/online/JKXGJ_SMS/optcost/
##splitFiles /home/oracle/etl/data/guangdong/month/fenkan/online/JKXGJ_SMS/city/

##bzip2 /home/oracle/etl/data/guangdong/month/fenkan/online/JKXGJ_SMS/optcost/*
bzip2 /home/oracle/etl/data/guangdong/month/fenkan/online/JKXGJ_SMS/city/*


##优惠券
wget -m -nH  "http://192.100.6.247:9999/data/dump/ZJYHJ_MMS/users.txt.bz2"
cp /home/oracle/etl/data/guangdong/month/fenkan/online/data/dump/ZJYHJ_MMS/users.txt.bz2 /home/oracle/etl/data/guangdong/month/fenkan/online/ZJYHJ_MMS_users.txt.bz2

##cat area.txt | awk -F'\t' '{print "areas[\""$1"\"]=\""$2"\";"}' | unix2dos > areas.txt
bzcat /home/oracle/etl/data/guangdong/month/fenkan/online/ZJYHJ_MMS_users.txt.bz2 | awk 'BEGIN{
areas["20011"]="东山区";
areas["20012"]="越秀区";
areas["20013"]="天河区";
areas["20014"]="白云区";
areas["20015"]="番禺区";
areas["20016"]="增城市";
areas["20017"]="荔湾区";
areas["20018"]="海珠区";
areas["20019"]="芳村区";
areas["20020"]="黄埔区";
areas["20021"]="花都区";
areas["20022"]="从化市";
areas["75111"]="北江区";
areas["75112"]="浈江区";
areas["75113"]="始兴县";
areas["75114"]="翁源县";
areas["75115"]="新丰县";
areas["75116"]="南雄市";
areas["75117"]="武江区";
areas["75118"]="曲江县";
areas["75119"]="仁化县";
areas["75120"]="乳源瑶族自治县";
areas["75121"]="乐昌市";
areas["75511"]="罗湖区";
areas["75512"]="南山区";
areas["75513"]="龙岗区";
areas["75514"]="福田区";
areas["75515"]="宝安区";
areas["75516"]="盐田区";
areas["75517"]="VIP区";
areas["75518"]="深圳全市";
areas["75611"]="香洲区";
areas["75612"]="金湾区";
areas["75613"]="斗门区";
areas["75411"]="龙湖区";
areas["75412"]="濠江区";
areas["75413"]="潮南区";
areas["75414"]="南澳县";
areas["75415"]="金平区";
areas["75416"]="潮阳区";
areas["75417"]="澄海区";
areas["75418"]="汕头全市";
areas["75711"]="禅城区";
areas["75712"]="顺德区";
areas["75713"]="高明区";
areas["75714"]="南海区";
areas["75715"]="三水区";
areas["75011"]="蓬江区";
areas["75012"]="新会区";
areas["75013"]="开平市";
areas["75014"]="恩平市";
areas["75015"]="江海区";
areas["75016"]="台山市";
areas["75017"]="鹤山市";
areas["75911"]="赤坎区";
areas["75912"]="坡头区";
areas["75913"]="遂溪县";
areas["75914"]="廉江市";
areas["75915"]="吴川市";
areas["75916"]="霞山区";
areas["75917"]="麻章区";
areas["75918"]="徐闻县";
areas["75919"]="雷州市";
areas["66811"]="茂南区";
areas["66812"]="电白县";
areas["66813"]="化州市";
areas["66814"]="茂港区";
areas["66815"]="高州市";
areas["66816"]="信宜市";
areas["75811"]="端州区";
areas["75812"]="广宁县";
areas["75813"]="封开县";
areas["75814"]="高要市";
areas["75815"]="鼎湖区";
areas["75816"]="怀集县";
areas["75817"]="德庆县";
areas["75818"]="四会市";
areas["75211"]="惠城区";
areas["75212"]="博罗县";
areas["75213"]="龙门县";
areas["75214"]="惠阳区";
areas["75215"]="惠东县";
areas["75311"]="梅江区";
areas["75312"]="大埔县";
areas["75313"]="五华县";
areas["75314"]="蕉岭县";
areas["75315"]="梅县";
areas["75316"]="丰顺县";
areas["75317"]="平远县";
areas["75318"]="兴宁市";
areas["66011"]="城区";
areas["66012"]="陆河县";
areas["66013"]="海丰县";
areas["66014"]="陆丰市";
areas["76211"]="源城区";
areas["76212"]="龙川县";
areas["76213"]="和平县";
areas["76214"]="紫金县";
areas["76215"]="连平县";
areas["76216"]="东源县";
areas["66211"]="江城区";
areas["66212"]="阳东县";
areas["66213"]="阳西县";
areas["66214"]="阳春市";
areas["76311"]="清城区";
areas["76312"]="阳山县";
areas["76313"]="连南瑶族自治县";
areas["76314"]="英德市";
areas["76315"]="佛冈县";
areas["76316"]="连山壮族瑶族自治县";
areas["76317"]="清新县";
areas["76318"]="连州市";
areas["76911"]="东莞市";
areas["76011"]="中山市";
areas["76811"]="湘桥区";
areas["76812"]="饶平县";
areas["76813"]="潮安县";
areas["76814"]="枫溪区";
areas["66311"]="榕城区";
areas["66312"]="揭西县";
areas["66313"]="普宁市";
areas["66314"]="揭东县";
areas["66315"]="惠来县";
areas["76611"]="云城区";
areas["76612"]="郁南县";
areas["76613"]="罗定市";
areas["76614"]="新兴县";
areas["76615"]="云安县";
}{if($2=="020" && ($3=="20"||$3=="755"||$3=="754")) {if($5~/,/){area="";split($5,tmp,",");for(t in tmp){key=tmp[t];area=area"&"areas[key];} area=substr(area,2);} else{area=areas[$5];} print $1"|"$4"|"area"|"$5;}}' | bzip2 > /home/oracle/etl/data/guangdong/month/fenkan/online/ZJYHJ_MMS_users_guangdong.txt.bz2

bzcat /home/oracle/etl/data/guangdong/month/fenkan/online/ZJYHJ_MMS_users_guangdong.txt.bz2 /data/match/orig/${DEALDATE}/snapshot.txt.bz2 | awk -F'|' '{if(NF==4){d[$1]=$3;}else if($8=="020" && $3=="06" && $2=="10511024" && $1 in d)print $1","$2","$3","$4",99991230000000,"$7","$11","d[$1]}' > /home/oracle/etl/data/guangdong/month/fenkan/online/ZJYHJ_MMS_users_guangdong_snapshot.txt

awk -F'[|,]' -v NODIST_DIR=/data/match/orig/profile/nodist.tsv -v OPTCODE_DIR=/home/oracle/etl/data/optcode.txt '{
if(FILENAME == NODIST_DIR && $5==200){split($0,tmp,"|");p=tmp[1];c=tmp[2];m=tmp[4];nodist[m]=p","c;}
else if(FILENAME == OPTCODE_DIR){if($1~/^W/) optcode[$3] = "违章业务,"$4","$5; else optcode[$3] = $7","$4","$5;}
else{nod=substr($1,1,7);if(nod in nodist){split(nodist[nod],nodtmp,",");province=nodtmp[1];city=nodtmp[2];
split(optcode[$2],opttmp,",");optcost=opttmp[1];jfcode=opttmp[2];fee=opttmp[3];
subtime=substr($4,1,4)"-"substr($4,5,2)"-"substr($4,7,2)" "substr($4,9,2)":"substr($4,11,2)":"substr($4,13,2);
endtime=substr($5,1,4)"-"substr($5,5,2)"-"substr($5,7,2)" "substr($5,9,2)":"substr($5,11,2)":"substr($5,13,2);
print $1","optcost","province","city","subtime","$7","endtime","jfcode","$2","fee","$8;}}
}' /data/match/orig/profile/nodist.tsv /home/oracle/etl/data/optcode.txt /home/oracle/etl/data/guangdong/month/fenkan/online/ZJYHJ_MMS_users_guangdong_snapshot.txt > /home/oracle/etl/data/guangdong/month/fenkan/online/ZJYHJ_MMS_users_guangdong_final.txt

##cat /home/oracle/etl/data/guangdong/month/fenkan/online/ZJYHJ_MMS_users_guangdong_final.txt | awk 'sub("$", "\r")' | awk -F',' '{d="/home/oracle/etl/data/guangdong/month/fenkan/online/ZJYHJ_MMS/optcost/"$NF".csv";print>>d;}'
cat /home/oracle/etl/data/guangdong/month/fenkan/online/ZJYHJ_MMS_users_guangdong_final.txt | awk 'sub("$", "\r")' | awk -F',' '{d="/home/oracle/etl/data/guangdong/month/fenkan/online/ZJYHJ_MMS/city/"$4".csv";print>>d;}'

##splitFiles /home/oracle/etl/data/guangdong/month/fenkan/online/ZJYHJ_MMS/optcost/
##splitFiles /home/oracle/etl/data/guangdong/month/fenkan/online/ZJYHJ_MMS/city/

##bzip2 /home/oracle/etl/data/guangdong/month/fenkan/online/ZJYHJ_MMS/optcost/*
bzip2 /home/oracle/etl/data/guangdong/month/fenkan/online/ZJYHJ_MMS/city/*



ftp -i -v -n 172.16.24.23 <<EOF
user g*n 1*r
binary
cd /month/fenkan/online/JKXGJ_SMS/
mkdir $DEALMONTH
cd $DEALMONTH
lcd /home/oracle/etl/data/guangdong/month/fenkan/online/JKXGJ_SMS/city/
mput *
EOF



ftp -i -v -n 172.16.24.23 <<EOF
user gdadmin 1234qwer
binary
cd /month/fenkan/online/ZJYHJ_MMS/
mkdir $DEALMONTH
cd $DEALMONTH
lcd /home/oracle/etl/data/guangdong/month/fenkan/online/ZJYHJ_MMS/city/
mput *
EOF

