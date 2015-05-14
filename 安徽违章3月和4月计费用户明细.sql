--158上操作
cat /data0/2015/20150331/qiangxiang_smswz_pay_users.txt  | grep ',551,' | awk -F',' '{if($2=="10301028")print }' > /home/oracle/anhui_3y_wz.txt
awk -F',' -v CODE_DIR=/data0/match/orig/mm7/20150331/stats_month.wuxian_qianxiang.0 -v fileok=/home/oracle/anhui_3y_wz_ok.txt -v fileno=/home/oracle/anhui_3y_wz_0.txt '{
if( FILENAME == CODE_DIR&& $3>=2 ) d[$1$2]=$1","$2","$3; 
else if ( FILENAME != CODE_DIR && substr($2,1,3) == "103" && $1$2 in d ) print >> fileok ; 
else if ( FILENAME != CODE_DIR && substr($2,1,3) == "103" && !($1$2 in d )) print >> fileno ; 
}' /data0/match/orig/mm7/20150331/stats_month.wuxian_qianxiang.0 /home/oracle/anhui_3y_wz.txt
------------------------------------------------
cat /data0/2015/20150430/qiangxiang_smswz_pay_users.txt  | grep ',551,' | awk -F',' '{if($2=="10301028")print }' > /home/oracle/anhui_4y_wz.txt
awk -F',' -v CODE_DIR=/data0/match/orig/mm7/20150430/stats_month.wuxian_qianxiang.0 -v fileok=/home/oracle/anhui_4y_wz_ok.txt -v fileno=/home/oracle/anhui_4y_wz_0.txt '{
if( FILENAME == CODE_DIR&& $3>=2 ) d[$1$2]=$1","$2","$3; 
else if ( FILENAME != CODE_DIR && substr($2,1,3) == "103" && $1$2 in d ) print >> fileok ; 
else if ( FILENAME != CODE_DIR && substr($2,1,3) == "103" && !($1$2 in d )) print >> fileno ; 
}' /data0/match/orig/mm7/20150430/stats_month.wuxian_qianxiang.0 /home/oracle/anhui_4y_wz.txt
