	awk -F',' '{if($10 == "xzyh" && substr($8,1,6) == "201101"){
	subtime=substr($8,1,4)"-"substr($8,5,2)"-"substr($8,7,2)" "substr($8,9,2)":"substr($8,11,2)":"substr($8,13,2);
	unsubtime=substr($9,1,4)"-"substr($9,5,2)"-"substr($9,7,2)" "substr($9,9,2)":"substr($9,11,2)":"substr($9,13,2);
	print $1","$6","$4","$5","subtime","unsubtime}}' neimenggu.txt | unix2dos > neimenggu_xzyh.csv
