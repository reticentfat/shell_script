	awk  -F',' -v CODE_DIR=/data0/match/orig/mm7/20101212/stats_month.wuxian_qianxiang.1000 -v fileok=zjyhq_0_ok.txt -v fileno=zjyhq_0_0.txt '{
	if( FILENAME == CODE_DIR  )  d[$1$2]=$1","$2","$3;
	 else if ( FILENAME != CODE_DIR &&  substr($2,1,3) == "105"   &&  $1$2 in d ) print d[$1$2]","$0 >> fileok ;
	 else if ( FILENAME != CODE_DIR &&  substr($2,1,3) == "105"   && !($1$2 in d )) print $1","$2",0,"$0 >> fileno ;
	}' /data0/match/orig/mm7/20101212/stats_month.wuxian_qianxiang.1000 zjyhq_0.txt
