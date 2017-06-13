---25上
bzcat /data/match/mm7/20170501/outputumessage_001_wuxian_20170501_snapshot.bz2 | head -5
11111111111|10301010|06|20110601094546|20110601094546|20110601094546|1|999|999||SUB_BOSS|||YYBK_SMS|10658880|20000000|||99990909235959|None
13007131391|10301139|06|20161224094506|20161224094506|20161224094506|1|027|27||SUB_ZUOXI|||sjyl10301139|1065888016||||99990909235959|1
13007131391|10511078|06|20161224105633|20161224105633|20161224105633|1|027|27||SUB_ZUOXI|||sjyl10511078|1065888016||||99990909235959|1
13016260568|10301023|06|20140802101352|20140802101352|20140802101352|1|0898|898||SUB_BOSS|||CP_06_SMS|10658880|81600000|||99990909235959|None
13035281900|10511078|06|20170115051247|20170115051247|20170115051247|1|027|719||SUB_ZUOXI|||sjyl10511078|1065888016||||99990909235959|1
bzcat /data/match/mm7/20170501/outputumessage_001_wuxian_20170501_snapshot.bz2 | awk -F'|' '$2=="10511051"&&$3=="06"&&$7=="1"{print $1"|"$8}' | bzip2 > 51_flbk.txt.bz2 

-------- bzcat 51_flbk.txt.bz2  /data/match/mm7/20170531/outputumessage_001_wuxian_20170531_snapshot.bz2 | awk -F'|' '{if(NF==2) aa[$1$2]=$1$2;else if(($1$8 in aa)&&$2=="10511051"&&$3=="06"&&$7=="0")  print aa[$1$8]}' | awk -F'|' '{print $2}' | sort  | uniq -c | sort -rn > flbk_result.txt
bzcat 51_flbk.txt.bz2  /data/match/mm7/20170531/outputumessage_001_wuxian_20170531_snapshot.bz2 | awk -F'|' '{if(NF==2) aa[$1]=$1;else if(($1 in aa)&&$2=="10511051"&&$3=="06"&&$7=="0")  print $1"|"$8}'  >flbk_tmp.txt
cat  flbk_tmp.txt  | awk -F'|' '{print $2}' | sort  | uniq -c | sort -rn > flbk_result.txt
---------匹配省份中文----------
/data/211/dictionary/region_gbk.txt
[gateway@wtraffic /data/211/dictionary]$ cat region_gbk.txt | head -5
0571	浙江省	570	衢州市 
0571	浙江省	571	杭州市
 cat /data/211/dictionary/region_gbk.txt flbk_result.txt | awk  '{if(NF==4) aa[$1]=$2;else if(($2 in aa))  print aa[$2],$1}' >flbk_result_region.txt
 ------然后匹配成功接受数量-----------
 cat flbk_tmp.txt | awk -F'|' '{print $1",10511051,"$2}' > flbk_tmp_1.txt 
 /data/match/mm7/20170531/stats_month.wuxian_qianxiang.1000
 
  awk -F',' -v CODE_DIR=/data/match/mm7/20170531/stats_month.wuxian_qianxiang.1000     '{
     if( FILENAME == CODE_DIR  )  d[$1$2]=$3 ;
         else if ( FILENAME != CODE_DIR && ($1$2 in d) ) print   $0","d[$1$2] ;      
        }'     /data/match/mm7/20170531/stats_month.wuxian_qianxiang.1000   flbk_tmp_1.txt > flbk_tmp_2.txt
      cat  flbk_tmp_2.txt  | awk -F',' '{print $3}' | sort  | uniq -c | sort -rn > flbk_result1.txt
       cat /data/211/dictionary/region_gbk.txt flbk_result1.txt | awk  '{if(NF==4) aa[$1]=$2;else if(($2 in aa))  print aa[$2],$1}' >flbk_result_region1.txt
       cat flbk_tmp_2.txt| awk '{if(NF!=1);FS=","; OFS=","; a[$3]+=$4 }  END { for (i in a)  {print i,a[i]}}'  > flbk_tmp_3.txt
