拆分文件并添加txt后缀
split sjsj_black.txt -l 1 -d -a 2 sjsj_black_&&ls|grep sjsj_black_|xargs -n1 -i{} mv {} {}.txt
-l：按行分割，上面表示将urls.txt文件按2000行一个文件分割为多个文件
-d：添加数字后缀，比如上图中的00，01，02
-a 2：表示用两位数据来顺序命名
sjsj_black_：看上图就应该明白了，用来定义分割后的文件名前面的部分。
&&后边为增加.txt
------------------------
split 20170110.log -l 5400 -d -a 2 pitui_&&ls|grep pitui_|xargs -n1 -i{} mv {} {}.txt
----上行提取------------
----三季度每月每端口两条---
select * from 
(select r.*,
                        row_number() over(partition by r.receiver,substr(r.dealtime,0,8) order by r.sender desc) RN
                   from R200904_201710 r 
                   where r.dealtime >='20170101000000' 
and r.dealtime <'20170201000000' )
          where RN <= 2
          -----拆分---
          cat a.txt | awk -F'|' '{d=substr($7,5,4)".txt";print $0>> d;}'
----------------------
无线-产品-11提取方法
5.31上
scp /data/logs/archives/bossproxy/20170[1-3][0-9][0-9]/bossproxy.log.20170[1-3][0-9][0-9]1600.bz2 gateway@192.100.7.25:/home/gateway/quanliang_mail/
scp /data/logs/archives/bossproxy/20170[1-3][0-9][0-9]/appproxy.log.20170[1-3][0-9][0-9]1000.bz2 gateway@192.100.7.25:/home/gateway/quanliang_mail/
产品10 需要用原有文件拆分
cat app.txt | awk -F',' '{d=substr($3,5,4)".txt";print $0>> d;}'
cat boss.txt | awk -F',' '{d=substr($2,1,6)".txt";print $0>> d;}'
----------
无线-产品-11提取方法
5.31
scp gateway@192.100.7.25:/data/home/gateway/wy.txt.bz2 ~
bzcat ~/wy.txt.bz2 ./20170[1-2][0-3][0-9]/appproxy.log.20170[1-2][0-3][0-9]0[0-9]00.bz2 | awk -F',' '{if(NF==3) aa[$1$2]=$3;else if($4$7 in aa)  print aa[$4$7]","substr($1,1,15)","$3","$4","$6","$7","$8","$11","$14}' | bzip2 > ~/app.txt.bz2
appproxy.log.201706090900.bz2
bzcat ~/wy.txt.bz2 ./20170[1-2][0-3][0-9]/bossproxy.log.20170[1-2][0-3][0-9]0[0-9]00.bz2 | awk -F',' '{if(NF==3) aa[$1$2]=$3;else if($5$7 in aa)  print aa[$5$7]","substr($1,1,15)","$3","$4","$6","$7","$8","$11","$14}' | bzip2 > ~/boss.txt.bz2
scp ~/boss.txt.bz2 gateway@192.100.7.25:/data/home/gateway
--------------------------
 ----上月订购号码---------
 select b.mobile_sn, o.jfcode,'sub'
   from (select *
           from (select t.*,
                        row_number() over(partition by t.appcode,t.addr_code order by t.mobile_sn desc) RN
                   from new_wireless_subscription t 
                   where t.mobile_sub_time>= to_date('2017-10-01', 'yyyy-mm-dd')
                   and t.mobile_sub_time< to_date('2017-11-01', 'yyyy-mm-dd'))
          where RN <= 2) b,
        opt_code o
  where b.appcode = o.appcode
  union all
   select b.mobile_sn,o.jfcode,'sub'
   from (select *
           from (select t.*,
                        row_number() over(partition by t.appcode,t.addr_code order by t.mobile_sn desc) RN
                   from new_wireless_subscription_shbb t 
                   where t.mobile_sub_time>= to_date('2017-10-01', 'yyyy-mm-dd')
                   and t.mobile_sub_time< to_date('2017-11-01', 'yyyy-mm-dd'))
          where RN <= 2) b,
        opt_code o
  where b.appcode = o.appcode
  union all 
  select b.mobile_sn,o.jfcode,'sub'
   from (select *
           from (select t.*,
                        row_number() over(partition by t.opt_type,t.addr_code order by t.mobile_sn desc) RN
                   from bjwz t 
                   where t.mobile_sub_time>= to_date('2017-10-01', 'yyyy-mm-dd')
                   and t.mobile_sub_time< to_date('2017-11-01', 'yyyy-mm-dd'))
          where RN <= 2) b,
        opt_code o
  where b.opt_type = o.opt_type 
   union all 
  select b.mobile_sn, o.jfcode,'sub'
   from (select *
           from (select t.*,
                        row_number() over(partition by t.fee_app_code,t.addr_code order by t.mobile_sn desc) RN
                   from fswz t 
                   where t.mobile_sub_time>= to_date('2017-10-01', 'yyyy-mm-dd')
                   and t.mobile_sub_time< to_date('2017-11-01', 'yyyy-mm-dd'))
          where RN <= 2) b,
        opt_code o
  where 'F' || b.fee_app_code = o.opt_type  
  ---------------上月退订号码--------------
   select b.mobile_sn, o.jfcode,'unsub'
   from (select *
           from (select t.*,
                        row_number() over(partition by t.appcode,t.addr_code order by t.mobile_sn desc) RN
                   from new_wireless_subscription t 
                   where t.mobile_modify_time>= to_date('2017-10-01', 'yyyy-mm-dd')
                   and t.mobile_modify_time< to_date('2017-11-01', 'yyyy-mm-dd'))
          where RN <= 2) b,
        opt_code o
  where b.appcode = o.appcode
  union all
   select b.mobile_sn,o.jfcode,'unsub'
   from (select *
           from (select t.*,
                        row_number() over(partition by t.appcode,t.addr_code order by t.mobile_sn desc) RN
                   from new_wireless_subscription_shbb t 
                   where t.mobile_modify_time>= to_date('2017-10-01', 'yyyy-mm-dd')
                   and t.mobile_modify_time< to_date('2017-11-01', 'yyyy-mm-dd'))
          where RN <= 2) b,
        opt_code o
  where b.appcode = o.appcode
  union all 
  select b.mobile_sn,o.jfcode,'unsub'
   from (select *
           from (select t.*,
                        row_number() over(partition by t.opt_type,t.addr_code order by t.mobile_sn desc) RN
                   from bjwz t 
                   where t.mobile_modify_time>= to_date('2017-10-01', 'yyyy-mm-dd')
                   and t.mobile_modify_time< to_date('2017-11-01', 'yyyy-mm-dd'))
          where RN <= 2) b,
        opt_code o
  where b.opt_type = o.opt_type 
   union all 
  select b.mobile_sn, o.jfcode,'unsub'
   from (select *
           from (select t.*,
                        row_number() over(partition by t.fee_app_code,t.addr_code order by t.mobile_sn desc) RN
                   from fswz t 
                   where t.mobile_modify_time>= to_date('2017-10-01', 'yyyy-mm-dd')
                   and t.mobile_modify_time< to_date('2017-11-01', 'yyyy-mm-dd'))
          where RN <= 2) b,
        opt_code o
  where 'F' || b.fee_app_code = o.opt_type  
   ---------------------------
   匹配
   /data/match/mm7/20170301]$ bzcat bossproxy.log.20170301.bz2 | 
tail -5
Mar  1 23:59:59 192.100.6.33 bossproxy[1691]: BIP2B248,BOSS=>PROXY,wuxian,21020170301235959007139534446,15000679200,901808,-UMGQNZL,05,20170301235954,210BIP2B24820170301235959240055,0,2,52,210,,0,0000,0000,0.00499200820923
Mar  1 23:59:59 192.100.6.31 bossproxy[1695]: BIP2B248,BOSS=>PROXY,wuxian,6314597815,15840587008,801174,1258147,04,20170301235948,240BIP2B24820170302000000013322,0,2,52,240,,0,0000,0000,0.00753998756409
/data/211/bin/boss_sys.sh
[gateway@wtraffic /data/match/mm7/20170301]$ bzcat bossproxy.log.20170301.bz2 | 
grep '13810388456'
Mar  1 17:45:17 192.100.6.31 bossproxy[1695]: BIP2B247,BOSS=>PROXY,5416268697,13810388456,wuxian,801174,1258150,07,08,20170301174506,100,0,0000,0000,0.038125038147
You have new mail in /var/mail/gateway
[gateway@wtraffic /data/match/mm7/20170301]$ cd ../20170222
[gateway@wtraffic /data/match/mm7/20170222]$ bzcat bossproxy.log.20170301.bz2 | grep '13810388456'
bzcat: Can't open input file bossproxy.log.20170301.bz2: No such file or directory.
[gateway@wtraffic /data/match/mm7/20170222]$ bzcat bossproxy.log.20170222.bz2 | grep '13810388456'
[gateway@wtraffic /data/match/mm7/20170222]$ bzcat appproxy.log.20170301.bz2 | grep '13810388456'
bzcat: Can't open input file appproxy.log.20170301.bz2: No such file or directory.
[gateway@wtraffic /data/match/mm7/20170222]$ bzcat appproxy.log.20170222.bz2 | grep '13810388456'
Feb 22 10:46:10 192.100.6.33 appproxy[61316]: BIP2B247,APPS=>PROXY,20170222104546900344,13810388456,wuxian,801174,1258150,06,04,20170222104546,100,0,0000,1000,24.8252131939
Feb 22 10:46:38 192.100.6.31 appproxy[84577]: BIP2B247,APPS=>PROXY,20170222104638814335,13810388456,wuxian,801174,1258150,06,04,20170222104638,100,0,0000,1000,0.510383844376
Feb 22 10:46:55 192.100.6.31 appproxy[84577]: BIP2B247,APPS=>PROXY,20170222104654546972,13810388456,wuxian,801174,1258150,06,04,20170222104655,100,0,0000,1000,0.345132112503
Feb 22 10:47:03 192.100.6.33 appproxy[61316]: BIP2B247,APPS=>PROXY,20170222104703586764,13810388456,wuxian,801174,1258150,06,04,20170222104703,100,0,0000,1000,0.361727952957
Feb 22 10:47:24 192.100.6.33 appproxy[61316]: BIP2B247,APPS=>PROXY,20170222104723701935,13810388456,wuxian,801174,1258150,06,04,20170222104723,100,0,0000,1000,0.826564073563
Feb 22 10:48:26 192.100.6.33 appproxy[61316]: BIP2B247,APPS=>PROXY,20170222104826443260,13810388456,wuxian,801174,1258150,06,04,20170222104826,100,0,0000,1000,0.463086128235
Feb 22 11:39:14 192.100.6.31 appproxy[84577]: BIP2B248,APPS=>PROXY,20170222113914592744,13810388456,100BIP2B24820170222113008,20170222113008,0000,100,0,0000,OSN ACCEPT NOTICE OK,0.0241289138794
Feb 22 13:14:49 192.100.6.31 appproxy[84577]: BIP2B247,APPS=>PROXY,20170222131447164782,13810388456,wuxian,801174,1258150,07,R1,20170222131448,100,0,0000,2001,1.73387885094
Feb 22 14:39:03 192.100.6.31 appproxy[84577]: BIP2B248,APPS=>PROXY,20170222143903420889,13810388456,100BIP2B24820170222143445,20170222143445,0000,100,0,0000,OSN ACCEPT NOTICE OK,0.25870013237
Feb 22 15:03:02 192.100.6.31 appproxy[84577]: BIP2B248,APPS=>PROXY,20170222150303475919,13810388456,100BIP2B24820170222145210,20170222145210,0000,100,0,0000,OSN ACCEPT NOTICE OK,0.0217800140381
bzcat /data/home/gateway/wy.txt.bz2  bossproxy.log.20170228.bz2  | awk -F',' '{if(NF==3) aa[$1$2]=$3;else if($5$7 in aa)  print aa[$5$7]","substr($1,1,15)","$4","$5","$6","$7","$8","$14","$18}' | bzip2 > 123.txt.bz2
 bzcat 123.txt.bz2 | awk -F',' '{print substr($4,1,15)}' | head -5
 在/data/match/mm7下
 bzcat /data/home/gateway/wy.txt.bz2  ./201702[0-3][0-9]/bossproxy.log.201702[0-3][0-9].bz2  | awk -F',' '{if(NF==3) aa[$1$2]=$3;else if($5$7 in aa)  print aa[$5$7]","substr($1,1,15)","$4","$5","$6","$7","$8","$14","$18}' | bzip2 > boss.txt.bz2
 bzcat /data/home/gateway/wy.txt.bz2  ./201702[0-3][0-9]/appproxy.log.201702[0-3][0-9].bz2  | awk -F',' '{if(NF==3) aa[$1$2]=$3;else if($4$7 in aa)  print aa[$4$7]","substr($1,1,15)","$3","$4","$6","$7","$8","$11","$14}' | bzip2 > app.txt.bz2
