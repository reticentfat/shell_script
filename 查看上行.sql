---25上
bzcat /data/match/cmpp/20160131/monster-cmppmo.log.fengtai.log.20160131.bz2 | grep -e ',1065888077,' -e ',1065888078,' |  awk -F':' '{print $4}'  | awk -F',' '{print substr($1,2,14)"^"$6"^"$10"^"$14"^"$26"^"$27"^"$28}' 
