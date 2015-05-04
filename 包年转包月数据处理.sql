十二月北京各年套餐到期用户列表提取
十二月各年套餐业务到期用户（包括已暂停和在订购）请帮忙提前提一下吧； 
1、具体业务：
彩票各包年业务（共七个）
全能助理半年包
营养百科短、彩半年包
2、提取数据字段：
业务名称  业务代码  本月底到期用户手机号     该用户开通业务时间    用户状态（在线、暂停）

select t.mobile_sn 用户号码,
       o.opt_cost  业务名称,
       o.jfcode    业务代码,
       t.servcode  SERVCODE,
       --to_char(t.mobile_sub_time, 'yyyy-mm-dd hh24:mi:ss') 首次订购时间,
       to_char(t.prior_time, 'yyyy-mm-dd hh24:mi:ss') 开通时间,
       to_char(t.expire_time, 'yyyy-mm-dd hh24:mi:ss') 到期时间,
       case
         when t.is_paused = 1 then
          '在线'
         when t.is_paused = 0 then
          '暂停'
       end 用户状态
  from new_wireless_subscription t, opt_code o, mobilenodist n
 where substr(t.mobile_sn, 1, 7) = n.beginno
   and t.appcode = o.appcode
   and n.city = '北京'
   and t.mobile_sub_state = 3
   and substr(to_char(t.expire_time, 'yyyy-mm-dd hh24:mi:ss'), 1, 7) = '2015-03'
   and t.appcode in ('10324001', '10324002', '10324003', '10324004', '10324005',
                     '10324006', '10324007', '10511039', '10511043', '10301093')
--and t.mobile_sub_time != t.prior_time



========================================整理批退格式



 select  'http://172.16.88.67:8888/cancel?id='||t.mobile_sn||chr(38)||'servcode='||t.servcode||chr(38)||'longcode='||o.channel||chr(38)||'command='||o.unsub_cmd||chr(38)||'channel1=UNSUB_BOSS'
  from new_wireless_subscription t, opt_code o, mobilenodist n
 where substr(t.mobile_sn, 1, 7) = n.beginno
   and t.appcode = o.appcode
   and n.city = '北京'
   and t.mobile_sub_state = 3
   and substr(to_char(t.expire_time, 'yyyy-mm-dd hh24:mi:ss'), 1, 7) = '2015-03'
   and t.appcode in ('10324001', '10324002', '10324003', '10324004', '10324005',
                     '10324006', '10324007', '10511039', '10511043', '10301093')   








jf_1 : mobile,serial,opt_code,biz_code,opttime,subtime,cartype,job_num

select j.mobile, o.servcode, o.channel, o.unsub_cmd, j.serial
  from opt_code o, jf_1 j
 where o.jfcode = j.opt_code

cat new_wireless_subscription.txt |  awk -F'\t' '{ print "http://172.16.88.67:8888/cancel?id="$1"&servcode="$2"&longcode="$3"&command="$4"&channel1=UNSUB_BOSS"}' | unix2dos > new_wireless_subscription_ok.txt

====================================================














北京违章年套餐到期用户
209:
SELECT `MOBILE_SN` , `MOBILE_SUB_TIME` , `FEE_APP_CODE` , `SUB_COL_1`
FROM `wzcx_sub`
WHERE upper( `OPT_ADDR` ) = 'BEIJING'
AND `MOBILE_MODIFY_STATE` =3
AND `FEE_APP_CODE`
IN (
'B', 'D'
)
AND `SUB_COL_1` >= '2010-03-01'
AND `SUB_COL_1` < '2010-04-01'

jf_1 : mobile,subtime,cartype,opttime,job_num,opt_code,biz_code,serial

select j.mobile, o.opt_cost, o.jfcode, o.servcode, j.subtime, j.opttime, ''
  from jf_1 j, opt_code o
 where j.cartype = o.opt_type


平台与BOSS比对

tmp.awk

#!/bin/awk -f

BEGIN{
	FS=OFS="\t";
	optcost["北京违章包年15元"] = "违章及时通年包到期提醒";
	optcost["福彩3D包年"] = "福彩3D年套餐到期提醒";
	optcost["福彩7乐彩包年"] = "七乐彩年套餐到期提醒";
	optcost["排列3排列5包年"] = "排列三排列五年套餐到期提醒";
	optcost["全能助理彩信半年包"] = "全能助理彩信半年包到期提醒";
	optcost["双色球包年"] = "双色球年套餐到期提醒";
	optcost["体彩22选5包年"] = "体彩22选5年套餐到期提醒";
	optcost["体彩7星彩包年"] = "七星彩年套餐到期提醒";
	optcost["体彩大乐透包年"] = "超级大乐透年套餐到期提醒";
	optcost["营养百科彩信半年包"] = "营养百科彩信半年包到期提醒";
	optcost["营养百科短信半年包"] = "营养百科半年包到期提醒";
}
{
	if($2 in optcost) print $0,optcost[$2];
}

./tmp.awk flat_src.txt | unix2dos > flat.txt

逗号分隔
flat.txt 	mobile.jf_1 : mobile,opt_code,job_num,biz_code,subtime,opttime,cartype,serial
boss.txt 	mobile.jf	 : opt_code,mobile,opttime,cartype,job_num,biz_code,serial,subtime

select j.opt_code from jf_1 j group by j.opt_code

select j1.opt_code from jf j1 group by j1.opt_code

select j.mobile,
       j.opt_code,
       j.job_num,
       j.biz_code,
       j.subtime,
       j.opttime,
       j.cartype
  from jf_1 j
  left join jf j1 on j.mobile = j1.mobile
                 and j.serial = j1.opt_code
 where j1.mobile is null



select j1.opt_code, j1.mobile, j1.opttime
  from jf_1 j
 right join jf j1 on j.mobile = j1.mobile
                 and j.serial = j1.opt_code
 where j.mobile is null



select j.mobile,
       j.opt_code,
       j.job_num,
       j.biz_code,
       j.subtime,
       j.opttime,
       j.cartype,
       j1.opt_code,
       j1.mobile,
       j1.opttime
  from jf_1 j, jf j1
 where j.mobile = j1.mobile
   and j.serial = j1.opt_code
