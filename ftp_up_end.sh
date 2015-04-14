DATE_FILE=`date +%Y%m`
FILE_NAME=guangdong_qianxiang_nco_end.$DATE_FILE.txt
DATE_DIR_FTP=`date +%Y-%m-24`
GDQX_DIR="/data/wuying/zhangfang/guangdong_qx"


ftp -v -n 218.206.87.169 << EOF
user guangdong gmcc888
cd $DATE_DIR_FTP
lcd $GDQX_DIR
prompt
put $FILE_NAME
bye
EOF
