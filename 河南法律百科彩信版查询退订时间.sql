导入jf_1查询截止目前在线的
select j.mobile, to_char(n.expire_time, 'yyyy-mm-dd hh24:mi:ss') 到期时间
  from jf_1 j
  left join new_wireless_subscription n on j.mobile = n.mobile_sn
                                       and j.appcode = n.appcode
                                       ---然后在txt文件上传问服务器查询历史退订信息---
                                       ---注意文件许转换为unix格式--------
         oracle@wreport:/home/oracle$ bzcat /home/oracle/wy.txt.bz2  /home/oracle/etl/data/data/snapshot/archives.txt.bz2  | awk -F'[|^]' '{if(NF==2) aa[$1$2]=$1$2;else if(($2$6 in aa))  print $2","$6","$7","$8}' | bzip2 > /home/oracle/js.txt.bz2                              
