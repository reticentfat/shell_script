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

if [ $FILEFLAG -eq 1 ];then
   if [ -f $v_sms_dir/yhj_totals.zip ];then
      $v_work_dir/sendmms.sh $TELFLAG $v_work_dir/phone_fee_yhj.txt $v_sms_dir/yhj_totals.zip  
   else
      echo "yhj_totals.zip not exist"
   fi
fi


}

main >> ${v_work_log}/sendsms_${DEALDATE}.log