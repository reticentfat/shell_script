DATE_FILE=`date +%Y%m`
FILE_NAME=guangdong_qianxiang_nco_bgn.$DATE_FILE.txt
DATE_DIR_FTP=`date +%Y-%m-04`
GDQX_DIR="/data/wuying/zhangfang/guangdong_qx"


ftp -v -n 218.206.87.169 << EOF
user guangdong 123
cd $DATE_DIR_FTP
lcd $GDQX_DIR
prompt
put $FILE_NAME
bye
EOF
