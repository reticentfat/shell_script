select n.mobile_sn 新增号码,
       m.city 所属地市,
       o.opt_cost 业务名称,
       to_char(n.mobile_sub_time, 'yyyy-mm-dd hh24:mi:ss') 新增时间,
       to_char(n.mobile_modify_time, 'yyyy-mm-dd hh24:mi:ss') 退订时间,
       case
         when (n.mobile_modify_time - n.mobile_sub_time) * 24 <= 72 then
          '是'
         when (n.mobile_modify_time - n.mobile_sub_time) * 24 > 72 then
          '否'
          end "72小时内是否退订"
  from new_wireless_subscription n, opt_code o, mobilenodist m
 where n.appcode = o.appcode
   and substr(n.mobile_sn, 1, 7) = m.beginno
   and n.mobile_sub_time >= to_date('2015-01-01', 'yyyy-mm-dd')
   and n.mobile_sub_time < to_date('2015-02-01', 'yyyy-mm-dd')
   and n.appcode = '10511008'
   and m.city = '濮阳'
   -------------首先查询在线和近两个月退订的，下边查询1月1日到4月24日退订的---------------
   --158上
53 10 25  06 *  bzcat /home/oracle/etl/data/data/snapshot/archives.txt.bz2 | awk -F'[|^]' '{if(($6=="10511008")&&$(NF-11)>="20150101000000"&&$(NF-11)<"20150201000000"&&$(NF-5)>="20150101000000"&&$(NF-5)<="20150424000000"&&$4=="393") print   $2","$3","$4","$6","$5","$7","$8","$(NF-2)","$(NF-3)","$(NF-4) }' | bzip2 > /home/oracle/flbk_1011y_xinzeng_cancle.txt.bz2
cat flbk_1011y_xinzeng_cancle.txt | awk -F',' '{print $1"\t"$5"\t已退定\t"$6"\t"$7;}'  > 1.txt
awk -F'[,]' -v CODE_DIR=nodist_yaoyi.txt '{ if(FILENAME==CODE_DIR) d[$4]=$2; else if( substr($1,1,7) in d)  print $1"\t"d[substr($1,1,7)]"\t"$2"\t"$3"\t"$4}'   nodist_yaoyi.txt 1.txt > 2.txt
=IF(TEXT(E2,"YYYY-MM")<="2015-03","否","是")
