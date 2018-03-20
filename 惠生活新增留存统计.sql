---首先查找11月新增用户明细---
--在27上snapshot查询------
----先是11月统计
oracle@wreport:/home/oracle$ bzcat /data/match/orig/20171130/snapshot.txt.bz2 | awk -F'|' '$2=="10511055"&&$8=="025"&&$5>="20171101000000"&&$5<"20171201000000"{print $1"|"$2"|"$9}' | bzip2 > js_hsh5_11yue_xinzeng.txt.bz2
100207
bzcat /home/oracle/js_hsh5_11yue_xinzeng.txt.bz2  /data/match/orig/20171231/snapshot.txt.bz2  | awk -F'|'  '{if(NF==3) aa[$1$2]=$0;else if(($1$2 in aa)&&$3=="06")  print aa[$1$2]}' | bzip2 > /home/oracle/js_hsh5_11yue_xinzeng_12yueliucun.txt.bz2
bzcat /home/oracle/js_hsh5_11yue_xinzeng.txt.bz2  /data/match/orig/20171130/snapshot.txt.bz2  | awk -F'|'  '{if(NF==3) aa[$1$2]=$0;else if(($1$2 in aa)&&$3=="06")  print aa[$1$2]}' | bzip2 > /home/oracle/js_hsh5_11yue_xinzeng_11yueliucun.txt.bz2
bzcat /home/oracle/js_hsh5_11yue_xinzeng_11yueliucun.txt.bz2 | awk -F'|' '{print $3}' | sort | uniq -c
----从mysql 提出领券明细
SELECT
	 u.mobile,f.`month`,
	 case
                      when f.type IN ('1','2','5')  then
                       '10511055'
                      else
                       '10120013'
                    end appcode
FROM
	flbk_hsh_order f ,flbk_hsh_user u  ,flbk_hsh_nodist n
WHERE
	from_unixtime(f.ctime) >='2017-11-01'
and from_unixtime(f.ctime) <'2018-03-1'
and u.id = f.userid
and substr(u.mobile,1,7)=n.BEGINNO
and n.PROVINCE='江苏'
---dos2unix后
cat lingquan.txt |awk '{print $1"|"$2"|"$3"|"}' | bzip2>lingquan.txt.bz2
再统计新增领券数量
bzcat js_hsh5_11yue_xinzeng.txt.bz2  lingquan.txt.bz2  | awk -F'|'  '{if(NF==3) aa[$1$2]=$0;else if(($1$3 in aa)&&$2=="201711")  print aa[$1$3]}' | bzip2 > /home/oracle/js_hsh5_11yue_xinzeng_11lingquan.txt.bz2
bzcat js_hsh5_11yue_xinzeng_11lingquan.txt.bz2 | awk -F'|' '{print $3}' | sort | uniq -c
bzcat js_hsh5_11yue_xinzeng.txt.bz2  lingquan.txt.bz2  | awk -F'|'  '{if(NF==3) aa[$1$2]=$0;else if(($1$3 in aa)&&$2=="201712")  print aa[$1$3]}' | bzip2 > /home/oracle/js_hsh5_11yue_xinzeng_12lingquan.txt.bz2
bzcat js_hsh5_11yue_xinzeng_12lingquan.txt.bz2 | awk -F'|' '{print $3}' | sort | uniq -c
bzcat js_hsh5_11yue_xinzeng.txt.bz2  lingquan.txt.bz2  | awk -F'|'  '{if(NF==3) aa[$1$2]=$0;else if(($1$3 in aa)&&$2=="201801")  print aa[$1$3]}'  | awk -F'|' '{print $3}' | sort | uniq -c
------12月统计-----
/home/oracle$ bzcat /data/match/orig/20171231/snapshot.txt.bz2 | awk -F'|' '$2=="10511055"&&$8=="025"&&$5>="20171201000000"&&$5<"20180101000000"{print $1"|"$2"|"$9}' | bzip2 > js_hsh5_12yue_xinzeng.txt.bz2
bzcat /home/oracle/js_hsh5_12yue_xinzeng.txt.bz2  /data/match/orig/20171231/snapshot.txt.bz2  | awk -F'|'  '{if(NF==3) aa[$1$2]=$0;else if(($1$2 in aa)&&$3=="06")  print aa[$1$2]}' | bzip2 > /home/oracle/js_hsh5_12yue_xinzeng_12yueliucun.txt.bz2
bzcat /home/oracle/js_hsh5_12yue_xinzeng.txt.bz2  /data/match/orig/20180131/snapshot.txt.bz2  | awk -F'|'  '{if(NF==3) aa[$1$2]=$0;else if(($1$2 in aa)&&$3=="06")  print aa[$1$2]}' | bzip2 > /home/oracle/js_hsh5_12yue_xinzeng_01yueliucun.txt.bz2
bzcat /home/oracle/js_hsh5_12yue_xinzeng_12yueliucun.txt.bz2 | awk -F'|' '{print $3}' | sort | uniq -c
bzcat js_hsh5_12yue_xinzeng.txt.bz2  lingquan.txt.bz2  | awk -F'|'  '{if(NF==3) aa[$1$2]=$0;else if(($1$3 in aa)&&$2=="201712")  print aa[$1$3]}'  | awk -F'|' '{print $3}' | sort | uniq -c
bzcat js_hsh5_12yue_xinzeng.txt.bz2  lingquan.txt.bz2  | awk -F'|'  '{if(NF==3) aa[$1$2]=$0;else if(($1$3 in aa)&&$2=="201801")  print aa[$1$3]}'  | awk -F'|' '{print $3}' | sort | uniq -c
bzcat js_hsh5_12yue_xinzeng.txt.bz2  lingquan.txt.bz2  | awk -F'|'  '{if(NF==3) aa[$1$2]=$0;else if(($1$3 in aa)&&$2=="201802")  print aa[$1$3]}'  | awk -F'|' '{print $3}' | sort | uniq -c
---1月统计
bzcat /data/match/orig/20180131/snapshot.txt.bz2 | awk -F'|' '$2=="10511055"&&$8=="025"&&$5>="20180101000000"&&$5<"20180201000000"{print $1"|"$2"|"$9}' | bzip2 > js_hsh5_1yue_xinzeng.txt.bz2
bzcat /home/oracle/js_hsh5_1yue_xinzeng.txt.bz2  /data/match/orig/20180131/snapshot.txt.bz2  | awk -F'|'  '{if(NF==3) aa[$1$2]=$0;else if(($1$2 in aa)&&$3=="06")  print aa[$1$2]}' | bzip2 > /home/oracle/js_hsh5_1yue_xinzeng_02yueliucun.txt.bz2
bzcat /home/oracle/js_hsh5_1yue_xinzeng.txt.bz2  /data/match/orig/20180228/snapshot.txt.bz2  | awk -F'|'  '{if(NF==3) aa[$1$2]=$0;else if(($1$2 in aa)&&$3=="06")  print aa[$1$2]}' | bzip2 > /home/oracle/js_hsh5_1yue_xinzeng_03yueliucun.txt.bz2
bzcat /home/oracle/js_hsh5_1yue_xinzeng_03yueliucun.txt.bz2| awk -F'|' '{print $3}' | sort | uniq -c
bzcat js_hsh5_1yue_xinzeng.txt.bz2  lingquan.txt.bz2  | awk -F'|'  '{if(NF==3) aa[$1$2]=$0;else if(($1$3 in aa)&&$2=="201801")  print aa[$1$3]}'  | awk -F'|' '{print $3}' | sort | uniq -c
bzcat js_hsh5_1yue_xinzeng.txt.bz2  lingquan.txt.bz2  | awk -F'|'  '{if(NF==3) aa[$1$2]=$0;else if(($1$3 in aa)&&$2=="201802")  print aa[$1$3]}'  | awk -F'|' '{print $3}' | sort | uniq -c
bzcat js_hsh5_1yue_xinzeng.txt.bz2  lingquan.txt.bz2  | awk -F'|'  '{if(NF==3) aa[$1$2]=$0;else if(($1$3 in aa)&&$2=="201803")  print aa[$1$3]}'  | awk -F'|' '{print $3}' | sort | uniq -c
---2月统计
bzcat /data/match/orig/20180228/snapshot.txt.bz2 | awk -F'|' '$2=="10511055"&&$8=="025"&&$5>="20180201000000"&&$5<"20180301000000"{print $1"|"$2"|"$9}' | bzip2 > js_hsh5_2yue_xinzeng.txt.bz2
bzcat /home/oracle/js_hsh5_2yue_xinzeng.txt.bz2  /data/match/orig/20180228/snapshot.txt.bz2  | awk -F'|'  '{if(NF==3) aa[$1$2]=$0;else if(($1$2 in aa)&&$3=="06")  print aa[$1$2]}' | bzip2 > /home/oracle/js_hsh5_2yue_xinzeng_03yueliucun.txt.bz2
bzcat /home/oracle/js_hsh5_2yue_xinzeng_03yueliucun.txt.bz2| awk -F'|' '{print $3}' | sort | uniq -c
bzcat js_hsh5_2yue_xinzeng.txt.bz2  lingquan.txt.bz2  | awk -F'|'  '{if(NF==3) aa[$1$2]=$0;else if(($1$3 in aa)&&$2=="201802")  print aa[$1$3]}'  | awk -F'|' '{print $3}' | sort | uniq -c
bzcat js_hsh5_2yue_xinzeng.txt.bz2  lingquan.txt.bz2  | awk -F'|'  '{if(NF==3) aa[$1$2]=$0;else if(($1$3 in aa)&&$2=="201803")  print aa[$1$3]}'  | awk -F'|' '{print $3}' | sort | uniq -c
---3月统计
bzcat /data/match/orig/20180318/snapshot.txt.bz2 | awk -F'|' '$2=="10120013"&&$8=="025"&&$5>="20180301000000"&&$5<"20180401000000"{print $1"|"$2"|"$9}' | bzip2 > js_hsh5_3yue_xinzeng.txt.bz2
bzcat js_hsh5_3yue_xinzeng.txt.bz2 lingquan.txt.bz2  | awk -F'|'  '{if(NF==3) aa[$1$2]=$0;else if(($1$3 in aa)&&$2=="201803")  print aa[$1$3]}'  | awk -F'|' '{print $3}' | sort | uniq -c