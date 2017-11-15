----首先核对缺少的天数
--核查为9号10号缺失
cat /data/match/cmpp/201606{09,10}/*wuxian*.out | grep -e ',10202005,' -e ',10201036,' -e ',10202011,' -e ',10201002,'  -e ',10201006,' -e ',10201007,' -e ',10226002,'  -e ',10201034,' -e ',10201020,' -e',10201021,' -e ',10202001,'  -e ',10202010,' -e ',10202008,' -e ',10202009,' -e ',10202006,'   -e ',10201070,' -e ',10201071,'  -e ',10201072,'  -e ',10201073,'   | awk -F',' '{ print $1"^"$15"^"$19"^"$10"^"$14"^"$35"^"$(NF-3)}' |  awk -F':' '{print $4}' | awk -F'^' '{print substr($1,2,14)"^"$2"^"$3"^"$4"^"$5"^"$6"^"$7}' > /data/wuying/S200808_uf8temp_20160608.txt
iconv -f UTF-8  -t GB18030 -c   /data/wuying/S200808_uf8temp_20160608.txt  > /data/wuying/RSDATA/S200808_temp_20150522.txt;
注意：执行下面的scp命令是，看看系统时间是否在中午13点左右，158服务器加载数据入库的时间为中午13点整，所以运行补充数据时要避开这个时间点防止补充数据覆盖刚生成好的数据文件。 
scp /data/wuying/RSDATA/S200808_temp_20150522.txt oracle@192.100.7.27:/home/oracle/etl/data/S200808_temp.txt 

然后到27上执行 
sh /home/oracle/etl/bin/ldr_s200808_temp_new_bc.sh 20171113(时间串为需要增加的点播日期，即s200808里边dealtime的字段) (注意这里是对表数据追加方式，如果重复执行会重复追加入库。)
--------------------然后以 s200808_temp表为蓝本重新生成表WANGYUAN_TMP
    create table WANGYUAN_TMP
(
  mobile    VARCHAR2(11),
  appcode   VARCHAR2(8),
   deal_date VARCHAR2(20),
   totals    INTEGER
)
tablespace TBS_TJ
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 1280K
    next 1280K
    minextents 1
    maxextents unlimited
    pctincrease 0
  );
  ----------------------------------------------
     INSERT INTO WANGYUAN_TMP
(  mobile ,
  appcode  ,
   deal_date ,
   totals )
        select s.receiver,s.serviceid,substr(s.dealtime,0,4)||'-'||substr(s.dealtime,5,2)||'-'||substr(s.dealtime,7,2),count(*) from s200808_temp s
     where errordetail = '0'
   and dealtime >= '20160601000000'
   and dealtime < '20160701000000'
   and s.serviceid in ('10411014','10201072','10201073')
   group by 
    s.receiver,s.serviceid,substr(s.dealtime,0,4)||'-'||substr(s.dealtime,5,2)||'-'||substr(s.dealtime,7,2)
    --------------------------然后删除tmp_dianbo_day里边的6月30日手机商界的数据-------------------------
    delete   tmp_dianbo_day where deal_date = '2016-06-30'
       and appcode in ('10411014', '10201072', '10201073')
       --------------------再更新tmp_dianbo_day里边的6月30日手机商界的数据-------------------------
               INSERT INTO tmp_dianbo_day 
    (  mobile ,
  appcode  ,
  totals  ,
   deal_date )
  select w.mobile,w.appcode,sum(w.totals),'2016-06-30' from WANGYUAN_TMP w group by w.mobile,w.appcode 
  ---------------------删除tb_theory_income_dianbo里边的6月30日手机商界的数据-----------------------------------
  delete tb_theory_income_dianbo d where d.deal_date='2016-06-30' and appcode in ('10411014', '10201072', '10201073')
--------------然后更新tb_theory_income_dianbo里边的6月30日手机商界的数据-----------
INSERT INTO tb_theory_income_dianbo
  (deal_date, --插入一条消息
   appcode,
   num,
   prov_code,
   prov_name,
   city_code,
   city_name,
   oper_name,
   oper_name_real,
   oper_code,
   fee,
   spid,
   mobile)
  select t.deal_date,
         t.appcode,
         t.totals,
         m.provinceno,
         m.province,
         m.citycode,
         m.city,
         b.oper_name,
         b.oper_name_real,
         b.oper_code,
         b.fee,
         b.spid,
         t.mobile
    from tmp_dianbo_day t, tb_theory_income_base_dianbo b, mobilenodist m
   where t.appcode = b.appcode
     and substr(t.mobile, 1, 7) = m.beginno
     and t.deal_date in ('2016-06-30')
     and  t.appcode in ('10411014', '10201072', '10201073')
     ----------------核查数据--------------------------
       select count(*) from tb_theory_income_dianbo d where d.deal_date='2016-06-30' and appcode in ('10411014', '10201072', '10201073')
 delete tb_theory_income_dianbo d where d.deal_date='2016-06-30' and appcode in ('10411014', '10201072', '10201073')
 select * from tmp_dianbo_day
 ------------------------------------------------------------------
  select 
         count(distinct t.mobile)
    from tmp_dianbo_day t, tb_theory_income_base_dianbo b, mobilenodist m
   where t.appcode = b.appcode
     and substr(t.mobile, 1, 7) = m.beginno
     and t.deal_date in ('2016-06-30')
     and  t.appcode in ('10411014', '10201072', '10201073')
       select * from tb_theory_income_base_dianbo b where b.oper_name_real like '%手机商界%'
   truncate table WANGYUAN_TMP
   select w.mobile,w.appcode,sum(w.totals),'2016-06-30' from WANGYUAN_TMP w group by w.mobile,w.appcode 
   
    select sum(w.totals) from WANGYUAN_TMP w 
    delete   tmp_dianbo_day where deal_date = '2016-06-30'
       and appcode in ('10411014', '10201072', '10201073')
    
    select count(*)
      from tmp_dianbo_day
     where deal_date = '2016-06-30'
       and appcode in ('10411014', '10201072', '10201073')
    
