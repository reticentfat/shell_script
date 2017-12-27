<?php
$rootpath=@exec("pwd");
require ($rootpath . "/web2_db.php");
 // 将文件内容读入数组
 function get_impfile($filename)
   { 
      $a=array();
     if(is_file($filename))
     {
       $fp=fopen($filename,'r');
       while($oneline=fgets($fp,4096))
       {
         $a=split('\|',$oneline);
         if(is_file($a[0])) 
         {
           if(filetype($a[0])=="file")
           {
             $imp_file[$a[0]]=$a[1];
           }
         }
       }
       fclose($fp);
     }
     else{
      $imp_file["emp"]=1;
     }
     return $imp_file;
   }
 //判断当前文件是否已经导入数据库
 function is_impmysql($filename,$file_array)
 {
      if(is_file($filename))
      {
        $arr=stat($filename);

        $lastmodifytime=(int)$arr[9];

        if(array_key_exists($filename,$file_array) && $file_array[$filename]==$lastmodifytime){
          return 1;
        }
        else{
          return 0;
        }
      }
      else 
      {
        return 0;
      }
 }
 function write_log($filename,$logfile)
 {
     if(is_file($filename))
     {
        $arr=stat($filename);
        #取日志文件的时间
        if(!is_file($logfile)){
            $sfp=fopen($logfile,'w');
            fclose($sfp);
         }
        $log_time=stat($logfile);
        $lastmodifytime=(int)$arr[9];
        #取当前系统时间
        $currttime=mktime(0,0,0,date("m"),date("d"),date("Y"));
        if (((int)$log_time[9] < $currttime) && ((int)$log_time[7]>100*1024*1024)) //文件大小限制在100M保留大约3个月的日志
        {
          $fp=fopen($logfile,'w'); //重建文件
        } 
        else
        {
          $fp=fopen($logfile,'a');  //向文件追加
        }
        $line=$filename."|".$lastmodifytime."\n";
        if(fwrite($fp,$line)==true)
        {
          return 1;
        }
        else {
          return 0;
        }
        fclose($fp);
     }
     else
     {
        return 0;
     }
 }

/*
获取有效csv
*/
function get_csv_file($day_rawpath,&$dict_convert,$logfile_arr)
{
   $ret_arr=array();
   if (is_dir($day_rawpath)) {
     if ($dh = opendir($day_rawpath)) {
       while (($file = readdir($dh)) !== false) {
         $onefile=$day_rawpath."/".$file;
          # 判断文件是否已经加载过，如果已经加载不在加载避免重复入库
          if(is_impmysql($onefile,$logfile_arr)==0)
          {  
	     if($file!="." && $file!=".." && ereg("^report\.region\.(.*)\.csv",$file,$regs))
	     {
		$onetablekey=$regs[1];
		if(array_key_exists($onetablekey,$dict_convert))
		{
     		  $ret_arr[$onefile]=$onetablekey;
		}
	     }
	  }
         }
	  closedir($dh);
	 }
       }
      return $ret_arr;

}

define("INPUT_DIR", '/logs/out/dana/report/');
/* 记录每日加载的文件名，文件时间 */
$log_file="/logs/out/dana/target/stats/web2_imp_csv.log";
//读取导入日志
$logfile_arr=get_impfile($log_file);

//取最近一天内变化的文件的所在的目录
$last_line=system('find /logs/out/dana/report -type f -name \'report.region.*.csv\' -mtime -1|awk \'{print substr($1,1,index($1,"report.region")-2)}\'|sort -u |awk \'{if(NR>1) s=s"|"$1 ;else s=$1}END{print s}\'',$retval);
$ret_arr=explode("|",$last_line);

//获取可用的字典对照表
$dict_convert=array();
$query="select id,name,cname from danaweb_dataset;";
$result = mysql_query($query,$g_mysql);
while($row = mysql_fetch_array($result))
{
        //取表名
        if(strpos($row[name],"_day")>0){
           $onekey=substr($row[name],0,strpos($row[name],"_day"));
        } else if(strpos($row[name],"_week")>0){

           $onekey=substr($row[name],0,strpos($row[name],"_week"));
        }else if(strpos($row[name],"_month")>0){

           $onekey=substr($row[name],0,strpos($row[name],"_month"));
        }else {
         continue;
        }     
	$onetemplate="";
	$query1="select id,column_name,column_cname from danaweb_datasetcolumn where dataset_id='".$row[id]."' order by id asc;";
	$result1 = mysql_query($query1,$g_mysql);
        $row_num=0;
	while($row1 = mysql_fetch_array($result1))
	{ 
          if(($row1[column_name]!="end_date") && ($row1[column_name]!="begin_date") ){
             $row_num=$row_num+1; 
             $onetemplate.=$row1[column_name]."='#arg".$row_num."#',";
           }
	}
	$dict_convert[$onekey]=$onetemplate;
}
//轮训可用目录，解析csv入库
$temp_key = "";

for($i=0;$i<count($ret_arr);$i++)
{
	$onepath=$ret_arr[$i];
	$lastpath=substr($onepath,strrpos($onepath,"/")+1);

	$time_tail="day";
	$time_begin=substr($lastpath,0,4)."-".substr($lastpath,4,2)."-".substr($lastpath,6,2);
	$time_end=substr($lastpath,0,4)."-".substr($lastpath,4,2)."-".substr($lastpath,6,2);
	if(ereg("^week_(.*)_(.*)",$lastpath,$regs))
	{
		$time_tail="week";
		$time_begin=substr($regs[1],0,4)."-".substr($regs[1],4,2)."-".substr($regs[1],6,2);
		$time_end=substr($regs[2],0,4)."-".substr($regs[2],4,2)."-".substr($regs[2],6,2);
	}else if(ereg("^month_(.*)",$lastpath,$regs))
	{
		$time_tail="month";
		$days_num=date("t",mktime(0,0,0,substr($regs[1],4,2),1,substr($regs[1],0,4)));
		$time_begin=substr($regs[1],0,4)."-".substr($regs[1],4,2)."-01";
		$time_end=substr($regs[1],0,4)."-".substr($regs[1],4,2)."-".$days_num;
	}

	$onepath_csv=array();
	$onepath_csv=get_csv_file($onepath,$dict_convert,$logfile_arr);

  foreach($onepath_csv as $key=>$value)
  {
    //echo "file is ".$key."==".$value."==\n";
   $flag=0;
   $onetemp=$dict_convert[$value];
   $onetable=$value."_".$time_tail;
   $fp = fopen($key, 'r');
   $index=0;
   $delsql="DELETE FROM $onetable WHERE `begin_date` = '$time_begin' AND `end_date` = '$time_end';";
   //echo $delsql."\n";
   $del_result = mysql_query($delsql,$p_mysql);
   if(!$del_result){
      $flag=1;
      echo mysql_errno($p_mysql) . ":" . mysql_error($p_mysql).":".$delsql."\n";
      continue;
   }
   //取消索引检测
    $qry="/*!40000 ALTER TABLE `".$onetable."` DISABLE KEYS */;";
    mysql_query($qry,$p_mysql);
   while($input = fgets($fp, 4096))
   {
     $oneline=trim($input);
     $onesql=$onetemp;
     //跳过表头
     if($index==0 || $oneline==""){
	$index++;
	continue;
     }
     $oneline_arr=split(",",trim($oneline));
     for($k=0;$k<count($oneline_arr);$k++)
     {
       $onesql=str_replace("#arg".($k+1)."#",$oneline_arr[$k],$onesql);
     }
     $onesql="insert into $onetable set ".$onesql." begin_date='$time_begin',end_date='$time_end';";

     $ins_result = mysql_query($onesql,$p_mysql);
     if(!$ins_result)
     {
       //标志一个表导入过程中是否出错； 
       $flag=1;
       //一旦有错就退出当前表的导入
       if($temp_key != $key)
       {
          echo "[file:".$key."|".$value."]\n";
          $temp_key = $key;
       }
       echo mysql_errno($p_mysql) . ":" . mysql_error($p_mysql).":".$onesql."\n";
       continue;
     }
   }
   $qry="/*!40000 ALTER TABLE `".$onetable."` ENABLE KEYS */;";
   mysql_query($qry,$p_mysql);
   if($flag==0){
     $bb=write_log($key,$log_file);
   } 
   fclose($fp);
  }
}

print("========================The end===========================");

?>
