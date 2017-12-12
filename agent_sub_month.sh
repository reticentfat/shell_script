#!/bin/sh
. /usr/local/app/dana/current/shbb/profile
#. /home/shihy/bin/shbb_20090423/profile
	usage () {
    echo "usage: $0  target_dir" 1>&2
    exit 2
	}
	v_work_dir=$AUTO_WORK_BIN
  if [ $# -lt 1 ] ; then
     usage
  fi
	V_DATE=$1
	day=$(echo $V_DATE | cut -c 7-8)
	if [ $day = '04' ];then
		DEALDATE=`$v_work_dir/addday.php d $V_DATE -4`
		# 取文件目录
  	V_YEAR=$(echo $DEALDATE | cut -c 1-4)
 		V_DAY=$(echo $DEALDATE | cut -c 1-6)
		SOURCE_DIR=$AUTO_DATA_REPORT/$V_YEAR/$V_DAY
		TARGET_DIR=$AUTO_DATA_REPORT/$V_YEAR/month_${V_DAY}
		a=$(ls ${SOURCE_DIR}*/wireless.recommend.${V_DAY}*.csv|wc -l)
		b=$(ls ${SOURCE_DIR}*/report.region.search_telist_province.csv|wc -l)
 		c=$(echo $DEALDATE | cut -c 7-8)
 		if [ $a -ne $c -o $b -ne $c ];then
      exit 2
 		fi
		result_file=$TARGET_DIR/report.region.agent_sub_market_province.csv
		wire_filename=$TARGET_DIR/wire.txt
		ci_filename=$TARGET_DIR/ci.txt
		cat ${SOURCE_DIR}*/wireless.recommend.${V_DAY}*.csv|sed 's/[ \t  ]//g'|tr -d '[:blank:]'> $wire_filename
		cat ${SOURCE_DIR}*/report.region.search_telist_province.csv > $ci_filename
		shbb_filename=$TARGET_DIR/report.region.agent_meiti_pay_province.csv
		codefile=$AUTO_DATA_NODIST/nodist_city.txt
	awk -F'[|,]' '{
	if(FILENAME=="'$codefile'")
	{
		d[$4]=$4","$1
	}
	else if(FILENAME=="'$wire_filename'")
	{
		provi=length(d[$2])>0?d[$2]:"000,未知"
		indexstr=provi","$4
		w_1[indexstr]+=$5
		w_2[indexstr]+=$6
		p[indexstr]=1
	}
	else if(FILENAME=="'$ci_filename'")
	{
		provi=length(d[$2])>0?d[$2]:"000,未知"
		indexstr=provi","$1
		c_1[indexstr]+=$3
		c_2[indexstr]+=$4
		c_3[indexstr]+=$5
		c_4[indexstr]+=$6
		c_5[indexstr]+=$7
		p[indexstr]=1
	}
	else if(FILENAME=="'$shbb_filename'")
	{
		provi=length(d[$1])>0?d[$1]:"000,未知"
		indexstr=provi","$3
		s_1[indexstr]+=$4
		s_2[indexstr]+=$5
		p[indexstr]=1
	}
}END{
  title="省编码,省名称,工号,信息查询次数,单次查询次数,优先推荐(CI),查询转接(CI),优惠券(CI),推荐次数(生活播报),成功订制数(生活播报),推荐次数(前向),成功订制数(前向),积分值"
  print title
	for(name in p)
	{
		if(!(name in w)){w[name]="0,0"}
		if(!(name in c)){c[name]="0,0,0,0,0"}
		if(!(name in s)){s[name]="0,0"}
		aa=c_3[name]*5+c_4[name]*3+c_5[name]*2+s_1[name]*3+s_2[name]*3+w_1[name]*3+w_2[name]*3
		printf("%s,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\n",name,c_1[name],c_2[name],c_3[name],c_4[name],c_5[name],s_1[name],s_2[name],w_1[name],w_2[name],aa)
	}
}' $codefile $wire_filename $ci_filename $shbb_filename >$result_file
 	ERROR=$?
  rm -f $wire_filename $ci_filename
fi
exit $ERROR

