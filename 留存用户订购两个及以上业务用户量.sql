bzcat /data0/match/orig/20101231/snapshot.txt.bz2 | grep -v '|SHBB|' | awk -F '|' '{ if($3 == "06")  print $1","$2","$3;}' > /home/oracle/20101231_06_snapshot.txt
	bzcat /data0/match/orig/20101231/user_sn.txt.bz2 | awk -F '|' '{ if($3 == "06")  print $1","$2","$3;}' > /home/oracle/20101231_06_usersn.txt
	cat /home/oracle/20101231_06_snapshot.txt /home/oracle/20101231_06_usersn.txt > /home/oracle/20101231_06.txt
	bzip2 /home/oracle/20101231_06.txt
	
	导入 mobile.jf_1 : mobile,opt_code,cartype,opttime,serial,biz_code,job_num,subtime

	select c, count(*)
	  from (select count(*) c, mobile
			  from jf_1 j, opt_code o
			 where j.opt_code = o.appcode
			 group by mobile) c
	 where c >= 2
	 group by c
