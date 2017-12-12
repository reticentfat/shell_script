#!/bin/sh
. /usr/local/app/dana/current/shbb/profile
#. /home/chenly/profile
usage () {
        echo "usage: $0    target_dir" 1>&2
        exit 2
}

if [ $# -lt 1 ] ; then
        usage
fi

V_DATE=$1
V_YEAR=$(echo $V_DATE | cut -c 1-4)
SOURCE_DIR=$AUTO_SRC_MM7/$V_DATE
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

    # 处理mm7_out文件    
    CODE_FILE="$CODE_DIR/nodist.tsv"
    TARGET_FILE="$TARGET_DIR/mm7_out.txt"
    SOURCE_FILE=$SOURCE_DIR/*.out
    
    awk -F'[,|]' '{
        if(FILENAME=="'$CODE_FILE'")
         {
             #地市编码"|"省编码"|"地市名称"|"省名称
             nodist[$4]=$3"|"$5"|"$2"|"$1
         }
     else 
         {
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
                    provi="000|000|未知|未知"
                }
            port_id=$10
            flow=index($0,"]: ")+3
            flow_no=substr($1,flow)
            subtime=substr($42,1,4)""substr($27,1,10) #提交时间
            dealtime=substr($42,1,4)""substr($42,6,2)""substr($42,9,2)""substr($42,12,2)""substr($42,15,2)""substr($42,18,2)    #处理时间
            #输出手机号"|"appcode"|"发送状态"|"省份信息"|"通话序列号"|"提交时间"|"处理时间"|"端口号
            print $12"|"$15"|"$40"|"provi"|"flow_no"|"subtime"|"dealtime"|"port_id
        }
}' $CODE_FILE $SOURCE_FILE >$TARGET_FILE
    # 处理mm7_mt文件
 SOURCE_FILE1=$SOURCE_DIR/*.mt
    TARGET_FILE1="$TARGET_DIR/mm7_mt.txt"
    
    awk -F'[,|]' '{
    if(FILENAME=="'$CODE_FILE'")
    {
            #地市编码"|"省编码"|"地市名称"|"省名称
        nodist[$4]=$3"|"$5"|"$2"|"$1
    }
    else
    {
        port_id=$10
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
                provi="000|000|未知|未知"
            }
        #输出手机号"|"appcode"|"发送状态"|"省份信息"|"通话序列号"|"端口号
        print $12"|"$15"|"$28"|"provi"|"flow_no"|"port_id
}
}' $CODE_FILE $SOURCE_FILE1 >$TARGET_FILE1
