  #25上执行
  [gateway@wtraffic /data/match/cmpp]$ bzcat   /data/match/cmpp/20170[8-9][0-9][0-9]/monster-cmppmo.log.*.bz2  | grep -e ',1065888060,'  | awk -F',' 'toupper(substr($28,1,3))~/FL[1-3]/{print $0}'
Sep  5 15:34:54 192.100.6.1 Monster-CMPP20MO[12457]: 20170905153723SMS0000999L001000000000ec22875,0,00,,,09051545597710104322,,,,15177276191,,,1,1065888060,,,,,,,,,,,,0,3,FL2,
Sep  5 16:52:07 192.100.6.1 Monster-CMPP20MO[12457]: 20170905165437SMS0000999L00100000000d87eeb66,0,00,,,09051658515710155502,,,,15257122159,,,1,1065888060,,,,,,,,,,,,0,3,FL1,
  toupper(substr($28,1,2))=="FL"
  $1~/zhengxh/
  [gateway@wtraffic /data/match/cmpp]$ bzcat   /data/match/cmpp/20170[8-9][0-9][0-9]/monster-cmppmo.log.*.bz2  | grep -e ',1065888060,'  | awk -F',' 'toupper(substr($28,1,2))=="FL"{print $0}' >~/FL_UP.txt
bzcat   /data/match/cmpp/20170[8-9][0-9][0-9]/monster-cmppmo.log.*.bz2  | grep -e ',1065888060,'  | awk -F',' 'toupper(substr($28,1,2))~/FL{1,2,3}/{print $0}' >~/FL_UP.txt
