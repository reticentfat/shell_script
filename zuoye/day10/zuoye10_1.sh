#任务1：最热门的国家签到排行（除中国）
cat weibo_locate.2018-05/* | cut -f5,8,9 | sort -u > temp_user_location.txt
rm -rf temp_country.txt
touch temp_country.txt
cat temp_user_location.txt | while read line
do echo $line
do echo $line1
        lati1=$(echo $line1 | awk '{print $2}')
        long1=$(echo $line1 | awk '{print $3}')
        wget "http://api.map.baidu.com/geocoder?callback=renderReverse&location=$lati1,$long1&output=json&pois=1" -O temp_location.txt -q
        result1=$(grep cityCode temp_location.txt | grep -Eo [0-9]+ )
        if [ $result1 -ne 0 ]; then echo "China" >> temp_country.txt
        else wget "http://dev.virtualearth.net/REST/v1/Locations/$lati1,$long1?o=xml&key=AvwLdi5YcwldiXf5pWlES9OAEHKJvrE3sWPju56N_-RO-1nIbehzyQh4xKHDkyGn" -O temp_location.txt -q
                result1=$(grep -Eo "<CountryRegion>[A-Za-z -]+</CountryRegion>" temp_location.txt | grep -Eo ">[A-Za-z -]+<" | sed 's/<//g' | sed 's/>//g' | head -1)
                echo $result1 >> temp_country.txt
        fi
done
paste -d"\t" temp_user_location.txt temp_country.txt > country_result.txt
cat country_result.txt | cut -f1,4 | sort -u | cut -f2 | sort | uniq -c | sort -k1,1rn > temp_result_columns.txt
cat temp_result_columns.txt | sed -e 's/[^0-9]* //'| cut -d' ' -f1 > temp_result_column1.txt
cat temp_result_columns.txt | awk '{$1="";print $0}' | sed 's/^ //g' > temp_result_column2.txt
paste -d"\t" temp_result_column2.txt temp_result_column1.txt > hw10.1_result
sed -i " " '/China/d' hw10.1_result

#任务2： 最热门的中国城市排行
grep China country_result.txt > temp_china_users.txt
rm -rf temp_city.txt
touch temp_city.txt
cat temp_china_users.txt | while read line
do echo $line
        lati=$(echo $line | awk '{print $2}')
        long=$(echo $line | awk '{print $3}')
        wget "http://api.map.baidu.com/geocoder?callback=renderReverse&location=$lati,$long&output=json&pois=1" -O temp_china_location.txt -q
        result=$(grep "\"city\"" temp_china_location.txt | awk -F: '{print $2}' | sed 's/"//g' | sed 's/,//g')
        echo $result >> temp_city.txt
done
paste -d"\t" temp_china_users.txt temp_city.txt > city_result.txt
cat city_result.txt | cut -f1,5 | sort -u | cut -f2 | sed '/^$/d'| sort | uniq -c | awk '{print $2"\t"$1}' | sort -k2,2rn > hw10.2_ result


#任务3：最热门的中国省排名
grep China country_result.txt > temp_china_users.txt
rm -rf temp_province.txt
touch temp_province.txt
cat temp_china_users.txt | while read line
do echo $line
        lati=$(echo $line | awk '{print $2}')
        long=$(echo $line | awk '{print $3}')
        wget "http://api.map.baidu.com/geocoder?callback=renderReverse&location=$lati,$long&output=json&pois=1" -O temp_china_location.txt -q
        result1=$(grep province temp_china_location.txt | grep 省 | awk -F: '{print $2}' | sed 's/"//g' | sed 's/,//g')
        echo $result1 >> temp_province.txt
done
paste -d"\t" temp_china_users.txt temp_province.txt | cut -f1,5 | sort -u | cut -f2 | sed '/^$/d'| sort | uniq -c | awk '{print $2"\t"$1}' | sort -k2,2rn > hw10.3_result  

 #任务4：微博用户签到城市数量排名和签到数量排名
cat weibo_locate.2018-05/* | cut -f4,5 | sort | uniq > temp_user_weibo.txt
cut -f2 temp_user_weibo.txt | sort | uniq -c | awk '{print $2"\t"$1}' > temp_weibo_count.txt
cut -f1,5 city_result.txt | sort | uniq -c | awk '{print $2"\t"$1}' | sort -k2,2rn > user_city_sign.txt
join -t $'\t' user_city_sign.txt temp_weibo_count.txt > hw10.4_result    

 #任务5：5月有跨国旅行的人在微博总用户中的比例
foreign=$(grep -v China country_result.txt | cut -f1 | sort | uniq | wc -l)
total=$(cut -f1 temp_user_location.txt | sort | uniq | wc -l)
echo $foreign $total | awk '{print $1/$2*100"%"}'         

#任务6：跨国旅行的人喜欢什么手机
cut -f5,15 weibo_freshdata.2018-05-17 | sort -u > temp_user_device.txt
grep -v China country_result.txt | cut -f1 | uniq > temp_non_china_users.txt
join temp_non_china_users.txt temp_user_device.txt > temp_foreign_device.txt

rm -rf temp_device_merged.txt
touch temp_device_merged.txt
grep -i -e "iPhone" -e "iPad" -e "iPod" temp_foreign_device.txt | awk '{print $1" 苹果"}' >> temp_device_merged.txt
grep -i -e "HUAWEI" -e "华为" -e "荣耀" -e "麦芒" temp_foreign_device.txt | awk '{print $1" 华为"}' >> temp_device_merged.txt
grep -e "小米" -e "红米" temp_foreign_device.txt | awk '{print $1" 小米"}' >> temp_device_merged.txt
grep -i -e "OPPO" temp_foreign_device.txt | awk '{print $1" OPPO"}' >> temp_device_merged.txt
grep -i -e "VIVO" temp_foreign_device.txt | awk '{print $1" VIVO"}' >> temp_device_merged.txt
grep -i -v -e "iPhone" -e "iPad" -e "iPod" -e "HUAWEI" -e "华为" -e "荣耀" -e "麦芒" -e "小米" -e "红米" -e "OPPO" -e "VIVO" temp_foreign_device.txt >> temp_device_merged.txt
cat temp_device_merged.txt | sed 's/^[0-9]*//g'| sort | uniq -c | sort -k1,1rn > temp_phone_columns.txt
cat temp_phone_columns.txt | sed -e 's/[^0-9]* //'| cut -d' ' -f1 > temp_phone_column1.txt
cat temp_phone_columns.txt | awk '{$1="";print $0}' | sed 's/^ //g' > temp_phone_column2.txt
paste -d"\t" temp_phone_column2.txt temp_phone_column1.txt > hw10.6_result                          
