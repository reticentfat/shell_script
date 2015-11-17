---2015年4-9月新疆优惠券下载量
---通过Navicat Premium
---在172.200.7.13上coupon库ondemand表上查询
SELECT
	count(o.mobile)
FROM
	ondemand o
WHERE
	o.source != '99'
and  LEFT(o.code,3) in ('991','996','999','902')
and  o.date>=str_to_date('2015-04-01','%Y-%m-%d')
and  o.date<str_to_date('2015-10-01','%Y-%m-%d')
