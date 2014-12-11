-------分为两个部分先取1月到11月订购且在线的用户,导出为浙江法律百科.txt----------
select mobile_sn 手机号码,
  m.province 省份,
  m.city 城市,
                    case
                      when n.mobile_sub_state = 3 then
                       '订购中'
                      else
                       '已退定'
                    end  "订购状态",
                    to_char(n.mobile_sub_time, 'yyyy-mm-dd hh24:mi:ss') 订购时间,
                    to_char(n.mobile_modify_time, 'yyyy-mm-dd hh24:mi:ss') 退订时间,
                    o.opt_cost 业务名称
               from new_wireless_subscription n, opt_code o,mobilenodist m
              where n.appcode = o.appcode
                and n.appcode = '10301079'
                and substr(n.mobile_sn, 1, 7) = m.beginno
                 and m.province = '浙江'
                 and n.mobile_sub_state=3
                  and n.mobile_sub_time >= to_date('2014-01-01', 'yyyy-mm-dd')
                  and n.mobile_sub_time < to_date('2014-12-01', 'yyyy-mm-dd')
                  ----------------下边取4月1日至今订购的退订用户---------
158上crontab上写为
19 09 11  12 *  bzcat /home/oracle/etl/data/data/snapshot/archives.txt.bz2 | awk -F'[|^]' '{if($6=="10301079"&&$(NF-11)>="20140101000000"&&$(NF-11)<="20141201000000"&&$3=="0571") print   $2","$3","$4","$6","$5","$7","$8","$(NF-2)","$(NF-3)","$(NF-4) }' | bzip2 > /home/oracle/flbk_14yxz_cancle.txt.bz2

下载到本地后用cygwin处理步骤如下
cat flbk_14yxz_cancle.txt | awk -F',' '{print $1",浙江,"$3",已退定,"$6","$7","$5;}'  > 1.txt
awk -F'[,]' -v CODE_DIR=nodist_yaoyi.txt '{ if(FILENAME==CODE_DIR) d[$4]=$2; else if( substr($1,1,7) in d)  print $1"\t"$2"\t"d[substr($1,1,7)]"\t"$4"\t"$5"\t"$6"\t"$7}'   nodist_yaoyi.txt 1.txt > 2.txt
sed -i 's/FLBK_MMS/12580生活播报-法律百科彩信版/g;s/FLZS_SMS/12580生活播报-法律百科短信版/g;' 2.txt
-----------------合并两个文件-----------------
cat 浙江法律百科.txt 2.txt >浙江法律百科_ok.txt |  unix2dos -o 浙江法律百科_ok.txt
--------------------然后排重取同一号码最后一条信息---------------------
ctl文件
LOAD DATA  INFILE 'F:\work\浙江法律百科_ok.txt' 
BADFILE 'F:\work\dingzhi1.txt.bad'
truncate INTO TABLE mobile.jf_1 
FIELDS TERMINATED BY '	' OPTIONALLY ENCLOSED BY '"' 
 TRAILING NULLCOLS
( mobile,province,cartype,job_num,opttime,subtime,biz_code,opt_code,serial
 )
 select j.mobile 手机号码,
       j.province 省份,
       j.cartype 城市,
       j.job_num 订购状态,
       
       to_char(max(to_date(j.opttime, 'yyyy-mm-dd hh24:mi:ss')),
               'yyyy-mm-dd hh24:mi:ss') 开通时间,
       to_char(max(to_date(j.subtime, 'yyyy-mm-dd hh24:mi:ss')),
               'yyyy-mm-dd hh24:mi:ss') 退订时间,
       j.biz_code 业务名称 
  from jf_1 j
  group by j.mobile,j.province,j.cartype,j.job_num,j.biz_code
