----27上

cd /data/match/orig/20160112/
bzcat snapshot.txt.bz2 | awk -F'|' '{print $1"|"$2}' >result.txt
bzcat user_sn.txt.bz2 | awk -F'|' '{print $1"|"$2}' >>result.txt
/data/match/orig/20160112/
/data/homeoracle/etl/data/opt_code_all.txt
result.txt
13070191176|10324010|
  awk -F'[,|]' -v CODE_DIR=/data/homeoracle/etl/data/opt_code_all.txt     '{
     if( FILENAME == CODE_DIR  )  d[$1]=$3 ;
         else if ( FILENAME != CODE_DIR && ($2 in d) ) print   $1"|"$2"|"d[$2] ;      
        }'     /data/homeoracle/etl/data/opt_code_all.txt  result.txt > result_sum.txt
        cat result_sum.txt | awk -F'|' '{ aa[$1] +=$3} END {for(i in aa){ print i","aa[i]}}' >1.txt
