grep -nsr "outputumessage_003_meiti" shbb/
oracle@wreport:/data/homeoracle/etl/bin$ find . -maxdepth 2 -name "*.sh" |xargs grep "report.region.sj_buss_wireless_city.csv"
./exportmonth_KPI.sh:iconv -f GB2312 -t UTF-8   $REPORT_DIR/$DIR_YEAR/$DIR_MONTH/report.region.sj_buss.wireless_city.txt  > $REPORT_DIR/$DIR_YEAR/$DIR_MONTH/report.region.sj_buss_wireless_city.csv  ;
./export_KPItmp.sh:iconv -f GB2312 -t UTF-8   $REPORT_DIR/$DIR_YEAR/$DIR_WEEK/report.region.sj_buss.wireless_city.txt  > $REPORT_DIR/$DIR_YEAR/$DIR_WEEK/report.region.sj_buss_wireless_city.csv ;
./export_KPI.sh:iconv -f GB2312 -t UTF-8   $REPORT_DIR/$DIR_YEAR/$DIR_WEEK/report.region.sj_buss.wireless_city.txt  > $REPORT_DIR/$DIR_YEAR/$DIR_WEEK/report.region.sj_buss_wireless_city.csv ;
