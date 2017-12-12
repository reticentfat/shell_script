#! /bin/sh
. /usr/local/app/dana/current/shbb/profile

usage () {
    echo "usage: $0 INDATE" 1>&2
    exit 2
}

if [ $# -lt 1 ] ; then
    usage
else
   INDATE=$1
fi

v_work_dir=$AUTO_WORK_BIN
v_work_log=$AUTO_WORK_LOG
v_sms_dir=/logs/out/dana/sms_send
v_nodist_dir=$AUTO_DATA_NODIST
#v_work_log=/home/zhuxp

if [ ${INDATE:=999} = 999 ];then
   DEALDATE=`date +%Y%m%d`
   DEALDATE=`$v_work_dir/addday.php d $DEALDATE -1`
else
   DEALDATE=$INDATE
fi

echo $DEALDATE

main()
{




   #check the daymsg everyday
   if [ -f $v_sms_dir/sms_ds_warn_${DEALDATE}.txt ];then
      $v_work_dir/sendsms.sh 1 $v_nodist_dir/phonelist.txt $v_sms_dir/sms_ds_warn_${DEALDATE}.txt
   else
      echo "sms_ds_warn_${DEALDATE}.txt not exist!"
   fi
   
}

main >> ${v_work_log}/sendsms_${DEALDATE}.log

 
