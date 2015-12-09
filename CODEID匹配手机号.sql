----25上操作
awk -F'^' -v CODE_DIR=/data/wxlog/wxsub/BJWZNEW_ok.txt     '{
     if( FILENAME == CODE_DIR  )  d[$1]=$2 ;
         else if ( FILENAME != CODE_DIR && ($1 in d) ) print   $1","d[$1] ;      
        }'     /data/wxlog/wxsub/BJWZNEW_ok.txt  code.txt > wy_ok.txt
