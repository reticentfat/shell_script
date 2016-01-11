第一步：准备违章业务全量:
在192.100.7.25服务器上执行以下三行 命令

cat /data/wxlog/wxsub/20160111/BJWZNEW20160111_first.txt | grep -v  'HEBEI'  |awk -F'^' '{if($7<"2016-01-11 00:00:00" && $9>="2016-01-11 00:00:00") print $2"^"$7"^"$24"^"$28"^"$29"^"$9}' > /data/wuying/20160111_wzcx.txt
cat /data/wxlog/wxsub/20160111/FSWZ20160111_first.txt | grep -v  'HEBEI'   | awk -F'^' '{if($7<"2016-01-11 00:00:00" && $9>="2016-01-11 00:00:00") print $2"^"$7"^"$23"^"$28"^"$29"^"$9}' >> /data/wuying/20160111_wzcx.txt
bzip2 /data/wuying/20160111_wzcx.txt
 
然后将20160111_wzcx.txt下载下来
导入mobile.jf_1 : mobile,opttime,opt_code,cartype,job_num,subtime,serial,biz_code
执行以下sql

update jf_1 set opt_code='-UMGWZJJ' where opt_code='A' and cartype='BEIJING';
commit;
update jf_1 set opt_code='-UMGWZJJB' where opt_code='B' and cartype='BEIJING';
commit;
update jf_1 set opt_code='-UMGWZJS' where opt_code='C' and cartype='BEIJING';
commit;
update jf_1 set opt_code='-UMGWZJSB' where opt_code='D' and cartype='BEIJING';
commit;
update jf_1 set opt_code='-UMGWZJST' where opt_code='E_BJ' and cartype='BEIJING';
commit;
--update jf_1 set opt_code='-UMGCZFW' where opt_code='E' and cartype='SHANDONG';
commit;
update jf_1 set opt_code='-UMGJTXM' where opt_code='E' and cartype!='SHANDONG';
commit;
update jf_1 set opt_code='-UMGCZMSD' where opt_code='F5' and cartype in ('HUNAN','NINGXIA');
commit;
--佛山、东莞
update jf_1 set opt_code='-UMGWZJS' where opt_code='2' and job_num in ('DONGGUAN','FOSHAN');
commit;
update jf_1 set opt_code='-UMGJTXM' where opt_code='3' and job_num in ('DONGGUAN','FOSHAN');
commit;
update jf_1 set opt_code='-UMGCZMSC' where opt_code='4' and job_num in ('DONGGUAN','FOSHAN');
commit;
update jf_1 set opt_code='-UMGCZMSD' where opt_code='5' and job_num in ('DONGGUAN','FOSHAN');
commit;
update jf_1 set opt_code='-UMGCZMSE' where opt_code='6' and job_num in ('DONGGUAN','FOSHAN');
commit;
update jf_1 set opt_code='-UMGCZMSF' where opt_code='7' and job_num in ('DONGGUAN','FOSHAN');
commit;
update jf_1 set opt_code='-UMGCZMSG' where opt_code='8' and job_num in ('DONGGUAN','FOSHAN');
commit;
update jf_1 set opt_code='-UMGCZMSH' where opt_code='9' and job_num in ('DONGGUAN','FOSHAN');
commit;
update jf_1 set opt_code='-UMGCZMSJ' where opt_code='10' and job_num in ('DONGGUAN','FOSHAN');
commit;
--中山、深圳、珠海、广州、湛江
update jf_1 set opt_code='-UMGCZMSA' where opt_code='2' and job_num in ('ZHONGSHAN','SHENZHEN','ZHUHAI','GUANGZHOU','ZHANJIANG');
commit;
update jf_1 set opt_code='-UMGCZMSB' where opt_code='3' and job_num in ('ZHONGSHAN','SHENZHEN','ZHUHAI','GUANGZHOU','ZHANJIANG');
commit;
update jf_1 set opt_code='-UMGCZMSC' where opt_code='4' and job_num in ('ZHONGSHAN','SHENZHEN','ZHUHAI','GUANGZHOU','ZHANJIANG');
commit;
update jf_1 set opt_code='-UMGCZMSD' where opt_code='5' and job_num in ('ZHONGSHAN','SHENZHEN','ZHUHAI','GUANGZHOU','ZHANJIANG');
commit;
update jf_1 set opt_code='-UMGCZMSE' where opt_code='6' and job_num in ('ZHONGSHAN','SHENZHEN','ZHUHAI','GUANGZHOU','ZHANJIANG');
commit;
update jf_1 set opt_code='-UMGCZMSF' where opt_code='7' and job_num in ('ZHONGSHAN','SHENZHEN','ZHUHAI','GUANGZHOU','ZHANJIANG');
commit;
update jf_1 set opt_code='-UMGCZMSG' where opt_code='8' and job_num in ('ZHONGSHAN','SHENZHEN','ZHUHAI','GUANGZHOU','ZHANJIANG');
commit;
update jf_1 set opt_code='-UMGCZMSH' where opt_code='9' and job_num in ('ZHONGSHAN','SHENZHEN','ZHUHAI','GUANGZHOU','ZHANJIANG');
commit;
update jf_1 set opt_code='-UMGCZMSJ' where opt_code='10' and job_num in ('ZHONGSHAN','SHENZHEN','ZHUHAI','GUANGZHOU','ZHANJIANG');
commit;
--检查错误时间格式 
delete from jf_1 where opttime='0000-00-00 00:00:00';
 commit;

--执行完以上步骤后执行以下语句导出生成 20160111_wzcx_style.txt ，然后上传到192.100.7.27的 /data/match/quanliang_in_advance/ 目录下，并且压缩生成20160111_wzcx_style.txt.bz2 文件
select o.appcode||'|'||j.mobile||'|00|'||to_char(max(to_date(j.opttime,'yyyy-mm-dd hh24:mi:ss')),'yyyymmddhh24miss')||'|02|901808|'||o.jfcode||'|0|'||to_char(max(to_date(j.opttime,'yyyy-mm-dd hh24:mi:ss')),'yyyymmddhh24miss')
from jf_1 j, opt_code o
where j.opt_code = o.jfcode
  and to_date(j.opttime, 'yyyy-mm-dd hh24:mi:ss') <= to_date('2016-01-11 00:00:00', 'yyyy-mm-dd hh24:mi:ss')	--订购时间
  and to_date(j.subtime, 'yyyy-mm-dd hh24:mi:ss') >	to_date('2016-01-11 00:00:00', 'yyyy-mm-dd hh24:mi:ss')		--退订时间
group by j.mobile, o.appcode, o.jfcode

------20160111_wzcx_style.txt----------------------------------------

第二步：准备考务资讯全量: -UMGKWZX
   
在192.100.7.25服务器上执行以下一行命令

cat /data/wxlog/wxsub/20160111/KWZX20160111_first.txt | sed 's/0000-00-00 00:00:00/9999-12-31 23:59:59/g' | awk -F'^' '{print $2"^"$5"^-UMGKWZX^"$7}' | bzip2 > /data/wuying/20160111_kwzx.txt.bz2
然后下载 /data/wuying/20160111_kwzx.txt.bz2 文件到本地，解压后按以下字段顺序导入mobile数据库的jf_1表中
mobile.jf_1 : mobile,opttime,opt_code,subtime,cartype,serial,job_num,biz_code
执行以下sql语句
delete from jf_1 where mobile in ('_\', '\');
commit;
delete from jf_1 where mobile is null;
commit;
然后导出生成 20160111_kwzx_style.txt 文件，上传至192.100.7.27的 /data/match/quanliang_in_advance/ 目录下，并且压缩生成20160111_kwzx_style.txt.bz2 文件
select o.appcode||'|'||j.mobile||'|00|'||to_char(max(to_date(j.opttime,'yyyy-mm-dd hh24:mi:ss')),'yyyymmddhh24miss')||'|02|901808|'||o.jfcode||'|0|'||to_char(max(to_date(j.opttime,'yyyy-mm-dd hh24:mi:ss')),'yyyymmddhh24miss')
  from jf_1 j, opt_code o
 where j.opt_code = o.jfcode
   and to_date(j.opttime, 'yyyy-mm-dd hh24:mi:ss') <= to_date('2016-01-11 00:00:00', 'yyyy-mm-dd hh24:mi:ss')	--订购时间
   and to_date(j.subtime, 'yyyy-mm-dd hh24:mi:ss') > to_date('2016-01-11 00:00:00', 'yyyy-mm-dd hh24:mi:ss')	--退订时间
 group by j.mobile, o.appcode, o.jfcode
 
 
---20160111_kwzx_style.txt 




第三步：执行完以上步骤后，执行以下语句导出生成 qx_other_online_20151201.txt ，然后上传到192.100.7.27的 /data/match/quanliang_in_advance/ 目录下即可。
 
select b.mobile_sn || '^' || o.appcode
  from bjwz b, opt_code o
 where b.opt_type = o.opt_type
   and b.mobile_sub_state = 3
   and b.mobile_sub_time >= to_date('2015-12-01', 'yyyy-mm-dd')

union

select f.mobile_sn || '^' || o.appcode
  from fswz_new f, opt_code o
 where f.fee_app_code = o.opt_type
   and f.mobile_sub_state = 3
   and f.mobile_sub_time >= to_date('2015-12-01', 'yyyy-mm-dd')

union

select k.mobile_sn || '^' || o.appcode
  from kwzx_sub k, opt_code o
 where k.appcode = o.appcode
   and k.user_state = 3
   and k.sub_time >= to_date('2015-12-01', 'yyyy-mm-dd')

union

select j.mobile || '^' || o.appcode
  from jsyybk_sub j, opt_code o
 where j.appcode = o.appcode
   and j.status = 3
   and j.order_time >= to_date('2015-12-01', 'yyyy-mm-dd')


--第四步：进入 192.100.7.27的 /data/match/quanliang_in_advance/ 目录下 执行以下wget 命令，下载准备文件 filter.txt.bz2
 
wget http://192.100.6.31:9999/data/filter/filter.txt.bz2
--第五步：进入 192.100.7.27的 /data/match/quanliang_in_advance/ 目录下 执行以下scp  命令，拷贝准备文件 jswzkw_cancel_20160111.txt.bz2

scp gateway@192.100.7.25:/data/wxlog/jswzkw_cancel_20160111.txt.bz2 /data/match/quanliang_in_advance/

