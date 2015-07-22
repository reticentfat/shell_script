#158上
bzcat /data0/match/orig/20150531/snapshot.txt.bz2 | awk -F'|' '{if ($8=="020"&&$2=="10511051"&&$3=="06"&&$5>=20150101000000&&$5<20150501000000) print $9 }' |sort |uniq -c
bzcat /data0/match/orig/20150630/snapshot.txt.bz2 | awk -F'|' '{if ($8=="020"&&$2=="10511051"&&$3=="06"&&$5>=20150101000000&&$5<20150601000000) print $9 }' |sort |uniq -c
bzcat /data0/match/orig/20150720/snapshot.txt.bz2 | awk -F'|' '{if ($8=="020"&&$2=="10511051"&&$3=="06"&&$5>=20150101000000&&$5<20150701000000) print $9 }' |sort |uniq -c
