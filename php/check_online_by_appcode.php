<?php
if($argc != 3)
{
	echo "usage: php ". $argv[0] . " [inputFileName] [outputFileName]\n";
	exit;
}
set_time_limit (0);
ini_set("memory_limit","1024M");

$inFileName = $argv[1];
$outFileName = $argv[2];

if(file_exists($outFile))
{
	unlink($outFile);
}

if(!($outFileHandle = fopen($outFileName,"w")))
{
	$logInfo="open $outFileName error";
	exit;
}

$sourceString = file($inFileName);
$count = 1;
foreach ($sourceString as $src)
{
	$dataArray = explode("^",$src);
	$mobile = trim($dataArray[0]);
	$appcode = trim($dataArray[1]);

	get_user_sub_info($mobile,'',$appcode,$get_ext1,$order_time);
//	 echo "mobile:".$mobile."\tprovince:".$province."\tcity:".$city."\text1:".$ext1."\tarea:".$area."\n";
	echo $count++."\n";

	$data = $mobile."\t".$appcode."\t".$get_ext1."\t".$order_time."\n";

	fputs($outFileHandle,$data);
}
fclose($outFileHandle);



function get_user_sub_info($mobile,$servcode='',$appcode='',&$get_ext1,&$order_time){
$url = "http://192.100.6.33:8888/services?id=".$mobile."&servcode=".$servcode."&appcode=".$appcode;
//echo $url."\n";
$ch2 = curl_init();
curl_setopt($ch2, CURLOPT_URL, $url);
curl_setopt($ch2, CURLOPT_HEADER, false);
curl_setopt($ch2, CURLOPT_RETURNTRANSFER, 1);
$orders=curl_exec($ch2);
$result = strip_tags($orders);
$log = $result ;
//echo $result."\n";

curl_close($ch2);

preg_match("/\"subcodes\": \[.*?\].*\"ext1\": \"(.*?)\",.*\"order_time\": \"(.*?)\",/", $result, $matches);
$order_time = $matches[2];
$get_ext1 = $matches[1];
//echo $ext1;
return 1;

/*
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
*/
}
?>


