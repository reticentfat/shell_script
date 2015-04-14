DATE_FILE=`date +%Y%m`
FILE_NAME=guangdong_qianxiang_nco_end.$DATE_FILE.txt
DATE_DIR_FTP=`date +%Y-%m-24`
GDQX_DIR="/data/wuying/zhangfang/guangdong_qx"


ftp -v -n 218.206.87.169 << EOF
user guangdong gmcc888
cd $DATE_DIR_FTP
lcd $GDQX_DIR 
#lcd [ directory ] 更改 local host 的工作目录
prompt 
#更改交谈模式，若为 on 则在 mput 与 mget 时每做一个文件传输时均会询问
put $FILE_NAME
#将 local host 的文件送到 remote host
bye
EOF
