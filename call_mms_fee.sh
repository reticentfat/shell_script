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


if [ ${INDATE:=999} = 999 ];then
   DEALDATE=`date +%Y%m%d`
   DEALDATE=`$v_work_dir/addday.php d $DEALDATE -1`
else
   DEALDATE=$INDATE
fi

main()
{
DEALWEEK=`$v_work_dir/addday.php w $DEALDATE 0`
echo $DEALDATE

if [ $FILEFLAG -eq 1 ];then
   if [ -f $v_sms_dir/totals.zip ];then
     # $v_work_dir/sendmms_fee.sh $TELFLAG $v_work_dir/phone_fee.txt $v_sms_dir/fee.zip     #$v_work_dir/sendmail.sh $TELFLAG $v_work_dir/q1.txt $v_sms_dir/div_province_day7_${i}_${DEALDATE}.txt $v_daytitle $v_urlfile
      $v_work_dir/sendmms.sh $TELFLAG $v_work_dir/phone_fee.txt $v_sms_dir/totals.zip  
   else
      echo "1.zip not exist"
   fi
#else
   #check the daymms_msg everyday
#     if [ -f $v_sms_dir/1.zip ];then
#       $v_work_dir/sendmms_pro.sh $TELFLAG $v_work_dir/phone_mms.txt $v_sms_dir/1.zip
#     else
#       echo "1.zip not exist"
#     fi
fi
#done

}

main >> ${v_work_log}/sendsms_${DEALDATE}.log

