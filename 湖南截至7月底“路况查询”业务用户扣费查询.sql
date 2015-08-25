select t.mobile_sn 用户号码,
       o.opt_cost 业务名称,
       o.fee 资费,
       to_char(t.prior_time, 'yyyy-mm-dd hh24:mi:ss') 订购时间,
       to_char(t.mobile_modify_time, 'yyyy-mm-dd hh24:mi:ss') 退订时间,
       n.province 省份,
       n.city 地市
       
  from new_wireless_subscription t, mobilenodist n, opt_code o
 where substr(t.mobile_sn, 1, 7) = n.beginno
   and n.province = '湖南'
   and t.appcode = o.appcode
   and t.appcode='10301044'
  -------------上边是明细下边是扣费明细-------------
cat /data0/2015/20150731/qiangxiang_sms_pay_users.txt  | grep ',731,' | awk -F',' '{if($2=="10301044")print }' > /home/oracle/hunan_hnkl.txt
awk -F',' -v CODE_DIR=/data0/match/orig/mm7/20150731/stats_month.wuxian_qianxiang.0 -v fileok=/home/oracle/hunan_hnkl_ok.txt -v fileno=/home/oracle/hunan_hnkl_0.txt '{
if( FILENAME == CODE_DIR&& $3>=5 ) d[$1$2]=$1","$2","$3; 
else if ( FILENAME != CODE_DIR && substr($2,1,3) == "103" && $1$2 in d ) print >> fileok ; 
else if ( FILENAME != CODE_DIR && substr($2,1,3) == "103" && !($1$2 in d )) print >> fileno ; 
}' /data0/match/orig/mm7/20150731/stats_month.wuxian_qianxiang.0 /home/oracle/hunan_hnkl.txt
----------因为路况查询资费为10元所以下行数量得大于等于5（10/2）------------------------
