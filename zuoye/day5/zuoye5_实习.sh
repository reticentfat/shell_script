#提取userid和小尾巴
cat weibo.top10wan | cut -f5,15 | sort -k2,2 -k1,1n -t $'\t' | uniq | cut -f2 > temp_user
#获取uniq的小尾巴列表
cat temp_user | uniq > temp_user_device
#获取使用该设备发文的独立用户量
cat temp_user | uniq -c | awk '{print $1}' > temp_user_cnt
#合并两列数据
paste -d"\t" temp_user_device temp_user_cnt > temp.txt

#提取weiboid和小尾巴
cat weibo.top10wan | cut -f9,15 | sort -k2,2 -k1,1n -t $'\t' | uniq | cut -f2 > temp_weibo
#获取使用该设备发文的独立微博量
cat temp_weibo | uniq -c | awk '{print $1}' > temp_weibo_cnt
#合并数据并sort
paste -d"\t" temp.txt temp_weibo_cnt | sort -k2,2rn -k3,3rn -t $'\t' > hw4.1_result

#提取用户名和小尾巴
cat weibo.top10wan | cut -f6,15 | sort -k2,2 -k1,1n -t $'\t' | uniq | cut -f1 | sort > temp_name
#获取用户名的发文设备数
cat temp_name | uniq -c | awk '{print $2"\t"$1}' | sort -k2,2rn > temp_result
#只打印设备数不为1的用户
n=$(expr $(cat temp_result | grep -n '\t1$' | head -1 | cut -d : -f 1) - 1)
head -$n temp_result > hw4.2_result

rm -rf temp_*
