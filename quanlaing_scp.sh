#/bin/sh
#----------------------
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/home/gateway/;
export PATH

---25上--
BEGINDATE=`date -v-1d "+%Y-%m-%d"`
#BEGINDATE="1990-01-01"
ENDDATE=`date "+%Y-%m-%d"`
##echo ${BEGINDATE}
##echo ${ENDDATE}

DEALDATE=`date -v-1d "+%Y%m%d"`
##echo ${DEALDATE}

RUNDATE=`date "+%Y%m%d"`

##创建目录

sudo -u shujuyzx scp /data/wxlog/${RUNDATE}_all_orderusers.txt.bz2 shujuyzx@172.200.5.31:/logs/shujuyzx/Inc/

#sudo -u shujuyzx scp /data/wxlog/shujuyzx/${RUNDATE}/Req_${DEALDATE}.inc.txt.bz2 shujuyzx@172.200.5.31:/logs/shujuyzx/Inc/Req_${DEALDATE}.inc.txt.bz2

