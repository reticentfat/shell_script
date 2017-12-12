#! /bin/sh

. /usr/local/app/dana/current/shbb/profile

if [ $# -eq 2 ];then
   TELFLAG=$1
   FILEFLAG=$2
elif [ $# -eq 3 ];then
   TELFLAG=$1
   FILEFLAG=$2
   INDATE=$3
else
   echo "Usage:call_sms_proc.sh [phone flag][file flag][deal date]"
   exit
fi

v_work_dir=$AUTO_WORK_BIN
v_work_log=$AUTO_WORK_LOG
v_sms_dir=/logs/out/dana/sms_send
v_daytitle="12580ÒµÎñÔËÓª×ÛºÏÈÕ±¨"
v_weektitle="12580ÒµÎñÔËÓª×ÛºÏÖÜ±¨"

v_urlfile=$v_work_dir/urlfile.txt

if [ ${INDATE:=999} = 999 ];then
   DEALDATE=`date +%Y%m%d`
   DEALDATE=`$v_work_dir/addday.php d $DEALDATE -1`
   DEALYEAR=$(echo $DEALDATE | cut -c 1-4)
else
   DEALDATE=$INDATE
   DEALYEAR=$(echo $DEALDATE | cut -c 1-4)
fi
main()
{
data_file=$AUTO_DATA_TARGET/$DEALYEAR/$DEALDATE/wap_pachong_tmp.txt
[ ! -f $data_file  ] && exit 0
get_week()
{
  ##给星期赋值中文名
  DEALMON=`echo $v_date|cut -c 5-6`
  DEALDAY=`echo $v_date|cut -c 7-8`

  DEALWEEK=`$v_work_dir/addday.php w $DEALDATE 0`
  case "$DEALWEEK" in
  "1")
  weekname="星期一";;
  "2")
  weekname="星期二";;
  "3")
  weekname="星期三";;
  "4")
  weekname="星期四";;
  "5")
  weekname="星期五";;
  "6")
  weekname="星期六";;
  "0")
  weekname="星期日";;
  esac
}
get_week
echo "${DEALDATE},${weekname}，wap自有业务查询量相关指标如下:" >$v_sms_dir/wap_pachong_jk_${DEALDATE}.txt.bak
cat $data_file|awk '{b+=$1;ia=$3;}END{print "wap查询总量:"ia",wap预设爬虫量:"b",wap剩余查询量:"ia-b}' >>$v_sms_dir/wap_pachong_jk_${DEALDATE}.txt.bak
cat $v_sms_dir/wap_pachong_jk_${DEALDATE}.txt.bak|piconv -f utf8 -t  gbk >$v_sms_dir/wap_pachong_jk_${DEALDATE}.txt 
rm $v_sms_dir/wap_pachong_jk_${DEALDATE}.txt.bak
if [ $FILEFLAG -eq 1 ];then

   if [ -f $v_sms_dir/wap_pachong_jk_${DEALDATE}.txt ];then
      python /usr/local/app/dana/current/shbb/compression_wap.py ${DEALDATE} 
      $v_work_dir/sendmms.sh $TELFLAG $v_work_dir/phone_wap.txt $v_sms_dir/wap_pachong_jk_${DEALDATE}.zip
    
   else
      echo "sms_msg_day_new_${DEALDATE}.zip not exist"
   fi
fi

}

main >> ${v_work_log}/sendsms_${DEALDATE}.log

