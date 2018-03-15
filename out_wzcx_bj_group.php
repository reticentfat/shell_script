<?
require_once("/data0/12580/api/common/common_wireless_api.php");
require_once('/data0/12580/api/lib/download_api.php');
require_once("/data0/12580/api/bj_wzcx_new/global.php");
require_once("/data0/12580/api/bj_wzcx_new/lib_bj_wzcx.php");
require_once("/data0/12580/api/bj_wzcx_new/fs_msg.php");

$download_dir = '/data0/12580/api_cron/cron_wzcx_bj/';



if(empty($argv[1])){
  $msg = $argv[1].'---未取到缺少参数';
  $fp=fopen('error.log', "a+");
  if($fp) {
    @fputs($fp,strftime("%y%m%d %H:%M:%S").":\tPATH: ".getcwd()."\tcontent: ".$msg."\n");
    @fclose($fp);
  }

  exit();
}

$p_name = date('Ymd');
//$c_name = date('H') ;
//  $c_name = date('H') - 1;
$c_name = date('H',time()-3600);
$s_path = $download_dir.'M100805/'.$argv[1].'/'.$p_name.'/'.$c_name.'/'.'data_'.$argv[1].'.txt';

//群发日志
$log_fp_path =$download_dir.'log/'.$argv[1].'/'.$p_name.'/'.'data_fp_'.$argv[1].'.txt';

if(!is_dir($download_dir.'log/'.$argv[1].'/'.$p_name)){
    mkdir($download_dir.'log/'.$argv[1].'/'.$p_name,0777,true);
//资费
if($argv[1]=='general_1'){
    $CAR_BJ_WZCX_FEE_CODE = $CAR_BJ_WZCX_FEE_A_CODE;
}elseif($argv[1]=='general_2'){
     $CAR_BJ_WZCX_FEE_CODE = $CAR_BJ_WZCX_FEE_B_CODE;
}elseif($argv[1]=='general_3'){
     $CAR_BJ_WZCX_FEE_CODE = $CAR_BJ_WZCX_FEE_C_CODE;
}elseif($argv[1]=='general_4'){
     $CAR_BJ_WZCX_FEE_CODE = $CAR_BJ_WZCX_FEE_D_CODE;
}

if( is_file($download_dir.'M100805/'.$argv[1].'/'.$p_name.'/'.$c_name.'/'.'data_'.$argv[1].'.txt')){
  $fp = fopen($download_dir.'M100805/'.$argv[1].'/'.$p_name.'/'.$c_name.'/'.'data_'.$argv[1].'.txt',"r");
  
  $log_fp = fopen($log_fp_path,'a');
  $str_50 = '';
  $i=1;
  $send_msg='';
  while(!feof($fp)){
    $content = fgets($fp);
    $content = str_replace("\r\n",'',$content);
    $content = trim(str_replace("\n",'',$content));
    $content_arr = explode("\t",$content);
    $str_50 .= $content_arr[0].",";
    if(empty($send_msg)){ $send_msg = $content_arr[1];}
    
    if($i == 50){
        $str_50 = trim($str_50,',');
        $ret_val =  send_msg_group_python($interface_type='1',$send_msg,$CAR_BJ_WZCX_FEE_CODE,$str_50,$mt_long_code,'0','010','','1',$auto_long_msg_type);
        $time_1 = date('Y-m-d H:i:s');
        fwrite($log_fp,$str_50."\t".$time_1."\t".$ret_val."\n");
        $i = 0;
        $str_50 = '';
        usleep(2000);
    }else{
        $i++;
    }
    
  }
  if($i != 0 || $i != 1){
        $str_50 = trim($str_50,',');
        $ret_val =  send_msg_group_python($interface_type='1',$send_msg,$CAR_BJ_WZCX_FEE_CODE,$str_50,$mt_long_code,'0','010','','1',$auto_long_msg_type);
        $time_1 = date('Y-m-d H:i:s');
        fwrite($log_fp,$str_50."\t".$time_1."\t".$ret_val."\n");
        $str_50 = '';
        $i = 0;
    }
    
    //发送完成日志
    $msg = $argv[1].'--下发完成';
    $fp=fopen('success.log', "a+");
    if($fp) {
      @fputs($fp,strftime("%y%m%d %H:%M:%S")."|\tPATH: ".$s_path."|\t".$c_name."--".$msg."\n");
      @fclose($fp);
    }
     @fclose($log_fp);
	
}else{
  $msg = $argv[1].'--未有下发文件';
  $fp=fopen('success.log', "a+");
  if($fp) {
    @fputs($fp,strftime("%y%m%d %H:%M:%S")."|\tPATH: ".$s_path."|\t".$c_name."--".$msg."\n");
    @fclose($fp);
  }

  exit();

}
?>
