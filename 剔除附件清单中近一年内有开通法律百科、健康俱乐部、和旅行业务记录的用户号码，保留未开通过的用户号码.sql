bzip2 -z wh.txt
---先剔除退订表里边的号码------------

30 17 27 05 * bzcat /home/oracle/etl/data/data/snapshot/archives.txt.bz2 /home/oracle/wh.txt.bz2    | awk -F'^' '{if((NF==17)&&($6=="10301079"||$6=="10511051"||$6=="10301010"||$6=="10511004")) aa[$2]=$2;else if((NF==1)&&!(substr($1,1,11) in aa))  print $1}' | bzip2 > /home/oracle/js.txt.bz2
----再剔除在线的号码---------------
50 17 27 05 * bzcat /home/oracle/etl/data/data/snapshot/snapshot.txt.bz2 /home/oracle/js.txt.bz2  | awk -F'|' '{if((NF==20)&&($2=="10301079"||$2=="10511051"||$2=="10301010"||$2=="10511004")&&($3=="06")) aa[$1]=$1; else if((NF==1)&&!(substr($1,1,11) in aa))  print $1}' | bzip2 > /home/oracle/js1.txt.bz2
