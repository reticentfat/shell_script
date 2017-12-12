#! /bin/sh
. /usr/local/app/dana/current/shbb/profile
'''
下发12580全网日报脚本，改造日期：2017年3月13日
'''

if [ $# -eq 2 ];then
   TELFLAG=$1
   FILEFLAG=$2
elif [ $# -eq 3 ];then
   TELFLAG=$1
   FILEFLAG=$2
   INDATE=$3
else
   echo "Usage:call_wireless_mms_fee [phone flag][file flag][deal date]"
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

data_file=${v_sms_dir}/wireless_smsday_new_${DEALDATE}.txt

main()
{
echo $(date "+%Y-%m-%d %H:%M:%S")'执行call_wireless_mms_fee.sh'

if [ $FILEFLAG -eq 1 ];then
   if [ ! -f "$data_file" ];then
      sh -x /usr/local/app/dana/current/ETL/gen_sms_fee_new.sh ${DEALDATE}
   fi
  
   if [ -f $data_file ];then
      #echo "$TELFLAG $v_work_dir/phone_test.txt ${data_file}"
      $v_work_dir/sendsms.sh $TELFLAG $v_work_dir/phone_test.txt ${data_file}

   else

      echo ${data_file}" not exist"

   fi

fi
}

main >> ${v_work_log}/sendsms_${DEALDATE}.log

