#/bin/sh
# --------------------                              --------------------
# ||||||||||||||||||||   END CONFIGURATION SECTION  ||||||||||||||||||||
export PATH=/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/data/app/oracle/product/11.2.0/db/bin/
export ORACLE_HOME=/data/app/oracle/product/11.2.0/db

export ORACLE_SID=wreportdb
ORACLE_NLS=$ORACLE_HOME/nls/data ;
export ORACLE_NLS
NLS_LANG="simplified chinese"_china.ZHS16CGB231280 ;
export NLS_LANG
#export LANG=zh_CN
#export LC_ALL=zh_CN.UTF-8
#./home/oracle/.bash_profile
usage () {
    echo "usage: $0 REPORT_DIR " 1>&2
    exit 2
}

if [ $# -lt 1 ] ; then
    usage
fi

ERROR=0

REPORT_DIR=$1

if [ ! -d "$REPORT_DIR" ]; then
  echo "$REPORT_DIR not found"
  exit 1
fi

#.............
DIR_YEAR=`date --date='19 days ago' +%Y` 
BEGIN_DEALDATE=`date --date='19 days ago' +%Y-%m`
BEGIN_NAME=`date --date='19 days ago' +%Y%m`
CITY_NAME=report.region.wireless_city.txt
PROV_NAME=report.region.wireless_province.txt
COUNTRY_NAME=report.region.wireless_country.txt

CITY_NAMEBUSINESS=report.region.buss.wireless_city.txt
PROV_NAMEBUSINESS=report.region.buss.wireless_province.txt
COUNTRY_NAMEBUSINESS=report.region.buss.wireless_country.txt
SJCITY_NAMEBUSINESS=report.region.sj_buss.wireless_city.txt
TJ_NAME=report.region.wireless_tuijian_province.txt
LJ_NAME=report.region.lj_buss_wireless_province.txt

DIR_MONTH=month_${BEGIN_NAME}

cd $REPORT_DIR

if [ ! -d "$DIR_YEAR" ]; then
  mkdir $DIR_YEAR
fi

cd $DIR_YEAR

if [ ! -d "$DIR_MONTH" ]; then
  mkdir $DIR_MONTH 
fi


##...... ..spool..
sqlplus -s ptj/ptj@wreportdb<<!

set heAding off feedback off  linesize 1024 pause off echo off tab off timing off pagesize 0 newpage 1 trimsPOOL ON term off

spool on;

Spool $REPORT_DIR/$DIR_YEAR/$DIR_MONTH/$CITY_NAME;
select '省ID,市ID,省名称,市名称,前向包月业务用户数,包月计费用户数,点播用户数,预估包月信息费,点播信息费预估'
from ptj.tb_rpt_all_month where 1=1 and rownum=1;
select nvl(A.PROVID,'000')||','||nvl(A.CITYID,'000')||','||nvl(A.Provname,'未知')||','||nvl(A.Cityname,'未知')||','||sum(QXBYYW_USERNO)||','||sum(BYJF_USERNO)||','||sum(DB_USERNO)||','||sum(YG_BYXXF)||','||sum(YG_DBXXF) from PTJ.TB_RPT_ALL_month  w, PTJ.AREA_CITY A where w.pro_id=a.provid(+)  and w.city_id= a.cityid(+)  and DEAL_DATE='$BEGIN_DEALDATE' and PRO_ID !='999' group by a.cityname,a.cityid,a.provname,a.provid;
spool off;


spool on;
spool $REPORT_DIR/$DIR_YEAR/$DIR_MONTH/$PROV_NAME;
select '省ID,省名称,前向包月业务用户数,包月计费用户数,点播用户数,预估包月信息费,点播信息费预估,累计预估包月信息费,累计点播信息费预估'
from ptj.tb_rpt_all_month where 1=1 and rownum=1;
 select PRO_ID||','||PRO_NAME||','||QXBYYW_USERNO||','||BYJF_USERNO||','||DB_USERNO||','||YG_BYXXF||','||YG_DBXXF||','||t.lj_byxxf||','||t.lj_dbxxf from tb_rpt_all_month_lj t, (select PRO_ID,PRO_NAME,sum(QXBYYW_USERNO) QXBYYW_USERNO ,sum(BYJF_USERNO) BYJF_USERNO,sum(DB_USERNO) DB_USERNO,sum(YG_BYXXF) YG_BYXXF,sum(YG_DBXXF) YG_DBXXF ,DEAL_DATE from tb_rpt_all_month 
where DEAL_DATE='$BEGIN_DEALDATE'  and PRO_ID !='999' group by PRO_ID,PRO_NAME,DEAL_DATE order by PRO_ID) m where t.proid=m.pro_id and t.deal_date=m.deal_date and t.proid !='999' and t.deal_date='$BEGIN_DEALDATE';
spool off;




spool on;
spool $REPORT_DIR/$DIR_YEAR/$DIR_MONTH/$LJ_NAME;
select '省ID,省名称,累计预估包月信息费,累计点播信息费预估'
from ptj.tb_rpt_all_month where 1=1 and rownum=1;  
select PRO_ID||','||PRO_NAME||','||t.ljsj_byxxf||','||t.lj_dbxxf from tb_rpt_all_month_lj t, (select PRO_ID,PRO_NAME,sum(QXBYYW_USERNO) QXBYYW_USERNO ,sum(BYJF_USERNO) BYJF_USERNO,sum(DB_USERNO) DB_USERNO,sum(YG_BYXXF) YG_BYXXF,sum(YG_DBXXF) YG_DBXXF ,DEAL_DATE from tb_rpt_all_month  where DEAL_DATE='$BEGIN_DEALDATE'  and PRO_ID !='999' group by PRO_ID,PRO_NAME,DEAL_DATE order by PRO_ID) m where t.proid=m.pro_id and t.deal_date=m.deal_date and t.proid !='999' and t.deal_date='$BEGIN_DEALDATE';
spool off;





spool on;
spool $REPORT_DIR/$DIR_YEAR/$DIR_MONTH/$COUNTRY_NAME;
select '全国合计,前向包月业务用户数,包月计费用户数,点播用户数,预估包月信息费,点播信息费预估,累计预估包月信息费,累计点播信息费预估'
from ptj.tb_rpt_all_month where 1=1 and rownum=1;
select CITY_NAME||','||QXBYYW_USERNO||','||BYJF_USERNO||','||DB_USERNO||','||YG_BYXXF||','||YG_DBXXF||','||t.LJ_BYXXF||','||t.LJ_DBXXF from PTJ.TB_RPT_ALL_month m,PTJ.TB_RPT_ALL_month_lj t where m.deal_date=t.deal_date and m.pro_id=t.proid and m.DEAL_DATE='$BEGIN_DEALDATE' and PRO_ID='999' and t.DEAL_DATE='$BEGIN_DEALDATE' and t.PROID='999';
spool off;



spool on;
Spool $REPORT_DIR/$DIR_YEAR/$DIR_MONTH/$CITY_NAMEBUSINESS;
select '省ID,市ID,省名称,市名称,前向包月业务用户数,包月计费用户数,点播用户数,预估包月信息费,点播信息费预估,业务名称'
from ptj.tb_rpt_all_month where 1=1 and rownum=1;
select nvl(A.PROVID,'000')||','||nvl(A.CITYID,'000')||','||nvl(A.Provname,'未知')||','||nvl(A.Cityname,'未知')||','||nvl(sum(QXBYYW_USERNO),0)||','||nvl(sum(BYJF_USERNO),0)||','||nvl(sum(DB_USERNO),0)||','||nvl(sum(YG_BYXXF),0)||','||nvl(sum(YG_DBXXF),0)||','||oper_name  from PTJ.TB_RPT_ALL_month_opername  w, PTJ.AREA_CITY A where w.pro_id=a.provid(+)  and w.city_id= a.cityid(+)  and DEAL_DATE='$BEGIN_DEALDATE' and PRO_ID !='999' group by w.oper_name,a.cityname,a.cityid,a.provname,a.provid;
spool off;



spool on;
Spool $REPORT_DIR/$DIR_YEAR/$DIR_MONTH/$SJCITY_NAMEBUSINESS;
select '省ID,市ID,省名称,市名称,前向包月业务用户数,包月计费用户数,点播用户数,预估包月信息费,点播信息费预估,业务名称'
from ptj.tb_rpt_all_month where 1=1 and rownum=1;
select nvl(A.PROVID,'000')||','||nvl(A.CITYID,'000')||','||nvl(A.Provname,'未知')||','||nvl(A.Cityname,'未知')||','||nvl(sum(QXBYYW_USERNO),0)||','||nvl(sum(BYJFSJ_USERNO),0)||','||nvl(sum(DB_USERNO),0)||','||nvl(sum(SJ_BYXXF),0)||','||nvl(sum(YG_DBXXF),0)||','||oper_name  from PTJ.TB_RPT_ALL_month_opername  w, PTJ.AREA_CITY A where w.pro_id=a.provid(+)  and w.city_id= a.cityid(+)  and DEAL_DATE='$BEGIN_DEALDATE' and PRO_ID !='999' group by w.oper_name,a.cityname,a.cityid,a.provname,a.provid;
spool off;






spool on;
spool $REPORT_DIR/$DIR_YEAR/$DIR_MONTH/$PROV_NAMEBUSINESS;
select '省ID,省名称,前向包月业务用户数,包月计费用户数,点播用户数,预估包月信息费,点播信息费预估,业务名称'
from ptj.tb_rpt_all_month where 1=1 and rownum=1;
 select PRO_ID||','||PRO_NAME||','||nvl(sum(QXBYYW_USERNO),0)||','||nvl(sum(BYJF_USERNO),0)||','||nvl(sum(DB_USERNO),0)||','||nvl(sum(YG_BYXXF),0)||','||nvl(sum(YG_DBXXF),0)||','||OPER_NAME from tb_rpt_all_month_OPERNAME  where DEAL_DATE='$BEGIN_DEALDATE'  and PRO_ID !='999' group by PRO_ID,PRO_NAME,DEAL_DATE,oper_name order by PRO_ID;
spool off;


spool on;
set echo off
spool $REPORT_DIR/$DIR_YEAR/$DIR_MONTH/$COUNTRY_NAMEBUSINESS;
select '全国合计,前向包月业务用户数,包月计费用户数,点播用户数,预估包月信息费,点播信息费预估,业务名称'
from ptj.tb_rpt_all_month where 1=1 and rownum=1;
select CITY_NAME||','||nvl(QXBYYW_USERNO,0)||','||nvl(BYJF_USERNO,0)||','||nvl(DB_USERNO,0)||','||nvl(YG_BYXXF,0)||','||nvl(YG_DBXXF,0)||','||OPER_NAME from PTJ.TB_RPT_ALL_month_OPERNAME m  where m.DEAL_DATE='$BEGIN_DEALDATE' and PRO_ID='999';
spool off;

spool on;
set echo off
spool $REPORT_DIR/$DIR_YEAR/$DIR_MONTH/$TJ_NAME;
select '省份编码,省份名称,坐席工号,推荐业务名称,推荐次数,推荐成功次数,成功订制次数'
from ptj.tb_rpt_all_month where 1=1 and rownum=1;
select prov_code||','||prov_name||','||staffno||','||oper_name||','||nvl(sum(recommend_num),0)||','||nvl(sum(success_reco_num),0)||','||nvl(sum(threeday_reco_num),0) from PTJ.tb_rpt_recommend_month  m  where m.DEAL_DATE='$BEGIN_DEALDATE'  group by  prov_code,prov_name,staffno,oper_name;
spool off;


!
      
       
      
     
   
    
     
      
       
iconv -f GB2312 -t UTF-8   $REPORT_DIR/$DIR_YEAR/$DIR_MONTH/report.region.wireless_city.txt  > $REPORT_DIR/$DIR_YEAR/$DIR_MONTH/report.region.wireless_city.csv  ;
iconv -f GB2312 -t UTF-8   $REPORT_DIR/$DIR_YEAR/$DIR_MONTH/report.region.wireless_province.txt > $REPORT_DIR/$DIR_YEAR/$DIR_MONTH/report.region.wireless_province.csv ;
iconv -f GB2312 -t UTF-8   $REPORT_DIR/$DIR_YEAR/$DIR_MONTH/report.region.wireless_country.txt >  $REPORT_DIR/$DIR_YEAR/$DIR_MONTH/report.region.wireless_country.csv ;
 

iconv -f GB2312 -t UTF-8   $REPORT_DIR/$DIR_YEAR/$DIR_MONTH/report.region.buss.wireless_city.txt  > $REPORT_DIR/$DIR_YEAR/$DIR_MONTH/report.region.buss_wireless_city.csv  ;
iconv -f GB2312 -t UTF-8   $REPORT_DIR/$DIR_YEAR/$DIR_MONTH/report.region.buss.wireless_province.txt > $REPORT_DIR/$DIR_YEAR/$DIR_MONTH/report.region.buss_wireless_province.csv ;
iconv -f GB2312 -t UTF-8   $REPORT_DIR/$DIR_YEAR/$DIR_MONTH/report.region.buss.wireless_country.txt >  $REPORT_DIR/$DIR_YEAR/$DIR_MONTH/report.region.buss_wireless_country.csv ;
iconv -f GB2312 -t UTF-8   $REPORT_DIR/$DIR_YEAR/$DIR_MONTH/report.region.sj_buss.wireless_city.txt  > $REPORT_DIR/$DIR_YEAR/$DIR_MONTH/report.region.sj_buss_wireless_city.csv  ;
iconv -f GB2312 -t UTF-8   $REPORT_DIR/$DIR_YEAR/$DIR_MONTH/report.region.wireless_tuijian_province.txt >  $REPORT_DIR/$DIR_YEAR/$DIR_MONTH/report.region.wireless_tuijian_province.csv

iconv -f GB2312 -t UTF-8   $REPORT_DIR/$DIR_YEAR/$DIR_MONTH/report.region.lj_buss_wireless_province.txt  > $REPORT_DIR/$DIR_YEAR/$DIR_MONTH/report.region.lj_buss_wireless_province.csv  ;


rm $REPORT_DIR/$DIR_YEAR/$DIR_MONTH/*.txt
rm  $REPORT_DIR/$DIR_YEAR/*.lst

#scp $REPORT_DIR/$DIR_YEAR/$DIR_MONTH/report.region.wireless_tuijian_province.csv oracle@172.16.100.158:/$REPORT_DIR/$DIR_YEAR/$DIR_MONTH/

#rsync -v -z -r  -e 'ssh -l channel_wi' $REPORT_DIR/*_2009*  172.16.101.196:/logs/out/dana/channel_report/wi/ 
#rsync -v -z -r  -e 'ssh -l channel_wi' $REPORT_DIR/*_2009*  172.16.101.197:/logs/out/dana/channel_report/wi/ 

##select A.PROVID||',',A.CITYID||',',A.Provname||',',A.Cityname||',',sum(QXBYYW_USERNO)||',',sum(BYJF_USERNO)||',',sum(DB_USERNO)||',',sum(YG_BYXXF)||',',sum(YG_DBXXF) from PTJ.TB_RPT_ALL_month  w, PTJ.AREA_CITY A where w.pro_id=a.provid(+)  and w.city_id= a.cityid(+)  and DEAL_DATE='$BEGIN_DEALDATE' and PRO_ID !='999' group by a.cityname,a.cityid,a.provname,a.provid;


