----三季度每月每端口两条---
select * from 
(select r.*,
                        row_number() over(partition by r.receiver,substr(r.dealtime,0,8) order by r.sender desc) RN
                   from R200904_201710 r 
                   where r.dealtime >='20170701000000' 
and r.dealtime <'20171001000000' )
          where RN <= 2
          -----拆分---
          cat a.txt | awk -F'|' '{d=substr($7,5,4)".txt";print $0>> d;}'
