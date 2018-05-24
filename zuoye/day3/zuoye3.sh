# 统计每个人发的微博数
cat weibo.top10wan | cut -f5,9 | sort | uniq | cut -f1 | uniq -c |  awk '{print $1,$2}' | sort -k2 > weibo_cnt
# 统计每个人发的长微博数
cat weibo_changweibo.2018-05-17 | cut -f4,5 | sort | uniq | cut -f1 | uniq -c  |  awk '{print $1,$2}' | sort -k2 > weibo_chang

# 连接
join -1 2 -2 2 -a1 -a2 -e '  '  -o  0 1.1 2.1 weibo_chang weibo_cnt | sort -nrk2 -k1 > result

#	Tips
#	1. 以上代码中#连接的部分不完全正确，但是写法上是最简洁的写法。正确的参考写法如下：
join -1 2 -2 2 -a1 -a2 -e '0'  -o  0 1.1 2.1 weibo_cnt weibo_chang | sort -nrk2 -k1 > result
