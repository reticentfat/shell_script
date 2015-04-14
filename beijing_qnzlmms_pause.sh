PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/home/wuying/;
export PATH


 
DATE_mm5=`date -v-3d  +%Y%m%d`
DATE_mm3=`date -v-5d  +%Y%m%d`
DATE_mm1=`date -v-7d  +%Y%m%d`
DATE_DAY=`date -v-1d  +%Y%m%d`
DATE_NAME=`date -v-0d  +%Y-%m-%d`
####这里可以根据$Z的值来按业务下发周期获取对应日期的下行日志文件彩信4441和4442用户提取 
###对应业务的APPCODE
 
QNZL=10511003
QNZL_BNB=10511039
 
##以下为营养百科彩信下发周期为周1周3周5 为例子，其他业务类同
 
   cat /data/match/mm7/${DATE_mm1}/*wuxian*.out |   grep  ','${QNZL}',' | awk -F','   '{ if($(NF-2) == "4441" && $5== '010' ) print $12","$15","$(NF-2)  }'  > /data/wuying/bj_4441/mm7_${QNZL}4441_1_3.txt
   cat /data/match/mm7/${DATE_mm3}/*wuxian*.out |   grep  ','${QNZL}','  | awk -F','   '{ if($(NF-2) == "4441" && $5== '010' ) print $12","$15","$(NF-2)  }'  >> /data/wuying/bj_4441/mm7_${QNZL}4441_1_3.txt
   
   cat /data/match/mm7/${DATE_mm3}/*wuxian*.out |   grep  ','${QNZL}','  | awk -F','   '{ if($(NF-2) == "4441" && $5== '010' ) print $12","$15","$(NF-2)  }'  > /data/wuying/bj_4441/mm7_${QNZL}4441_3_5.txt
   cat /data/match/mm7/${DATE_mm5}/*wuxian*.out |   grep ','${QNZL}','   | awk -F','   '{ if($(NF-2) == "4441" && $5== '010' ) print $12","$15","$(NF-2)  }'  >> /data/wuying/bj_4441/mm7_${QNZL}4441_3_5.txt


   cat /data/match/mm7/${DATE_mm1}/*wuxian*.out |   grep ','${QNZL_BNB}',' | awk -F','   '{ if($(NF-2) == "4441" && $5== '010' ) print $12","$15","$(NF-2)  }'  > /data/wuying/bj_4441/mm7_${QNZL_BNB}4441_1_3.txt
   cat /data/match/mm7/${DATE_mm3}/*wuxian*.out |   grep ','${QNZL_BNB}',' | awk -F','   '{ if($(NF-2) == "4441" && $5== '010' ) print $12","$15","$(NF-2)  }'  >> /data/wuying/bj_4441/mm7_${QNZL_BNB}4441_1_3.txt
   cat /data/match/mm7/${DATE_mm3}/*wuxian*.out |   grep ','${QNZL_BNB}',' | awk -F','   '{ if($(NF-2) == "4441" && $5== '010' ) print $12","$15","$(NF-2)  }'  > /data/wuying/bj_4441/mm7_${QNZL_BNB}4441_3_5.txt
   cat /data/match/mm7/${DATE_mm5}/*wuxian*.out |   grep ','${QNZL_BNB}',' | awk -F','   '{ if($(NF-2) == "4441" && $5== '010' ) print $12","$15","$(NF-2)  }'  >> /data/wuying/bj_4441/mm7_${QNZL_BNB}4441_3_5.txt

####提取三日内重复号码

cat /data/wuying/bj_4441/mm7_${QNZL}4441_1_3.txt | sort | uniq -c | awk '{if($1>=2) print $2","$1}'  > /data/wuying/bj_4441/mm7_${QNZL}4441_1_3_ok.txt
cat /data/wuying/bj_4441/mm7_${QNZL}4441_3_5.txt | sort | uniq -c | awk '{if($1>=2) print $2","$1}'  > /data/wuying/bj_4441/mm7_${QNZL}4441_3_5_ok.txt

cat /data/wuying/bj_4441/mm7_${QNZL_BNB}4441_1_3.txt | sort | uniq -c | awk '{if($1>=2) print $2","$1}'  > /data/wuying/bj_4441/mm7_${QNZL_BNB}4441_1_3_ok.txt
cat /data/wuying/bj_4441/mm7_${QNZL_BNB}4441_3_5.txt | sort | uniq -c | awk '{if($1>=2) print $2","$1}'  > /data/wuying/bj_4441/mm7_${QNZL_BNB}4441_3_5_ok.txt

###生成暂停
 
cat /data/wuying/bj_4441/mm7_${QNZL}4441_1_3_ok.txt  /data/wuying/bj_4441/mm7_${QNZL}4441_3_5_ok.txt  /data/wuying/bj_4441/mm7_${QNZL_BNB}4441_1_3_ok.txt  /data/wuying/bj_4441/mm7_${QNZL_BNB}4441_3_5_ok.txt  | awk -F',' '{ print "http://gweb.intra.umessage.com.cn:8888/pause?id="$1"&servcode=QNZL_MMS&reason=3" }' | sort -u | bzip2 >  /data/wuying/bj_4441/mm7_${DATE_DAY}_pause_url.txt.bz2
cp /data/wuying/bj_4441/mm7_${DATE_DAY}_pause_url.txt.bz2 /home/wuying/public_html/bj_4441/
bzcat /data/wuying/bj_4441/mm7_${DATE_DAY}_pause_url.txt.bz2  >  /home/wuying/bin/neimeng_dzyhjpk_update/mm7_bj_pause_url_${DATE_NAME}.txt
 
