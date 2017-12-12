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

v_daytitle="12580ҵӪ"
v_weektitle="12580ҵӪ"
#

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
#PROV_STR="100|200|210|220|230|240|250|270|280|290|311|351|371|431|451|471|531|551|571|591|731|771|791|851|871|891|898|931|951|971|991"
#PROV_ID=`echo $PROV_STR |gawk 'BEGIN{RS="|"}{print $1}'`
#echo $PROV_STR | gawk 'BEGIN{RS="|"}{print $1}' |while read i
#do
#7

   if [ $FILEFLAG -eq 1 ];then
   #Monday check the weekmsg
   #if [ $DEALWEEK -eq 0 ];then
   #   STARTDAY=`$v_work_dir/addday.php d $DEALDATE -6`
   #   ENDDAY=$DEALDATE

     # if [ -f $v_sms_dir/sms_msg_week7_${STARTDAY}_${ENDDAY}.txt ];then
     #    $v_work_dir/sendsms.sh $TELFLAG $v_work_dir/phone.txt $v_sms_dir/sms_msg_week7_${STARTDAY}_${ENDDAY}.txt
          #    $v_work_dir/sendmail.sh $TELFLAG $v_work_dir/phone.txt $v_sms_dir/sms_msg_week7_${STARTDAY}_${ENDDAY}.txt $v_weektitle $v_urlfile
     # else
     #    echo "sms_msg_week7_${STARTDAY}_${ENDDAY}.txt not exist!"
     # fi
   #fi
   #sleep 30;
   #check the daymsg everyday
   if [ -f $v_sms_dir/1.zip ];then
      $v_work_dir/sendmms.sh $TELFLAG $v_work_dir/phone_mms1.txt $v_sms_dir/mms_msg${DEALDATE}.zip      #$v_work_dir/sendmail.sh $TELFLAG $v_work_dir/q1.txt $v_sms_dir/div_province_day7_${i}_${DEALDATE}.txt $v_daytitle $v_urlfile
    
   else
      echo "mms_msg${DEALDATE}.zip not exist"
   fi
#9

   else
   #check the daymsg everyday
     if [ -f $v_sms_dir/1.zip ];then
       $v_work_dir/sendmms.sh $TELFLAG $v_work_dir/phone_mmsqinghai.txt $v_sms_dir/mms_msg${DEALDATE}.zip
     else
       echo "mms_msg${DEALDATE}.zip not exist"
     fi
fi
#done

}

main >> ${v_work_log}/sendsms_${DEALDATE}.log
