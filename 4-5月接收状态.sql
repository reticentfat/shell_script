---25上
[gateway@wtraffic /data/match/cmpp/20160501]$ cat outputumessage_005_wuxian_20160501_cmpp.out | head -5
cat /data/match/mm7/201104*/*.out | grep 'wuxian_qianxiang' | awk -F',' '{
split($1,tmp,": "); split(tmp[2],time,"MMS"); sendtime=time[1];
split($34,tmp,": "); split(tmp[1],time,":"); recvtime=time[1]":"time[2]":"substr(time[3],1,2);
print $12"^"$15"^"$(NF-2)"^"sendtime"^"recvtime;}' | bzip2 > /home/chensm/QF_mm7_201104.txt.bz2
--May  1 00:00:13 192.100.6.7 Monster-CMPP20MT[88551]: 20160501000013SMS010201072100197ca46aaaa9ef4,0,1,000,010,28810,I,wuxian_qianxiang,1,1065888018,03,18318474882,1,18318474882,10201072,1,,,UMGSQHYDB,02,200,0,0,0,0,8,0501ab95b50e73aa5c725e5273e48f931aa6,0,5,0,901808,05010000090101005273,0,90,欢迎您使用中国移动的商情慧眼点播业务，资费2元/次，详询4006509590,200,758,May  1 00:00:14 192.100.6.3 Monster-CMPP20REPORT[29367]: 000000,05010000090101005273,0,CB:0007,18318474882,201605010000,201605010000
-- cat outputumessage_005_wuxian_20160501_cmpp.out | awk -F',' '{print $(NF-3),$(NF-2)}'
 --10511020
 --10511019
-- 20500110
 --cat /data/match/mm7/201605*/outputumessage_005_wuxian_*_cmpp.out | grep -e ',10511020,' -e ',10511019,' -e ',20500110,'    | awk -F',' '{ print $(NF-2)"^"$(NF-3)}'  > zhuangtai-5yue.txt
 cat /data/match/mm7/201605{01..31}/*.out | grep -e ',10511020,' -e ',10511019,' -e ',20500110,'    | awk -F',' '{ print $12"|"$(NF-2)}'  > zhuangtai-5yue.txt
 --/data/match/cmpp/20160501]$ cat /data/match/mm7/20160501/outputumessage_003_wuxian_20160501_mm7.out | head -5
$12, $(NF-2)
--- May  1 00:06:28 192.100.6.11 Monster-MM7MT[27416]: 20160501000627MMS2105110123111da5946be5f0eb8,1,1,,0311,,I,wuxian_qianxiang,2000,1065888060,03,15133522011,1,15133522011,10511012,1,,,125823,03,500,,0,0,15,15,050100062791005701172,1000,11,/mt.in/mms/asr/0501/0d/7f/b626e1eaf83055d65fe0361d77d7/resource,12580国学堂,311,335,May  1 00:06:39 192.100.6.5 Monster-Sandwich[48069]: 0pk160,050100062791005701172,-127,8615133522011,1065888060,Retrieved,1000,129,2016-05-01T00:06:22+08:00
 
 cat /data/match/cmpp/201605{01..31}/*.out | grep -e ',10324001,' -e ',10324002,' -e ',10324003,' -e ',10324004,' -e ',10324005,' -e ',10324006,' -e ',10324007,' -e ',10324008,' -e ',10301018,' -e ',10301019,' -e ',10301020,'  -e ',10301021,'  -e ',10301022,'  -e ',10301023,'  -e ',10301024,'  -e ',10301025,' -e ',10301034,'  -e ',10301035,'| awk -F',' '{ print $(NF-2)"|"$(NF-3)}'  > zhuangtai-5yue_duanxin.txt
 ---合并后排重
 cat zhuangtai-5yue.txt zhuangtai-5yue_duanxin.txt | sort -u >zhuangtai.txt
 ----匹配---
 awk -F'|' -v CODE_DIR=zhuangtai.txt     '{
     if( FILENAME == CODE_DIR  )  d[$1]=$2 ;
         else if ( FILENAME != CODE_DIR && ($1 in d) ) print   $1","d[$1] ;      
        }'     zhuangtai.txt  5yuehaoma.txt > 5yue_xiafazhuangtai.txt
