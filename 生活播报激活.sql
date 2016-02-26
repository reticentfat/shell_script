---27上
cd /data/match/orig/20160224
bzcat snapshot.txt.bz2 | awk -F'|' '$2~/^2/&&$3==06&&$7==0&&(toupper(substr($20,1,4))!="BOSS" ){print $1"|"$14}' >0226.txt
---统计数量
cat 0226.txt | awk -F'|' '{print $2}' | sort | uniq -c | sort -rn | awk '{print $2"|"$1}'>result.txt
---拼写周五激活字符串------------
http://192.100.6.247:8888/activate?id=13654715558&servcode=CFZZ
cat 0226.txt | awk -F'|' '$2=="MZONE"||$2=="WEXPO"||$2=="CTX"||$2=="CFZZ"{ print "http://192.100.6.247:8888/activate?id="$1"&servcode="$2;}' >0226_jihuo.txt
传到25上/data/www/sjyl_sjsj_url
scp  0226_jihuo.txt gateway@192.100.7.25:/data/www/sjyl_sjsj_url/url/
crontab如下
20 16 26 02 * /usr/local/bin/php /data/www/sjyl_sjsj_url/url.php 0226_jihuo 2>&1
----------生活播报业务需要匹配三个月下发--
  scp  gateway@192.100.7.25:/data/match/mm7/20160225/stats_month.bizdev_shenghbb.1000  /data/homeoracle/20160225_stats_month.bizdev_shenghbb.1000
       
     cat 20160225_stats_month.bizdev_shenghbb.1000 20160131_stats_month.bizdev_shenghbb.1000 20151231_stats_month.bizdev_shenghbb.1000 >shenghbb_all.1000
  cat /data/match/orig/20160224/0226.txt | awk -F'|' '$2=="SHBB"{print $1","$2}' > /data/homeoracle/shbb_1.txt
  awk -F',' -v CODE_DIR=shenghbb_all.1000     '{
     if( FILENAME == CODE_DIR  )  d[$1]=$1 ;
         else if ( FILENAME != CODE_DIR && ($1 in d) ) print   $1 ;      
        }'     shenghbb_all.1000  shbb_1.txt > shbb_2.txt
cat 0226.txt | awk -F'|' '$2=="NRZNEW"||$2=="SHJLB"||$2=="ZSHK"||$2=="YYHK"{ print "http://192.100.6.247:8888/activate?id="$1"&servcode="$2;}' >0227_jihuo1.txt
cat 0226.txt | awk -F'|' '$2=="YZLX"||$2=="DCNEW"{ print "http://192.100.6.247:8888/activate?id="$1"&servcode="$2;}' >0229_jihuo1.txt
cat shbb_2.txt  | awk -F'|' '{ print "http://192.100.6.247:8888/activate?id="$1"&servcode=SHBB";}' >shbb_jihuo.txt
然后按照310000，500000,207052拆分
sed -n 1,310000p shbb_jihuo.txt>shbb_jihuo_0227.txt
sed -n 310001,810000p shbb_jihuo.txt>shbb_jihuo_0228.txt
sed -n 810001,1017052p shbb_jihuo.txt>shbb_jihuo_0229.txt
然后合并文件
cat shbb_jihuo_0227.txt 0227_jihuo1.txt > 0227_jihuo.txt
cat shbb_jihuo_0229.txt 0229_jihuo1.txt > 0229_jihuo.txt
scp  0227_jihuo.txt 0229_jihuo.txt shbb_jihuo_0228.txt gateway@192.100.7.25:/data/www/sjyl_sjsj_url/url/
cat 0226_jihuo.log  |grep  '\"errcode\"\: \"12\"' >1.txt
