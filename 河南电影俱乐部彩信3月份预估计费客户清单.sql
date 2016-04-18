---27上
cat /data/2016/20160331/qiangxiang_mms_pay_users.txt | awk -F',' '$2=="10511008"&&$5=="371"{print  $1","$2}' >3yue_henan_DYJLB_MMS_pay_users.txt
----匹配下行，有一条下行就可以计费-------------------
awk -F',' -v CODE_DIR=/data/match/orig/mm7/20160331/stats_month.wuxian_qianxiang.1000     '{
     if( FILENAME == CODE_DIR  )  d[$1$2]=$1 ;
         else if ( FILENAME != CODE_DIR && ($1$2 in d) ) print   $1"|"$2 ;      
        }'     /data/match/orig/mm7/20160331/stats_month.wuxian_qianxiang.1000  3yue_henan_DYJLB_MMS_pay_users.txt > 3yue_henan_DYJLB_MMS_pay_users_final.txt
     
        ---------------------------导入到jf_1----------------
        13403730035|10511008
        LOAD DATA  INFILE 'F:\work\hubei_yhj_0324_3.txt' 
BADFILE 'F:\work\dingzhi.txt.bad'
truncate INTO TABLE  jf_1
FIELDS TERMINATED BY '|' OPTIONALLY ENCLOSED BY '"' 
 TRAILING NULLCOLS
(   mobile,opt_code,cartype,subtime,opttime,serial,job_num,biz_code
 )
-----------------------三月的匹配信息--------------------------
select n.mobile_sn 号码, 
m.city 所属地市,
     to_char(n.mobile_sub_time, 'yyyy-mm-dd hh24:mi:ss') 订购时间,
     to_char(n.mobile_modify_time, 'yyyy-mm-dd hh24:mi:ss') 退订时间
  from jf_1 j, new_wireless_subscription n, mobilenodist m
 where j.mobile = n.mobile_sn
   and j.opt_code = n.appcode
   and substr(n.mobile_sn, 1, 7) = m.beginno
