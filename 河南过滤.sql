bzcat /home/oracle/etl/data/data/snapshot/snapshot.txt.bz2 | awk -F'|' '{if($3=="06"&&$8=="0371"&&$2=="10511050") print $1"|"$2"|"}'| bzip2 > /home/oracle/henan_jkbd.txt.bz2
bzcat /home/oracle/etl/data/data/snapshot/snapshot.txt.bz2 | awk -F'|' '{if($3=="06"&&$8=="0371"&&$2=="10511051") print $1"|"$2"|"}'| bzip2 > /home/oracle/henan_flbk.txt.bz2
 awk -F'|' -v CODE_DIR=jkbd_all.txt    '{
 if( FILENAME == CODE_DIR  )  d[$1]=$1 ;
         else if ( FILENAME != CODE_DIR && !($1 in d) ) print   ;      
        }'  jkbd_all.txt  target_all.txt > target_jkbd.txt
         awk -F'|' -v CODE_DIR=flbk_all.txt    '{
 if( FILENAME == CODE_DIR  )  d[$1]=$1 ;
         else if ( FILENAME != CODE_DIR && !($1 in d) ) print   ;      
        }'  flbk_all.txt  target_all.txt > target_flbk.txt
         bzcat  henan_jkbd.txt.bz2  target_jkbd.txt.bz2  | awk -F'|' '{if(NF==3) aa[$1]=$1"|"$2; else if((NF==2)&&!($1 in aa))  print $1"|" }' | bzip2 > /home/oracle/target_jkbd_all.txt.bz2
          bzcat  henan_flbk.txt.bz2  target_flbk.txt.bz2  | awk -F'|' '{if(NF==3) aa[$1]=$1"|"$2; else if((NF==2)&&!($1 in aa))  print $1"|" }' | bzip2 > /home/oracle/target_flbk_all.txt.bz2
          awk -F'|' -v CODE_DIR=target_flbk_all.txt   '{
 if( FILENAME == CODE_DIR  )  d[$1]=$1 ;
         else if ( FILENAME != CODE_DIR && !($1 in d) ) print   ;      
        }'  target_flbk_all.txt  target_jkbd_all.txt > target_jkbd_all_final.txt
