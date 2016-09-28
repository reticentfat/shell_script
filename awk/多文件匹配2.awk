gawk -F\| 'BEGIN{OFS="|";v_date=substr("'$DEALDATE'",1,4)"-"substr("'$DEALDATE'",5,2)"-"substr("'$DEALDATE'",7,2)}{
  if(FILENAME=="'$CODE_NODIST'") 
  {
    d[$4]=$1"|"$2"|"$3"|"$5"|"$6
  }
  else if(FILENAME=="'$OTHER_CODE_NODIST'"){
    od[$4]=$1"|"$2"|"$3"|"$5"|"$6
    od_city[$3]=$1"|"$2"|"$3"|"$5"|"$6

  } 
  else if(FILENAME=="'$CODE_PRO'")
  { 
    #$1- 省份编码 $3-权值 ＝2 按移动流水号计算
    if((v_date>=$1) && (v_date<=$2))
    {    
      kk[$3]=$5
    }
  }
  else if(FILENAME=="'$FILTER_FILE'")
  {
    #短信稽核后的呼叫id
     s[$1]=1
  }
  else if(FILENAME=="'$CODE_CHANGE_CITY'")
  {
      if((v_date>=$1) && (v_date<=$2)){
        change_city[$3","$4]=$6
        change_city[$5","$6]=$4
      }
  }
  else
  { 
      #号段处理 
      if(substr($7,1,8) in d)
      {
        provino=d[substr($7,1,8)]
      }
      else if(substr($7,1,7) in d)
      {
        provino=d[substr($7,1,7)]
      }else if(substr($7,1,7) in od){
        provino=od[substr($7,1,7)]
      }else if(substr($7,1,6) in od){
        provino=od[substr($7,1,6)]
      }else if((substr($7,1,1)==0)&&(substr($7,2,3) in od_city)){
        provino=od_city[substr($7,2,3)]
      }else if((substr($7,1,1)==0)&&(substr($7,2,2)"0" in od_city)){
        provino=od_city[substr($7,2,2)"0"]
      }
      else 
      {
       provino="未知|未知|000|000|00000000"
      }
 
     #如果不在按产品过滤后的文件中，直接处理下一条记录，此条记录不输出
      if(!($1 in s))
      { 
        next
      }
      callprovino=$4
      userid=$7
      ydcallid=$3
      #保证移动流水号,呼叫省,手机号码唯一
      index_str=ydcallid"|"callprovino"|"userid    
      if(callprovino in kk){
       # 如果一个移动流水号对应多条讯奇流水号，只输出第一条
       if(and(kk[callprovino],2)==2){
         if(index_str in callid)
         { #如果本移动流水号已经有输出记录，直接处理下一条记录，本条记录不输出
           print >"'$LOST_FILE'"
           next
           
         }
         else
         {
           #记录需要被稽核的移动流水号
           callid[index_str]=1
         }
       }
      }
      #没有过滤掉的话单被输出
      if($4","$5 in change_city){
        $5=change_city[$4","$5]
        print >"'$CHANGE_CITY'"
      }
      str=$1"|"$3"|"$7"|"$4"|"$5"|"$11"|"provino"|0|"$6"|"$13"|"$14"|"$9"|"$10
      print str
 }
}' $CODE_NODIST $OTHER_CODE_NODIST $CODE_PRO $FILTER_FILE $CODE_CHANGE_CITY $SOURCE_FILE > $RESULT_FILE
