#/bin/sh

YT=`date -v-1d +%Y-%m-%d`
TODAY=`date +%Y-%m-%d`
YM=`date -v-2d +%Y%m`

echo `/usr/local/bin/mysqldump -ur_slave_db -pwzMIWdZ93n45d5NT WZCX_DB $YM_wzcx_msg fee_change wzcx_log wzcx_sub > /usr/local/www/cron/data/WZCX_DB.sql`


db="dbback"


echo "wireless_operation tables finish "

DEALDATE=`date +%Y%m%d%H`$db

if [ ! -d ./data/$DEALDATE ];then
mkdir -p ./data/$DEALDATE
fi

mv ./data/WZCX_DB.sql ./data/$DEALDATE/

cd data
tar czvf $DEALDATE.tar.gz $DEALDATE



echo "backup file $DEALDATE.tar.gz"

echo "del backup file"
rm -rf /usr/local/www/cron/data/$DEALDATE







