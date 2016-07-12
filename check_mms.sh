#/bin/sh

echo $(date)
LOG_SMS_DIR=/data/match/mm7
CREATE_FILE_DIR=/data/youyang/match/


filter=${2:-"wuxian_qianxiang"}
code=${3:-"0"}

d0=$1
[ -z "$d0" ] && d0=$(date -v-0d +%Y%m%d)

if [ -z "$d0" ]; then
  d0=$(date -v-0d +%Y%m%d)
fi
hm=$(date +%H%M)

d1=$(date -v-1d -j $d0$hm +%Y%m%d)
d2=$(date -v-1d -j $d1$hm +%Y%m%d)
d3=$(date -v-1d -j $d2$hm +%Y%m%d)



echo $LOG_SMS_DIR

#YT_1=`date -v-2d +%Y%m%d`
#YT_0=`date -v-1d +%Y%m%d`
#TODAY=`date +%Y%m%d`
TODAY=$d1
YT_0=$d2
YT_1=$d3

#create dir
if [ ! -d "$CREATE_FILE_DIR$YT_1" ]; then
mkdir "$CREATE_FILE_DIR$YT_1"
fi

if [ ! -d "$CREATE_FILE_DIR$YT_0" ]; then
mkdir "$CREATE_FILE_DIR$YT_0"
fi

if [ ! -d "$CREATE_FILE_DIR$TODAY" ]; then
mkdir "$CREATE_FILE_DIR$TODAY"
fi

if [  -f "$CREATE_FILE_DIR$YT_1/$YT_1"_filure_mms_user.txt"" ]; then
  rm "$CREATE_FILE_DIR$YT_1/$YT_1"_filure_mms_user.txt""
fi


if [  -f "$CREATE_FILE_DIR$YT_0/$YT_0"_filure_mms_user.txt"" ]; then
  rm "$CREATE_FILE_DIR$YT_0/$YT_0"_filure_mms_user.txt""
fi

if [  -f "$CREATE_FILE_DIR$TODAY/$TODAY'_filure_mms_user.txt'" ]; then
rm "$CREATE_FILE_DIR$TODAY/$TODAY"_filure_mms_user.txt""
fi

if [  -f "$CREATE_FILE_DIR$TODAY/$TY_1'_mms_cm_user.txt'" ]; then
rm "$CREATE_FILE_DIR$TODAY"/"$YT_1"_mms_cm_user.txt""
fi


file1=$CREATE_FILE_DIR$YT_1"/"$YT_1"_filure_mms_user.txt"
file0=$CREATE_FILE_DIR$YT_0"/"$YT_0"_filure_mms_user.txt"
today=$CREATE_FILE_DIR$TODAY"/"$TODAY"_filure_mms_user.txt"

######


readpath=$LOG_SMS_DIR/$YT_1
#PATH_DIR="`ls ${readpath}/*.out`"
#for file in $PATH_DIR/* 
if [  -d "$readpath" ]; then
for file in $readpath/* 
  do 
      file_end=`ls ${file} | cut -d "." -f2`
      file_head=`ls ${file} | cut -d "." -f1`
      if [ $file_end = "out" ];then
      cat $file | grep wuxian_qianxiang | awk  -F',' '{if( $20=="03" && $(NF-2)!="1000") print $1"^"$12"^"$14"^"$10"^"$15"^"$19"^"$5"^"$(NF-2)}' | awk -F':' '{print $4" "$5}'  | awk -F'^' '{print substr($1,0,15)"^"$2"^"$3"^"$4"^"$5"^"$6"^"$7"^"$8}'  >> $file1
      fi
  done 
fi


readpath=$LOG_SMS_DIR/$YT_0
#PATH_DIR="`ls ${readpath}/*.out`"
#for file in $PATH_DIR/* 
if [  -d "$readpath" ]; then
unset file
for file in $readpath/* 
  do 
      file_end=`ls ${file} | cut -d "." -f2`
      file_head=`ls ${file} | cut -d "." -f1`
      if [ $file_end = "out" ];then
      cat $file | grep wuxian_qianxiang | awk  -F',' '{if( $20=="03" && $(NF-2)!="1000") print $1"^"$12"^"$14"^"$10"^"$15"^"$19"^"$5"^"$(NF-2)}' | awk -F':' '{print $4" "$5}'  | awk -F'^' '{print substr($1,0,15)"^"$2"^"$3"^"$4"^"$5"^"$6"^"$7"^"$8}'  >> $file0

      fi
  done 
fi


readpath=$LOG_SMS_DIR/$TODAY
#PATH_DIR="`ls ${readpath}/*.out`"
#for file in $PATH_DIR/* 
if [  -d "$readpath" ]; then
unset file
for file in $readpath/* 
  do 
      file_end=`ls ${file} | cut -d "." -f2`
      file_head=`ls ${file} | cut -d "." -f1`
      if [ $file_end = "out" ];then
      cat $file | grep wuxian_qianxiang | awk  -F',' '{if( $20=="03" && $(NF-2)!="1000") print $1"^"$12"^"$14"^"$10"^"$15"^"$19"^"$5"^"$(NF-2)}' | awk -F':' '{print $4" "$5}'  | awk -F'^' '{print substr($1,0,15)"^"$2"^"$3"^"$4"^"$5"^"$6"^"$7"^"$8}'  >> $today

      fi
  done 
  fi


##xunhuan
cat $file1 $file0 $today |  awk -v of="$filter" -v co="$code" '
BEGIN { FS = "^"; OFS = "," }
{
ps[$2 "," $5 "," $6] ++
next
}
END { for(p in ps) { if (ps[p] >= 3 ) print p, ps[p] } }
' > $CREATE_FILE_DIR$TODAY"/"$YT_1"_mms_cm_user.txt"
[ $? -eq 0 ] || exit 1

echo $(date)
