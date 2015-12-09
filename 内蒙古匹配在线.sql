27上
cd /data/match/orig/20151207
bzcat snapshot.txt.bz2 user_sn.txt.bz2 | awk -F'|' '$8=="0471"&&$3=="06"{print $1"|"$2}' | sort -u >nmg_sn_1209.txt
/home/oracle$  awk -F'|' -v CODE_DIR=/data/match/orig/20151207/nmg_sn_1209.txt     '{
     if( FILENAME == CODE_DIR  )  d[$1$2]=$1 ;
         else if ( FILENAME != CODE_DIR && ($1$9 in d) ) print    ;      
        }'     /data/match/orig/20151207/nmg_sn_1209.txt   r1.txt > wy_ok.txt
bzcat  user_sn.txt.bz2 | awk -F'|' '$8=="471"&&$3=="06"{print $1"|"$2}' | sort -u >nmg_wz_1209.txt
awk -F'|' -v CODE_DIR=/data/match/orig/20151207/nmg_wz_1209.txt     '{
>      if( FILENAME == CODE_DIR  )  d[$1$2]=$1 ;
>          else if ( FILENAME != CODE_DIR && ($1$9 in d) ) print    ;      
>         }'     /data/match/orig/20151207/nmg_wz_1209.txt   r1.txt > wy_ok1.txt
cat wy_ok* | awk -F'|' '{print $1"\t"$6"\t06"}' >1209.txt
