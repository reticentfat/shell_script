select n.mobile_sn 新增号码,
      m.province 省份,
       m.city 所属地市,
       to_char(n.mobile_sub_time, 'yyyy-mm-dd hh24:mi:ss') 新增时间,
       to_char(n.mobile_modify_time, 'yyyy-mm-dd hh24:mi:ss') 退订时间,
       o.opt_cost 业务类型
  from new_wireless_subscription n, opt_code o, mobilenodist m
 where n.appcode = o.appcode
   and substr(n.mobile_sn, 1, 7) = m.beginno
   and n.mobile_sub_time >= to_date('2015-06-01', 'yyyy-mm-dd')
   and n.mobile_sub_time < to_date('2015-08-01', 'yyyy-mm-dd')
   and n.appcode = '10511051'
   and m.province = '广东'
      -------------首先查询在线和近两个月退订的，下边查询6月1日到6月4日退订的---------------
#158上
57 13 05  08 *  bzcat /home/oracle/etl/data/data/snapshot/archives.txt.bz2 | awk -F'[|^]' '{if(($6=="10511051")&&$(NF-11)>="20150601000000"&&$(NF-11)<"20150605000000"&&$3=="020") print   $2","$3","$4","$6","$5","$7","$8","$(NF-2)","$(NF-3)","$(NF-4) }' | bzip2 > /home/oracle/flbk_1011y_xinzeng_cancle.txt.bz2
cat flbk_1011y_xinzeng_cancle.txt | awk -F',' '{print $1"\t"$6"\t"$7;}'  > 1.txt
awk -F'[,\t]' -v CODE_DIR=nodist_yaoyi.txt '{ if(FILENAME==CODE_DIR) d[$4]=$1"\t"$2; else if( substr($1,1,7) in d)  print $1"\t"d[substr($1,1,7)]"\t"$2"\t"$3}'   nodist_yaoyi.txt 1.txt > 2.txt
sort -u 2.txt >3.txt
awk -F'[\t,]' -v CODE_DIR=zaixian.txt '{ if(FILENAME==CODE_DIR) d[$1]=$1 ; else if(!($1 in d))  print $0;  }' zaixian.txt  3.txt>4.txt
cat 4.txt  | awk -F',' '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t12580生活播报-法律百科彩信版";}'  > 5.txt
cat zaixian.txt 5.txt >2015年6-7月广东各地市彩信新增用户明细237579.txt
----------------15年1-7月新增且目前仍然在网的彩信用户数------------------------
 select m.city 城市,count(n.mobile_sn) 
   from new_wireless_subscription n, opt_code o, mobilenodist m
 where n.appcode = o.appcode
   and substr(n.mobile_sn, 1, 7) = m.beginno
   and n.mobile_sub_time >= to_date('2015-01-01', 'yyyy-mm-dd')
   and n.mobile_sub_time < to_date('2015-08-01', 'yyyy-mm-dd')
   and n.appcode = '10511051'
   and m.province = '广东'
   and n.mobile_sub_state='3'
   group by m.city
