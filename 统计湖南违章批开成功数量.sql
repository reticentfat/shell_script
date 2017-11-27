--7.45
select  DATE_FORMAT(w.OPTTIME, '%Y-%m-%d'),count(w.MOBILE_SN) from  wzcx_log w where w.OPT_TYPE = '1000'
and w.OPT_ADDR='HUNAN'
and w.OPTTIME  >= '2017-11-20'
   and w.OPTTIME < '2017-11-27'
group by  DATE_FORMAT(w.OPTTIME, '%Y-%m-%d')
