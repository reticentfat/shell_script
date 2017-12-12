#!/bin/sh
. /usr/local/app/dana/current/shbb/profile
#. /home/chenly/profile
usage () {
    echo "usage: $0  target_dir" 1>&2
    exit 2
}

if [ $# -lt 1 ] ; then
    usage
fi

V_DATE=$1
V_YEAR=$(echo $V_DATE | cut -c 1-4)
SOURCE_DIR=$AUTO_SRC_CMPP/$V_DATE
TARGET_DIR=$AUTO_DATA_TARGET/$V_YEAR/$V_DATE
CODE_DIR=$AUTO_DATA_NODIST
if [ ! -d "$SOURCE_DIR" ]; then
  echo "$SOURCE_DIR not found"
  exit 1
fi
if [ ! -d "$TARGET_DIR" ]; then
  if ! mkdir -p $TARGET_DIR
  then
    echo "mkdir $TARGET_DIR error"
    exit 19
  fi
fi

	# 处理cmpp out文件        
	TARGET_FILE="$TARGET_DIR/cmpp_out.txt"
	SOURCE_FILE=$SOURCE_DIR/*.out
	
	awk -F',' '$0 != "" && NF> 7{
          flow=index($0,"]: ")+3
          flow_no=substr($1,flow)
          if(length($(NF-1)==10)){$(NF-1)="20"$(NF-1)}
          if(length($NF==10)){$NF="20"$NF}  #啊。。。。 你懂的
	  print  $8"|"$9"|"$10"|"$11"|"$12"|"$13"|"$14"|"$15"|"$17"|"$19"|"$20"|"$21"|"$23"|"$24"|"$25"|"$26"|"$29"|"$30"|"$31"|"$32"|"$33"|"$(NF-3)"|"$(NF-2)"|"$(NF-1)"00|"$(NF)"00|"$(NF-7)"|"$(NF-8)"|"flow_no
}' $SOURCE_FILE >$TARGET_FILE
	# 处理cmpp mt文件
 SOURCE_FILE1=$SOURCE_DIR/*.mt
	CODE_FILE="$CODE_DIR/nodist.tsv"
	TARGET_FILE1="$TARGET_DIR/cmpp_mt.txt"
	
	awk -F'[,|]' '{
	if(FILENAME=="'$CODE_FILE'")
	{
	  nodist[$4]=$3"|"$5
	}
	else
	{
	  flow=index($0,"]: ")+3
	  flow_no=substr($1,flow)
	  if(substr($12,1,7) in nodist)
	    {
	      provi=nodist[substr($12,1,7)]
	    }
	  else if(substr($12,1,8) in nodist)
	    {
	      provi=nodist[substr($12,1,8)]
	    }
	  else
	    {
	      provi="000|000"
	    }
	  print  $8"|"$9"|"$10"|"$11"|"$12"|"$13"|"$14"|"$15"|"$17"|"$19"|"$20"|"$21"|"$23"|"$24"|"$25"|"$26"|"$29"|"$30"|"$31"|"$32"|"$33"|"provi"|"flow_no
}
}' $CODE_FILE $SOURCE_FILE1 >$TARGET_FILE1

