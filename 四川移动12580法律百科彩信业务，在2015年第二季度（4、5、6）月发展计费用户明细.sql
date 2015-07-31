cat /data0/2015/20150430/qiangxiang_mms_pay_users.txt  | grep ',280,' | awk -F',' '{if($2=="10511051")print  $1"|"$6}' > /home/oracle/sc_4y_flbkcai.txt
cat /data0/2015/20150531/qiangxiang_mms_pay_users.txt  | grep ',280,' | awk -F',' '{if($2=="10511051")print  $1"|"$6}' > /home/oracle/sc_5y_flbkcai.txt
cat /data0/2015/20150630/qiangxiang_mms_pay_users.txt  | grep ',280,' | awk -F',' '{if($2=="10511051")print  $1"|"$6}'  > /home/oracle/sc_6y_flbkcai.txt
cat sc_4y_flbkcai.txt sc_5y_flbkcai.txt sc_6y_flbkcai.txt | sort -u >sc_flbkcai.txt
导入jf_1
LOAD DATA  INFILE 'F:\work\sc_flbkcai.txt' 
BADFILE 'F:\work\dingzhi.txt.bad'
truncate INTO TABLE  jf_1
FIELDS TERMINATED BY '|' OPTIONALLY ENCLOSED BY '"' 
 TRAILING NULLCOLS
( mobile,job_num,province,opt_code,opttime,biz_code,serial,subtime,city,cartype
 )
 --------然后写sql--------
  select  j.mobile 用户号码,
 j.JOB_NUM ,
       to_char(n.mobile_sub_time, 'yyyy-mm-dd hh24:mi:ss') 订购时间，
      to_char(n.mobile_modify_time, 'yyyy-mm-dd hh24:mi:ss') 退订时间
       
     
  from jf_1 j , new_wireless_subscription n
where  j.mobile = n.mobile_sn
 and n.appcode='10511051'
 and n.mobile_sub_state='3'
