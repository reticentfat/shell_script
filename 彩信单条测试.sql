192.100.7.1
/data/www/sms/jf_test
下执行php fs.php
修改php可以修改手机号，端口号，和彩信包
生活播报端口号为1065888090
  1 <?php
  2 require_once("/data0/12580/api/common/common_wireless_api.php");
  3 $test_mobile_array = array('13581960272','13699296779');
  4 
  5 $city_first_mms = "/data/www/sms/jf_test/flbk.zip";
  6 
  7 $i = 0;
  8 foreach ($test_mobile_array as $key => $value) {
  9          $i++;
 10    list($addr_info) = check_new_mobile_addr($value);
 11    $province = $addr_info['no'];
 12     $num = send_mms_python('1','1',$city_first_mms,'10611000',$value,'','1065888011111','2000',$province);
 13     echo '['.$i.'] '.$value.' ['.$province.'] ['.$num.']<br>';
 14 }
 15 
 16 
 17 exit;
 18 
 19 
 20 
 21 //send_mms_python('1','1',$city_first_mms,$this_mms_cg_fee_appcode,$mobile,'',$this_mms_longcode,'2000',$province);
 22 
 23 ?>
