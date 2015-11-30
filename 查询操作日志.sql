172.200.5.31上
到/data/logs/archives/usa2/文件夹下查询usa2-access.log.201511202100.bz2文件
例如
[root@wbird2 /data/logs/archives/usa2]# bzcat ./2015112[0-9]/usa2-access.log* | grep '13971651069'
