#158上
bzcat /data0/match/orig/20150228/snapshot.txt.bz2 | awk -F'|' '{if ($8=="0431"&&$2=="10511051"&&$5>=20150101000000&&$5<20150201000000) print $1 }' >1yue.txt
bzcat /data0/match/orig/20150228/snapshot.txt.bz2 | awk -F'|' '{if ($8=="0431"&&$2=="10511051"&&$5>=20150201000000&&$5<20150301000000) print $1 }' >2yue.txt
bzcat /data0/match/orig/20150331/snapshot.txt.bz2 | awk -F'|' '{if ($8=="0431"&&$2=="10511051"&&$5>=20150301000000&&$5<20150401000000) print $1 }' >3yue.txt
bzcat /data0/match/orig/20150430/snapshot.txt.bz2 | awk -F'|' '{if ($8=="0431"&&$2=="10511051"&&$5>=20150401000000&&$5<20150501000000) print $1 }' >4yue.txt
bzcat /data0/match/orig/20150531/snapshot.txt.bz2 | awk -F'|' '{if ($8=="0431"&&$2=="10511051"&&$5>=20150501000000&&$5<20150601000000) print $1 }' >5yue.txt
bzcat /data0/match/orig/20150630/snapshot.txt.bz2 | awk -F'|' '{if ($8=="0431"&&$2=="10511051"&&$5>=20150601000000&&$5<20150701000000) print $1 }' >6yue.txt
------------下载到本地匹配城市-----------
awk -F'[\t,]' -v CODE_DIR=nodist_umgstat.txt '{ if(FILENAME==CODE_DIR) d[$4]=$2 ; else if((substr($1,1,7) in d) ) print $1"\t"d[substr($1,1,7)];  }' nodist_umgstat.txt  1yue.txt>吉林一月法律百科彩信版新增明细12673.txt
awk -F'[\t,]' -v CODE_DIR=nodist_umgstat.txt '{ if(FILENAME==CODE_DIR) d[$4]=$2 ; else if((substr($1,1,7) in d) ) print $1"\t"d[substr($1,1,7)];  }' nodist_umgstat.txt  2yue.txt>吉林二月法律百科彩信版新增明细4624.txt
awk -F'[\t,]' -v CODE_DIR=nodist_umgstat.txt '{ if(FILENAME==CODE_DIR) d[$4]=$2 ; else if((substr($1,1,7) in d) ) print $1"\t"d[substr($1,1,7)];  }' nodist_umgstat.txt  3yue.txt>吉林三月法律百科彩信版新增明细1804.txt
awk -F'[\t,]' -v CODE_DIR=nodist_umgstat.txt '{ if(FILENAME==CODE_DIR) d[$4]=$2 ; else if((substr($1,1,7) in d) ) print $1"\t"d[substr($1,1,7)];  }' nodist_umgstat.txt  4yue.txt>吉林四月法律百科彩信版新增明细15348.txt
awk -F'[\t,]' -v CODE_DIR=nodist_umgstat.txt '{ if(FILENAME==CODE_DIR) d[$4]=$2 ; else if((substr($1,1,7) in d) ) print $1"\t"d[substr($1,1,7)];  }' nodist_umgstat.txt  5yue.txt>吉林五月法律百科彩信版新增明细28405.txt
awk -F'[\t,]' -v CODE_DIR=nodist_umgstat.txt '{ if(FILENAME==CODE_DIR) d[$4]=$2 ; else if((substr($1,1,7) in d) ) print $1"\t"d[substr($1,1,7)];  }' nodist_umgstat.txt  6yue.txt>吉林五月法律百科彩信版新增明细18130.txt
