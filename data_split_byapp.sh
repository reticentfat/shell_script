#!/bin/sh
gawk 'BEGIN{

 i="'$1'"

 dir="'$2'"

 file_name="'$3'"
 FS="'$5'"
 file_title="'$6'"
 v_date="'$7'"
 #读配置文件
 while(getline var < "'$4'"){split(var,aa,"|");a[aa[1]]=aa[2]}
}
{ #如果列值在配置文件中输出

  if($i in a)
  {

    #输出目录/文件名_部门编号

    out_file=dir"/"file_title"_"a[$i]"_"v_date"_"file_name

    print > out_file
  }
}'

