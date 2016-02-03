---27上----
 --1、请协助分别调取2015年2月18日至20日，每日23：00——24：00、凌晨0：00——6：00两个时段的前向业务开通/取消/修改量。
 cd /data/match/orig/20150228
 bzcat snapshot.txt.bz2 user_sn.txt.bz2 | awk -F'|' '$8=="0471"&&$3=="06"&&substr($4,1,8)<="20150220"&&substr($4,1,8)>"20150217"{print $1"|"$2"|"$4}' | sort -u >nmg_06_0203.txt
  bzcat snapshot.txt.bz2 user_sn.txt.bz2 | awk -F'|' '$8=="0471"&&$3=="07"&&substr($4,1,8)<="20150220"&&substr($4,1,8)>"20150217"{print $1"|"$2"|"$4}' | sort -u >nmg_07_0203.txt
  导入excel提取日期MID(C2,7,2)小时MID(C2,9,2)，然后数据透视
   2、请协助分别调取2016年1月27日至2月2日每日23：00——24：00、凌晨0：00——6：00两个时段的前向业务开通/取消/修改量。
  cd /data/match/orig/20160201
   bzcat snapshot.txt.bz2 user_sn.txt.bz2 | awk -F'|' '$8=="0471"&&$3=="06"&&substr($4,1,8)<="20160202"&&substr($4,1,8)>"20160126"{print $1"|"$2"|"$4}' | sort -u >nmg_06_0204.txt
     bzcat snapshot.txt.bz2 user_sn.txt.bz2 | awk -F'|' '$8=="0471"&&$3=="07"&&substr($4,1,8)<="20160202"&&substr($4,1,8)>"20160126"{print $1"|"$2"|"$4}' | sort -u >nmg_07_0204.txt
