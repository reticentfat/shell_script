#!/bin/sh
. /usr/local/app/dana/current/shbb/profile

if [ $# -eq 1 ] ; then
    V_DATE=$1
else
    echo "Usage:$0 "
    exit 1
fi

V_YEAR=$(echo $V_DATE | cut -c 1-4)
WEEKNUM=$(date -v-0d -j ${V_DATE}0000 +%w)
[ $WEEKNUM -ne 2 ] && exit 
END_DATE=$(date -v-0d -j $V_DATE"0000" +%Y%m%d)
BEGIN_DATE=$(date -v-6d -j $V_DATE"0000" +%Y%m%d)

#路径
ORIG_DIR=$AUTO_SRC_DATA
REPORT_DIR=/logs/out/dana/report/$V_YEAR/week_${BEGIN_DATE}_${END_DATE}
CODE_DIR=$AUTO_DATA_NODIST

#字典
REGION_NODIST=$CODE_DIR/nodist.tsv
PRODUCT_NODIST=$CODE_DIR/qx_appcode_new.txt
#数据文件
DATA_FILE=$ORIG_DIR/$END_DATE/data/snapshot/snapshot.txt.bz2
#结果文件
REPORT_FILE=$REPORT_DIR/qianxiang_report_pause_subcribe_city.csv

#判断数据文件与字典文件是否存在 
if [ ! -f "$DATA_FILE" ];then 
    echo "快照文件不存在"
    exit 1
fi
if [ ! -f "$PRODUCT_NODIST" ];then 
    echo "字典文件不存在"
    exit 1
fi
if [ ! -f "$REPORT_DIR/email.report.region.qianxiang_subscribe_city.csv" ];then 
    echo "前向业务月报结果文件不存在"
    exit 1
fi
#title="省编码,省名称,市编码,市名称,计费代码,业务主类,业务名称,业务类型,业务资费,暂停用户数,72小时即订即退用户数"
pbunzip2 -d -p4 -c $DATA_FILE | gawk -F\| 'BEGIN{
    while(getline var < "'$REGION_NODIST'" ){
        split(var,a,"|")
        #号段表,省编码,省名称,市编码,市名称
        phoneNum[a[4]]=a[5]","a[1]","a[3]","a[2]
    }
    while(getline svar < "'$PRODUCT_NODIST'" ){
        split(svar,b,"|")
        #业务主类,业务名称,业务类型,业务资费
        product[b[3]]=b[8]","b[2]","b[4]","b[6]
    }

}
function detail(phone,product_num){
    #区域维度
    if(substr(phone,1,8) in  phoneNum){
        add=phoneNum[substr(phone,1,8)]
    }else if(substr(phone,1,7) in phoneNum){
        add=phoneNum[substr(phone,1,7)]
    }else{
        add="000,未知,000,未知"
    }
    #业务类型
    if(product_num in product){
        addProduct=product_num","product[product_num]
    }
    #区域维度+业务类型
    detail_type=add","addProduct
    return detail_type
}
{
    phone=$1
    product_num=$2
    subscribe_status=$3
    pause_status=$7
    option_time=$4      #订退时间取决于订购状态
    first_time=$5
	if( product_num in product){
		product_type=detail(phone,product_num)
		#暂停用户：
		if(pause_status==0 && subscribe_status==06){
			pause_user[product_type]++
		}
		#本月开通72小时退订用户
		#退订时间
		yy=substr(option_time,1,4);mm=substr(option_time,5,2);dd=substr(option_time,7,2);hh=substr(option_time,9,2) ;Mi=substr(option_time,11,2); ss=substr(option_time,13,2)
		s=yy" "mm" "dd" "hh" "Mi" "ss
		d=mktime(s)
		#本月首次订购时间
		yy=substr(first_time,1,4);mm=substr(first_time,5,2);dd=substr(first_time,7,2);hh=substr(first_time,9,2) ;Mi=substr(first_time,11,2); ss=substr(first_time,13,2)
		s=yy" "mm" "dd" "hh" "Mi" "ss
		e=mktime(s)
		#时间差=退订时间-上一次订购时间
		if( substr(option_time,1,8)>="'$BEGIN_DATE'"&& substr(option_time,1,8)<="'$END_DATE'" && subscribe_status=="07" && (d-e)<=259200){
			subscribe_pause[product_type]++
		}
		relate_data[product_type]=1
	}
}END{
    for(i in relate_data){
        print i","pause_user[i]","subscribe_pause[i]
    }

}'  >$REPORT_DIR/email_tmp_one

#将暂停用户数,本月开通72小时内退订用户数与前向订购报表整合

#判断所需文件是否存在
if [ ! -f "$REPORT_DIR/email_tmp_one" ];then 
    echo "暂停指标结果文件不存在"
    exit 1
fi

echo "省编码,省名称,市编码,市名称,业务主类,业务名称,业务类型,业务资费,前向包月订购用户数,订购用户数,点播用户数,退订用户数,付费用户数,上周新增包月用户数,上周新增留存用户数,本周留存包月用户数,上周包月用户数,本周留存点播用户数,上周点播用户数,四川业务类型,四川业务名称,四川业务资费,暂停用户数,本周开通72小时退订用户数" > $REPORT_FILE
 
awk -F\, '{
    if(FILENAME=="'$REPORT_DIR/'email_tmp_one"){
        a[$1","$3","$2","$4","$6","$7","$8","$9]=$10","$11
    }else{
        if( $1","$2","$3","$4","$5","$6","$7","$8 in a){
            print $0","a[$1","$2","$3","$4","$5","$6","$7","$8]
        }else{
            print $0",0,0"
        }
    }
}' $REPORT_DIR/email_tmp_one $REPORT_DIR/email.report.region.qianxiang_subscribe_city.csv |awk -F\, '$1!="省编码"{print}'>>$REPORT_FILE

#rm -rf $REPORT_DIR/email_tmp_one
