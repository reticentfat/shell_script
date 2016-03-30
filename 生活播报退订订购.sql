LOAD DATA  INFILE 'F:\work\wy.txt' 
BADFILE 'F:\work\dingzhi.txt.bad'
truncate INTO TABLE  jf_1
FIELDS TERMINATED BY '|' OPTIONALLY ENCLOSED BY '"' 
 TRAILING NULLCOLS
( mobile,opt_code,cartype,subtime,opttime,serial,job_num,biz_code
 )
 字段如下
 18752702280|22200030
 拼写如下---
 http://192.100.6.33:8888/cancel?id=18851512166&servcode=SHBB&longcode=1065888098&command=QX98&channel1=CMCC&channel2=QX98TONGBU&channel3=CMCC
 select  'http://192.100.6.33:8888/cancel?id='||j.mobile||chr(38)||'servcode='||o.servcode||chr(38)||'longcode=1065888098'||chr(38)||'command=QX'||substr(n.mobile_sub_cmd,1,2)||chr(38)||'channel1=CMCC'||chr(38)||'channel2=QX'||substr(n.mobile_sub_cmd,1,2)||'TONGBU'||chr(38)||'channel3=CMCC'
  from new_wireless_subscription_shbb n, jf_1 j, opt_code o
 where n.appcode = o.appcode
   and n.mobile_sn = j.mobile
   and j.opt_code = n.appcode
   and n.mobile_sub_state = '3'
   and n.servcode='SHBB'
   union all
   select  'http://192.100.6.33:8888/cancel?id='||j.mobile||chr(38)||'servcode='||o.servcode||chr(38)||'longcode=1065888098'||chr(38)||'command='||o.unsub_cmd||chr(38)||'channel1=CMCC'||chr(38)||'channel2='||o.unsub_cmd||'TONGBU'||chr(38)||'channel3=CMCC'
  from new_wireless_subscription_shbb n, jf_1 j, opt_code o
 where n.appcode = o.appcode
   and n.mobile_sn = j.mobile
   and j.opt_code = n.appcode
   and n.mobile_sub_state = '3'
   and n.servcode!='SHBB'
   -------------------------------------然后退订成功的再订购------------------
   cat shbb_td_0329.log | grep 'true' | awk -F'[=&]' '{print $2"|"$4}' >/home/gateway/shbb_147033.txt
   http://192.100.6.33:8888/subscribe?id=18851512166&servcode=SHBB&appcode=22200030&subcodes=CFSH,QCHDT,SWSH,FCH,GWZFT,PZXK,JKSH,PZSHB&longcode=10658880&command=98FREEBOSS&channel1=BOSS&channel2=ITEM&channel3=BOSS&optime=20110730170720                 
   cp /data/match/mm7/20160309/outputumessage_001_meiti_20160309_snapshot.bz2 /home/gateway/
   awk -F'|' -v CODE_DIR=shbb_147033.txt     '{
     if( FILENAME == CODE_DIR  )  d[$1$2]=$1 ;
         else if ( FILENAME != CODE_DIR && ($1$14 in d)&&($3=="06") ) {print   "http://192.100.6.33:8888/subscribe?id="$1"&servcode="$14"&appcode="$2"&subcodes="$10"&longcode="$15"&command="$16"&channel1="$11"&channel2="$12"&channel3="$13"&optime="$4 ;}      
        }'     shbb_147033.txt  outputumessage_001_meiti_20160309_snapshot.txt > shbb_dinggou_0329.txt
        cat shbb_dinggou_0329.txt | head -3
        awk -F'|' -v CODE_DIR=shbb_147033.txt     '{
     if( FILENAME == CODE_DIR  )  d[$1$2]=$1 ;
         else if ( FILENAME != CODE_DIR && ($1$14 in d)&&($7=="0")&&($3=="06") ) {print "http://192.100.6.247:8888/pause?id="$1"&servcode="$14"&reason="$20; }      
        }'     shbb_147033.txt  outputumessage_001_meiti_20160309_snapshot.txt > shbb_zanting_0329.txt
