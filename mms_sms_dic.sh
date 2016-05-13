oracle@wreport:/home/oracle$ cat /home/oracle/etl/bin/mms_sms_dic.sh
#/bin/sh
# --------------------                              --------------------
# ||||||||||||||||||||   END CONFIGURATION SECTION  ||||||||||||||||||||

export PATH=/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/data/app/oracle/product/11.2.0/db/bin/
export ORACLE_HOME=/data/app/oracle/product/11.2.0/db

export ORACLE_SID=wreportdb
ORACLE_NLS=$ORACLE_HOME/nls/data ;
export ORACLE_NLS
NLS_LANG="simplified chinese"_china.ZHS16CGB231280 ;
export NLS_LANG
export NLS_LANG
 curl   http://192.100.7.9:8806/12580/bill/api.php/index/online_province_all | awk '{gsub(/},/,"\n"); print }' | awk '{gsub(/"/,"");print}' | awk '{gsub(/{/,"");print }' | awk '{gsub(/}]/,"");print }' | awk '{gsub(/\[/,"");print}'  | awk -F'[:,]' '{print $2","$4","$6","$8","$10 }' > /home/oracle/etl/data/data/mms_sms_dic.txt

scp /home/oracle/etl/data/data/mms_sms_dic.txt gateway@192.100.7.25:/data/211/PKFILTER_DIC/
