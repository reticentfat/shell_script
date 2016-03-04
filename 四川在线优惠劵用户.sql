--从192.100.7.25上最新一个日期文件夹
/data/yhj_count_province/20160303
cat /data/yhj_count_province/20160303/YHJ.txt  | iconv -f UTF-8  -t GB18030 | grep '四川' > sc.txt
