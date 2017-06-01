outputumessage_001_meiti_20170530_snapshot.bz2
bzcat /data/match/mm7/20170530/outputumessage_001_meiti_20170530_snapshot.bz2   num1.txt.bz2  | awk -F'|' '{if(NF==20) aa[$1$14]=$NF;else if(($1$2 in aa)&&$7=="1")  print $1"|"$2"|"aa[$1$2]}' | bzip2 > num_result.txt.bz2
[gateway@wtraffic /data/www/sjyl_sjsj_url/log]$ cat shbb_jihuo_0529.log  jihuo_0531b.log | grep 'true' | grep '2017-05'| awk -F'[=&]' '{print $2"|"$4}' | sort -u |awk -F'|' '{print $1"|"$2"|"}' > ~/num1.txt
bzcat /data/match/mm7/20170530/outputumessage_001_meiti_20170530_snapshot.bz2   num1.txt.bz2  | awk -F'|' '{if(NF==20) aa[$1$14]=$NF;else if(($1$2 in aa)&&$7=="1")  print $1"|"$2"|"aa[$1$2]}' | bzip2 > num_result1.txt.bz2
bzcat num_result1.txt.bz2 | awk -F'|' '{print $3}' | sort |uniq -c | sort -rn
gateway@wtraffic ~]$ bzcat num_result1.txt.bz2 | awk -F'|' 'length($3)==0{print $0}' | bzip2 > num2.txt.bz2
[gateway@wtraffic ~]$ bzcat num_result1.txt.bz2 | awk -F'|' 'length($3)>0{print $0}' | bzip2 > result1.txt.bz2
bzcat /data/match/mm7/20170529/outputumessage_001_meiti_20170529_snapshot.bz2   num2.txt.bz2  | awk -F'|' '{if(NF==20) aa[$1$14]=$NF;else if($1$2 in aa)  print $1"|"$2"|"aa[$1$2]}' | bzip2 > num_result_tmp_2.txt.bz2
13880127703|22200030|06|20130212112336|20130212112336|20130212112336|0|028|28|GWZFT,JKSH,PZSHB,SWSH,QCHDT,CFSH,FCH,PZXK|BOSS|ITEM|BOSS|SHBB|10658880|98FREEBOSS|||99990909235959|cmyh
------------以下正式开始-------
[gateway@wtraffic /data/www/sjyl_sjsj_url/log]$ cat shbb_jihuo_0529.log  jihuo_0531b.log | grep 'true' | grep '2017-05'| awk -F'[=&]' '{print $2"|"$4}' | sort -u |awk -F'|' '{print $1"|"$2"|"}' > ~/num1.txt
bzcat /data/match/mm7/20170530/outputumessage_001_meiti_20170530_snapshot.bz2   num1.txt.bz2  | awk -F'|' '{if((NF==20)&&$7=="1") aa[$1$14]=$NF;else if($1$2 in aa)  print $1"|"$2"|"aa[$1$2]}' | bzip2 > num_result.txt.bz2
bzcat num_result.txt.bz2 | awk -F'|' '{print $3}' | sort |uniq -c | sort -rn
bzcat num_result.txt.bz2 | awk -F'|' 'length($3)>0{print $0}' | bzip2 > result1.txt.bz2
bzcat result1.txt.bz2 num_result_tmp_2.txt.bz2 >resultall.txt.bz2
----拼写暂停串----

bzcat resultall.txt.bz2 | awk -F'|' '{ print "http://192.100.6.247:8888/pause?id="$1"&servcode="$2"&reason="$3;}' >/data/www/sjyl_sjsj_url/url/shbb_zanting_0531.txt
