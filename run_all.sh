#! /bin/sh

. /usr/local/app/dana/current/shbb/profile 

if [ $# -eq 1 ];then
   STARTDATE=$1
elif [ $# -eq 2 ];then
   STARTDATE=$1
   ENDDATE=$2
fi

v_work_dir=$AUTO_WORK_BIN

if [ ${STARTDATE:=999} = 999 ];then
   TODAY=`date +%Y%m%d`
   STARTDATE=`$v_work_dir/addday.php d $TODAY -1`
fi

if [ ${ENDDATE:=999} = 999 ];then
   ENDDATE=$STARTDATE
   STARTDATE=`$v_work_dir/addday.php d $ENDDATE -2`
fi

TEMPDATE=$STARTDATE

while [ $TEMPDATE -le $ENDDATE ]
do
   echo "Start to run run_all.sh $TEMPDATE on `date`"
   $v_work_dir/run_shbb.sh $TEMPDATE

   TEMPDATE=`$v_work_dir/addday.php d $TEMPDATE 1`
done
