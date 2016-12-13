---25上
sudo -s
su shujuyzx
ssh shujuyzx@172.200.5.31
---到172.200.5.31上----
bzcat monster-cmppmt.log*.bz2 | awk -F',' '$15=="10101000"||$15=="10101026"{print $0}' | wc -l 
cd /logs/archives/monster
bzcat ./20161[0-2][0-3][0-9]/monster-cmppmt.log*.bz2 | awk -F',' '$15=="10101000"||$15=="10101026"{print $0}' >~/10_12.txt&
bzcat ./20160[6-9][0-3][0-9]/monster-cmppmt.log*.bz2 | awk -F',' '$15=="10101000"||$15=="10101026"{print $0}' >~/6_9.txt&
[2] 30682 30683
--------查看生成完没---
ls -lh *.txt
-------------然后整合提取需要字段排重----------
cat 6_9.txt 10_12.txt | head -5
cat 6_9.txt 10_12.txt | awk -F',' '{print $5,$10,$15,$NF}' | sort -u > 6_12_final.txt&
--------压缩---
bzip2 6_12_final.txt
--------传到25---------
scp 6_12_final.txt.bz2 gateway@192.100.7.25:/home/gateway/quanliang_mail/
