awk -F',' '{if( $1 in jk ){ split( jk[$1], tmp, "," ); unsubtime = tmp[3]; if( $3 > unsubtime ) jk[$1] = $0; } else { jk[$1] = $0; } } END{ for( j in jk ) print jk[j]; }' jkxgj.txt | unix2dos > jkxgj_ret.txt
awk -F',' '{if(FILENAME=="sendcode.txt") sc[$1]=$0; else{if($2 in sc){
	split(sc[$2],tmp,","); name=tmp[2]; cate=tmp[3]; appcode=tmp[4]; port=tmp[5]; qftime=tmp[6]; 
	d=name"_"cate"_"appcode"_"port"_"qftime".txt"; print $1>>d;}}}' sendcode.txt qf_20110224_all.txt
bzcat /home/oracle/etl/data/data/snapshot/snapshot.txt.bz2 | grep -v 'SHBB' | grep -e '|10301009|' -e '|10511003|' -e '|10301010|' -e '|10511004|' -e '|10511012|' -e '|10301015|' -e '|10301013|' -e '|10511008|' | awk -F '|' '{
 if( $3 == "06" ) { subtime = substr($4,1,4)"-"substr($4,5,2)"-"substr($4,7,2)" "substr($4,9,2)":"substr($4,11,2)":"substr($4,13,2);
 print $1","$2","subtime",9999-12-30 00:00:00"; }}' > /home/oracle/online_dc.txt
