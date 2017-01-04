-n, --line-number
在输出的每行前面加上它所在的文件中它的行号。
-s, --no-messages
禁止输出关于文件不存在或不可读的错误信息。
-R, -r, --recursive
递归地读每一目录下的所有文件。这样做和 -d recurse 选项等价。
grep -nsr "outputumessage_003_meiti" shbb/
oracle@wreport:/data/homeoracle/etl/bin$ find . -maxdepth 2 -name "*.sh" |xargs grep "report.region.sj_buss_wireless_city.csv"
./exportmonth_KPI.sh:iconv -f GB2312 -t UTF-8   $REPORT_DIR/$DIR_YEAR/$DIR_MONTH/report.region.sj_buss.wireless_city.txt  > $REPORT_DIR/$DIR_YEAR/$DIR_MONTH/report.region.sj_buss_wireless_city.csv  ;
./export_KPItmp.sh:iconv -f GB2312 -t UTF-8   $REPORT_DIR/$DIR_YEAR/$DIR_WEEK/report.region.sj_buss.wireless_city.txt  > $REPORT_DIR/$DIR_YEAR/$DIR_WEEK/report.region.sj_buss_wireless_city.csv ;
./export_KPI.sh:iconv -f GB2312 -t UTF-8   $REPORT_DIR/$DIR_YEAR/$DIR_WEEK/report.region.sj_buss.wireless_city.txt  > $REPORT_DIR/$DIR_YEAR/$DIR_WEEK/report.region.sj_buss_wireless_city.csv ;
