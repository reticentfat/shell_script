#/bin/sh
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:
export PATH

   INDATE_h=$2
   INDATE_23h=$3
fi

if [ ${INDATE:=999} = 999 ];then

  DEALDATE=`date -v-1H  +%Y%m%d`
  DEALDATE_23d=`date -v-1d  +%Y%m%d`
else

  DEALDATE=$INDATE

fi
if [ ${INDATE_h:=999} = 999 ];then

  DEALDATE_H=`date -v-1H  +%Y%m%d%H`
  DEALDATE_23H=`date -v-1H  +%H`
else

  DEALDATE_H=$INDATE_h
  DEALDATE_23H=$INDATE_23h
fi


scp /logs/archives/monster/${DEALDATE}/monster-mm7*${DEALDATE_H}*.bz2 /logs/archives/monster/${DEALDATE}/monster-cmpp-report.*${DEALDATE_H}* /logs/archives/monster/${DEALDATE}/mon
ster-cmppmt*${DEALDATE_H}*  gateway@192.100.7.25:/data/monster/${DEALDATE}/

if [ ${DEALDATE_23H} -eq 23 ];then

scp /logs/archives/monster/${DEALDATE_23d}/monster-mm7*${DEALDATE_H}*.bz2 /logs/archives/monster/${DEALDATE_23d}/monster-cmpp-report.*${DEALDATE_H}*.bz2 /logs/archives/monster/${D
EALDATE_23d}/monster-cmppmt*${DEALDATE_H}* gateway@192.100.7.25:/data/monster/${DEALDATE_23d}/
