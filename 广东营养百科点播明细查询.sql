cat /data/match/cmpp/201505*/*wuxian*.out | grep -e ',10202005,' -e ',10201036,' -e ',10202011,' -e ',10201002,'  -e ',10201006,' -e ',10201007,' -e ',10226002,'  -e ',10201034,' -e ',10201020,' -e',10201021,' -e ',10202001,'  -e ',10202010,' -e ',10202008,' -e ',10202009,' -e ',10202006,'   -e ',10201070,' -e ',10201071,'  -e ',10201072,'  -e ',10201073,'   | awk -F',' '{ print $1"^"$15"^"$19"^"$10"^"$14"^"$35"^"$(NF-3)}' |  awk -F':' '{print $4}' | awk -F'^' '{print substr($1,2,14)"^"$2"^"$3"^"$4"^"$5"^"$6"^"$7}' > /data/wuying/gd_uf8temp.txt
cat /data/match/mm7/201505*/*wuxian*.out | grep   -e ',10411012,' -e ',10411013,' -e ',10411014,' | awk -F',' '{ print $1"^"$15"^"$19"^"$10"^"$14"^"$31"^"$(NF-2)}' |  awk -F':' '{print $4}' | awk -F'^' '{print substr($1,2,14)"^"$2"^"$3"^"$4"^"$5"^"$6"^"$7}' >> /data/wuying/gd_uf8temp.txt

iconv -f UTF-8  -t GB18030 -c   /data/wuying/gd_uf8temp.txt  > /data/wuying/RSDATA/gd_temp.txt;
上传到/data/wuying/RSDATA
cat wy.txt  gd_temp.txt  | awk -F'^' '{if(NF==2) aa[$1]=$1;else if(($5 in aa))  print }' | bzip2 > js.txt.bz2
