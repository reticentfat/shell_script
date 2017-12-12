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
ALL_DIR=$AUTO_DATA_TARGET/snapshot
TARGET_DIR=$AUTO_DATA_TARGET/$V_YEAR/$V_DATE

   if [ ! -d "$ALL_DIR" ]; then
    if ! mkdir -p $ALL_DIR
      then
       echo "mkdir $ALL_DIR error"
       exit 1
    fi
  fi
   if [ ! -d "$TARGET_DIR" ]; then
    if ! mkdir -p $TARGET_DIR
      then
       echo "mkdir $TARGET_DIR error"
       exit 1
    fi
  fi

#全量表
SOURCE_FILE1=$ALL_DIR/meiti_add_logs.csv   #采购单全量表
SOURCE_FILE2=$ALL_DIR/meiti_exec_logs.csv    #执行单全量表
SOURCE_FILE3=$ALL_DIR/meiti_change_logs.csv    #财务变更全量表
#增量日志结果文件
RESULT_FILE1=$TARGET_DIR/back_meiti_add_logs.csv   #采购单每日快照
RESULT_FILE2=$TARGET_DIR/back_meiti_exec_logs.csv    #执行单每日快照
RESULT_FILE3=$TARGET_DIR/back_meiti_change_logs.csv   #财务变更每日快照
#增量日志结果文件放到snapshot目录里
RESULT1=$ALL_DIR/back_meiti_add_logs.csv   #采购单全量表
RESULT2=$ALL_DIR/back_meiti_exec_logs.csv    #执行单全量表
RESULT3=$ALL_DIR/back_meiti_change_logs.csv    #财务变更全量表

# 字典表文
ERROR=0
#处理添加采购单日志信息
awk -F'`' '{ 
    yy=substr($18,1,4)
    mm=substr($18,6,2)
    dd=substr($18,9,2)
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
            z[indexstr]=1
          }
      }
}
END{
  for (name in z)
     {
       printf("%s`%s`%s`%s`%s`%s`%s`%s`%s`%s`%s`%s`%s`%s`%s`%s`%s`%s`%s`%s\n",a[name],name,b[name],c[name],d[name],e[name],f[name],g[name],h[name],i[name],j[name],k[name],l[name],m[name],n[name],o[name],p[name],q[name],r[name],s[name]) 
     }
}' $SOURCE_FILE1 > $RESULT_FILE1

#处理生成执行单日志信息
awk -F'`' '{ 
   yy=substr($11,1,4)
   mm=substr($11,6,2)
   dd=substr($11,9,2)
   contract_day=yy""mm""dd
   if(contract_day<="'$V_DATE'")
      {
        if(!($13==3))
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
            z[indexstr]=1
          }
      }
}
END{
  for (name in z)
     {
       printf("%s`%s`%s`%s`%s`%s`%s`%s`%s`%s`%s`%s\n",name,b[name],c[name],d[name],e[name],f[name],g[name],h[name],i[name],j[name],k[name],l[name]) 
     }
}' $SOURCE_FILE2 > $RESULT_FILE2

awk -F'`' '{ 
    yy=substr($11,1,4)
    mm=substr($11,6,2)
    dd=substr($11,9,2)
    contract_day=yy""mm""dd
    if(contract_day<="'$V_DATE'")
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
END{
  for (name in z)
     {
       printf("%s`%s`%s`%s`%s`%s`%s`%s`%s`%s`%s`%s\n",name,b[name],c[name],d[name],e[name],f[name],g[name],h[name],i[name],j[name],k[name],l[name]) 
     }
}' $SOURCE_FILE2 >> $RESULT_FILE2



#处理财务变更日志信息
awk -F'`' '{ 
    yy=substr($13,1,4)
    mm=substr($13,6,2)
    dd=substr($13,9,2)
    contract_day=yy""mm""dd
    if(contract_day<="'$V_DATE'")
      {
        indexstr=$1
        if(length(indexstr)>0)
          {
            if(length($2)>0)
              {
                a[indexstr]=$2
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
            z[indexstr]=1
          }
      }
}
END{
  for (name in z)
     {
       printf("%s`%s`%s`%s`%s`%s`%s`%s`%s`%s`%s`%s`%s`%s`%s`%s\n",name,a[name],b[name],c[name],d[name],e[name],f[name],g[name],h[name],i[name],j[name],k[name],l[name],m[name],n[name],o[name]) 
     }
}' $SOURCE_FILE3 > $RESULT_FILE3
 
 
 
cp $RESULT_FILE1 $RESULT1
cp $RESULT_FILE2 $RESULT2
cp $RESULT_FILE3 $RESULT3
