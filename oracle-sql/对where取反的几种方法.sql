--------------------1子查询
select *
from jf_1
where (mobile,appcode) not in 
(select mobile,appcode
  from jf_1 j 
 where 
j.opt_code in ('佛山', '东莞')
   and j.appcode in ('-UMGWZJS',
                     '-UMGJTXM',
                     '-UMGCZMSC',
                     '-UMGCZMSD',
                     '-UMGCZMSE',
                     '-UMGCZMSF',
                     '-UMGCZMSG',
                     '-UMGCZMSH',
                     '-UMGCZMSJ')
    or j.opt_code in ('中山', '深圳', '珠海', '广州', '湛江')
   and j.appcode in ('-UMGCZMSA',
                     '-UMGCZMSB',
                     '-UMGCZMSC',
                     '-UMGCZMSD',
                     '-UMGCZMSE',
                     '-UMGCZMSF',
                     '-UMGCZMSG',
                     '-UMGCZMSH',
                     '-UMGCZMSJ'))
                     
----------------------                     2在where 前添加not
select *
  from jf_1 j 
 where 
NOT(j.opt_code in ('佛山', '东莞')
   and j.appcode in ('-UMGWZJS',
                     '-UMGJTXM',
                     '-UMGCZMSC',
                     '-UMGCZMSD',
                     '-UMGCZMSE',
                     '-UMGCZMSF',
                     '-UMGCZMSG',
                     '-UMGCZMSH',
                     '-UMGCZMSJ')
    or j.opt_code in ('中山', '深圳', '珠海', '广州', '湛江')
   and j.appcode in ('-UMGCZMSA',
                     '-UMGCZMSB',
                     '-UMGCZMSC',
                     '-UMGCZMSD',
                     '-UMGCZMSE',
                     '-UMGCZMSF',
                     '-UMGCZMSG',
                     '-UMGCZMSH',
                     '-UMGCZMSJ'))
-----------------------          3minus
select *
  from jf_1 j
minus
select *
  from jf_1 j 
 where 
NOT(j.opt_code in ('佛山', '东莞')
   and j.appcode in ('-UMGWZJS',
                     '-UMGJTXM',
                     '-UMGCZMSC',
                     '-UMGCZMSD',
                     '-UMGCZMSE',
                     '-UMGCZMSF',
                     '-UMGCZMSG',
                     '-UMGCZMSH',
                     '-UMGCZMSJ')
    or j.opt_code in ('中山', '深圳', '珠海', '广州', '湛江')
   and j.appcode in ('-UMGCZMSA',
                     '-UMGCZMSB',
                     '-UMGCZMSC',
                     '-UMGCZMSD',
                     '-UMGCZMSE',
                     '-UMGCZMSF',
                     '-UMGCZMSG',
                     '-UMGCZMSH',
                     '-UMGCZMSJ'))
