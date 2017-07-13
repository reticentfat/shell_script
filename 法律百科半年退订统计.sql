27上
bzcat /home/oracle/etl/data/data/snapshot/archives.txt.bz2 | awk -F'^' '$5=="FLBK_MMS"&&$8>="2017-01-01"&&$8<"2017-07-01" {print $2"|"$3"|"$7"|"$8"|"$(NF)}' | awk -F'|' '{print $1"|"$2"|"$3"|"$4"|"$(NF-2)}' >flbk_unsub.txt
awk -F'|' -v CODE_DIR=/home/oracle/etl/data/nodist.tsv '{ if(FILENAME==CODE_DIR) d[$4]=$1 ; else if((substr($1,1,7) in d) ) print $1"|"d[substr($1,1,7)]"|"$3"|"$4"|"$5;  }' /home/oracle/etl/data/nodist.tsv  flbk_unsub.txt | bzip2 > flbk_unsub_final.txt.bz2
下载来导入临时表
                           
LOAD DATA  INFILE 'C:\备份\F盘\work\flbk_unsub_final.txt' 
BADFILE 'C:\备份\F盘\work\dingzhi.txt.bad'
truncate INTO TABLE  jf_2
FIELDS TERMINATED BY '|' OPTIONALLY ENCLOSED BY '"' 
 TRAILING NULLCOLS
(    mobile,opt_code,opttime,subtime,job_num,province,serial,biz_code,city,cartype
 )
 ------------------
 select count(j.mobile),j.opt_code,j.job_num,
case 
when (to_date(substr(j.subtime,1,10),'yyyy-mm-dd')- to_date(substr(j.opttime,1,10),'yyyy-mm-dd') )<= 30 then
          '1个月以下'
         when (to_date(substr(j.subtime,1,10),'yyyy-mm-dd')- to_date(substr(j.opttime,1,10),'yyyy-mm-dd')) > 30 and
              (to_date(substr(j.subtime,1,10),'yyyy-mm-dd')- to_date(substr(j.opttime,1,10),'yyyy-mm-dd') )<= 90 then
          '1-3个月'
         when (to_date(substr(j.subtime,1,10),'yyyy-mm-dd')- to_date(substr(j.opttime,1,10),'yyyy-mm-dd'))> 90 and
              (to_date(substr(j.subtime,1,10),'yyyy-mm-dd')- to_date(substr(j.opttime,1,10),'yyyy-mm-dd') )<= 180 then
          '3-6个月'
          
          
           when (to_date(substr(j.subtime,1,10),'yyyy-mm-dd')- to_date(substr(j.opttime,1,10),'yyyy-mm-dd'))> 180 and
              (to_date(substr(j.subtime,1,10),'yyyy-mm-dd')- to_date(substr(j.opttime,1,10),'yyyy-mm-dd') )<= 360 then
              
          '6-12个月'
            when (to_date(substr(j.subtime,1,10),'yyyy-mm-dd')- to_date(substr(j.opttime,1,10),'yyyy-mm-dd'))> 360 and
              (to_date(substr(j.subtime,1,10),'yyyy-mm-dd')- to_date(substr(j.opttime,1,10),'yyyy-mm-dd') )<= 720 then
             
              
          '1年-2年'
            when (to_date(substr(j.subtime,1,10),'yyyy-mm-dd')- to_date(substr(j.opttime,1,10),'yyyy-mm-dd')) > 720 then
          '2年以上'
          end onlinetime
from jf_2 j
 where j.subtime < '2017-07-01'
   and j.subtime >= '2017-01-01'
   group by
   j.opt_code,j.job_num,
case 
when (to_date(substr(j.subtime,1,10),'yyyy-mm-dd')- to_date(substr(j.opttime,1,10),'yyyy-mm-dd') )<= 30 then
          '1个月以下'
         when (to_date(substr(j.subtime,1,10),'yyyy-mm-dd')- to_date(substr(j.opttime,1,10),'yyyy-mm-dd')) > 30 and
              (to_date(substr(j.subtime,1,10),'yyyy-mm-dd')- to_date(substr(j.opttime,1,10),'yyyy-mm-dd') )<= 90 then
          '1-3个月'
         when (to_date(substr(j.subtime,1,10),'yyyy-mm-dd')- to_date(substr(j.opttime,1,10),'yyyy-mm-dd'))> 90 and
              (to_date(substr(j.subtime,1,10),'yyyy-mm-dd')- to_date(substr(j.opttime,1,10),'yyyy-mm-dd') )<= 180 then
          '3-6个月'
          
          
           when (to_date(substr(j.subtime,1,10),'yyyy-mm-dd')- to_date(substr(j.opttime,1,10),'yyyy-mm-dd'))> 180 and
              (to_date(substr(j.subtime,1,10),'yyyy-mm-dd')- to_date(substr(j.opttime,1,10),'yyyy-mm-dd') )<= 360 then
               
          '6-12个月'
            when (to_date(substr(j.subtime,1,10),'yyyy-mm-dd')- to_date(substr(j.opttime,1,10),'yyyy-mm-dd'))> 360 and
              (to_date(substr(j.subtime,1,10),'yyyy-mm-dd')- to_date(substr(j.opttime,1,10),'yyyy-mm-dd') )<= 720 then
               
              
          '1年-2年'
            when (to_date(substr(j.subtime,1,10),'yyyy-mm-dd')- to_date(substr(j.opttime,1,10),'yyyy-mm-dd')) > 720 then
          '2年以上'
          end
