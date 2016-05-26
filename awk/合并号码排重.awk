awk -F',' '{if( $1 in jk ){ split( jk[$1], tmp, "," ); unsubtime = tmp[3]; if( $3 > unsubtime ) jk[$1] = $0; } else { jk[$1] = $0; } } END{ for( j in jk ) print jk[j]; }' jkxgj.txt | unix2dos > jkxgj_ret.txt
awk -F',' '{if(FILENAME=="sendcode.txt") sc[$1]=$0; else{if($2 in sc){
	split(sc[$2],tmp,","); name=tmp[2]; cate=tmp[3]; appcode=tmp[4]; port=tmp[5]; qftime=tmp[6]; 
	d=name"_"cate"_"appcode"_"port"_"qftime".txt"; print $1>>d;}}}' sendcode.txt qf_20110224_all.txt
