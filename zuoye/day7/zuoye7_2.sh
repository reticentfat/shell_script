思路：将原文件做预处理（取出$5 $9 $19,剔除原创微博和自己转发自己的微博，剔除weiboid重复的数据）；然后uniq -c "$5-$19" 和"$19-$5"这两个拼接字段，结果分别写入tmp1 tmp2 中；随后只需要将2个文件依据拼接字段进行join，第一列useridA-useridB，第二列为A转发B的条数，第三列为B转发A的条数；最后对join后的文件直接进行awk 计算即可，将互动最频繁的条目写入final文件。

awk -F '\t' '{if(length($19)!=0&&$5!=$19) print $9,$5,$19}' weibo.top10wan.txt|sort -u -k1.1|awk '{print $2"-"$3}' |sort|uniq -c|sed 's/^[ ]*//g'|awk '{print $2,$1}'|sort>tmp1;

awk -F '\t' '{if(length($19)!=0&&$5!=$19) print $9,$5,$19}' weibo.top10wan.txt|sort -u -k1.1|awk '{print $3"-"$2}' |sort|uniq -c|sed 's/^[ ]*//g'|awk '{print $2,$1}'|sort>tmp2;
 
join tmp1 tmp2|awk '{print($2>$3)?$3*2:$2*2,$1,$2,$3}'|sort -rnk 1,1|awk 'NR==1{a=$1;print} NR>1{if($1==a)print}'>final;


注意：这个算法不完全正确，最后会出现重复的用户，如：
2 5760089239-2174407342 1 1
2 2174407342-5760089239 1 1 需在最后再一次去重。
