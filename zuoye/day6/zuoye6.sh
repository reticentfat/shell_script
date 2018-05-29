# script06_1.sh 
#运行 ./script06_1.sh <NICK_NAME>
user=$1
#获得该用户全部微博
cut -f 6,9,10 weibo.top10wan | grep "^$user" | sort -u | cut -f3 | sed 's/#//g'> 'temp_'$user'_weibo.txt'
echo ' ' > temp_total_weibo.txt

#对其微博进行分词
cat 'temp_'$user'_weibo.txt' | while read line
do newline=${line//#/ } 
        wget "http://api.pullword.com/get.php?source=$newline&param1=0.6&param2=1" -O temp_weibo.txt
        cat temp_weibo.txt | cut -d: -f1 | sort -u >> temp_total_weibo.txt
done

#计算词频
weibo_cnt=$((cat 'temp_'$user'_weibo.txt') | wc -l)
grep -v '^\s*$' temp_total_weibo.txt | sort | uniq -c | awk '{print $2"\t"$1'/'cnt}' cnt="$weibo_cnt" | sort -k2rn -t$'\t' > hw6.1_result



# script06_2.sh
# 运行 ./script06_2.sh <KEYWORD>
keyword=$1
cut -f 6,9,10 weibo.top10wan | sort -u > temp_all_weibo.txt

#获得user
cat temp_all_weibo.txt | awk -F"\t" '{if($3~key)print $1;}' key="$keyword" | sort -u > temp_keyword_users.txt
echo " " > temp_user_freq.txt

#计算keyword词频
cat temp_keyword_users.txt | while read line
do  total=$(grep "^$line" temp_all_weibo.txt | wc -l)
    keynum=$(grep "^$line" temp_all_weibo.txt | cut -f3 | grep $keyword | wc -l)
    re=$(awk -v key="$keynum" -v to="$total" 'BEGIN{print key/to}')
    echo -e $line"\t"$re >> temp_user_freq.txt
done
cat temp_user_freq.txt | sort -k2,2rn > hw6.2_result

