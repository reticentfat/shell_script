#!/bin/sh

LOGROOT="/logs"
DIR=$1
LOGNAME=$2
PID="rsyslogd.pid"
PRD=$3
DATE=`date -v-1H \+%Y%m%d`
STARTTIME=`date -v-1H \+%Y%m%d%H`00

kill -HUP `cat /var/run/${PID}`

if [ ! -d ${LOGROOT}/archives/${DIR}/${DATE} ]
then
        mkdir -p ${LOGROOT}/archives/${DIR}/${DATE}
        chmod 775 ${LOGROOT}/archives/${DIR}/${DATE}
fi

if [ "${PRD}" = "DAY" ]
then
 	SUFFIX=${DATE}
elif [ "${PRD}" = "HOUR" ]
then
	SUFFIX=${STARTTIME}
else
	SUFFIX=${DATE}
fi

(
bzip2 ${LOGROOT}/${DIR}/${LOGNAME}.0 && \
cp ${LOGROOT}/${DIR}/${LOGNAME}.0.bz2 ${LOGROOT}/${DIR}/${LOGNAME}.${SUFFIX}.bz2 && \
mv ${LOGROOT}/${DIR}/${LOGNAME}.${SUFFIX}.bz2 ${LOGROOT}/archives/${DIR}/${DATE}/
) &
