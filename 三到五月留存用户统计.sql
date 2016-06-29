select   
count(distinct t1.mobile_sn)                  

 
from  new_wireless_subscription  t1 , mobilenodist t2   
where substr(t1.mobile_sn,1,7)=t2.beginno(+)   
  
    and  mobile_modify_time >to_date('2016-06-01 00:00:00','yyyy-mm-dd hh24:mi:ss')   
 
   and  mobile_sub_time  < to_date('2016-06-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 
   and  mobile_sub_time  >= to_date('2016-05-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 
and t2.province ='福建' 
----------------上边为五月----------------------
--这个为四月----
 bzcat /data/match/orig/20160501/snapshot.txt.bz2 | awk -F'|' '$3=="06"&&$2~/^1/&&$5>=20160401000000&&$5<20160501000000{print $1"|"$2}' |sort -u | wc -l
 bzcat /data/match/orig/20160501/snapshot.txt.bz2 | awk -F'|' '$3=="06"&&$8=="0591"&&$2~/^1/&&$5>=20160401000000&&$5<20160501000000{print $1"|"$2}' |sort -u | wc -l
  bzcat /data/match/orig/20160401/snapshot.txt.bz2 | awk -F'|' '$3=="06"&&$2~/^1/&&$5>=20160301000000&&$5<20160401000000{print $1"|"$2}' |sort -u | wc -l
 bzcat /data/match/orig/20160401/snapshot.txt.bz2 | awk -F'|' '$3=="06"&&$8=="0591"&&$2~/^1/&&$5>=20160301000000&&$5<20160401000000{print $1"|"$2}' |sort -u | wc -l
