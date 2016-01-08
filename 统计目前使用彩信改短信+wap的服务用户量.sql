25上cd /home/gateway/data
wget -N "http://192.100.6.31:9999/data/dump/HSH_05_MMS/users.txt.bz2" -O HSH_05_MMS.txt.bz2
wget -N "http://192.100.6.31:9999/data/dump/HSH_MMS/users.txt.bz2" -O HSH_MMS.txt.bz2
wget -N "http://192.100.6.31:9999/data/dump/QNZL_MMS/users.txt.bz2" -O QNZL_MMS.txt.bz2
wget -N "http://192.100.6.31:9999/data/dump/YYBK_MMS/users.txt.bz2" -O YYBK_MMS.txt.bz2
wget -N "http://192.100.6.31:9999/data/dump/YYBS_MMS/users.txt.bz2" -O YYBS_MMS.txt.bz2
wget -N "http://192.100.6.31:9999/data/dump/QCBD_MMS/users.txt.bz2" -O QCBD_MMS.txt.bz2
wget -N "http://192.100.6.31:9999/data/dump/FCTC_MMS/users.txt.bz2" -O FCTC_MMS.txt.bz2
wget -N "http://192.100.6.31:9999/data/dump/TCTC_MMS/users.txt.bz2" -O TCTC_MMS.txt.bz2
wget -N "http://192.100.6.31:9999/data/dump/SZXT_MMS/users.txt.bz2" -O SZXT_MMS.txt.bz2
wget -N "http://192.100.6.31:9999/data/dump/FLBK_MMS/users.txt.bz2" -O FLBK_MMS.txt.bz2
bzcat *.txt.bz2 >all.txt
cat all.txt | grep 'jf_on' | awk '{print $4}' | sort |uniq -c | sort -rn | awk '{print $2","$1}'>result.txt
