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
  	DEALDATE=`$v_work_dir/addday.php d $V_DATE -5`
		# 取文件目录
  	V_YEAR=$(echo $DEALDATE | cut -c 1-4)
 		V_DAY=$(echo $DEALDATE | cut -c 1-6)
		SOURCE_DIR=$AUTO_DATA_TARGET/$V_YEAR/$V_DAY
		CODE_FILE=$AUTO_DATA_NODIST/nodist_city.txt
		SOURCE_FILE_1=${SOURCE_DIR}[0-3][0-9]/shbb_agent_ci_subscribe.*.txt #取一个月的数据文件
		SOURCE_FILE_2=${SOURCE_DIR}"01"/shbb_ci_agent_meiti.txt #收费用户统计
		TARGET_DIR=$AUTO_DATA_REPORT/$V_YEAR/month_${V_DAY}
		RESULT_FILE_1=$TARGET_DIR/$$_tmp
		RESULT_FILE_2=$TARGET_DIR/$$_pay
		TARGET_File=$TARGET_DIR/report.region.agent_meiti_pay_province.csv
  	# 话务员推荐次数
		awk -F\| '{
  		print $1,$2,$5,$6
		}' $SOURCE_FILE_1|sort -u|
		awk '{ P[$3","$4]++
		}END{
		for(name in P){
			printf("%s,%d\n",name,P[name])
		}
		}' > $TARGET_DIR/$$_tmp
		#收费用户数部分
		awk -F\| '{
	 		print $1,$8,$9
		}' $SOURCE_FILE_2|sort -u|
		awk '{
			s[$2","$3]++
		}END{
			for(name in s){printf("%s,%d\n",name,s[name])}
		}' >$TARGET_DIR/$$_pay
		awk -F'[,|]' '{
		if(FILENAME=="'$CODE_FILE'")
		{
			provi[$4]=$1
		}
		else if(FILENAME=="'$RESULT_FILE_1'"){
		 proviname=length(provi[$1])>0?provi[$1]:"未知"
		 d[$1","proviname","$2]=$3
		 a[$1","proviname","$2]=1
		}
		else{
		 proviname=length(provi[$1])>0?provi[$1]:"未知"
		 p[$1","proviname","$2]=$3
		 a[$1","proviname","$2]=1
		}
		}END{
    	print "省编码,省份名称,工号,订制用户数,扣费用户数"
	 	for(name in a){
	 		printf("%s,%d,%d\n",name,d[name],p[name])
	 	}
	 }' $CODE_FILE $RESULT_FILE_1 $RESULT_FILE_2 >$TARGET_File
   trap "rm -f $TARGET_DIR/$$_tmp $TARGET_DIR/$$_pay" EXIT
	fi
