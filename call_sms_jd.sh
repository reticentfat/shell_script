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
   echo "Usage:call_sms.sh [phone flag][file flag][deal date]"
   exit
fi

v_work_dir=$AUTO_WORK_BIN
v_work_log=$AUTO_WORK_LOG
v_sms_dir=/logs/out/dana/sms_send

v_daytitle="12580业务运营综合日报"
v_weektitle="12580业务运营综合周报"
#报表链接存放文件
v_urlfile=$v_work_dir/urlfile.txt

if [ ${INDATE:=999} = 999 ];then
   DEALDATE=`date +%Y%m%d`
   DEALDATE=`$v_work_dir/addday.php d $DEALDATE -1`
else
   DEALDATE=$INDATE
fi

main()
{
DEALWEEK=`$v_work_dir/addday.php w $DEALDATE 0`
#7：30
if [ $FILEFLAG -eq 1 ];then
   #Monday check the weekmsg
   #check the daymsg everyday
   if [ -f $v_sms_dir/sms_msg_day7_${DEALDATE}.txt ];then
      $v_work_dir/sendsms.sh $TELFLAG $v_work_dir/phone_jd.txt $v_sms_dir/sms_msg_day7_${DEALDATE}.txt
      #$v_work_dir/sendmail.sh $TELFLAG $v_work_dir/phone.txt $v_sms_dir/sms_msg_day7_${DEALDATE}.txt $v_daytitle $v_urlfile
   else
      echo "sms_msg_day7_${DEALDATE}.txt not exist!"
   fi
   
#9：30
else
   #check the weekmsg on monday
   #check the daymsg everyday
   if [ -f $v_sms_dir/sms_msg_day_${DEALDATE}.txt ];then
      $v_work_dir/sendsms.sh $TELFLAG $v_work_dir/phone_jd.txt $v_sms_dir/sms_msg_day_${DEALDATE}.txt
    # $v_work_dir/sendmail.sh $TELFLAG $v_work_dir/phone.txt $v_sms_dir/sms_msg_day_${DEALDATE}.txt $v_daytitle $v_urlfile
   else
      echo "sms_msg_day_${DEALDATE}.txt not exist!"
   fi
fi
}

main >> ${v_work_log}/sendsms_${DEALDATE}.log

