---192.100.7.25上
sudo -s
su shujuyzx
ssh shujuyzx@172.200.5.31
ssh shujuyzx@192.100.6.39
cd /data/shujuyzx/consist/
---文件夹为需要发送日期比如15号的就进入当年当月15
cd 20160215
--scp FLAT_20160217010000_0042531.0001304771.gz gateway@192.100.7.25:/home/gateway/quanliang_mail/
scp *.gz gateway@192.100.7.25:/home/gateway/quanliang_mail/
scp FLAT_20160217010000_0042451.0000072102.gz gateway@192.100.7.25:/home/gateway/quanliang_mail/
然后下载FLAT_20160215010000_0042220.0000367450.gz
220为省份代码
---山东拆分违章和非违章两个文件---
-UMGCHTXA（应该为-UMGCZFW）
-UMGWZJST
cat FLAT_20160217010000_0042531.0001304771 | awk -F'|' '$6=="-UMGCZFW"||$6=="-UMGWZJST"{print }' > wz.txt
cat FLAT_20160217010000_0042531.0001304771 | awk -F'|' '$6!="-UMGCZFW"&&$6!="-UMGWZJST"{print }' > FLAT_20160217010000_0042531.0001214700
提取时间
省份数
省份详细
2月14日0点
19
北京、 广东 、上海 、辽宁、 湖北 、陕西、 河南、 吉林、 山东、 安徽、 浙江、 广西、 江西 、云南、  海南、 福建、 甘肃、 宁夏、 新疆
2月15日0点
12
天津、四川、西藏、内蒙、贵州、青海、黑龙江、 江苏、河北、山西、重庆、湖南
2月16日0点
1
山东
2月18日1点
31
全国
2月25日0点
1
黑龙江
awk -F'[\t|]' -v CODE_DIR=nodist_umgstat.txt '{ if(FILENAME==CODE_DIR) d[$4]=$1 ; else if((substr($1,1,7) in d) ) print $1"|";  }' nodist_umgstat.txt  weizhang0451.txt>1.txt
