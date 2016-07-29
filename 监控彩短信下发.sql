---25上
---做一个07201900的例子---
bzcat /data/monster/20160720/monster-cmppmt.log.201607201900.bz2 | awk -F',' '$15~/^[0-9]+$/{print $15}' |  sort |uniq -c | sort -rn | awk '{print $2","$1}'
-----------做监控字典表--------------
select tb.appcode||','||tb.oper_name_real from tb_theory_income_base_dianbo tb
select oc.appcode||','||oc.opt_cost||','||oc.servcode||','||oc.jfcode||','||oc.optname from opt_code_all oc
/data/211/dictionary/
monitor_dictionary_baoyue.txt
monitor_dictionary_dianbo.txt
--------------------------做每小时生成一个计数文件--
----monitor.sh--------------------
#!/bin/sh
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/home/gateway/;
export PATH
DEALDATE=`date -v-0d  +%Y%m%d`
DEALDATETIME=`date -v-2H  +%Y%m%d%H00`
DEALDATE_1=`date -v-1d  +%Y-%m-%d`
DEALDATE_2=`date -v-0d  +%Y-%m-%d` 
echo ${DEALDATE}
echo ${DEALDATETIME}
--DEALDATE=`date -v-${AGO_DAY1}d -v${AGO_DAY2}H  +%Y%m%d%H`
--TODAYTIME=`date -v-${AGO_DAY1}d -v${AGO_DAY2}H  +%Y%m%d%H%M%S`
--DATEYEAR=`date -v-${AGO_DAY2}d  +%Y`

DIC="/data/monitor/servercodelist.txt"
cd /data/monitor
if [ ! -d "${DEALDATE}" ]; then
   mkdir ${DEALDATE}   
fi
echo "mkdir_done"
cd ${DEALDATE}
bzcat /data/monster/${DEALDATE}/monster-cmppmt.log.${DEALDATETIME}.bz2 | awk -F',' '$15~/^[0-9]+$/{print $15}' |  sort |uniq -c | sort -rn | awk '{print $2","$1}'>xiafa_${DEALDATETIME}.txt
bzcat /data/monster/${DEALDATE}/monster-mm7mt.log.${DEALDATETIME}.bz2 | awk -F',' '$15~/^[0-9]+$/{print $15}' |  sort |uniq -c | sort -rn | awk '{print $2","$1}'>>xiafa_${DEALDATETIME}.txt
----------------然后把24小时的合并从6点到6点--------------------
--------monitor2.sh-----------
#!/bin/sh
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/home/gateway/;
export PATH
DEALDATE=`date -v-0d  +%Y%m%d`
DEALDATETIME=`date -v-2H  +%Y%m%d%H00`
DEALDATE_1=`date -v-1d  +%Y%m%d`
DEALDATE_2=`date -v-0d  +%Y%m%d` 
DEALDATE_3=`date -v-2d  +%Y%m%d`
echo ${DEALDATE}
echo ${DEALDATETIME}
#DEALDATE=`date -v-${AGO_DAY1}d -v${AGO_DAY2}H  +%Y%m%d%H`
#TODAYTIME=`date -v-${AGO_DAY1}d -v${AGO_DAY2}H  +%Y%m%d%H%M%S`
#DATEYEAR=`date -v-${AGO_DAY2}d  +%Y`

DIC_baoyue="/data/211/dictionary/monitor_dictionary_baoyue.txt"
DIC_dianbo="/data/211/dictionary/monitor_dictionary_dianbo.txt"
DIC_weizhang="/data/211/dictionary/monitor_dictionary_weizhang.txt"
cd /data/monitor
cat ./${DEALDATE_1}/xiafa_${DEALDATE_1}0[6-9]00.txt ./${DEALDATE_1}/xiafa_${DEALDATE_1}1[0-9]00.txt  ./${DEALDATE_1}/xiafa_${DEALDATE_1}2[0-1]00.txt ./${DEALDATE_2}/xiafa_${DEALDATE_1}2[2-3]00.txt  ./${DEALDATE_2}/xiafa_${DEALDATE_2}0[0-5]00.txt > xiafa_${DEALDATE_1}0600_to_${DEALDATE_2}0500.txt
#cat xiafa_201607240600_to_201607250500.txt | awk -F',' '{ aa[$1] +=$2}END{for (i in aa){ print i","aa[i]} }' >xiafa_201607240600_to_201607250500_allcount.txt
cat xiafa_${DEALDATE_1}0600_to_${DEALDATE_2}0500.txt | awk -F',' '{ aa[$1] +=$2}END{for (i in aa){ print i","aa[i]} }' >xiafa_${DEALDATE_1}0600_to_${DEALDATE_2}0500_allcount.txt
awk -F',' -v CODE_DIR=${DIC_baoyue} '{ if(FILENAME==CODE_DIR) d[$1]=$3 ; else if( $1 in d  ) print d[$1]","$2;  }' ${DIC_baoyue}  xiafa_${DEALDATE_1}0600_to_${DEALDATE_2}0500_allcount.txt>xiafa_${DEALDATE_1}0600_to_${DEALDATE_2}0500_count_baoyue_tmp.txt
awk -F',' -v CODE_DIR=${DIC_weizhang} '{ if(FILENAME==CODE_DIR) d[$1]=$1","$2 ; else if( $1 in d  ) print d[$1]","$2;  }' ${DIC_weizhang}  xiafa_${DEALDATE_1}0600_to_${DEALDATE_2}0500_allcount.txt>xiafa_${DEALDATE_1}0600_to_${DEALDATE_2}0500_count_weizhang.txt
awk -F',' -v CODE_DIR=${DIC_dianbo} '{ if(FILENAME==CODE_DIR) d[$1]=$1","$2 ; else if( $1 in d  ) print d[$1]","$2;  }' ${DIC_dianbo}  xiafa_${DEALDATE_1}0600_to_${DEALDATE_2}0500_allcount.txt>xiafa_${DEALDATE_1}0600_to_${DEALDATE_2}0500_count_dianbo.txt
cat xiafa_${DEALDATE_1}0600_to_${DEALDATE_2}0500_count_baoyue_tmp.txt | awk -F',' '{ aa[$1] +=$2}END{for (i in aa){ print i","aa[i]} }' >xiafa_${DEALDATE_1}0600_to_${DEALDATE_2}0500_count_baoyue.txt
------------------weizhang_dump.sh----
#!/bin/sh
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/home/gateway/;
export PATH
DEALDATE_1=`date -v-1d  +%Y%m%d`
cd /data/monitor
bzcat /data/user_sn.txt.bz2 | awk -F'|' '$3=="06"{print $2}' | sort | uniq -c | sort -rn | awk '{print $2","$1}'>dump_weizhang_${DEALDATE_1}.txt
----user_sn.txt.bz2每天12：15生成
--------把下发统计从appcode转换为severcode并拆分为包月和点播-------------------------
awk -F',' -v CODE_DIR=${DIC_baoyue} '{ if(FILENAME==CODE_DIR) d[$1]=$3 ; else if( $1 in d  ) print d[$1]"|"$2;  }' ${DIC_baoyue}  xiafa_${DEALDATE_1}0600_to_${DEALDATE_2}0500_allcount.txt>xiafa_${DEALDATE_1}0600_to_${DEALDATE_2}0500_count_baoyue.txt
---------拆分包月字典表----
cat /data/211/dictionary/monitor_dictionary_baoyue.txt |awk -F',' '$3==""{print}' >cat /data/211/dictionary/monitor_dictionary_weizhang.txt
#cat monitor_dictionary_baoyue.txt |awk -F',' '$3==""{print}' >monitor_dictionary_weizhang.txt
cat monitor_dictionary_baoyue.txt |awk -F',' '$3!=""{print}' >monitor_dictionary_new.txt
---------------对比脚本-----------
#!/bin/sh
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/home/gateway/;
export PATH
DEALDATE_1=`date -v-1d  +%Y%m%d`
DIC="/data/monitor/servercodelist.txt"
cd /data/monitor
if [ ! -d "${DEALDATE}" ]; then
   mkdir ${DEALDATE}   
fi
echo "mkdir_done"
cd ${DEALDATE}
wget -N "http://192.100.6.31:9999/data/sort/count.txt"
------------------违章对比----------------------------
#dump_weizhang_20160727.txt与xiafa_201607270600_to_201607280500_count_weizhang.txt
[gateway@wtraffic /data/monitor]$ cat dump_weizhang_20160727.txt | head -5
10301031,987566
10301028,802703
[gateway@wtraffic /data/monitor]$ cat xiafa_201607270600_to_201607280500_count_weizhang.txt | head -5
10324010,北京违章包年15元,41527
10301028,违章包月3元,2387990
#awk -F',' 'BEGIN{print "APPCODE,业务名称,下发数量,在线用户量,差异";}{if(NF==2) aa[$1]=$2;else if(NF==3&&($1 in aa))  print $0","aa[$1]","sqrt(($3-aa[$1])*($3-aa[$1]))}' dump_weizhang_20160727.txt xiafa_201607270600_to_201607280500_count_weizhang.txt > weizhang_final_20160727.txt
#awk -F',' 'BEGIN{print "APPCODE,mingcheng,xiazai,yonghu,gap";}{if(NF==2) aa[$1]=$2;else if(NF==3&&($1 in aa))  print $0","aa[$1]","sqrt(($3-aa[$1])*($3-aa[$1]))}' dump_weizhang_20160727.txt xiafa_201607270600_to_201607280500_count_weizhang.txt > weizhang_final_20160727.txt
-------------对比monitor3.sh---------------
#!/bin/sh
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/home/gateway/;
export PATH
DEALDATE=`date -v-0d  +%Y%m%d`
DEALDATETIME=`date -v-2H  +%Y%m%d%H00`
DEALDATE_1=`date -v-1d  +%Y%m%d`
DEALDATE_2=`date -v-0d  +%Y%m%d` 
DEALDATE_3=`date -v-2d  +%Y%m%d`
echo ${DEALDATE}
echo ${DEALDATETIME}
#DEALDATE=`date -v-${AGO_DAY1}d -v${AGO_DAY2}H  +%Y%m%d%H`
#TODAYTIME=`date -v-${AGO_DAY1}d -v${AGO_DAY2}H  +%Y%m%d%H%M%S`
#DATEYEAR=`date -v-${AGO_DAY2}d  +%Y`

DIC_baoyue="/data/211/dictionary/monitor_dictionary_baoyue.txt"
DIC_dianbo="/data/211/dictionary/monitor_dictionary_dianbo.txt"
DIC_weizhang="/data/211/dictionary/monitor_dictionary_weizhang.txt"
cd /data/monitor
awk -F',' 'BEGIN{print "APPCODE,业务名称,下发数量,在线用户量,差异";}{if(NF==2) aa[$1]=$2;else if(NF==3&&($1 in aa))  print $0","aa[$1]","sqrt(($3-aa[$1])*($3-aa[$1]))}' dump_weizhang_${DEALDATE_1}.txt xiafa_${DEALDATE_1}0600_to_${DEALDATE_2}0500_count_weizhang.txt > weizhang_final_${DEALDATE_1}.txt
#awk -F',' -v CODE_DIR=xiafa_201607270600_to_201607280500_count_dianbo.txt 'BEGIN{print "APPCODE,name,t-1,t-2,gap";}{if(FILENAME==CODE_DIR) aa[$1]=$3;else if(FILENAME != CODE_DIR&&($1 in aa))  print $0","aa[$1]","sqrt(($3-aa[$1])*($3-aa[$1]))}' xiafa_201607270600_to_201607280500_count_dianbo.txt xiafa_201607280600_to_201607290500_count_dianbo.txt > dianbo_final.txt
awk -F',' -v CODE_DIR=xiafa_${DEALDATE_3}0600_to_${DEALDATE_1}0500_count_dianbo.txt 'BEGIN{print "APPCODE,业务名称,昨天点播量,前天点播量,差异";}{if(FILENAME==CODE_DIR) aa[$1]=$3;else if(FILENAME != CODE_DIR&&($1 in aa))  print $0","aa[$1]","sqrt(($3-aa[$1])*($3-aa[$1]))}' xiafa_${DEALDATE_3}0600_to_${DEALDATE_1}0500_count_dianbo.txt xiafa_${DEALDATE_1}0600_to_${DEALDATE_2}0500_count_dianbo.txt > dianbo_final_${DEALDATE_1}.txt
wget -N "http://192.100.6.31:9999/data/sort/count.txt"
sed 's/ //g' count.txt > count1.txt
awk -F',' -v CODE_DIR=count1.txt '{if(FILENAME==CODE_DIR) aa[$1]=$2;else if(FILENAME != CODE_DIR&&($1 in aa))  print $0","aa[$1]","sqrt(($3-aa[$1])*($3-aa[$1]))}' count1.txt xiafa_${DEALDATE_1}0600_to_${DEALDATE_2}0500_count_baoyue.txt | sort -rn -k2 > baoyue_tmp_${DEALDATE_1}.txt
awk -F',' -v CODE_DIR=${DIC_baoyue} 'BEGIN{print "SERVCODE,业务名称,下发数量,DUMP量,差异";}{if(FILENAME==CODE_DIR) aa[$3]=$2;else if(FILENAME != CODE_DIR&&($1 in aa))  print $1","aa[$1]","$2","$3","$4}' ${DIC_baoyue} baoyue_tmp_${DEALDATE_1}.txt > baoyue_final_${DEALDATE_1}.txt
--------------------群发邮件脚本-----------
----------前向-----------------------
#!bin/bash
DEALDATE=`date -v-1d  +%Y%m%d`
echo ${DEALDATE}
echo "qiangxiang_monitor"`date -v-1d  +%Y%m%d` >>  /data/211/log/monitor_email.log

/usr/local/bin/php /data/211/bin/qianxiang_monitor_sedMail.php /data/monitor/baoyue_final_${DEALDATE}.txt >> /data/211/log/monitor_email.log

echo ${DEALDATE}
---------------------
<?php
	/**
	* @desc 前向监控 每天发送 
	* @author wangyuan
	* @date 2016-07-29 17:35
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
	$headers .= "Cc:cuiyou@umessage.com.cn,qinlu@umessage.com.cn,liuyh@umessage.com.cn,wuying@umessage.com.cn,183644346@qq.com\n";
	$headers .= "Content-type:multipart/mixed;boundary=\"$boundary\"";
	$subject = iconv("UTF-8", "gbk", "前向监控邮件---".$end_time."日报告");
	$to = "13581960272@139.com,283049708@qq.com";
	var_dump(mail($to, $subject,$body,$headers));

?>
-----------------
crontab
#monitor
10 * * * * /bin/sh /data/211/bin/monitor.sh  > /dev/null 2>&1
00 08 * * * /bin/sh /data/211/bin/monitor2.sh > /dev/null 2>&1
00 13 * * * /bin/sh /data/211/bin/weizhang_dump.sh > /dev/null 2>&1
15 13 * * * /bin/sh /data/211/bin/monitor3.sh > /dev/null 2>&1
20 13 * * * sh /data/211/bin/qianxiang_monitor_mail.sh  > /dev/null 2>&1
23 13 * * * sh /data/211/bin/dianbo_monitor_mail.sh  > /dev/null 2>&1
26 13 * * * sh /data/211/bin/weizhang_monitor_mail.sh  > /dev/null 2>&1





