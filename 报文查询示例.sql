27上查询订购号码
bzcat /data/homeoracle/etl/data/data/snapshot/snapshot.txt.bz2 | awk -F'|' '$2=="10511055"&&$9=="512"&&$6~/^2018042/{print $0}' | head
6.31上查报文
/usr/local/yap2/log> cat *.20180420 | grep 13402629499
