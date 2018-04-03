<?
function auth_lv_comp($adm_lv, $lv_id) {
  return ($lv_id == 0)?true:(((1<<$lv_id)&$adm_lv)>0);
} // end of auth_lv_comp()


function auth_chk() {
  $auth_ret = false;

  $pid = (empty($_GET['pid']))?1:intval($_GET['pid']);
  if(_reg_page_data($pid)) {
    if(is_numeric($_SESSION['adm_lv'])) {
      if(auth_lv_comp($_SESSION['adm_lv'], ADM_PAGE_LV)) {
	$auth_ret = true;
      } else if(ADM_PAGE_LV>PAGE_ADM_LV &&	
	  auth_lv_comp($_SESSION['adm_lv'], PAGE_ADM_LV)) {
	$auth_ret = true;
      }
    }
  }

  return $auth_ret;
} // end of auth_chk()

function get_ques_by_cond($id='',$loginuser='',$page='',$pagesize='',$count=false) {
  global $db_opt;
  $ret = array();
  $def_odr = " ORDER BY INPUT_TIME  DESC ";
  if($count){
    $sql =  "SELECT count(*) as num  FROM question_new_info WHERE STATE = 1  ";
    if(!empty($loginuser)){
      $cond = " AND  QUESTION_INFO like '%".$loginuser."%' ";
    }

  }else{
    $sql  = "SELECT * FROM question_new_info WHERE STATE = 1 ";
    $cond = "";
    if(!empty($id)) {
      $cond = " AND id=".$id;
    }else{
      if(!empty($loginuser)){
	$cond = " AND QUESTION_INFO  like '%".$loginuser."%' ";
      }
      $limit = " limit ".($page-1)*$pagesize." , ".$pagesize;
    }
  }
  $ret = _db_query($db_opt,($sql.$cond.$def_odr.$limit));
  return $ret;
}

function set_ques_by_id($id,$opt_data){
  global $db_opt;
  $sql_val = array();
  if(empty($id)){
    $sql = "INSERT INTO question_new_info(QUESTION_INFO,REAL_ANSW,INPUT_TIME,NO,CITY,START_TIME,END_TIME,ADM_NAME) values('".$opt_data['QUESTION_INFO']."','".$opt_data['REAL_ANSW']."','".$opt_data['INPUT_TIME']."','".$opt_data['NO']."','".$opt_data['CITY']."','".$opt_data['START_TIME']."','".$opt_data['END_TIME']."','".$opt_data['ADM_NAME']."')";
  }else{
    foreach($opt_data as $key=>$val){
      $sql_val[]=$key."='".$val."'";
    }
    $sql = "UPDATE question_new_info  SET ".implode(",",$sql_val)." WHERE id=".$id;
  }
  $db_opt->connect();
  $db_opt->query($sql,true);
  if($db_opt->is_fail()){
    return false;
  }else{
    return true;
  }

}

function get_city_info() {
  global $db_opt;
  $def_odr      = " GROUP BY no ";
  $ret  = array();
  $sql = "SELECT * FROM addr_info ";
  $ret = _db_query($db_opt,($sql.$cond.$def_odr));
  return $ret;
} //

function get_nation_info($no=''){
  global $db_opt;
  $ret = array();
  if(!empty($no)){
    $no = str_replace(",","','",$no);
    $no = "'".$no."'";
    $cond = " WHERE no in (".$no.")";
  }
  $sql = "SELECT * FROM addr_info ";
  //echo $sql."\n";
  $ret = _db_query($db_opt,($sql.$cond.$def_odr));
  return $ret;

}


function get_ques_by_id($id=''){
  global $db_opt;
  $ret = array();
  $sql  = "SELECT * FROM question_new_info WHERE STATE = 1  ";
  $cond = "";

  if(is_numeric($id)) {
    $cond .= " AND  ID=".$id;
  } else {
  }
  $ret = _db_query($db_opt,($sql.$cond.$order));
  return $ret;

}

function del_ques_by_id($id){
  global $db_opt;
  $sql = "UPDATE question_new_info SET STATE='-1' WHERE ID=".$id;
  $db_opt->connect();
  $db_opt->query($sql,true);
  if($db_opt->is_fail()){
    return false;
  }else{
    return true;
  }
}



function get_page_by_cond($page_id, $parent_id, $order_seq="") {
  global $db_adm;
  $ret = array();

  $sql  = "SELECT * FROM page_arch";
  $cond = "";

  if(!empty($page_id)) {
    $cond .= " WHERE page_id=".$page_id;
  }

  if(!empty($parent_id)) {
    if(empty($cond)) {
      $cond = " WHERE parent_id=".$parent_id;
    } else {
      $cond .= " AND parent_id=".$parent_id;
    }
  }
  if($order_seq===true) {
    $order = " ORDER BY page_seq";
  } else {
    $order = "";
  }

  $ret = _db_query($db_adm,($sql.$cond.$order));
  return $ret;
} // end of get_page_by_cond()


function get_adm_by_cond($adm_name, $adm_passwd, $adm_id='') {
  global $db_adm;
  $ret = array();

  $sql  = "SELECT * FROM administrator";
  $cond = "";

  if(!empty($adm_name)) {
    $cond .= " WHERE adm_name='".$adm_name."' AND adm_pass='".$adm_passwd."'";
  } else {
    if(!empty($adm_id)) {
      $cond .= " WHERE adm_id=".$adm_id;
    }
  }

  $ret = _db_query($db_adm,($sql.$cond));
  return $ret;
} // end of get_adm_by_cond()



function get_adm_grp($adm_grp_id="") {
  global $db_adm;
  $def_odr	= " ORDER BY group_id";
  $ret	= array();

  $sql = "SELECT * FROM adm_group";
  if(is_numeric($adm_grp_id)) {
    $cond = " WHERE group_id=".$adm_grp_id;
  } else {
    $cond = "";
  }

  $ret = _db_query($db_adm,($sql.$cond.$def_odr));
  return $ret;
} // end of get_adm_grp()

function get_yhj_list($set_id="") {
  global $db_adm;
  $order = " ORDER BY INPUT_TIME DESC ";
  $ret  = array();

  $sql = "SELECT * FROM zj_yhl_set ";
  if(is_numeric($adm_grp_id)) {
    $cond = " WHERE ID=".$set_id;
  } else {
    $cond = "";
  }

  $ret = _db_query($db_adm,($sql.$cond.$order));
  return $ret;
} // end of get_adm_grp()


function del_yhj_by_id($set_id){
  global $db_adm;
  $sql = " UPDATE  zj_yhl_set SET STATE = -1  WHERE ID=".$set_id;
  $db_adm->connect();
  $db_adm->query($sql,true);
  if($db_adm->is_fail()){
    return false;
  }else{
    return true;
  }
}

function set_yhj_by_id($set_data){
  global $db_adm;
  $sql_val = array();
  $sql = "INSERT INTO zj_yhl_set(MMS_ID,START_TIME,END_TIME,SET_TYPE,SEL_2_NUM,ADM_NAME,INPUT_TIME) values('".$set_data['MMS_ID']."','".$set_data['START_TIME']."','".$set_data['END_TIME']."','".$set_data['SET_TYPE']."',".$set_data['SEL_2_NUM'].",'".$set_data['ADM_NAME']."',NOW())";
  $db_adm->connect();
  $db_adm->query($sql,true);
  if($db_adm->is_fail()){
    return false;
  }else{
    return true;
  }
}


function set_yhj_log($log_data){
  global $db_adm;
  $sql_val = array();
  $sql = "INSERT INTO zj_yhl_log( MMS_ID,SET_ID,DTIME ) values('".$log_data['MMS_ID']."','".$log_data['SET_ID']."',NOW())";
  $db_adm->connect();
  $db_adm->query($sql,true);
  if($db_adm->is_fail()){
    return false;
  }else{
    return true;
  }
}

function get_yhj_log($set_id) {
  global $db_adm;
  $order = " ORDER BY DTIME DESC ";
  $ret  = array();

  $sql = "SELECT * FROM zj_yhl_log ";
  $cond = " WHERE SET_ID=".$set_id;
  $ret = _db_query($db_adm,($sql.$cond.$order));
  return $ret;
} // end of get_adm_grp()


function get_mms($state=0){
  global $db_adm;
  $def_odr      = " ORDER BY id";
  $ret  = array();

  $sql = "SELECT * FROM mms ";
  if($state == 0){
    $cond = " WHERE state=0";
  }else{
     $cond = " WHERE state=1";

  }

  $ret = _db_query($db_adm,($sql.$cond.$def_odr));
  return $ret;

}
function get_ones_sms($user_name,$page='',$page_size=''){
  global $db_adm;
  $limit = $page_size;
  $def_odr      = " ORDER BY create_time desc";
  $ret  = array();

  $sql = "SELECT * FROM sms  ";
  $cond = " WHERE  create_person='".$user_name."' AND status<>-1";
  if(!empty($page)) {
    if($page==1 )
    {
      $limit_str = " limit 0,".$limit;
    }
    else
    {
      $begin = ($page-1)*$limit;
      $end = $limit;
      $limit_str = " limit ".$begin.",".$end;
    }
  } else {
    $limit_str = " ";
  }

  $sql =  $sql.$cond.$def_odr.$limit_str;
  $ret = _db_query($db_adm,$sql);
  return $ret;
}
function get_ones_mms($user_name,$page='',$page_size=''){
  global $db_adm;
  $limit = $page_size;
  $def_odr      = " ORDER BY create_time desc";
  $ret  = array();

  $sql = "SELECT * FROM mms  ";
  $cond = " WHERE  create_person='".$user_name."' AND status<>-1";
  if(!empty($page)) {
    if($page==1 )
    {
      $limit_str = " limit 0,".$limit;
    }
    else
    {
      $begin = ($page-1)*$limit;
      $end = $limit;
      $limit_str = " limit ".$begin.",".$end;
    }
  } else {
    $limit_str = " ";
  }

  $sql =  $sql.$cond.$def_odr.$limit_str;
  $ret = _db_query($db_adm,$sql);
  return $ret;
}
function get_check_sms($page='',$page_size=''){
  global $db_adm;
  $limit = $page_size;
  $def_odr      = " ORDER BY create_time desc";
  $ret  = array();

  $sql = "SELECT * FROM sms  ";
  $cond = " WHERE status<>-1";
  if(!empty($page)) {
    if($page==1  )
    {
      $limit_str = " limit 0,".$limit;
    }
    else
    {
      $begin = ($page-1)*$limit;
      $end = $limit;
      $limit_str = " limit ".$begin.",".$end;
    }
  } else {
    $limit_str = " ";
  }

  $sql =  $sql.$cond.$def_odr.$limit_str;
  $ret = _db_query($db_adm,$sql);
  return $ret;
}
function get_check_mms($page='',$page_size=''){
  global $db_adm;
  $limit = $page_size;
  $def_odr      = " ORDER BY create_time desc";
  $ret  = array();

  $sql = "SELECT * FROM mms  ";
  $cond = " WHERE status<>-1";
  if(!empty($page)) {
    if($page==1  )
    {
      $limit_str = " limit 0,".$limit;
    }
    else
    {
      $begin = ($page-1)*$limit;
      $end = $limit;
      $limit_str = " limit ".$begin.",".$end;
    }
  } else {
    $limit_str = " ";
  }

  $sql =  $sql.$cond.$def_odr.$limit_str;
  $ret = _db_query($db_adm,$sql);
  return $ret;
}

function get_sended_sms_num($date,$status){
  global $db_adm;
  $ret  = array();

  $sql = "SELECT dir_name,title,send_time,area FROM sms  ";
  $cond = " WHERE status=".$status." AND send_time like '".$date."%'";
  $order = " order by send_time,title";
  $sql =  $sql.$cond.$order;
  $ret = _db_query($db_adm,$sql);
  return $ret;
}

function get_sms_by_id($sms_id){
  global $db_adm;
  $def_odr      = " ORDER BY id";
  $ret  = array();

  $sql = "SELECT id,title,content,area,longcode,appcode,send_time,create_person,create_time,check_person_1,check_time_1,check_person_2,check_time_2,check_person_3,check_time_3,dir_name,file_name,check_1,check_2,check_3,status,test1,test2,test3,NOW()-send_time as overtime ,send_type,timing FROM sms";
  $cond = " WHERE id=$sms_id ";

  $sql =  $sql.$cond.$def_odr;
  $ret = _db_query($db_adm,$sql);
  return $ret;
}
function get_ready_timing_sms_nums(){
  global $db_adm;
  $ret  = array();
  $date = date('Y-m-d');
  $sql = "SELECT count(1) as num FROM sms";
  $cond = " WHERE (UNIX_TIMESTAMP(send_time) BETWEEN UNIX_TIMESTAMP(NOW()-INTERVAL 5 MINUTE) AND UNIX_TIMESTAMP(NOW()+INTERVAL 5 MINUTE)) AND (send_time BETWEEN '".$date." 10:00:00' AND '".$date." 22:00:00') AND check_1=1 AND check_2=1 AND check_3=1 AND status=0 AND timing=1";
  $sql =  $sql.$cond;
  //echo $sql."\n";
  $ret = _db_query($db_adm,$sql);
  return $ret[0]['num'];
}
function get_ready_timing_sms(){
  global $db_adm;
  $def_odr      = " ORDER BY send_time limit 0,1";
  $ret  = array();
  $date = date('Y-m-d');
  $sql = "SELECT * FROM sms";
  $cond = " WHERE (UNIX_TIMESTAMP(send_time) BETWEEN UNIX_TIMESTAMP(NOW()-INTERVAL 5 MINUTE) AND UNIX_TIMESTAMP(NOW()+INTERVAL 5 MINUTE)) AND (send_time BETWEEN '".$date." 10:00:00' AND '".$date." 22:00:00') AND check_1=1 AND check_2=1 AND check_3=1 AND status=0 AND timing=1";
  $sql =  $sql.$cond.$def_odr;
  echo $sql."\n";
  $ret = _db_query($db_adm,$sql);
  return $ret;
}
function get_ready_sms(){
  global $db_adm;
  $def_odr      = " ORDER BY send_time limit 0,1";
  $ret  = array();
  $date = date('Y-m-d');
  $sql = "SELECT * FROM sms";
  $cond = " WHERE send_time BETWEEN '".$date." 09:00:00' AND '".$date." 22:00:00' AND check_1=1 AND check_2=1 AND check_3=1 AND status=0 AND timing=2";
  $sql =  $sql.$cond.$def_odr;
  echo $sql."\n";
  $ret = _db_query($db_adm,$sql);
  return $ret;
}
function get_ready_mms(){
  global $db_adm;
  $def_odr      = " ORDER BY send_time limit 0,1";
  $ret  = array();
  $date = date('Y-m-d');
  $sql = "SELECT * FROM mms";
  $cond = " WHERE send_time BETWEEN '".$date." 09:00:00' AND '".$date." 22:00:00' AND check_1=1 AND check_2=1 AND check_3=1 AND status=0";
  $sql =  $sql.$cond.$def_odr;
  echo $sql."\n";
  $ret = _db_query($db_adm,$sql);
  return $ret;
}

function get_split_sms(){
  global $db_adm;
  $def_odr      = " ORDER BY send_time";
  $ret  = array();
  $date = date('Y-m-d');
  $sql = "SELECT * FROM sms";
  $cond = " WHERE send_time BETWEEN '".$date." 09:30:00' AND '".$date." 21:00:00' AND check_1=1 AND check_2=1 AND check_3=1 AND status=0";
  $sql =  $sql.$cond.$def_odr;
  $ret = _db_query($db_adm,$sql);
  return $ret;
}
function get_adm_lv($adm_lv_id, $show_all=false) {
  global $db_adm;
  $def_odr = " ORDER BY lv_id";
  $ret     = array();

  $sql = "SELECT * FROM adm_lv";
  if($show_all) {
    $cond = "";
  } else {
    if(empty($adm_lv_id)) {
      $cond = " WHERE lv_id>5";	// lv_id=1~5 保留給特殊用途
    } else {
      $cond = " WHERE lv_id=".$adm_lv_id;
    }
  }

  $ret = _db_query($db_adm,($sql.$cond.$def_odr));
  return $ret;
} // end of get_adm_lv()


function set_adm_grp_by_id($adm_grp_id, $adm_grp_attr) {
  /*
   */
}

function import_sql_file($filename)
{
  global $db_adm;
  $sql = "DROP TABLES  ".IMPORT_TABLE_NAME;
  $db_adm->connect();
  $db_adm->query($sql,true);
  if($db_adm->is_fail()){
    return false;
  }else{
   popen(MYSQL_COMMAND_DIR."mysql -u".DB_ADM_MASTER_USER." -p".DB_ADM_MASTER_PASSWD." -h".DB_ADM_MASTER_HOST." ".DB_ADM_MASTER_NAME." < ".$filename, "r");
    return true;
  }

}

function del_page_by_id($page_id){
  global $db_adm;
  $sql = "DELETE FROM page_arch WHERE page_id=".$page_id;
  
  $db_adm->connect();
  $db_adm->query($sql,true);
  if($db_adm->is_fail()){
    return false;
  }else{
     $page_data = get_page_by_cond('',$page_id);
     if($page_data){
	foreach($page_data as $val){
	  del_page_by_id($val['page_id']);
	} 
      }
     return true;
  }
}

function del_lv_by_id($lv_id){
  global $db_adm;
  $sql = "DELETE FROM adm_lv WHERE lv_id=".$lv_id;
  $db_adm->connect();
  $db_adm->query($sql,true);
  if($db_adm->is_fail()){
    return false;
  }else{
    return true;
  }
}

function del_mms_by_id($id){
  global $db_adm;
  $sql = "DELETE FROM mms WHERE id=".$id;
  $db_adm->connect();
  $db_adm->query($sql,true);
  if($db_adm->is_fail()){
    return false;
  }else{
    return true;
  }

}
function del_sms_by_id($id){
  global $db_adm;
  $sql = "UPDATE sms set status=-1 WHERE id=".$id;
  $db_adm->connect();
  $db_adm->query($sql,true);
  if($db_adm->is_fail()){
    return false;
  }else{
    return true;
  }

}

function del_mms_user_id($id){
  global $db_adm;
  $sql = "DELETE FROM mms_user WHERE mms_id=".$id;
  $db_adm->connect();
  $db_adm->query($sql,true);
  if($db_adm->is_fail()){
    return false;
  }else{
    return true;
  }

}
function del_grp_by_id($group_id){
  global $db_adm;
  $sql = "DELETE FROM adm_group WHERE group_id=".$group_id;
  $db_adm->connect();
  $db_adm->query($sql,true);
  if($db_adm->is_fail()){
    return false;
  }else{
    return true;
  }
}


function set_page_by_id($page_id, $page_data) {
  /*
     return bool 
   */
   global $db_adm;
   $sql_val = array();
   if(empty($page_id)){
     $sql = "INSERT INTO page_arch(parent_id,page_seq,page_lv,page_name,page_file,page_act,page_hid,page_col) values(".$page_data['parent_id'].",".$page_data['page_seq'].",".$page_data['page_lv'].",'".$page_data['page_name']."','".$page_data['page_file']."','".$page_data['page_act']."',".$page_data['page_hid'].",".$page_data['page_col'].")";
   }else{
     foreach($page_data as $key=>$val)
     {
       $sql_val[]= $key."='".$val."'";
     }
     $sql = "UPDATE page_arch SET ".implode(",",$sql_val)." WHERE page_id =".$page_id;
   }
   $db_adm->connect();
   $db_adm->query($sql,true);
   if($db_adm->is_fail()){
     return false;
   }else{
     return true;
   }
}

function set_grp_by_id($group_id,$group_data){
  global $db_adm;
  $sql_val = array();
  if(empty($group_id)){
    $sql = "INSERT INTO adm_group(group_name,group_lv) values('".$group_data['group_name']."',".$group_data['group_lv'].")";
  }else{
    foreach($group_data as $key=>$val){
      $sql_val[]=$key."='".$val."'";
    }
    $sql = "UPDATE adm_group SET ".implode(",",$sql_val)." WHERE group_id=".$group_id;
  }
  $db_adm->connect();
  $db_adm->query($sql,true);
  if($db_adm->is_fail()){
    return false;
  }else{
    return true;
  }
}

function set_lv_by_id($lv_id,$lv_data){
  global $db_adm;
  $sql_val = array();
  if(empty($lv_id)){
    $sql = "INSERT INTO adm_lv(lv_id,lv_name) values(".$lv_data['lv_id'].",'".$lv_data['lv_name']."')";
  }else{
    $sql = "UPDATE adm_lv SET lv_name='".$lv_data['lv_name']."' WHERE lv_id =".$lv_id;
  }
  $db_adm->connect();
  $db_adm->query($sql,true);
  if($db_adm->is_fail()){
    return false;
  }else{
    return true;
  } 
}

/*
function set_mms_by_id($mms_id,$mms_data){
  global $db_adm;
  $sql_val = array();
  if(empty($lv_id)){
    $sql = "INSERT INTO mms(id,name,createuser,createtime,sendtime,url) values(".$mms_data['id'].",'".$data['name']."','".$_SESSION['adm_name']."',NOW(),'".$mms_data['sendtime']."','".$mms_data['url']."')";
  }else{

    foreach($mms_data as $key=>$val){
      $sql_val[]=$key."='".$val."'";
    }
    $sql = "UPDATE mms SET ".implode(",",$sql_val)." WHERE id=".$id;
  }
  $db_adm->connect();
  $db_adm->query($sql,true);
  if($db_adm->is_fail()){
    return false;
  }else{
    return true;
  }

}
*/
function set_mms_by_id($mms_id,$mms_data){
  global $db_adm;
  $sql_val = array();
  if(empty($mms_id)){
    $sql = "INSERT INTO mms(title,mms_file_name,content,area,longcode,appcode,send_time,dir_name,status,create_person,create_time,test1,test2,test3,file_name,check_person_2,check_time_2,check_2) values('".$mms_data['title']."','".$mms_data['mms_file_name']."','".$mms_data['content']."','".$mms_data['area']."','".$mms_data['longcode']."','".$mms_data['appcode']."','".$mms_data['send_time']."','".$mms_data['dir_name']."',0,'".$_SESSION['adm_name']."',NOW(),'".$mms_data['test1']."','".$mms_data['test2']."','".$mms_data['test3']."','".$mms_data['file_name']."','".$mms_data['check_person_2']."',NOW(),".$mms_data['check_2'].")";
  }else{

    foreach($mms_data as $key=>$val){
      $sql_val[]=$key."='".$val."'";
    }
    $sql = "UPDATE mms SET ".implode(",",$sql_val)." WHERE id=".$mms_id;
  }
  $db_adm->connect();
  $db_adm->query($sql,true);
  if($db_adm->is_fail()){
    return false;
  }else{
    return true;
  }
}
function set_split_sms_by_id($sms_id,$sms_data){
  global $db_adm;
  $sql_val = array();
  if(empty($sms_id)){
    $sql = "INSERT INTO sms(title,content,area,send_time,dir_name,status,create_person,create_time,test1,test2,test3,longcode,appcode,file_name,check_person_2,check_time_2,check_2,check_person_1,check_time_1,check_1,check_person_3,check_time_3,check_3,send_type) values('".$sms_data['title']."','".$sms_data['content']."','".$sms_data['area']."','".$sms_data['send_time']."','".$sms_data['dir_name']."',0,'".$sms_data['create_person']."',NOW(),'".$sms_data['test1']."','".$sms_data['test2']."','".$sms_data['test3']."','".$sms_data['longcode']."','".$sms_data['appcode']."','".$sms_data['file_name']."','".$sms_data['check_person_2']."',NOW(),".$sms_data['check_2'].",'".$sms_data['check_person_1']."','".$sms_data['check_time_1']."',".$sms_data['check_1'].",'".$sms_data['check_person_3']."','".$sms_data['check_time_3']."',".$sms_data['check_3'].",'".$sms_data['send_type']."')";
  }else{

    foreach($sms_data as $key=>$val){
      $sql_val[]=$key."='".$val."'";
    }
    $sql = "UPDATE sms SET ".implode(",",$sql_val)." WHERE id=".$sms_id;
  }
  $db_adm->connect();
  $db_adm->query($sql,true);
  if($db_adm->is_fail()){
    return false;
  }else{
    return true;
  }

}
function set_sms_by_id($sms_id,$sms_data){
  global $db_adm;
  $sql_val = array();
  if(empty($sms_id)){
    $sql = "INSERT INTO sms(title,content,area,longcode,appcode,send_time,dir_name,status,create_person,create_time,test1,test2,test3,file_name,check_person_2,check_time_2,check_2,send_type,timing) values('".$sms_data['title']."','".$sms_data['content']."','".$sms_data['area']."','".$sms_data['longcode']."','".$sms_data['appcode']."','".$sms_data['send_time']."','".$sms_data['dir_name']."',0,'".$_SESSION['adm_name']."',NOW(),'".$sms_data['test1']."','".$sms_data['test2']."','".$sms_data['test3']."','".$sms_data['file_name']."','".$sms_data['check_person_2']."',NOW(),".$sms_data['check_2'].",'".$sms_data['send_type']."',".$sms_data['timing'].")";
  }else{

    foreach($sms_data as $key=>$val){
      $sql_val[]=$key."='".$val."'";
    }
    $sql = "UPDATE sms SET ".implode(",",$sql_val)." WHERE id=".$sms_id;
  }
  $db_adm->connect();
  $db_adm->query($sql,true);
  if($db_adm->is_fail()){
    return false;
  }else{
    return true;
  }

}
//修改sms群发表的状态
function update_sms_status_id($sms_id,$status){
  global $db_adm;
  $sql_val = array();
  $sql = "UPDATE sms SET status=".$status."  WHERE id=".$sms_id;
  $db_adm->connect();
  $db_adm->query($sql,true);
  if($db_adm->is_fail()){
    return false;
  }else{
    return true;
  }

}
//修改mms群发表的状态
function update_mms_status_id($mms_id,$status){
  global $db_adm;
  $sql_val = array();
  $sql = "UPDATE mms SET status=".$status."  WHERE id=".$mms_id;
  $db_adm->connect();
  $db_adm->query($sql,true);
  if($db_adm->is_fail()){
    return false;
  }else{
    return true;
  }

}

function check_sms_first_by_id($sms_id){
  global $db_adm;
  $sql = "UPDATE sms SET check_1=1,check_person_1='".$_SESSION['adm_name']."',check_time_1=NOW() WHERE id=".$sms_id;
  $db_adm->connect();
  $db_adm->query($sql,true);
  if($db_adm->is_fail()){
    return false;
  }else{
    return true;
  }

}
function check_mms_first_by_id($mms_id){
  global $db_adm;
  $sql = "UPDATE mms SET check_1=1,check_person_1='".$_SESSION['adm_name']."',check_time_1=NOW() WHERE id=".$mms_id;
  $db_adm->connect();
  $db_adm->query($sql,true);
  if($db_adm->is_fail()){
    return false;
  }else{
    return true;
  }

}

function check_sms_second_by_id($sms_id){
  global $db_adm;
  $sql = "UPDATE sms SET check_2=1,check_person_2='".$_SESSION['adm_name']."',check_time_2=NOW() WHERE id=".$sms_id;
  $db_adm->connect();
  $db_adm->query($sql,true);
  if($db_adm->is_fail()){
    return false;
  }else{
    return true;
  }

}
function check_sms_third_by_id($sms_id){
  global $db_adm;
  $sql = "UPDATE sms SET check_3=1,check_person_3='".$_SESSION['adm_name']."',check_time_3=NOW() WHERE id=".$sms_id;
  $db_adm->connect();
  $db_adm->query($sql,true);
  if($db_adm->is_fail()){
    return false;
  }else{
    return true;
  }

}
function check_mms_third_by_id($mms_id){
  global $db_adm;
  $sql = "UPDATE mms SET check_3=1,check_person_3='".$_SESSION['adm_name']."',check_time_3=NOW() WHERE id=".$mms_id;
  $db_adm->connect();
  $db_adm->query($sql,true);
  if($db_adm->is_fail()){
    return false;
  }else{
    return true;
  }
}

function change_test_number($sms_id,$sms_data){
  global $db_adm;
  $sql = "UPDATE sms SET test1='".$sms_data['test1']."',test2='".$sms_data['test2']."',test3='".$sms_data['test3']."' WHERE id=".$sms_id;
  $db_adm->connect();
  $db_adm->query($sql,true);
  if($db_adm->is_fail()){
    return false;
  }else{
    return true;
  }
}

function set_adm_by_id($adm_id, $adm_data) {
  global $db_adm;
  $sql_val = array();

  if(empty($adm_id)) {
    $sql = "INSERT INTO administrator(adm_name,adm_pass,adm_group,adm_lv,adm_email) ".
      "VALUES('".$adm_data['adm_name']."','".$adm_data['adm_pass']."',".
      "'".$adm_data['adm_group']."','".$adm_data['adm_lv']."','".$adm_data['adm_email']."')";
  } else {
    if($adm_data['adm_pass']=="d41d8cd98f00b204e9800998ecf8427e") {
      unset($adm_data['adm_pass']);
    }
    $sql_val = array();
    foreach($adm_data as $key=>$val) {
      $sql_val[] = $key."='".$val."'";
    }
    $sql = "UPDATE administrator SET ".implode(",", $sql_val).
      " WHERE adm_id=".$adm_id;
  }
  $db_adm->connect();
  $db_adm->query($sql, true);
  if($db_adm->is_fail()) {
    return false;
  } else {
    return true;
  }
} // end of set_adm_by_id()


function set_adm_lv($adm_lv, $adm_lv_data) {
}


function del_adm_by_id($adm_id) {
  global $db_adm;
  $sql = "DELETE FROM administrator WHERE adm_id=".$adm_id;

  $db_adm->connect();
  $db_adm->query($sql, false);
  if($db_adm->is_fail()) {
    return false;
  } else {
    return true;
  }
} // end of del_adm_by_id()


function reg_adm_session($adm_name, $adm_passwd) {
  global $main;

  if(!empty($adm_name) && $adm_passwd != "d41d8cd98f00b204e9800998ecf8427e") {
    list($adm_data)	= get_adm_by_cond($adm_name, $adm_passwd);
    list($adm_grp)	= get_adm_grp($adm_data['adm_group']);

    if($adm_data) {
      $_SESSION['adm_lv']	= $adm_data['adm_lv'];
      $_SESSION['adm_name']	= $adm_data['adm_name'];
      $_SESSION['adm_group']	= $adm_grp['group_name'];

      $main['adm_name']	= $adm_data['adm_name'];
      $main['adm_group']	= $adm_grp['group_name'];
      return true;
    }
  }

  return false;
} // end of reg_adm_session()

//by 132 sms  SSO
function get_adm_by_sms($adm_name, $adm_id='') {
  global $db_adm;
  $ret = array();

  $sql  = "SELECT * FROM administrator";
  $cond = "";

  if(!empty($adm_name)) {
    $cond .= " WHERE adm_name='".$adm_name."'";
  } else {
    if(!empty($adm_id)) {
      $cond .= " WHERE adm_id=".$adm_id;
    }
  }

  $ret = _db_query($db_adm,($sql.$cond));
  return $ret;
} // end of get_adm_by_cond()

function reg_adm_sms_session($adm_name, $adm_passwd) {
  global $main;

  if(!empty($adm_name) && $adm_passwd != "d41d8cd98f00b204e9800998ecf8427e") {	
    list($adm_data)	= get_adm_by_sms($adm_name);
    list($adm_grp)	= get_adm_grp($adm_data['adm_group']);

    if($adm_data) {
      $_SESSION['adm_lv']	= $adm_data['adm_lv'];
      $_SESSION['adm_name']	= $adm_data['adm_name'];
      $_SESSION['adm_group']	= $adm_grp['group_name'];

      $main['adm_name']	= $adm_data['adm_name'];
      $main['adm_group']	= $adm_grp['group_name'];
      return true;
    }
  }

  return false;
} // end of reg_adm_session()


//-------------------------------
function unreg_adm_session() {
  unset($_SESSION['adm_lv']);
  unset($_SESSION['adm_name']);
  unset($_SESSION['adm_group']);
  session_destroy();
} // end of unreg_adm_session()


function _reg_page_data($page_id) {
  global $ga_children_page, $main;
  $ga_children_page = array();

  $reg_page_ret = false;
  $page_data	  = array();
  $children_data= array();

  if(!empty($page_id)) {
    list($page_data)	= get_page_by_cond($page_id, "");
    $children_data	= get_page_by_cond("", $page_id, true);

    if($page_data) {
      $_SESSION['adm_page_id']= $page_id;

      define(ADM_PAGE_ID,	$page_id);
      define(ADM_PAGE_ACT,	$page_data['page_act']);
      define(ADM_PAGE,		$page_data['page_file']);
      define(ADM_PAGE_HDR,	$page_data['page_hid']);
      define(ADM_PAGE_COL_HDR,	$page_data['page_col']);
      define(ADM_PAGE_LV,	$page_data['page_lv']);
      define(ADM_PAGE_SEQ,	$page_data['page_seq']);
      define(ADM_PAGE_PARENT,	$page_data['parent_id']);

      $main['title']		.= $page_data['page_name'];
      $main['func_title']	.= $page_data['page_name'];
      $_GET['act']		= $page_data['page_act'];
      $reg_page_ret		= true;

      if($children_data) {
	foreach($children_data as $val) {
	  if(auth_lv_comp($_SESSION['adm_lv'], $val['page_lv'])) {
	    $ga_children_page[$val['page_file']."_".$val['page_act']] = array(
	      "page_id"	 => $val['page_id'],
	      "page_name"=> $val['page_name'],
	      "parent_id"=> $val['parent_id']
	    );
	  } else if(auth_lv_comp($_SESSION['adm_lv'], PAGE_ADM_LV)) {
	    switch($val['page_lv']) {
	      default:
		$ga_children_page[$val['page_file']."_".$val['page_act']] = array(
		  "page_id"  => $val['page_id'],
		  "page_name"=> $val['page_name'],
		  "parent_id"=> $val['parent_id']
		);
		break;
	      case PAGE_RD_LV:
		break;
	    }
	  }
	}
      }

      $reg_page_ret = true;
    } else {
      $reg_page_ret = false;
    }
  }

  return $reg_page_ret;
} // end of _reg_page_data()


function trace_root_page($parent_id) {
  global $db_adm;
  $parents	= array();
  $page	= array('parent_id' => $parent_id);

  while($page['parent_id']!=0) {
    list($page)	= get_page_by_cond($page['parent_id'], 0);
    $parents[]	= $page;
  } 

  return $parents;
} // end of trace_root_page()


function _db_query($db_obj,$sql) {
  $db_obj->connect();
  $res = $db_obj->query($sql);

  if($db_obj->count($res)>0) {
    while($row = $db_obj->fetch_array($res)) {
      $ret[] = $row;

    }
  } else {
    $ret = false;
  }
   return $ret;
} // end of _db_query()


function act_log($act_msg) {
  $fp = fopen(ADM_ACT_LOG, "a+");
  $user_name = (empty($_SESSION['adm_name']))?$_POST['login_name']:$_SESSION['adm_name'];

  $msg = date("Ymd:His")."\t".$_SERVER['REMOTE_ADDR']."\t".ADM_PAGE."?".ADM_PAGE_ACT."&".ADM_PAGE_ID."\t".
    $user_name.":".$_SESSION['adm_lv']."\t".$act_msg."\n";
  fputs($fp, $msg);
  fclose($fp);
} // end of _db_query()







function applyupdate_log($up_id="",$dtime="",$title_msg="",$content="",$reply_user="",$reply_time="",$status="")
{
  $fp=fopen(APPLY_LOG,"a+");
  $user_name = $_SESSION['adm_name'];
  $msg = $up_id."\t".$dtime."\t".$user_name."\t".$title_msg."\t".$content."\t".$reply_user."\t".$reply_time."\t".$status."\n";
  fputs($fp, $msg);
  fclose($fp);

}


function genre_list_gen($xtpl, $xtpl_block_name, $genre_chk="", $genre_list) {
  $genre_chk_arr = explode(",", $genre_chk);
  
  $i = 0;
  foreach($genre_list as $key=>$val) {
    $i++;
    $xtpl->assign("genre_id",		$key);
    $xtpl->assign("genre_name",	$val['genre_name']);
    if(in_array($key, $genre_chk_arr)) {
      $xtpl->assign("genre_chk",	" checked");
    } else {
      $xtpl->assign("genre_chk",	"");
    }

    if($i%5==0) {
      $xtpl->assign("genre_start_tr",	"<tr>\n");
      $xtpl->assign("genre_end_tr",	"</tr>\n");
    } else {
      $xtpl->assign("genre_start_tr",	"");
      $xtpl->assign("genre_end_tr",	"");
    }
    $xtpl->parse($xtpl_block_name);
  }
} // end of genre_list_gen()
function check_fee_third_by_id($fee_id){
  global $db_adm;
  $sql = "UPDATE fee SET check_3=1,check_person_3='".$_SESSION['adm_name']."',check_time_3=NOW() WHERE id=".$fee_id;
  $db_adm->connect();
  $db_adm->query($sql,true);
  if($db_adm->is_fail()){
    return false;
  }else{
    return true;
  }

}
function check_fee_second_by_id($fee_id){
  global $db_adm;
  $sql = "UPDATE fee SET check_2=1,check_person_2='".$_SESSION['adm_name']."',check_time_2=NOW() WHERE id=".$fee_id;
  $db_adm->connect();
  $db_adm->query($sql,true);
  if($db_adm->is_fail()){
    return false;
  }else{
    return true;
  }

}
function check_fee_first_by_id($fee_id){
  global $db_adm;
  $sql = "UPDATE fee SET check_1=1,check_person_1='".$_SESSION['adm_name']."',check_time_1=NOW() WHERE id=".$fee_id;
  $db_adm->connect();
  $db_adm->query($sql,true);
  if($db_adm->is_fail()){
    return false;
  }else{
    return true;
  }

}
function update_fee_status_id($fee_id,$status){
  global $db_adm;
  $sql_val = array();
  $sql = "UPDATE fee SET status=".$status."  WHERE id=".$fee_id;
  $db_adm->connect();
  $db_adm->query($sql,true);
  if($db_adm->is_fail()){
    return false;
  }else{
    return true;
  }

}
function set_fee_by_id($fee_id,$fee_data){
  global $db_adm;
  $sql_val = array();
  if(empty($fee_id)){
    $sql = "INSERT INTO fee(title,content,area,send_time,dir_name,status,create_person,create_time,test1,test2,test3,file_name,receive_file_name,rule,normal,end_time,fee_code,speed,times) values('".$fee_data['title']."','".$fee_data['content']."','".$fee_data['area']."','".$fee_data['send_time']."','".$fee_data['dir_name']."',0,'".$_SESSION['adm_name']."',NOW(),'".$fee_data['test1']."','".$fee_data['test2']."','".$fee_data['test3']."','".$fee_data['file_name']."','".$fee_data['receive_file_name']."','".$fee_data['rule']."','".$fee_data['normal']."','".$fee_data['end_time']."','".$fee_data['fee_code']."','".$fee_data['speed']."','".$fee_data['times']."')";
  }else{

    foreach($fee_data as $key=>$val){
      $sql_val[]=$key."='".$val."'";
    }
    $sql = "UPDATE fee SET ".implode(",",$sql_val)." WHERE id=".$fee_id;
  }
  $db_adm->connect();
  $db_adm->query($sql,true);
  if($db_adm->is_fail()){
    return false;
  }else{
    return true;
  }

}
function get_ones_fee($user_name,$page='',$page_size=''){
  global $db_adm;
  $limit = $page_size;
  $def_odr      = " ORDER BY send_time,title";
  $ret  = array();

  $sql = "SELECT * FROM fee  ";
  $cond = " WHERE  create_person='".$user_name."' AND status<>-1";
  if(!empty($page)) {
    if($page==1 )
    {
      $limit_str = " limit 0,".$limit;
    }
    else
    {
      $begin = ($page-1)*$limit;
      $end = $limit;
      $limit_str = " limit ".$begin.",".$end;
    }
  } else {
    $limit_str = " ";
  }

  $sql =  $sql.$cond.$def_odr.$limit_str;
  $ret = _db_query($db_adm,$sql);
  return $ret;
}
function del_fee_by_id($id){
  global $db_adm;
  $sql = "UPDATE fee set status=-1 WHERE id=".$id;
  $db_adm->connect();
  $db_adm->query($sql,true);
  if($db_adm->is_fail()){
    return false;
  }else{
    return true;
  }

}
function get_ready_fee(){
  global $db_adm;
  $def_odr      = " ORDER BY id";
  $ret  = array();

  $sql = "SELECT * FROM fee";
  $cond = " WHERE (UNIX_TIMESTAMP(send_time) BETWEEN UNIX_TIMESTAMP(NOW()-INTERVAL 5 MINUTE) AND UNIX_TIMESTAMP(NOW()+INTERVAL 5 MINUTE)) AND check_1=1 AND check_2=1 AND check_3=1 AND status <>-1 AND status<>3";

  $sql =  $sql.$cond.$def_odr;
  echo $sql."\n";
  $ret = _db_query($db_adm,$sql);
  return $ret;
}
function get_fee_by_id($fee_id){
  global $db_adm;
  $def_odr      = " ORDER BY id";
  $ret  = array();

  $sql = "SELECT id,title,content,area,send_time,create_person,create_time,check_person_1,check_time_1,check_person_2,check_time_2,check_person_3,check_time_3,dir_name,file_name,receive_file_name,check_1,check_2,check_3,status,test1,test2,test3,NOW()-send_time as overtime,rule,end_time,normal,fee_code,speed,times FROM fee";
  $cond = " WHERE id=$fee_id ";
  $sql =  $sql.$cond.$def_odr;
  $ret = _db_query($db_adm,$sql);
  return $ret;
}
function _curl_sms($url){
  if(!empty($url)){
    $ch2 = curl_init();
    curl_setopt($ch2, CURLOPT_URL, $url);
    curl_setopt($ch2, CURLOPT_HEADER, false);
    curl_setopt($ch2, CURLOPT_RETURNTRANSFER, 1);
    $val = curl_exec($ch2);
    curl_close($ch2);
    $ret_val = array();
    $ret_val = explode("\n",$val);
    $ret = $ret_val[0]."##".$ret_val[1];
  }else{
    $ret = '';
  }
  return $ret ;
}

function send_long_msg_single_python($msg_url,$sms_content,$sms_appcode,$mobile,$long_code='10658880',$from='0',$gateway='',$ReceiveType='0'){
  $url = $msg_url."?UserName=wuxian_qianxiang&Password=ed1f30042gNV2iUl0WLinSfdRMLEIbTP&AppCode=".$sms_appcode."&ReceiveType=".$ReceiveType."&DestTermID=".$mobile."&FeeTermID=".$mobile."&MessageContent=".urlencode($sms_content)."&GateWay=".$gateway."&Tag=".$from."&SourceTermID=".$long_code;
  $ret=_curl_sms($url);
  usleep(1000);
  return $ret;

}
function qunfa_sms_by_50($msg,$log_name,$file,$this_appcode,$this_longcode,$this_addr,$send_type){
  echo 'send_type-'.$send_type."\n";
  $send_msg = $msg; 
  $fp = fopen($file,'r');
  $log_fp = fopen($log_name,'a');
  $i = 1;
  while(!feof($fp)){
    $mobile = fgets($fp);
    $mobile = str_replace("\r\n",'',$mobile);
    $mobile = str_replace("\n",'',$mobile);
    if($mobile == '')
       continue;
    $str_50 = $str_50.$mobile.",";
    if($i == 50){
      $str_50 = substr($str_50,0,strlen($str_50)-1);
      if(substr($str_50,-1) == ',')
	$str_50 = substr($str_50,0,strlen($str_50)-1);
      $ret_val = send_msg_group_python('1',$send_msg,$this_appcode,$str_50,$this_longcode,'',$this_addr,$str_50,'',$send_type);
      $time_1 = date('Y-m-d H:i:s');
      fwrite($log_fp,$str_50."\t".$time_1."\t".$ret_val."\n");
      $i = 0;
      $str_50 = '';
    }
    else{
      $i++;
    }
    //echo $i."\n";
  }
  if($i != 0 || $i != 1){
    $str_50 = substr($str_50,0,strlen($str_50)-1);
    $ret_val = send_msg_group_python('1',$send_msg,$this_appcode,$str_50,$this_longcode,'',$this_addr,$str_50,'',$send_type);
    $time_1 = date('Y-m-d H:i:s');
    fwrite($log_fp,$str_50."\t".$time_1."\t".$ret_val."\n");
    $str_50 = '';
    $i = 0;
  }
  fclose($fp);
  fclose($log_fp);
}
function send_msg_group_python($interface_type='1',$sms_content,$sms_appcode,$mobile,$long_code='10658880',$from='0',$gateway='',$receive_mobile_arr='',$times='1' , $ReceiveType='0'){
  echo 'receivetype='.$ReceiveType."\n";
global $msg_group_url;
  if( $interface_type == '1'){

    $url = $msg_group_url."?UserName=wuxian_qianxiang&Password=ed1f30042gNV2iUl0WLinSfdRMLEIbTP&AppCode=".$sms_appcode."&ReceiveType=".$ReceiveType."&DestTermID=".$mobile."&FeeTermID=".$mobile."&MessageContent=".urlencode($sms_content)."&GateWay=".$gateway."&Tag=".$from."&SourceTermID=".$long_code;
    echo $url;
    $ret=_curl_sms($url);
    //wirte_system_log('sms', $sms_content,$sms_appcode,$mobile,$mobile,$long_code,$from,$ret );
    usleep(1000);
  }elseif( $interface_type == '2'){

  }
  return $ret;

}
function send_mms_python($send_type = '1', $interface_type='1',$mms_file,$mms_appcode,$mobile,$base_content='',$long_code='10658880',$from='0',$gateway='',$receive_mobile_arr='',$times='1'){
  global $mms_msg_url;
  if($send_type == '2'){
    $url = $mms_msg_url.'group';
  }else{
    $url = $mms_msg_url.'single';
  }
  $curl_data = array();
  $curl_data['UserName'] = 'wuxian_qianxiang';
  $curl_data['Password'] = 'ed1f30042gNV2iUl0WLinSfdRMLEIbTP';
  $curl_data['AppCode'] = $mms_appcode;
  //$curl_data['ReceiveType'] = 0 ;
  $curl_data['FeeTermID'] = $mobile;
  $curl_data['GateWay'] = $gateway;
  $curl_data['Tag'] = $from;
  $curl_data['SourceTermID'] = $long_code ;
  if( empty($base_content) ){
    $curl_data['Resource'] = urlencode(base64_encode(file_get_contents($mms_file)));
  } else {
    $curl_data['Resource'] = urlencode($base_content);
  }

  $mms_content = '彩信内容';
  if( $interface_type == '1'){
    $curl_data['DestTermID'] = $mobile;
    $ret=_curl_mms($url,$curl_data);
    //wirte_system_log('mms', $mms_content,$mms_appcode,$mobile,$mobile,$long_code,$from,$ret );
    usleep(1000);

  }elseif( $interface_type == '2'){
    for($i = 1;$i<=$times;$i++){
      $num = rand(0,count($receive_mobile_arr)-1);
      $receive_mobile = $receive_mobile_arr[$num];
      $curl_data['DestTermID'] = $receive_mobile;
      $ret=_curl_mms($url,$curl_data);
      //wirte_system_log('mms', $mms_content,$mms_appcode,$receive_mobile,$mobile,$long_code,$from,$ret);
      usleep(1000);
    }

  }
  //return true;
  return $ret;
}

function get_mms_by_id($mms_id){
  global $db_adm;
  $def_odr      = " ORDER BY id";
  $ret  = array();

  $sql = "SELECT id,title,mms_file_name,content,area,longcode,appcode,send_time,create_person,create_time,check_person_1,check_time_1,check_person_2,check_time_2,check_person_3,check_time_3,dir_name,file_name,check_1,check_2,check_3,status,test1,test2,test3,NOW()-send_time as overtime FROM mms";
  $cond = " WHERE id=$mms_id ";

  $sql =  $sql.$cond.$def_odr;
  $ret = _db_query($db_adm,$sql);
  return $ret;
}
function _curl_mms($url,$data){
  if(!empty($url) && is_array($data) ){
    foreach($data as $key=>$val)
    {
      $fields_val[]= $key."=".$val;
    }

    $fields = implode('&',$fields_val);
    //echo $fields."\n";
    $ch2 = curl_init();
    curl_setopt($ch2, CURLOPT_URL,$url);
    curl_setopt($ch2, CURLOPT_POST, 1 );
    curl_setopt($ch2, CURLOPT_POSTFIELDS, $fields);
    curl_setopt($ch2, CURLOPT_RETURNTRANSFER, 1);
    $val = curl_exec($ch2);
    curl_close($ch2);
    $ret_val = array();
    $ret_val = explode("\n",$val);
    $ret = $ret_val[0]."##".$ret_val[1];
  }else{
    $ret = '';
  }
  return $ret ;
}
function qunfa_mms_by_50($msg,$msg_name,$log_name,$file,$this_appcode,$this_longcode,$this_addr){
  file_put_contents($msg_name,base64_decode($msg));
  $fp = fopen($file,'r');
  $log_fp = fopen($log_name,'a');
  $i = 1;
  while(!feof($fp)){
    $mobile = fgets($fp);
    $mobile = str_replace("\r\n",'',$mobile);
    $mobile = str_replace("\n",'',$mobile);
    if($mobile == '')
       continue;
    $str_50 = $str_50.$mobile.",";
    if($i == 50){
      $str_50 = substr($str_50,0,strlen($str_50)-1);
      if(substr($str_50,-1) == ',')
	$str_50 = substr($str_50,0,strlen($str_50)-1);
      $ret_val = send_mms_python('2', '1','',$this_appcode,$str_50,$msg,$this_longcode,'0',$this_addr);
      $time_1 = date('Y-m-d H:i:s');
      fwrite($log_fp,$str_50."\t".$time_1."\t".$ret_val."\n");
      $i = 0;
      $str_50 = '';
    }
    else{
      $i++;
    }
  }
  if($i != 0 || $i != 1){
    $str_50 = substr($str_50,0,strlen($str_50)-1);
    $ret_val = send_mms_python('2', '1','',$this_appcode,$str_50,$msg,$this_longcode,'0',$this_addr);
    $time_1 = date('Y-m-d H:i:s');
    fwrite($log_fp,$str_50."\t".$time_1."\t".$ret_val."\n");
    $str_50 = '';
    $i = 0;
  }
  fclose($fp);
  fclose($log_fp);
}
//下面是为搜索部门专设的群发
function qunfa_search_sms_by_50($msg,$log_name,$file,$this_appcode,$this_longcode,$this_addr,$send_type){
  echo 'send_type-'.$send_type."\n";
  $send_msg = $msg;
  $fp = fopen($file,'r');
  $log_fp = fopen($log_name,'a');
  $i = 1;
  while(!feof($fp)){
    $mobile = fgets($fp);
    $mobile = str_replace("\r\n",'',$mobile);
    $mobile = str_replace("\n",'',$mobile);
    if($mobile == '')
      continue;
    $str_50 = $str_50.$mobile.",";
    if($i == 50){
      $str_50 = substr($str_50,0,strlen($str_50)-1);
      if(substr($str_50,-1) == ',')
	$str_50 = substr($str_50,0,strlen($str_50)-1);
      $ret_val = send_search_msg_group_python('1',$send_msg,$this_appcode,$str_50,$this_longcode,'',$this_addr,$str_50,'',$send_type);
      $time_1 = date('Y-m-d H:i:s');
      fwrite($log_fp,$str_50."\t".$time_1."\t".$ret_val."\n");
      $i = 0;
      $str_50 = '';
    }
    else{
      $i++;
    }
    //echo $i."\n";
  }
  if($i != 0 || $i != 1){
    $str_50 = substr($str_50,0,strlen($str_50)-1);
    $ret_val = send_search_msg_group_python('1',$send_msg,$this_appcode,$str_50,$this_longcode,'',$this_addr,$str_50,'',$send_type);
    $time_1 = date('Y-m-d H:i:s');
    fwrite($log_fp,$str_50."\t".$time_1."\t".$ret_val."\n");
    $str_50 = '';
    $i = 0;
  }
  fclose($fp);
  fclose($log_fp);
}
function send_search_msg_group_python($interface_type='1',$sms_content,$sms_appcode,$mobile,$long_code='10658181',$from='0',$gateway='',$receive_mobile_arr='',$times='1' , $ReceiveType='0'){
  echo 'receivetype='.$ReceiveType."\n";
  global $msg_group_url;
  if( $interface_type == '1'){

    $url = "http://192.100.8.242:7000/sms/group?UserName=smssearch&Password=3rj3ire989w&AppCode=".$sms_appcode."&ReceiveType=".$ReceiveType."&DestTermID=".$mobile."&FeeTermID=".$mobile."&MessageContent=".urlencode($sms_content)."&GateWay=".$gateway."&Tag=".$from."&SourceTermID=".$long_code;
    echo $url;
    $ret=_curl_sms($url);
    //wirte_system_log('sms', $sms_content,$sms_appcode,$mobile,$mobile,$long_code,$from,$ret );
    usleep(1000);
  }elseif( $interface_type == '2'){

  }
  return $ret;

}
function send_search_long_msg_single_python($msg_url,$sms_content,$sms_appcode,$mobile,$long_code='10658181',$from='0',$gateway='',$ReceiveType='0'){
  $url = "http://192.100.8.242:7000/sms/single?UserName=smssearch&Password=3rj3ire989w&AppCode=".$sms_appcode."&ReceiveType=".$ReceiveType."&DestTermID=".$mobile."&FeeTermID=".$mobile."&MessageContent=".urlencode($sms_content)."&GateWay=".$gateway."&Tag=".$from."&SourceTermID=".$long_code;
  $ret=_curl_sms($url);
  usleep(1000);
  return $ret;

}

function get_client_ip($type = 0,$adv=false) {
    $type       =  $type ? 1 : 0;
    static $ip  =   NULL;
    if ($ip !== NULL) return $ip[$type];
    if($adv){
        if (isset($_SERVER['HTTP_X_FORWARDED_FOR'])) {
            $arr    =   explode(',', $_SERVER['HTTP_X_FORWARDED_FOR']);
            $pos    =   array_search('unknown',$arr);
            if(false !== $pos) unset($arr[$pos]);
            $ip     =   trim($arr[0]);
        }elseif (isset($_SERVER['HTTP_CLIENT_IP'])) {
            $ip     =   $_SERVER['HTTP_CLIENT_IP'];
        }elseif (isset($_SERVER['REMOTE_ADDR'])) {
            $ip     =   $_SERVER['REMOTE_ADDR'];
        }
    }elseif (isset($_SERVER['REMOTE_ADDR'])) {
        $ip     =   $_SERVER['REMOTE_ADDR'];
    }
    // IP地址合法验证
    $long = sprintf("%u",ip2long($ip));
    $ip   = $long ? array($ip, $long) : array('0.0.0.0', 0);
    return $ip[$type];
}


function check_ip($IP){
 $ALLOWED_IP=array('219.239.133.66','127.0.0.1','172.16.*.*');
 $IP= get_client_ip();
 $check_ip_arr= explode('.',$IP);//要检测的ip拆分成数组
 #限制IP
 if(!in_array($IP,$ALLOWED_IP)) {
  foreach ($ALLOWED_IP as $val){
      if(strpos($val,'*')!==false){//发现有*号替代符
        $arr=array();//
        $arr=explode('.', $val);
        $bl=true;//用于记录循环检测中是否有匹配成功的
        for($i=0;$i<4;$i++){
         if($arr[$i]!='*'){//不等于*  就要进来检测，如果为*符号替代符就不检查
          if($arr[$i]!=$check_ip_arr[$i]){
           $bl=false;
           break;//终止检查本个ip 继续检查下一个ip
          }
         }
        }//end for
        if($bl){//如果是true则找到有一个匹配成功的就返回
         return;
         die;
        }
      }
  }//end foreach

   header('HTTP/1.1 404 Not Found'); 
   header("status: 404 Not Found");
  // echo 'ip:'.$IP." Access forbidden";
   die;
 }
}

?>
