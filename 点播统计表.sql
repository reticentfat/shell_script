172.200.7.13coupon的ondemand表
SELECT LEFT(o.date,4) ,o.source,o.appcode,count(o.mobile) FROM ondemand o   GROUP BY LEFT(o.date,4) ,o.source , o.appcode
