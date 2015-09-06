<?
//导出优惠卷数据sql

define('ROOT', dirname(__FILE__).'/');
define('EF_ROOT', '/data/www/ef');
define('DOWN_ROOT', '/data/www/cron/down/img');

$exp_dir = "/data/www/cron/";
$out_dir = "/data/www/cron/down/data/";
$file_name = date("YmdH")."_YHJ.txt";
$exp_name = "YHJ.txt";
$conn = mysql_connect('192.100.7.45:3306','w_master_db','iWrQj4pdr4t9fNDc')
or die("Could not connect: " . mysql_error());
mysql_query("SET NAMES 'utf-8'");
mysql_select_db("caipiaoManage_ef");
$sql  = "select acdb_id, store_discount , store_code,store_source,region_name,trade_name,store_intro,store_concessions,store_starttime,store_endtime,sub_col_1,sub_col_2,num,is_send_mms,is_send_sms,store_input_time,fax,down_num from ef_store  where status = 1 and (is_send_mms = 1 or is_send_sms = 1) and acdb_id > 0 and store_endtime >= '".date("Y-m-d")."'";
//echo $sql."\n";
$i = 0 ;
$result = mysql_query($sql);
$fp=fopen($exp_dir.$file_name, "a+");
while ($row = mysql_fetch_array($result)){
	if($fp) {
		$len = strlen($row['store_code']);
		if ($len == 9) {
			$is_send_mms = $row['is_send_mms'] == 1 ? 1 : 0;
			$is_send_sms = $row['is_send_sms'] == 1 ? 1 : 0;
			$v = array();$k = array();
			$down_num = '';
			if (!empty($row['down_num'])) {
				$down_num_arr = array();
				$down_num_arr = unserialize($row['down_num']);
				$v = array_values($down_num_arr);
				$k = array_keys($down_num_arr);
				$down_num = $k[0].'|'.$v[0];
			}
			$store_discount = str_replace(array("\r\n","\r","\n","\t"),"",$row['store_discount']);
			$store_intro = str_replace(array("\r\n","\r","\n","\t"),"",$row['store_intro']);
			$store_concessions = str_replace(array("\r\n","\r","\n","\t"),"",$row['store_concessions']);
			$num = str_replace(array("\r\n","\r","\n","\t"),"",$row['num']);
			@fputs($fp,$row['acdb_id']."\t".trim($store_discount)."\t".$row['store_code']."\t".$row['store_source']."\t".$is_send_mms."\t".$is_send_sms."\t".trim($row['region_name'])."\t".$row['trade_name']."\t".$store_intro."\t".$store_concessions."\t".$row['store_starttime']."\t".$row['store_endtime']."\t".trim($num)."\t".$row['store_input_time']."\t".trim($row['fax'])."\t".$down_num."\t".$row['sub_col_1']."\t".trim($row['sub_col_2'])."\n");
			
		}
	}
}
@fclose($fp);
mysql_free_result($result);
mysql_close($conn);

exec("/bin/cp ".$exp_dir.$file_name." ".$out_dir.$exp_name);
echo "finish\n";




	/*
	 * @ 传入商户代码获取所在彩信图片|商户图片
	 * @ 提供www页面展示
	 * @ 2014-09-29
	 * 
	 * @ return
	 * 
	 */
	function getStoreImges($store_code) {
		$storePic = $absolute_path = $path = $mk_dir = '';	
		if ($store_code) {
			$path = getStorePic($store_code,$thumb = false,$is_local=false);//获取提供下载图片
			if (!is_file($path)) {
				$absolute_path = getStorePicDir($store_code);
				$storePic = getStorePic($store_code,$thumb = false);	//获取本地商户图片
				$mk_dir = ef_mkdir($absolute_path, $mode = 0777);	//创建目录
				if (!empty($storePic)) {
					exec("/bin/cp ".$storePic." ".DOWN_ROOT.$absolute_path);
					
				} else {
					$storePic = getMmsImg($store_code);	//获取彩信图片
					if (!empty($storePic)) {
						exec("/bin/cp ".$storePic." ".DOWN_ROOT.$absolute_path.'2'.md5($store_code).'.jpg');
					}
				}
			}

		}
	}


    /**
	* @获取商户存储规则
	* @store_code string 商户代码
	* @thumb bool 是否生成缩略图
	* @ext string 扩展文件名
	* 
	*/
	function getStorePicDir($store_code) {
		$dir = '';
		$code = sprintf("%09d", $store_code);
		$dir1 = substr($code, 0, 3);
		$dir2 = substr($code, 3, 2);
		$dir3 = substr($code, 5, 2);
		$dir = '/'.$dir1.'/'.$dir2.'/'.$dir3.'/';
		return $dir;
	} 



    /**
	* @获取商户图片地址
	* @store_code string 商户代码
	* @thumb bool 是否生成缩略图
	* @ext string 扩展文件名
	* 
	*/
	function getStorePic($store_code,$thumb = false,$is_local=true) {
		$path = $localPath = $paths = '';
		if ($store_code) {
			$code = sprintf("%09d", $store_code);
			$dir1 = substr($code, 0, 3);
			$dir2 = substr($code, 3, 2);
			$dir3 = substr($code, 5, 2);
			$filename = $thumb ? '0'.md5($store_code).'.jpg' : '1'.md5($store_code).'.jpg';
			$downPath = DOWN_ROOT.'/'.$dir1.'/'.$dir2.'/'.$dir3.'/'.$filename;
			$localPath = EF_ROOT.'/data/store/'.$dir1.'/'.$dir2.'/'.$dir3.'/'.$filename;
			$path = $is_local ? $localPath : $downPath;
			if (is_file($path)) {
				$paths = $path;
			}
		}
		return $paths;
	} 

	/*
	 * @ 传入商户代码获取所在彩信图片
	 * @ $store_code 商户code
	 * 
	 * @ return
	 * 
	 */
	function getMmsImg($store_code) {
		$path = '';
		$result = get_store_code_info($store_code);
		if (!empty($result)) {	
			$store_id = $result['store_id'];
			$mms_id = get_mms_store_info($store_id);
			$pid = get_mms_zhen_list($mms_id);			
			$path = get_pic_path($pid);
			$localPath = EF_ROOT ."/" . $path;
			if (is_file($localPath)) {
				$path = $localPath;
			}			
		}			
		return $path;
	}

	/**
	 * 通过商户代码取得某商户信息
	 * @param int $code:商户代码
	 * @return array
	 */
	function get_store_code_info($code){
		global $conn;
		$sql = "SELECT * FROM ef_store  WHERE store_code='".$code."'";
		$query = mysql_query($sql,$conn);
		$result = mysql_fetch_array($query);
		return !empty($result) ? $result : false;
	}

	/**
	 * 取得某商户对应的彩信ID
	 * @param array $params $store_id:商户id
	 * @return array
	 */
	function get_mms_store_info($store_id){
		global $conn;
		if (intval($store_id)) {
			$sql = "SELECT mms_id FROM ef_mmslist WHERE store_id = '".$store_id."'";
			$query = mysql_query($sql,$conn);
			$mms_id = @mysql_result($query, 0);
		}
		return empty($mms_id) ? '' : $mms_id;
	}

	/**
	 * 取得某彩信的所有帧
	 * @param array $params $mms_id:彩信id
	 * @return array
	 */
	function get_mms_zhen_list($mms_id){
		global $conn;
		if (intval($mms_id)) {
			$sql = "SELECT pid FROM ef_zhen WHERE mms_id = $mms_id ORDER BY position ASC";
			$query = mysql_query($sql,$conn);
			$pid = @mysql_result($query, 0);
		}

		return empty($pid) ? '' : $pid;
	}

	/**
	 * 取得某图片路径
	 * @param array $params $pid:图片id
	 * @return array
	 */
	function get_pic_path($pid){
		global $conn;
		if (intval($pid)) {
			$sql = "SELECT filepath FROM ef_pic WHERE pid='".$pid."'";
			$query = mysql_query($sql,$conn);
			$filepath = @mysql_result($query, 0);
		}
		return empty($filepath) ? '' : $filepath;
	}

	/**
	 * 创建目录（如果该目录的上级目录不存在，会先创建上级目录）
	 * 依赖于 DOWN_ROOT 常量，且只能创建 ROOT_PATH 目录下的目录
	 * 目录分隔符必须是 / 不能是 \
	 *
	 * @param   string  $absolute_path  绝对路径
	 * @param   int     $mode           目录权限
	 * @return  bool
	 */
	function ef_mkdir($absolute_path, $mode = 0777) {
	    if (is_dir($absolute_path)){
	        return true;
	    }
	
	    $root_path      = DOWN_ROOT;
	    $relative_path  = str_replace($root_path, '', $absolute_path);
	    $each_path      = explode('/', $relative_path);
	    $cur_path       = $root_path; // 当前循环处理的路径
	    foreach ($each_path as $path) {
	        if ($path) {
	            $cur_path = $cur_path . '/' . $path;
	            if (!is_dir($cur_path)) {
	                if (@mkdir($cur_path, $mode)){
	                    fclose(fopen($cur_path . '/index.htm', 'w'));
	                } else {
	                    return false;
	                }
	            }
	        }
	    }
	
	    return true;
	} 

?>
