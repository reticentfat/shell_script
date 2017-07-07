[gateway@wtraffic /data/211/bin/sendmail]$ cat foshan_wzemail.sh
#!bin/bash
if [ $# -eq 1 ];then
   AGO_DAY1=$1

   
fi

if [ ${AGO_DAY1:=999} = 999 ];then
DEALDATE=`date -v-1d  +%Y-%m-%d`

else
DEALDATE=`date -v-${AGO_DAY1}d  +%Y-%m-%d`

fi

echo `date -v-1d  +%Y%m%d` >  /data/211/log/fswz_email.log
#cat /home/wuying/foshan_wz/fosha_2014-08-25-insertupdate.txt | sed "s/$/`echo  \\\r`/" | awk -F'|' '{print $1"|"$2"|"substr($3,1,2)}' > /home/wuying/foshan_wz/fosha_2014-08-25-insertupdate_ok.txt
#cat /home/wuying/foshan_wz/fosha_${DEALDATE}-insertupdate.txt | sed 's/$'"/`echo \\\r`/"  > /home/wuying/foshan_wz/fosha_${DEALDATE}-insertupdate_ok.txt

/usr/local/bin/php /data/211/bin/sendmail/mail_new.php /data/foshan_wz/fosha_${DEALDATE}-insertupdate.txt >> /data/211/log/fswz_email.log
-----------------------------------------------
<?php
require 'PHPMailer/PHPMailerAutoload.php';

$file = $_SERVER['argv'][1];
	 
	if( !file_exists($file)) {
		exit;
	}


$end_time = date("Y-m-d");
$start_time = date("Y-m-d" ,time()-3600*24);
$mail = new PHPMailer;

$mail->isSMTP();
$mail->CharSet="utf-8"; 
$mail->Host = "mail.umessage.com.cn";
$mail->Port = 25;
$mail->SMTPAuth = true;
$mail->Username = "***";
$mail->Password = "***";
$mail->setFrom('shuju@umessage.com.cn', "佛山违章--".$start_time."日新增及更新日志");
$mail->addReplyTo('shuju@umessage.com.cn', "佛山违章--".$start_time."日新增及更新日志");
$mail->addAddress('13528953477@139.com', '13528953477');
$mail->addAddress('283049708@qq.com', '283049708');
$mail->Subject = "佛山违章--".$start_time."日新增及更新日志";
$mail -> Body = "佛山违章--".$start_time."日新增及更新日志";
$mail -> AddAttachment($file,"佛山违章--".$start_time."日新增及更新日志");


/*
$mail->isSendmail();
$mail->setFrom('shuju@umessage.com.cn', "佛山违章--".$start_time."日新增及更新日志");
$mail->addReplyTo('shuju@umessage.com.cn', "佛山违章--".$start_time."日新增及更新日志");
$mail->addAddress('mapf@umessage.com.cn', 'CP');
$mail->Subject = "佛山违章--".$start_time."日新增及更新日志";
$mail -> Body = "佛山违章--".$start_time."日新增及更新日志";
$mail -> AddAttachment($file,"佛山违章--".$start_time."日新增及更新日志");
*/

if (!$mail->send()) {
    echo "Mailer Error: " . $mail->ErrorInfo;
} else {
    echo "Message sent!";
}

?>
