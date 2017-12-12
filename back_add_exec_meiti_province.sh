#!/bin/sh
#. /home/chenly/profile
. /usr/local/app/dana/current/shbb/profile
    usage ()
    {
       echo "usage: $0  target_dir" 1>&2
       exit 2
    }
    if [ $# -lt 1 ] ; then
      usage
    fi
V_DATE=$1
V_YEAR=$(echo $V_DATE | cut -c 1-4)
CODE_DIR=$AUTO_DATA_NODIST
CODE_FILE=$CODE_DIR/nodist_city.txt
TARGET_DIR=$AUTO_DATA_TARGET/$V_YEAR/$V_DATE
REPORT_DIR=$AUTO_DATA_REPORT/$V_YEAR/$V_DATE
TMP_CODE=$TARGET_DIR/tmpnodist.txt

   if [ ! -d "$TARGET_DIR" ]; then
    if ! mkdir -p $TARGET_DIR
      then
       echo "mkdir $TARGET_DIR error"
       exit 1
    fi
  fi

   if [ ! -d "$REPORT_DIR" ]; then
    if ! mkdir -p $REPORT_DIR
      then
       echo "mkdir $REPORT_DIR error"
       exit 1
    fi
  fi

#增量日志结果文件
SOURCE_FILE1=/logs/orig/hislog/contract_old.log   #采购单全量表
SOURCE_FILE2=/logs/orig/hislog/exec_old.log    #执行单全量表

RESULT_FILE1=$TARGET_DIR/tmp_back_meiti_add_logs.csv     #采购单每日临时快照（按签约日期）
RESULT_FILE2=$TARGET_DIR/tmp_back_meiti_exec_logs.csv    #执行单每日临时快照（按投放日期）
RESULT_FILE=$REPORT_DIR/report.region.back_sale_meiti_province.csv  # 媒体后向销售报表统计


#处理添加采购单日志信息
awk -F'`' '{ 
    yy=substr($14,1,4)
    mm=substr($14,6,2)
    dd=substr($14,9,2)
    contract_day=yy""mm""dd
    if(contract_day<="'$V_DATE'")
      {
        indexstr=$2
        if(length(indexstr)>0)
          { 
            if(length($1)>0)
              {
                a[indexstr]=$1
              }
            if(length($3)>0)
              {
                b[indexstr]=$3
              }
            if(length($4)>0)
              {
                c[indexstr]=$4
              }
            if(length($5)>0)
              {
                d[indexstr]=$5
              }
            if(length($6)>0)
              {
                e[indexstr]=$6
              }
            if(length($7)>0)
              {
                f[indexstr]=$7
              }
            if(length($8)>0)
              {
                g[indexstr]=$8
              }
            if(length($9)>0)
              {
                h[indexstr]=$9
              }
            if(length($10)>0)
              {
                i[indexstr]=$10
              }
            if(length($11)>0)
              {
                j[indexstr]=$11
              }
            if(length($12)>0)
              {
                k[indexstr]=$12
              }
            if(length($13)>0)
              {
                l[indexstr]=$13
              }
            if(length($14)>0)
              {
                m[indexstr]=$14
              }
            if(length($15)>0)
              {
                n[indexstr]=$15
              }
            if(length($16)>0)
              {
                o[indexstr]=$16
              }
            if(length($17)>0)
              {
                p[indexstr]=$17
              }
            if(length($18)>0)
              {
                q[indexstr]=$18
              }
            if(length($19)>0)
              {
                r[indexstr]=$19
              }
            if(length($20)>0)
              {
                s[indexstr]=$20
              }
            if(!($20==2))
              {
                z[indexstr]=1
              }
          }
      }
}
END{
  for (name in z)
     {
       printf("%s`%s`%s`%s`%s`%s`%s`%s`%s`%s`%s`%s`%s`%s`%s`%s`%s`%s`%s`%s\n",a[name],name,b[name],c[name],d[name],e[name],f[name],g[name],h[name],i[name],j[name],k[name],l[name],m[name],n[name],o[name],p[name],q[name],r[name],s[name]) 
     }
}' $SOURCE_FILE1 > $RESULT_FILE1


#处理生成执行单日志信息（已执行状态）
awk -F'`' '{ 
      yy=substr($9,1,4)
      mm=substr($9,6,2)
      dd=substr($9,9,2)
      exec_day=yy""mm""dd
      if(exec_day<="'$V_DATE'")
      {
        if(!($13==2))
          {
            indexstr=$1"`"$2
            if(length($3)>0)
              {
                b[indexstr]=$3
              }
            if(length($4)>0)
              {
                c[indexstr]=$4
              }
            if(length($5)>0)
              {
                d[indexstr]=$5
              }
            if(length($6)>0)
              {
                e[indexstr]=$6
              }
            if(length($7)>0)
              {
                f[indexstr]=$7
              }
            if(length($8)>0)
              {
                g[indexstr]=$8
              }
            if(length($9)>0)
              {
                h[indexstr]=$9
              }
            if(length($10)>0)
              {
                i[indexstr]=$10
              }
            if(length($11)>0)
              {
                j[indexstr]=$11
              }
            if(length($12)>0)
              {
                k[indexstr]=$12
              }
            if(length($13)>0)
              {
                l[indexstr]=$13
              }
            if($13==3)
              {
                z[indexstr]=1
              }
          }
      }
}
END{
  for (name in z)
     {
       printf("%s`%s`%s`%s`%s`%s`%s`%s`%s`%s`%s`%s\n",name,b[name],c[name],d[name],e[name],f[name],g[name],h[name],i[name],j[name],k[name],l[name]) 
     }
}' $SOURCE_FILE2 > $RESULT_FILE2


awk -F'|' '{
    prov=$1"`"$4
    printf("%s\n",prov)     
   }' $CODE_FILE > $TMP_CODE

awk -F'`' '{
 if(FILENAME=="'$TMP_CODE'")
   {
      nodist[$2]=$1
   }
 else if(FILENAME=="'$RESULT_FILE1'")
   {
    if(!($20=="2"))
       {
         contract=$16;discount[$2]=$15
         type[$2]=$11 
         yy=substr($14,1,4)
         mm=substr($14,6,2)
         dd=substr($14,9,2)
         contract_day=yy""mm""dd
         #处理代理商信息
         if(length($4)>0)
           {
             company=$4
           }
         else
           {
             company="未知"
           } 
         com[$2]=company
         #处理省份编码信息 
         if($6 in nodist)
           {
             province=$6
             provname=nodist[$6]
           }
         else
           {
             province="000"
             provname="未知"
           }
         prov[$2]=province
         ywtype=type[$2]
         indexstr=province","provname","company","ywtype
         if(contract_day=="'$V_DATE'")
           {
             buycount[indexstr]++    #采购单量
             contractfee[indexstr]+=contract  #签约金额
             fee[indexstr]=1
           }
       }
   }
 else if(FILENAME=="'$RESULT_FILE2'")
    {
      if($13==3)
        {
          price=$5
          yy=substr($9,1,4)
          mm=substr($9,6,2)
          dd=substr($9,9,2)
          exec_day=yy""mm""dd
          if($1 in com)
            {
              company=com[$1]
            }
          else
            {
              company="未知"
            }
          if($1 in prov)
            {
              province=prov[$1]
            }
          else
            {
              province="000"
            }
          if(province in nodist)
            {
              provname=nodist[province]
            }
          else
            {
              provname="未知"            
            }
          if($1 in discount)
            {
              done=price*discount[$1]/100
            }
          if($1 in type)
            {          
              ywtype=type[$1]
            }
          else
            {
              ywtype="其它"
            }
          indexstr=province","provname","company","ywtype
          if(exec_day=="'$V_DATE'")
            {
              donecount[indexstr]++  #执行单量
              donefee[indexstr]+=done  #执行金额
              fee[indexstr]=1
            }
        }
    }
}
END{         
    str="省份编码,省份名称,代理商,业务属性,采购单量,执行单量,签约金额,执行金额"
    printf("%s\n",str)
 for(name in fee)
    {
      printf("%s,%d,%d,%d,%d\n",name,buycount[name],donecount[name],contractfee[name],donefee[name])
    }
}' $TMP_CODE $RESULT_FILE1 $RESULT_FILE2 > $RESULT_FILE

if [ ! -f "$RESULT_FILE1" ];then
    touch $RESULT_FILE1
fi
if [ ! -f "$RESULT_FILE2" ];then
    touch $RESULT_FILE2
fi

rm $TMP_CODE
rm $RESULT_FILE1
rm $RESULT_FILE2

