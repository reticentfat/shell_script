--select * from  MOBILENODIST 
select * from recommend_dictype r where r.lotteryname like '%违章%'
	
--日期  工号  产生订购关系数 计费总数
select *
  from recommend_recode r 
  
 where r.ccid like '%871%'
   and r.dotime >= to_date('2015-09-01', 'YYYY-MM-DD')
   and r.dotime < to_date('2015-09-23', 'YYYY-MM-DD')

select  substr(to_char(r.dotime, 'yyyy-mm-dd hh24:mi:ss'), 1, 10) 日期,
             m.province 省份名称,
             r.staffno 坐席工号,
              d.lotteryname  业务名称,
              r.mobile 客户号码
               
          from recommend_recode          r,
               recommend_dictype         d,
               MOBILENODIST              m
         where 
         SUBSTR(ltrim(r.mobile, '	'), 1, 7) = m.BEGINNO(+)
           -- n.mobile_sn = SUBSTR(ltrim(r.mobile, '	'), 1, 11)
           -- n.appcode = d.appcode
         and   ltrim(r.serviceid, '	') = to_char(d.id)
           --and d.status = 1
           --and length(r.staffno) >= 3
           and r.dotime >= to_date('2015-09-01', 'YYYY-MM-DD') --
           and r.dotime < to_date('2015-09-23', 'YYYY-MM-DD') --
           --and mobile_sub_time >= to_date('2015-09-01', 'YYYY-MM-DD')
           --and mobile_sub_time < to_date('2015-09-23', 'YYYY-MM-DD')
           and d.type in (1, 3) --0 短信点播  1 短信  2 彩信点播 3 彩信包月
           and r.ccid like '%871%'
           --and m.province='云南'
        
         
       
union all
select  substr(to_char(r.dotime, 'yyyy-mm-dd hh24:mi:ss'), 1, 10) 日期,
             m.province 省份名称,
             r.staffno 坐席工号,
              '祝福我帮您'  业务名称,
              r.mobile 客户号码
               
          from recommend_recode          r,
              
               MOBILENODIST              m
         where 
         SUBSTR(ltrim(r.mobile, '	'), 1, 7) = m.BEGINNO(+)
           -- n.mobile_sn = SUBSTR(ltrim(r.mobile, '	'), 1, 11)
           -- n.appcode = d.appcode
        -- and   ltrim(r.serviceid, '	') = to_char(d.id)
           --and d.status = 1
           --and length(r.staffno) >= 3
           and r.dotime >= to_date('2015-09-01', 'YYYY-MM-DD') --
           and r.dotime < to_date('2015-09-23', 'YYYY-MM-DD') --
           --and mobile_sub_time >= to_date('2015-09-01', 'YYYY-MM-DD')
           --and mobile_sub_time < to_date('2015-09-23', 'YYYY-MM-DD')
           --and d.type in (1, 3) --0 短信点播  1 短信  2 彩信点播 3 彩信包月
           and r.ccid like '%871%'
           --and m.province='云南'
           and r.serviceid='001'
