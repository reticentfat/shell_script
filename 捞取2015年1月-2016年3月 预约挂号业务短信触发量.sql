
---服务器所在地址：192.100.7.5
--日志地址：/data/www/ef/server/log/2015/月份/12_01.log
--CP列表：详见cp_dict.php
--日志内容：见下图
--日志字段：

--eg：[ 2015-12-01T00:00:01+08:00 ]	INFO: "112.4.28.17 POST type=sms HTTP/1.1"|13816119004|恭喜你138*******4成功注册为guahao.com用户。使用手机客户端，让您随时随地查询预约!点击 t.cn/zHvxjBZ 下载。【挂号网】|12580PRECONTRACT|d112814c9b89f7786d788754d2f2e6ad|20151201000000041819|2|10101055|1065888042345|single
-----------带post为上行，cp到网关
-----------不带post为上行，网关到cp
'12580PRECONTRACT'=>'longCode'      => array('1065888042345'),
		
		
--各字段用|分割：IP|手机号|内容|CP名|密码|时间戳|短信类型|appcode|longCode|单发or群发
cd /data/www/ef/server/log/2015/
cat ./{10,01,02,03,04,05,06,07,08,09,11,12}/*.log| awk -F'|' '$1!~/POST/{print $1}' | awk -F':' '{print substr($1,8,2)"|"$5}' |  sort | uniq -c | sort -rn | awk '{print $2"|"$3"|"$1}' >result.txt
cat ./{10,01,02,03,04,05,06,07,08,09,11,12}/*.log | awk -F'|' '$4=="12580PRECONTRACT"{print }' |  grep '挂号网' | awk -F'|' '$1~/POST/{print $1}'  | awk -F':' '{print substr($1,3,7)}' |  sort | uniq -c | sort -rn | awk '{print $2"|"$1}' >result_2015_1.txt
cat ./{10,01,02,03,04,05,06,07,08,09,11,12}/*.log | awk -F'|' '$4=="12580PRECONTRACT"{print }' |  grep '【挂号网/12580】' | awk -F'|' '$1~/POST/{print $1}'  | awk -F':' '{print substr($1,3,7)}' |  sort | uniq -c | sort -rn | awk '{print $2"|"$1}' >result_2015_2.txt
cat ./{10,01,02,03,04,05,06,07,08,09,11,12}/*.log | awk -F'|' '$4=="12580PRECONTRACT"{print }' |  grep '【挂号网】' | awk -F'|' '$1~/POST/{print $1}'  | awk -F':' '{print substr($1,3,7)}' |  sort | uniq -c | sort -rn | awk '{print $2"|"$1}' >result_2015_3.txt
cat ./{01,02,03}/*.log | awk -F'|' '$4=="12580PRECONTRACT"{print }' |  grep '挂号网' | awk -F'|' '$1~/POST/{print $1}'  | awk -F':' '{print substr($1,3,7)}' |  sort | uniq -c | sort -rn | awk '{print $2"|"$1}' >result_2016_1.txt
cat ./{01,02,03}/*.log | awk -F'|' '$4=="12580PRECONTRACT"{print }' |  grep '【挂号网/12580】' | awk -F'|' '$1~/POST/{print $1}'  | awk -F':' '{print substr($1,3,7)}' |  sort | uniq -c | sort -rn | awk '{print $2"|"$1}' >result_2016_2.txt
cat ./{01,02,03}/*.log | awk -F'|' '$4=="12580PRECONTRACT"{print }' |  grep '【挂号网】' | awk -F'|' '$1~/POST/{print $1}'  | awk -F':' '{print substr($1,3,7)}' |  sort | uniq -c | sort -rn | awk '{print $2"|"$1}' >result_2016_3.txt
