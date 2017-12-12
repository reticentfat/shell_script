#!/bin/sh
. /usr/local/app/dana/current/shbb/profile
#. /home/shihy/bin/shbb_20090423/profile
usage () {
    echo "usage: $0  target_dir" 1>&2
    exit 2
}

  if [ $# -lt 1 ] ; then
     usage
  fi
V_DATE=$1
V_YEAR=$(echo $V_DATE | cut -c 1-4)
TARGET_DIR=$AUTO_DATA_REPORT/$V_YEAR/$V_DATE
CODE_DIR=$AUTO_DATA_NODIST
SOURCE_FILE=$AUTO_DATA_REPORT/$V_YEAR/$V_DATE/report.region.newzz_pay_chanel_city.csv
FILE_APP_CODE=$CODE_DIR/news_appcode.txt
FILE_CHANEL_CODE=$CODE_DIR/shbb_chanel_code.txt
#结果文件
result_file_pro=$AUTO_DATA_REPORT/$V_YEAR/$V_DATE/report.region.newzz_payuser_chanel_province.csv
result_file_city=$AUTO_DATA_REPORT/$V_YEAR/$V_DATE/report.region.newzz_payuser_chanel_city.csv
result_file_country=$AUTO_DATA_REPORT/$V_YEAR/$V_DATE/report.region.newzz_payuser_chanel_country.csv
awk -F'[|,]' '{
   if(FILENAME=="'$FILE_APP_CODE'")
   {
      if($3>0) app[$1]=$3
   }
   else if(FILENAME=="'$FILE_CHANEL_CODE'")
   {
     i++;ch[$1]=$2;ch_order[i]=$1
   }
   else
   { 
     nowone++  #去掉表头
     if(nowone>1)
     {
       provino=$1;proviname=$2;cityid=$3;city_name=$4;appcode=$5;appname=$6;chanel=$7;usernum=$8
       paynum=app[appcode]*usernum
       # 如果不在显示的的渠道范围内显示成其它
       if(!(chanel in ch))
       {
    	 chanel="OTHERS"
       }
       indexstr_city=provino","proviname","cityid","city_name","appcode","appname","chanel
       indexstr_A=provino","proviname","cityid","city_name","appcode","appname
       #分地市 
       p_city[indexstr_city]=p_city[indexstr_city]+usernum
       p_city_pay[indexstr_city]=p_city_pay[indexstr_city]+paynum
       a[indexstr_A]=1
       #分省份
       indexstr_provi=provino","proviname","appcode","appname","chanel
       indexstr_B=provino","proviname","appcode","appname
       p_provi[indexstr_provi]=p_provi[indexstr_provi]+usernum
       p_provi_pay[indexstr_provi]=p_provi_pay[indexstr_provi]+paynum
       b[indexstr_B]=1
       #全国
       indexstr_country=appcode","appname","chanel
       p_country[indexstr_country]=p_country[indexstr_country]+usernum
       p_country_pay[indexstr_country]=p_country_pay[indexstr_country]+paynum
       c[appcode","appname]=1
     }
  }
}END{
       i++
       ch_order[i]="OTHERS"
       for(n=1;n<=i;n++)
       {
         suc=suc",计费用户数("ch_order[n]")"
	 pay=pay",信息费预估("ch_order[n]")"
       }
       city_title="省编码,省名称,地市编码,地市名称,APPCODE,杂志名称"
       printf("%s%s%s\n",city_title,suc,pay)>"'$result_file_city'"
       for(name in a)
       {
   	 out_str1=""
   	 out_str2=""
   	 for(m=1;m<=i;m++ )
   	 {
           k=p_city[name","ch_order[m]]>0?p_city[name","ch_order[m]]:0
   	   out_str1=out_str1","k
   	   k=p_city_pay[name","ch_order[m]]>0?p_city_pay[name","ch_order[m]]:0
   	   out_str2=out_str2","k
   	 }
   	 printf("%s%s%s\n",name,out_str1,out_str2)>>"'$result_file_city'"
       }
       province_title="省编码,省名称,APPCODE,杂志名称"
       printf("%s%s%s\n",province_title,suc,pay) >"'$result_file_pro'"
       for(name in b)
       {
   	 out_str1=""
   	 out_str2=""
   	 for(m=1;m<=i;m++ )
   	 {
           k=p_provi[name","ch_order[m]]>0?p_provi[name","ch_order[m]]:0
   	   out_str1=out_str1","k
   	   k=p_provi_pay[name","ch_order[m]]>0?p_provi_pay[name","ch_order[m]]:0
   	   out_str2=out_str2","k
   	 }
   	 printf("%s%s%s\n",name,out_str1,out_str2)>>"'$result_file_pro'"
       }
       province_title="合计,APPCODE,杂志名称"
       printf("%s%s%s\n",province_title,suc,pay) >"'$result_file_country'"
    for(name in c)
    {
   	out_str1=""
   	out_str2=""
   	for(m=1;m<=i;m++ )
   	{
      	   k=p_country[name","ch_order[m]]>0?p_country[name","ch_order[m]]:0
   	   out_str1=out_str1","k
   	   k=p_country_pay[name","ch_order[m]]>0?p_country_pay[name","ch_order[m]]:0
   	   out_str2=out_str2","k
   	}
   	printf("%s,%s%s%s\n","合计",name,out_str1,out_str2)>>"'$result_file_country'"
    }

}' $FILE_APP_CODE $FILE_CHANEL_CODE $SOURCE_FILE


