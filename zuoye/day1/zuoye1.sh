计算发文(weibo_id)最多的top 100个用户
cut -f5,6,9 weibo.top10wan | sort -k3n | awk -F"\t" 'BEGIN{s=0;}{if($3!=s) print $0; s=$3;}END{if($3!=s) print $0;}' | cut -f1 | sort | uniq -c | awk -F" " '{print $2"\t"$1;}' | sort -k2rn | head -100
因为大文件没下完，使用的是小文件
<PATH_TO_weibo.top10wan> 指代文件 weibo.top10wan 的绝对路径
### 计算出微博 1 天的数据总量：


awk 'END{print NR}' <PATH_TO_weibo.top10wan>
输出：100000

###  微博发文user_id总量:

awk 'BEGIN{FS="\t";total=0}{sum[$5] ++}; END{ for (id in sum) {total++} {print total}}' <PATH_TO_weibo.top10wan>

输出：47661

###  微博文章总量:

awk 'BEGIN{FS="\t";total=0}{sum[$9] ++}; END{ for (id in sum) {total++} {print total}}' <PATH_TO_weibo.top10wan>


输出：96688

### 计算发文(weibo_id)最多的top 100个用户：
awk 'BEGIN{FS="\t"}{if(!seen[$5,$9]++) sum[$5]++;}; END{ for (id in sum) {print id, sum[id]} }' <PATH_TO_weibo.top10wan>  | sort -r -nk2 | head -n 100 > test1_3.txt


输出(前面是 user_id, 后面是该 user_id 的 distinct count(weibo_id))：
---------------------------
# 数据总量
wc -l top10wan # 100000

# 微博发文user_id总量
cat top10wan | awk -F"\t" '{print $5}' | sort | uniq | wc -l # 47661

# 微博文章weibo_id总量
cat top10wan | awk -F"\t" '{print $9}' | sort | uniq | wc -l # 96688

# 计算发文(weibo_id)最多的top 100个用户
cat top10wan | awk -F"\t" '{print $5,$9}' | sort | uniq | awk '{ct[$1]+=1};
  END {
   for(uid in ct) {print uid, ct[uid]}
  }
' | sort -k2 -nr | head -100
