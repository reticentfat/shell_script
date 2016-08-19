---27上
#!/bin/sh
export PATH=/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/data/app/oracle/product/11.2.0/db/bin/
export ORACLE_HOME=/data/app/oracle/product/11.2.0/db

export ORACLE_SID=wreportdb
ORACLE_NLS=$ORACLE_HOME/nls/data ;
export ORACLE_NLS
NLS_LANG="simplified chinese"_china.ZHS16CGB231280 ;
export NLS_LANG
DEALDATE=`date -d "4 day ago" +"%Y%m%d"`
DEALDATE_1=`date -d "4 day ago" +"%Y-%m-%d"`
DEALYEAR=`date --date='4 days ago' +%Y`
DEALDATE_2=`date --date='4 days ago' +%Y-%m`
echo $DEALDATE
cd /data/henan_jifei
if [ ! -d "${DEALDATE}" ]; then
   mkdir ${DEALDATE}   
fi
echo "mkdir_done"
cd ${DEALDATE} 
cat /data/$DEALYEAR/$DEALDATE/qiangxiang_mms_pay_users.txt | awk -F ',' '($2=="10511004"||$2=="10511050"||$2=="10511051")&&$5=="371"{print $1","$6","$2}'>henan_jifei_user_tmp1.txt
#cat /data/2016/20160731/qiangxiang_mms_pay_users.txt | awk -F ',' '($2=="10511004"||$2=="10511050"||$2=="10511051")&&$5=="371"{print $1","$6","$2}'>henan_jifei_user_tmp1.txt
#cat /data/2016/20160731/qiangxiang_mms_pay_users.txt | awk -F ',' '$2=="10511008"&&$5=="371"{print $1","$6","$2}'>henan_jifei_user_tmp2.txt
cat /data/$DEALYEAR/$DEALDATE/qiangxiang_mms_pay_users.txt | awk -F ',' '$2=="10511008"&&$5=="371"{print $1","$6","$2}'>henan_jifei_user_tmp2.txt
awk -F',' -v CODE_DIR=/data/match/orig/mm7/$DEALDATE/stats_month.wuxian_qianxiang.1000 -v fileok=/data/henan_jifei/$DEALDATE/henan_jifei_user_tmp2_ok.txt -v fileno=/data/henan_jifei/$DEALDATE/henan_jifei_user_tmp2_0.txt '{
if( FILENAME == CODE_DIR ) d[$1$2]=$1","$2","$3; 
else if ( FILENAME != CODE_DIR && substr($3,1,3) == "105" && $1$3 in d ) print >> fileok ; 
else if ( FILENAME != CODE_DIR && substr($3,1,3) == "105" && !($1$3 in d )) print >> fileno ; 
}' /data/match/orig/mm7/$DEALDATE/stats_month.wuxian_qianxiang.1000 /data/henan_jifei/$DEALDATE/henan_jifei_user_tmp2.txt
cat henan_jifei_user_tmp1.txt henan_jifei_user_tmp2_ok.txt > henan_jifei_user_tmp3.txt
---------------然后匹配订购时间退订时间----------------------
bzip2 henan_jifei_user_tmp3.txt
 bzcat henan_jifei_user_tmp3.txt.bz2  /data/match/orig/$DEALDATE/snapshot.txt.bz2  | awk -F'[|,]'  '{if(NF==3) aa[$1$3]=$0;else if(($1$2 in aa)&&$3=="06")  print aa[$1$2]","$5",99991231000000,"$3 ;else if (($1$2 in aa)&&$3=="07")  print aa[$1$2]","$5","$4","$3}'  > henan_jifei_user_tmp4.txt
cat henan_jifei_user_tmp4.txt | awk -F',' -v time=$DEALDATE 'BEGIN{print "用户号码|地市|业务名称|订购时间|退订时间|次月是否留存";}{if(substr($5,0,8)>time) is_liucun="是";else if (substr($5,0,8)<=time) is_liucun="否";print $1"|"$2"|"$3"|"$4"|"$5"|"is_liucun}' >henan_jifei_user_tmp5.txt
#cat henan_jifei_user_tmp4.txt | awk -F',' 'BEGIN{print "用户号码|地市|业务名称|订购时间|退订时间|次月是否留存";}{if(substr($5,0,8)>20160731) is_liucun="是";else if (substr($5,0,8)<=20160731) is_liucun="否";print is_liucun}' >shi.txt
-------把APPCODE换成中文名称--------------
sed  's/|10511004/|12580生活播报-健康俱乐部彩信版/g;s/|10511051/|12580生活播报-法律百科彩信版/g;s/|10511050/|12580生活播报-健康宝典彩信版/g;s/|10511008/|电影俱乐部彩信/g' henan_jifei_user_tmp5.txt>henan_jifei_user_$DEALDATE_2.txt
bzip2 henan_jifei_user_$DEALDATE_2.txt
#scp /data/henan_jifei/20160731/henan_jifei_user_2016-07.txt.bz2 gateway@192.100.7.25:/data/henan_jifei
scp henan_jifei_user_$DEALDATE_2.txt.bz2 gateway@192.100.7.25:/data/henan_jifei
--然后25上写邮件脚本----------------
#!bin/bash
DEALDATE=`date -v-4d  +%Y-%m`
echo ${DEALDATE}
echo "henan_jifei"`date -v-18d  +%Y%m%d` >>  /data/211/log/henan_jifei.log

/usr/local/bin/php /data/211/bin/henanjifei_sedMail.php /data/henan_jifei/henan_jifei_user_${DEALDATE}.txt.bz2 >> /data/211/log/henan_jifei.log

echo ${DEALDATE}
------------------------------php文件---------------
<?php
	/**
	* @desc 河南计费明细 每月四号发送 
	* @author wangyuan
	* @date 2016-08-18 17:35
	*
	*/

	error_reporting(E_ALL);
	define('SERVER_ROOT', dirname(__FILE__).'/');
	
	$end_time = date("Y-m-d",time()-3600*24);
	$start_time = date("Y-m-d" ,time()-3600*72);

	//$fileName = "general.txt";
	$file = $_SERVER['argv'][1];
	$fileName = basename($file); 
	//$file = SERVER_ROOT . $fileName;
	if( !file_exists($file)) {
		exit;
	}

	//把整个文件读入一个变量	
	$fp = fopen($file, "r");	
	$read = fread($fp, filesize($file));

	//base64编码
	$read = base64_encode($read);


	//把这个长字符串切成由每行76个字符组成的小块
	$read = chunk_split($read);
	
	$boundary = uniqid();

	//建立邮件的主体
	$body = "--$boundary\n";
	$body .= "Content-Type:application/octet-stream;name=\"".$fileName;
	$body .= "\"\nContent-Transfer-Encoding:BASE64\n";
	$body .= "Content-Disposition:attachment;filename=\"".$fileName;
	$body .= "\"\n\n".$read."\n\n";
	$body .= "--$boundary--\n\n";

	$headers = "From:wangyuan@umessage.com.cn\n";
	$headers .= "Cc:cuiyou@umessage.com.cn,283049708@qq.com,183644346@qq.com\n";
	$headers .= "Content-type:multipart/mixed;boundary=\"$boundary\"";
	$subject = iconv("UTF-8", "gbk", "河南计费明细");
	$to = "13581960272@139.com,13623847992@139.com,239485421@qq.com";
	var_dump(mail($to, $subject,$body,$headers));

?>
---------
