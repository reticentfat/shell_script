 select * from bjwz
where mobile_sn in (select   mobile_sn from   bjwz  b where   b.opt_addr='BEIJING' group by   mobile_sn having count(mobile_sn) > 1)
