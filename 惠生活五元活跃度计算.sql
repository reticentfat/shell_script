----其活跃度概念用户领券即活跃  ----
请协助捞取以下数据：其活跃度概念用户领券即活跃  
 
12月份统计前10天即可
首先导出领券明细---
SELECT
	u.mobile,from_unixtime(f.ctime , '%Y-%m'),n.PROVINCE
FROM
	flbk_hsh_order f ,flbk_hsh_user u  ,flbk_hsh_nodist n
WHERE
	from_unixtime(f.ctime) >='2017-08-01'
and from_unixtime(f.ctime) <'2017-12-11'
and u.id = f.userid
and substr(u.mobile,1,7)=n.BEGINNO
----bzip2 3.txt上传27上匹配---
---找8月1日snapshot
oracle@wreport:/home/oracle$ bzcat /data/match/orig/20170730/snapshot.txt.bz2 | head -5
11111111111|10301010|06|20110601094546|20110601094546|20110601094546|1|999|999||SUB_BOSS|||YYBK_SMS|10658880|20000000|||99990909235959|None
11111111111|22200030|06|20120509232805|20120509232805|20120509232805|0|999|999|GWZFT,JKSH,PZSHB,SWSH,QCHDT,CFSH,FCH,PZXK|BOSS|ITEM|BOSS|SHBB|10658880|98FREEBOSS|||99990909235959|cmyh
------------
oracle@wreport:/home/oracle$ bzcat 3.txt.bz2 | awk -F'|' '{print $1","$2","$NF}' |  head -5
13901587172,2017-08,江苏
13808010011,2017-08,四川
江苏8月新增用户领券数量

bzcat  4.txt.bz2 /data/match/orig/20170830/snapshot.txt.bz2  |  awk -F'|' -v first_date='20170801000000' -v last_date='20170901000000' '{if((NF==3)&&$2=="2017-08"&&$3=="江苏") aa[$1]=$1; else if(($1 in aa)&&(NF==20)&&$2=="10511055"&&$8=="025"&&$5>= first_date&&$5 <last_date)  print $0}' | bzip2 > ~/jiangsu8yuexinzeng_lingquan.txt.bz2
bzcat  4.txt.bz2 /data/match/orig/20170929/snapshot.txt.bz2  |  awk -F'|' -v first_date='20170901000000' -v last_date='20171001000000' '{if((NF==3)&&$2=="2017-09"&&$3=="江苏") aa[$1]=$1; else if(($1 in aa)&&(NF==20)&&$2=="10511055"&&$8=="025"&&$5>= first_date&&$5 <last_date)  print $0}' | bzip2 > ~/jiangsu9yuexinzeng_lingquan.txt.bz2
bzcat  4.txt.bz2 /data/match/orig/20171030/snapshot.txt.bz2  |  awk -F'|' -v first_date='20171001000000' -v last_date='20171101000000' '{if((NF==3)&&$2=="2017-10"&&$3=="江苏") aa[$1]=$1; else if(($1 in aa)&&(NF==20)&&$2=="10511055"&&$8=="025"&&$5>= first_date&&$5 <last_date)  print $0}' | bzip2 > ~/jiangsu10yuexinzeng_lingquan.txt.bz2
bzcat  4.txt.bz2 /data/match/orig/20171129/snapshot.txt.bz2  |  awk -F'|' -v first_date='20171101000000' -v last_date='20171201000000' '{if((NF==3)&&$2=="2017-11"&&$3=="江苏") aa[$1]=$1; else if(($1 in aa)&&(NF==20)&&$2=="10511055"&&$8=="025"&&$5>= first_date&&$5 <last_date)  print $0}' | bzip2 > ~/jiangsu11yuexinzeng_lingquan.txt.bz2
bzcat  4.txt.bz2 /data/match/orig/20171211/snapshot.txt.bz2  |  awk -F'|' -v first_date='20171201000000' -v last_date='20171214000000' '{if((NF==3)&&$2=="2017-12"&&$3=="江苏") aa[$1]=$1; else if(($1 in aa)&&(NF==20)&&$2=="10511055"&&$8=="025"&&$5>= first_date&&$5 <last_date)  print $0}' | bzip2 > ~/jiangsu12yuexinzeng_lingquan.txt.bz2
江苏8月留存用户领券数量
bzcat  4.txt.bz2 /data/match/orig/20170730/snapshot.txt.bz2  |  awk -F'|'  '{if((NF==3)&&$2=="2017-08"&&$3=="江苏") aa[$1]=$1; else if(($1 in aa)&&(NF==20)&&$2=="10511055"&&$8=="025"&&$3=="06")  print $0}' | bzip2 > ~/jiangsu8liucun_lingquan.txt.bz2
bzcat  4.txt.bz2 /data/match/orig/20170830/snapshot.txt.bz2  |  awk -F'|'  '{if((NF==3)&&$2=="2017-09"&&$3=="江苏") aa[$1]=$1; else if(($1 in aa)&&(NF==20)&&$2=="10511055"&&$8=="025"&&$3=="06")  print $0}' | bzip2 > ~/jiangsu9liucun_lingquan.txt.bz2
bzcat  4.txt.bz2 /data/match/orig/20170929/snapshot.txt.bz2  |  awk -F'|'  '{if((NF==3)&&$2=="2017-10"&&$3=="江苏") aa[$1]=$1; else if(($1 in aa)&&(NF==20)&&$2=="10511055"&&$8=="025"&&$3=="06")  print $0}' | bzip2 > ~/jiangsu10liucun_lingquan.txt.bz2
bzcat  4.txt.bz2 /data/match/orig/20171030/snapshot.txt.bz2  |  awk -F'|'  '{if((NF==3)&&$2=="2017-11"&&$3=="江苏") aa[$1]=$1; else if(($1 in aa)&&(NF==20)&&$2=="10511055"&&$8=="025"&&$3=="06")  print $0}' | bzip2 > ~/jiangsu11liucun_lingquan.txt.bz2
bzcat  4.txt.bz2 /data/match/orig/20171129/snapshot.txt.bz2  |  awk -F'|'  '{if((NF==3)&&$2=="2017-12"&&$3=="江苏") aa[$1]=$1; else if(($1 in aa)&&(NF==20)&&$2=="10511055"&&$8=="025"&&$3=="06")  print $0}' | bzip2 > ~/jiangsu12liucun_lingquan.txt.bz2
全国11月留存数量
bzcat  4.txt.bz2 /data/match/orig/20171030/snapshot.txt.bz2  |  awk -F'|'  '{if((NF==3)&&$2=="2017-11") aa[$1]=$1; else if(($1 in aa)&&(NF==20)&&$2=="10511055"&&$3=="06")  print $0}' | bzip2 > ~/quanguo11liucun_lingquan.txt.bz2
bzcat  4.txt.bz2 /data/match/orig/20171129/snapshot.txt.bz2  |  awk -F'|'  '{if((NF==3)&&$2=="2017-12") aa[$1]=$1; else if(($1 in aa)&&(NF==20)&&$2=="10511055"&&$3=="06")  print $0}' | bzip2 > ~/quanguo12liucun_lingquan.txt.bz2
全国11月新增用户领券数量
bzcat  4.txt.bz2 /data/match/orig/20171129/snapshot.txt.bz2  |  awk -F'|' -v first_date='20171101000000' -v last_date='20171201000000' '{if((NF==3)&&$2=="2017-11") aa[$1]=$1; else if(($1 in aa)&&(NF==20)&&$2=="10511055"&&$5>= first_date&&$5 <last_date)  print $0}' | bzip2 > ~/jiangsu11yuexinzeng_lingquan.txt.bz2
bzcat  4.txt.bz2 /data/match/orig/20171211/snapshot.txt.bz2  |  awk -F'|' -v first_date='20171201000000' -v last_date='20171214000000' '{if((NF==3)&&$2=="2017-12") aa[$1]=$1; else if(($1 in aa)&&(NF==20)&&$2=="10511055"&&$5>= first_date&&$5 <last_date)  print $0}' | bzip2 > ~/jiangsu12yuexinzeng_lingquan.txt.bz2
----------
直接计算数值
bzcat  4.txt.bz2 /data/match/orig/20171129/snapshot.txt.bz2  |  awk -F'|'  '{if((NF==3)&&$2=="2017-12") {aa[$1]=$1;i++} else if(($1 in aa)&&(NF==20)&&$2=="10511055"&&$3=="06") j++ } ;END {if(j>0) printf "%-8s %-8s %-8s %-8s %-8s\n", i,j,i/j,NR,FNR}' #15504    233      66.5408  120853   120853  #15504    1        15504    109620   109620 #15504    2        7752     109621   109621    
oracle@wreport:/home/oracle$ bzcat  4.txt.bz2 /data/match/orig/20171129/snapshot.txt.bz2  |  awk -F'|'  '{if((NF==3)&&$2=="2017-12") {aa[$1]=$1;i++} else if(($1 in aa)&&(NF==20)&&$2=="10511055"&&$3=="06") j++ }  END{if(j>0) printf "%-8s %-8s %-8s %-8s %-8s\n", i,j,i/j,NR,FNR}'
15504    14262    1.08708  25495107 25495107
---牛逼，14262计算成功！
 bzcat /data/match/orig/20171129/snapshot.txt.bz2 4.txt.bz2   |  awk -F'|'  '{if((NF==20)&&$2=="10511055"&&$3=="06") {aa[$1]=$1;i++} else if(($1 in aa)&&(NF==3)&&$2=="2017-12") j++ } ;END {if(j>0) printf "%-8s %-8s %.2f% %-8s %-8s\n", i,j,i/j*100,NR,FNR}'
----成功了---
oracle@wreport:/home/oracle$ bzcat /data/match/orig/20171129/snapshot.txt.bz2 4.txt.bz2   |  awk -F'|'  '{if((NF==20)&&$2=="10511055"&&$3=="06") {aa[$1]=$1;i++} else if(($1 in aa)&&(NF==3)&&$2=="2017-12") j++ } ;END {if(j>0) printf "%-8s %-8s %.2f%% %-8s %-8s\n", i,j,j/i*100,NR,FNR}'
1496454  14302    0.96% 25495107 25495107

　---试试交换文件顺序解决数据偏大的问题---
bzcat  /data/match/orig/20171030/snapshot.txt.bz2 4.txt.bz2   |  awk -F'|'  '{if((NF==20)&&$2=="10511055"&&$8=="025"&&$3=="06") aa[$1]=$1; else if(($1 in aa)&&(NF==3)&&$2=="2017-11"&&$3=="江苏")  print $0}' | bzip2 > ~/jiangsu11liucun_lingquan1.txt.bz2
实际数量一样
bzcat /data/match/orig/20171030/snapshot.txt.bz2 4.txt.bz2   |  awk -F'|' -v first_date='20171001000000' -v last_date='20171101000000' '{if((NF==20)&&$2=="10511055"&&$8=="025"&&$5>= first_date&&$5 <last_date) aa[$1]=$1; else if(($1 in aa)&&(NF==3)&&$2=="2017-10"&&$3=="江苏")  print $0}' | bzip2 > ~/jiangsu10yuexinzeng_lingquan1.txt.bz2
实际数量一样
-----------------------
$ bzcat jiangsu*.bz2 | awk -F'|' '{print $1}' | sort -u | wc -l
30904

