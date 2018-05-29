#作业5-1
#提取必要数据user_id,weibo_id,device
cut -f5,9,15 weibo.top10wan > xwb.dat
#处理并得到结果
sort -u -t $'\t' -k3 -k1 xwb.dat|awk -F"\t" 'BEGIN{xwb='0';user_id=0;user_cnt=0;weibo_cnt=0;}{if($3==xwb){weibo_cnt++;if($1!=user_id){user_cnt++;user_id=$1}}else{if(xwb!='0'){print xwb"\t"user_cnt"\t"weibo_cnt}xwb=$3;user_id=$1;user_cnt=1;weibo_cnt=1;}}END{print xwb"\t"user_cnt"\t"weibo_cnt}'|sort -t $'\t' -k2,2rn > xwb.result
#作业5-2
#提取必要数据user_id,nick_name,device
cut -f5,6,15 weibo.top10wan > xwb.dat2
#处理并得到结果
sort -u -t $'\t' xwb.dat2|awk -F"\t" 'BEGIN{id=0;name='0';count=0;}{if($1==id){count++;}else{if(id!=0){print name"\t"count}id=$1;name=$2;count=1;}}END{print name"\t"count}'|sort -k2,2rn|grep -v -E $'\t1' > xwb.result2

