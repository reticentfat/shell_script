12580生活播报-法律百科短信版 10301079
惠生活彩信 10511052
12580惠生活彩信5元 10511055
oracle@wreport:/data/2015$ bzcat /data/match/orig/20150228/snapshot.txt.bz2 | awk -F'|' '{print $8}' | sort | uniq -c
1892390 010
7351377 020
5917363 021
 427677 022
 442274 023
 605396 024
5248673 025
 942212 027
2394373 028
 807018 029
 499950 0311
 581772 0351
3361416 0371
2247696 0431
  94417 0451
1494364 0471
2428458 0531
 431688 0551
3213540 0571
1000513 0591
 238727 0731
 574484 0771
 672820 0791
 543836 0851
 519827 0871
 140384 0891
 133346 0898
 149110 0931
 673654 0951
 163922 0971
 154458 0991
  10064 999
  ---------------------------
/data/match/orig/20150131/snapshot.txt.bz2
/data/match/orig/20150228/snapshot.txt.bz2
/data/match/orig/20150331/snapshot.txt.bz2
---27上
--------1月新增计费用户留存-----------
cat /data/2015/20150131/qiangxiang_mms_pay_users.txt | awk -F',' '$2=="10511051"&&$5=="200"{print  $1"|"$2}'|bzip2 >1yue_gd_FLBK_MMS_pay_users.txt.bz2
bzcat /data/2015/1yue_gd_FLBK_MMS_pay_users.txt.bz2  /data/match/orig/20150131/snapshot.txt.bz2  | awk -F'|' -v first_date='20141229000000' -v last_date='20150201000000' '{if(NF==2) aa[$1$2]=$1"|"$2;else if($5>= first_date&&($1$2 in aa)&&$5 <last_date)  print aa[$1$2]"|"$3"|"$5"|"$4"|"$8}' | bzip2 > flbk_1yue_gd.txt.bz2
----------------匹配2月留存-----------------
bzcat /data/match/orig/20150131/snapshot.txt.bz2 flbk_1yue_gd.txt.bz2  | awk -F'|' '{if((NF==20)&&$2=="10511051"&&$8=="020"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > flbk_1yue_gd_1yuexinzeng2liucun.txt.bz2
bzcat /data/match/orig/20150228/snapshot.txt.bz2 flbk_1yue_gd_1yuexinzeng2liucun.txt.bz2  | awk -F'|' '{if((NF==20)&&$2=="10511051"&&$8=="020"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > flbk_1yue_gd_1yuexinzeng3liucun.txt.bz2
bzcat /data/match/orig/20150331/snapshot.txt.bz2 flbk_1yue_gd_1yuexinzeng3liucun.txt.bz2  | awk -F'|' '{if((NF==20)&&$2=="10511051"&&$8=="020"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > flbk_1yue_gd_1yuexinzeng4liucun.txt.bz2
bzcat /data/match/orig/20150430/snapshot.txt.bz2 flbk_1yue_gd_1yuexinzeng4liucun.txt.bz2  | awk -F'|' '{if((NF==20)&&$2=="10511051"&&$8=="020"&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > flbk_1yue_gd_1yuexinzeng5liucun.txt.bz2
       ------------------------------------------------
       cat /data/2015/20150131/qiangxiang_mms_pay_users.txt | awk -F',' '($2=="10511051"||$2=="10511055"||$2=="10511052")&&($5=="200"||$5=="571"||$5=="731"||$5=="311"||$5=="100"){print  $1"|"$2}'>1yue_pay_users.txt.bz2
     #  bzcat /data/2015/1yue_pay_users.txt.bz2  /data/match/orig/20150131/snapshot.txt.bz2  | awk -F'|' -v first_date='20141229000000' -v last_date='20150201000000' '{if(NF==2) aa[$1$2]=$1"|"$2;else if($5>= first_date&&($1$2 in aa)&&$5 <last_date)  print aa[$1$2]"|"$3"|"$5"|"$4"|"$8}' | bzip2 > flbk_1yue.txt.bz2
       ---法律百科短信--
       cat /data/2015/20150131/qiangxiang_sms_pay_users.txt  | awk -F',' '$2=="10301079"&&($5=="200"||$5=="571"||$5=="731"){print  }' >  /home/oracle/flbkduan_1yue.txt
awk -F',' -v CODE_DIR=/data/match/orig/mm7/20150131/stats_month.wuxian_qianxiang.0 -v fileok=/home/oracle/flbkduan_1yue_ok.txt -v fileno=/home/oracle/flbkduan_1yue_0.txt '{
if( FILENAME == CODE_DIR && $3>=2) d[$1$2]=$1","$2","$3; 
else if ( FILENAME != CODE_DIR && substr($2,1,3) == "103" && $1$2 in d ) print >> fileok ; 
else if ( FILENAME != CODE_DIR && substr($2,1,3) == "103" && !($1$2 in d )) print >> fileno ; 
}' /data/match/orig/mm7/20150131/stats_month.wuxian_qianxiang.0 /home/oracle/flbkduan_1yue.txt
cat /home/oracle/flbkduan_1yue.txt | awk -F',' '{print $1"|"$2}' >flbkduan_1yue.txt
bunzip2 1yue_pay_users.txt.bz2
cat 1yue_pay_users.txt flbkduan_1yue.txt| bzip2>1yue_pay_users_all.txt.bz2
bzcat /data/2015/1yue_pay_users_all.txt.bz2  /data/match/orig/20150131/snapshot.txt.bz2  | awk -F'|' -v first_date='20141229000000' -v last_date='20150201000000' '{if(NF==2) aa[$1$2]=$1"|"$2;else if($5>= first_date&&($1$2 in aa)&&$5 <last_date)  print aa[$1$2]"|"$3"|"$5"|"$4"|"$8}' | bzip2 > 1yue_all.txt.bz2
------------留存情况------------
bzcat /data/match/orig/20150131/snapshot.txt.bz2 1yue_all.txt.bz2  | awk -F'|' '{if((NF==20)&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > 1yuexinzeng2liucun.txt.bz2
bzcat /data/match/orig/20150228/snapshot.txt.bz2 1yuexinzeng2liucun.txt.bz2  | awk -F'|' '{if((NF==20)&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > 1yuexinzeng3liucun.txt.bz2
bzcat /data/match/orig/20150331/snapshot.txt.bz2 1yuexinzeng3liucun.txt.bz2 | awk -F'|' '{if((NF==20)&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > 1yuexinzeng4liucun.txt.bz2
bzcat /data/match/orig/20150430/snapshot.txt.bz2 1yuexinzeng4liucun.txt.bz2  | awk -F'|' '{if((NF==20)&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > 1yuexinzeng5liucun.txt.bz2
bzcat /data/match/orig/20150531/snapshot.txt.bz2 1yuexinzeng5liucun.txt.bz2  | awk -F'|' '{if((NF==20)&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > 1yuexinzeng6liucun.txt.bz2
bzcat /data/match/orig/20150630/snapshot.txt.bz2 1yuexinzeng6liucun.txt.bz2  | awk -F'|' '{if((NF==20)&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > 1yuexinzeng7liucun.txt.bz2
bzcat /data/match/orig/20150731/snapshot.txt.bz2 1yuexinzeng7liucun.txt.bz2  | awk -F'|' '{if((NF==20)&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > 1yuexinzeng8liucun.txt.bz2
bzcat /data/match/orig/20150831/snapshot.txt.bz2 1yuexinzeng8liucun.txt.bz2  | awk -F'|' '{if((NF==20)&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > 1yuexinzeng9liucun.txt.bz2
bzcat /data/match/orig/20150930/snapshot.txt.bz2 1yuexinzeng9liucun.txt.bz2  | awk -F'|' '{if((NF==20)&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > 1yuexinzeng10liucun.txt.bz2
bzcat /data/match/orig/20151031/snapshot.txt.bz2 1yuexinzeng10liucun.txt.bz2  | awk -F'|' '{if((NF==20)&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > 1yuexinzeng11liucun.txt.bz2
bzcat /data/match/orig/20151130/snapshot.txt.bz2 1yuexinzeng11liucun.txt.bz2  | awk -F'|' '{if((NF==20)&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > 1yuexinzeng12liucun.txt.bz2
oracle@wreport:/data/2015$ bzcat /data/match/orig/20150131/snapshot.txt.bz2 1yue_all.txt.bz2  | awk -F'|' '{if((NF==20)&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > 1yuexinzeng2liucun.txt.bz2
oracle@wreport:/data/2015$ bzcat 1yuexinzeng2liucun.txt.bz2 | awk -F'|' '{print $2"|"$6}' |sort |uniq -c | sort -rn
--------------------4月-------------------------
cat /data/2015/20150430/qiangxiang_mms_pay_users.txt | awk -F',' '($2=="10511051"||$2=="10511055"||$2=="10511052")&&($5=="200"||$5=="571"||$5=="731"||$5=="311"||$5=="100"){print  $1"|"$2}'>4yue_pay_users.txt
     #  bzcat /data/2015/1yue_pay_users.txt.bz2  /data/match/orig/20150131/snapshot.txt.bz2  | awk -F'|' -v first_date='20141229000000' -v last_date='20150201000000' '{if(NF==2) aa[$1$2]=$1"|"$2;else if($5>= first_date&&($1$2 in aa)&&$5 <last_date)  print aa[$1$2]"|"$3"|"$5"|"$4"|"$8}' | bzip2 > flbk_1yue.txt.bz2
       ---法律百科短信--
       cat /data/2015/20150430/qiangxiang_sms_pay_users.txt  | awk -F',' '$2=="10301079"&&($5=="200"||$5=="571"||$5=="731"){print  }' >  /home/oracle/flbkduan_4yue.txt
awk -F',' -v CODE_DIR=/data/match/orig/mm7/20150430/stats_month.wuxian_qianxiang.0 -v fileok=/home/oracle/flbkduan_4yue_ok.txt -v fileno=/home/oracle/flbkduan_4yue_0.txt '{
if( FILENAME == CODE_DIR && $3>=2) d[$1$2]=$1","$2","$3; 
else if ( FILENAME != CODE_DIR && substr($2,1,3) == "103" && $1$2 in d ) print >> fileok ; 
else if ( FILENAME != CODE_DIR && substr($2,1,3) == "103" && !($1$2 in d )) print >> fileno ; 
}' /data/match/orig/mm7/20150430/stats_month.wuxian_qianxiang.0 /home/oracle/flbkduan_4yue.txt
cat /home/oracle/flbkduan_4yue.txt | awk -F',' '{print $1"|"$2}' >flbkduan_4yue.txt
cat 4yue_pay_users.txt flbkduan_4yue.txt| bzip2>4yue_pay_users_all.txt.bz2
bzcat /data/2015/4yue_pay_users_all.txt.bz2  /data/match/orig/20150430/snapshot.txt.bz2  | awk -F'|' -v first_date='20150329000000' -v last_date='20150501000000' '{if(NF==2) aa[$1$2]=$1"|"$2;else if($5>= first_date&&($1$2 in aa)&&$5 <last_date)  print aa[$1$2]"|"$3"|"$5"|"$4"|"$8}' | bzip2 > 4yue_all.txt.bz2
bzcat 4yue_all.txt.bz2 | awk -F'|' '{print $2"|"$6}' |sort |uniq -c | sort -rn
------------留存情况------------
bzcat /data/match/orig/20150430/snapshot.txt.bz2 4yue_all.txt.bz2  | awk -F'|' '{if((NF==20)&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > 4yuexinzeng5liucun.txt.bz2
bzcat /data/match/orig/20150531/snapshot.txt.bz2 4yuexinzeng5liucun.txt.bz2  | awk -F'|' '{if((NF==20)&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > 4yuexinzeng6liucun.txt.bz2
bzcat /data/match/orig/20150630/snapshot.txt.bz2 4yuexinzeng6liucun.txt.bz2 | awk -F'|' '{if((NF==20)&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > 4yuexinzeng7liucun.txt.bz2
bzcat /data/match/orig/20150731/snapshot.txt.bz2 4yuexinzeng7liucun.txt.bz2 | awk -F'|' '{if((NF==20)&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > 4yuexinzeng8liucun.txt.bz2
bzcat /data/match/orig/20150831/snapshot.txt.bz2 4yuexinzeng8liucun.txt.bz2 | awk -F'|' '{if((NF==20)&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > 4yuexinzeng9liucun.txt.bz2
bzcat /data/match/orig/20150930/snapshot.txt.bz2 4yuexinzeng9liucun.txt.bz2 | awk -F'|' '{if((NF==20)&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > 4yuexinzeng10liucun.txt.bz2
bzcat /data/match/orig/20151031/snapshot.txt.bz2 4yuexinzeng10liucun.txt.bz2 | awk -F'|' '{if((NF==20)&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > 4yuexinzeng11liucun.txt.bz2
bzcat /data/match/orig/20151130/snapshot.txt.bz2 4yuexinzeng11liucun.txt.bz2 | awk -F'|' '{if((NF==20)&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > 4yuexinzeng12liucun.txt.bz2
bzcat /data/match/orig/20151231/snapshot.txt.bz2 4yuexinzeng12liucun.txt.bz2 | awk -F'|' '{if((NF==20)&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > 4yuexinzeng1liucun.txt.bz2
bzcat /data/match/orig/20160131/snapshot.txt.bz2 4yuexinzeng1liucun.txt.bz2 | awk -F'|' '{if((NF==20)&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > 4yuexinzeng2liucun.txt.bz2
bzcat /data/match/orig/20160229/snapshot.txt.bz2 4yuexinzeng2liucun.txt.bz2 | awk -F'|' '{if((NF==20)&&$3=="06") aa[$1$2]=$1$2;else if(($1$2 in aa))  print }' | bzip2 > 4yuexinzeng3liucun.txt.bz2
