---27上
bzcat /home/oracle/etl/data/data/snapshot/archives.txt.bz2 | awk -F'[|^]' '{if( $3=="028" && ($6=="10301013" || $6=="10511008") ) print   $2","$4","$5","$7","$8","$(NF-2) }'  > /home/oracle/sichuan_DYJLB_cancle.txt
-------下载到本地，匹配省份和业务名称-------------------
sed -i 's/DYJLB_MMS/电影俱乐部彩信版/g;s/DYJLB_SMS/电影俱乐部短信版/g' sichuan_DYJLB_cancle.txt
awk -F'[\t,]' -v CODE_DIR=nodist_umgstat.txt '{ if(FILENAME==CODE_DIR) d[$4]=$2 ; else if((substr($1,1,7) in d) ) print $1","d[substr($1,1,7)]","$3","$4","$5","$6;  }' nodist_umgstat.txt  sichuan_DYJLB_cancle.txt>sichuan_DYJLB_cancle_result.txt
