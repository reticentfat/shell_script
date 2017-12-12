#!/bin/sh
. /usr/local/app/dana/current/shbb/profile
usage () {
    echo "usage: $0  target_dir" 1>&2
    exit 2
}

if [ $# -lt 1 ] ; then
    usage
fi

V_DATE=$1
V_YEAR=$(echo $V_DATE | cut -c 1-4)
SOURCE_DIR=$AUTO_SRC_MM7/$V_DATE
TARGET_DIR=$AUTO_DATA_TARGET/$V_YEAR/$V_DATE
#TARGET_DIR=/home/shihy/bin/report/$V_YEAR/$V_DATE
NODIST_DIR=$AUTO_DATA_NODIST

CODE_FILE_1=$NODIST_DIR/nodist.tsv
CODE_FILE_2=$NODIST_DIR/Service_App_Code.txt
CODE_FILE_3=$NODIST_DIR/news_appcode.txt
SOURCE_FILE_1=$SOURCE_DIR/*.out
SOURCE_FILE_2=$SOURCE_DIR/*.mt

TARGET_FILE_1=$TARGET_DIR/MM7_OUT.txt
TARGET_FILE_2=$TARGET_DIR/MM7_MT.txt
TARGET_FILE_3=$TARGET_DIR/NEWZZ_MM7_OUT.txt
TARGET_FILE_4=$TARGET_DIR/NEWZZ_MM7_MT.txt




if [ ! -d "$TARGET_DIR" ]; then
  if ! mkdir -p $TARGET_DIR
  then
    echo "mkdir $TARGET_DIR error"
    exit 1
  fi
fi

if [ ! -d "$SOURCE_DIR" ]; then
  echo "$SOURCE_DIR not found"
  exit 1
fi

if [ ! -d "$NODIST_DIR" ]; then
  echo "$NODIST_DIR not found"
  exit 1
fi

if [ -f "$TARGET_FILE_1" ]; then
 rm -f $TARGET_FILE_1
 touch $TARGET_FILE_1
else
 touch $TARGET_FILE_1 
fi
if [ -f "$TARGET_FILE_2" ]; then
 rm -f $TARGET_FILE_2
 touch $TARGET_FILE_2
else
 touch $TARGET_FILE_2
fi
if [ -f "$TARGET_FILE_3" ]; then
 rm -f $TARGET_FILE_3
 touch $TARGET_FILE_3
 else
 touch $TARGET_FILE_3 
fi
if [ -f "$TARGET_FILE_4" ]; then
 rm -f $TARGET_FILE_4
 touch $TARGET_FILE_4
else
 touch $TARGET_FILE_4 
fi
ERROR=0

# 匹配 (由于appcode字段的前端有空格所以用gsub去掉空格)
gawk -F'[|,]' '{
    if (FILENAME=="'$CODE_FILE_1'") {
       #省名称|省代码|地市名称|地市代码
        d[$4]=$1"|"$5"|"$2"|"$3
        }
    else if(FILENAME=="'$CODE_FILE_2'"){
         #业务代码
          servicename=$1
         c[$2]=servicename
       }
    else if(FILENAME=="'$CODE_FILE_3'")
    {
    	e[$1]=$4
    }
    else if (substr($14,1,7) in d){
                servicecode=$15
                gsub(/[^0-9]/,"",servicecode)
                bzcode=$8
                userid=$14
                send_statu=$40
                if(c[servicecode]=="SHBB"){
                    print bzcode"|"userid"|"servicecode"|"send_statu"|"d[substr(userid,1,7)]"|"c[servicecode]>"'$TARGET_FILE_1'"
                  }
                else if(servicecode in e)
                {
                    print bzcode"|"userid"|"servicecode"|"send_statu"|"d[substr(userid,1,7)]"|"e[servicecode]  >"'$TARGET_FILE_3'"
                }
     }
    else if (substr($14,1,8) in d){
                servicecode=$15
                gsub(/[^0-9]/,"",servicecode)
                bzcode=$8
                userid=$14
                send_statu=$40
               if(c[servicecode]=="SHBB"){
                  print bzcode"|"userid"|"servicecode"|"send_statu"|"d[substr(userid,1,8)]"|"c[servicecode]>"'$TARGET_FILE_1'"
                }
               else if(servicecode in e)
               {
                   print bzcode"|"userid"|"servicecode"|"send_statu"|"d[substr(userid,1,8)]"|"e[servicecode] >"'$TARGET_FILE_3'"
               }

             }
    else   {
                servicecode=$15
                gsub(/[^0-9]/,"",servicecode)
                bzcode=$8
                userid=$14
                send_statu=$40
                if(c[servicecode]=="SHBB"){
                     print bzcode"|"userid"|"servicecode"|"send_statu"|未知|000|未知|000|"c[servicecode]>"'$TARGET_FILE_1'"
                  }
                else if(servicecode in e)
                {
                     print bzcode"|"userid"|"servicecode"|"send_statu"|未知|000|未知|000|"e[servicecode]>"'$TARGET_FILE_3'"
                }

            }
    }' $CODE_FILE_1 $CODE_FILE_2 $CODE_FILE_3 $SOURCE_FILE_1
    ERROR=$?
    if [ $ERROR -gt 0 ];then
    	exit $ERROR
    fi
#未匹配
awk -F'[|,]' '{
    if (FILENAME=="'$CODE_FILE_1'"){
             d[$4]=$1"|"$5"|"$2"|"$3
       }
    else if(FILENAME=="'$CODE_FILE_2'"){
           #业务代码
           servicename=$1
           c[$2]=servicename
         }
    else if(FILENAME=="'$CODE_FILE_3'"){
       e[$1]=$4
       }
    else if (substr($14,1,7) in d) {
                servicecode=$15
                gsub(/[^0-9]/,"",servicecode)
                bzcode=$8
                userid=$14
                send_statu=$28
               if(c[servicecode]=="SHBB"){
                  print bzcode"|"userid"|"servicecode"|"send_statu"|"d[substr(userid,1,7)]"|"c[servicecode]>"'$TARGET_FILE_2'"
               }
               else if(servicecode in e)
               {
                   print bzcode"|"userid"|"servicecode"|"send_statu"|"d[substr(userid,1,7)]"|"e[servicecode] >"'$TARGET_FILE_4'"
               }

           }
    else if (substr($14,1,8) in d) {
                servicecode=$15
                gsub(/[^0-9]/,"",servicecode)
                bzcode=$8
                userid=$14
                send_statu=$28
                if(c[servicecode]=="SHBB"){
                   print bzcode"|"userid"|"servicecode"|"send_statu"|"d[substr(userid,1,8)]"|"c[servicecode]>"'$TARGET_FILE_2'"
                 }
                else if(servicecode in e)
               {
                   print bzcode"|"userid"|"servicecode"|"send_statu"|"d[substr(userid,1,8)]"|"e[servicecode] >"'$TARGET_FILE_4'"
               }

           }
    else {
                servicecode=$15
                gsub(/[^0-9]/,"",servicecode)
                bzcode=$8
                userid=$14
                send_statu=$28
               if(c[servicecode]=="SHBB"){
                 print bzcode"|"userid"|"servicecode"|"send_statu"|未知|000|未知|000""|"c[servicecode]>"'$TARGET_FILE_2'"
                }
               else if(servicecode in e)
               {
                 print bzcode"|"userid"|"servicecode"|"send_statu"|未知|000|未知|000""|"c[servicecode]>"'$TARGET_FILE_4'"
               }

           }
    }'  $CODE_FILE_1 $CODE_FILE_2 $CODE_FILE_3 $SOURCE_FILE_2
