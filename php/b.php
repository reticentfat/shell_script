<?php
  get_user_sub_info('13422488390');

  function get_user_sub_info($mobile,$servcode='',$appcode=''){
  $url = "http://192.100.6.33:8888/services?id=".$mobile."&servcode=".$servcode."&appcode=".$appcode;
  echo $url."\n";
  $ch2 = curl_init();
  curl_setopt($ch2, CURLOPT_URL, $url);
  curl_setopt($ch2, CURLOPT_HEADER, false);
  curl_setopt($ch2, CURLOPT_RETURNTRANSFER, 1);
  $orders=curl_exec($ch2);
  $result = strip_tags($orders);
  $log = $result ;
  echo $result."\n";
  curl_close($ch2);
  if($result){
    $result = json_decode($result);
    $result_flag=array();
    $result_flag = $result->result;
    $service = $result->services;
    echo $result_flag."\n";
    print_r ($service);
    if($result_flag){
      $ret = '1' ;
      if(count($service) == 0){
        $ret = '-1';
      }
    }else{
      $ret = "ERRCODE:".$errcode_flag;
    }
  }else{
    $ret ='-1';
  }
  return $service;
}
?>
