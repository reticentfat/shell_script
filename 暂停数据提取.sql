cat /data/wuying/4_y_cm.txt | awk -F',' '{print $1"\t"$2}' | sort | uniq -c > /home/wuying/20150422.txt
cat /home/wuying/20150422.txt | awk -F'[ ,]' '{if ($3>=10||($4>=3&&$4<10)) print  }' > /home/wuying/wy1.txt
/data/wuying/PKFILTER_DIC/nodist.tsv
云南|丽江|888|1846956|871|34060000|
awk -F'|' -v CODE_DIR=/data/wuying/PKFILTER_DIC/nodist.tsv '{if(FILENAME==CODE_DIR) d[$4]=$1 ; else if(FILENAME != CODE_DIR &&( substr($1,2,7) in d) ) print d[s
ubstr($1,2,7)];}' /data/wuying/PKFILTER_DIC/nodist.tsv /home/wuying/wy3.txt > /home/wuying/sf.txt
scp /data/wuying/guangdong_4442.txt newci@172.16.88.147:/usr/local/www/manage_sys/12580/sjyl_sjsj_url/url/
