#用的群里同学的gis数据，合并到新的文件
awk  -F'\t' -v CODE_DIR=END_lat_lon_country_uniq -v fileok=weibo_locate.2018-05ok.txt '{
	if( FILENAME == CODE_DIR  )  d[$1$2]=$3"|"$4"|"$5;
	 else if ( FILENAME != CODE_DIR    &&  $8$9 in d ) print $4"|"$5"|"d[$8$9] >> fileok ;
	 else if ( FILENAME != CODE_DIR    && !($8$9 in d )) print $4"|"$5"|""|">> fileok ;
	}' END_lat_lon_country_uniq weibo_locate.2018-05
 # weibo_locate.2018-05ok.txt如下
  4234367150688110|3060133037|中国|四川省|眉山市
4234647187663653|5710102692|中国|浙江省|杭州市
4234642703456270|5052504108|中国|黑龙江省|哈尔滨市
  1）最热门的国家签到排行（除中国）

    签到国家\t uniq的签到人数
    cat weibo_locate.2018-05ok.txt | awk -F'|' '$3!="中国"&&$3!=""{print $2"|"$3}' | sort -u | awk -F'|' '{print $2}' | sort | uniq -c |sort -rn | awk '{print $2"\t"$1}' | head -10
Japan 23446
United 18392
Thailand 15187
Australia 10893
South 10017
United 9918
Canada 5586
Malaysia 5223
France 4813
Singapore 3957
2）最热门的中国城市排行
cat weibo_locate.2018-05ok.txt | awk -F'|' '{print $2"|"$5}' | sort -u | awk -F'|' '$2!=""{print $2}' | sort | uniq -c |sort -rn | awk '{print $2"\t"$1}' 
北京市 166980
上海市 113992
成都市 81424
广州市 73731
西安市 69849
深圳市 66021
杭州市 65363
武汉市 57319
重庆市 56478
南京市 55054
3）微博用户签到城市数量排名和签到数量排名，join到一张表，按照城市签到数量倒叙排列。（注意一个用户可能签到多次，但签到的城市是同样的一个）

    微博userid \t uniq的签到城市总数 \t uniq的签到总微博数
 首先计算每个userid的签到城市总数 
 cat weibo_locate.2018-05ok.txt | cut -d "|" -f2,5 | sort | uniq | cut -d "|" -f1 | sort |uniq -c |  awk '{print $2,$1}' | sort -k1,1 > zuoye10.3_tmp1.txt
 然后计算每个userid的签到总微博数
 awk -F'|' '{print $2"\t"$1}' weibo_locate.2018-05ok.txt | sort | uniq | cut  -f1 | uniq -c |  awk '{print $2,$1}' | sort -k1,1 > zuoye10.3_tmp2.txt
 合并
 join -1 1 -2 1 -a1 -a2 -e '0' zuoye10.3_tmp1.txt zuoye10.3_tmp2.txt | sort -k2,2rn > zuoye10.3.txt
 #结果
2331955785 36 482
1694021242 22 55
1136595755 21 69
2121290281 18 32
2616806833 18 64
1839186122 17 73
1843847002 17 51
2520186041 17 59
1058406865 16 83
1233628161 16 91
-----------
4）找到在5月份有跨国旅行的人，计算这部分人在微博总用户的比例。
#出国游人数
chuguo_count=$(cat weibo_locate.2018-05ok.txt | awk -F'|' '$3!="中国"&&$3!=""{print $2}' | sort | uniq | wc -l ）
145052
#总微博用户
all_count=$(cat weibo_locate.2018-05ok.txt | awk -F'|' '{print $2}' | sort | uniq | wc -l)
2482552
#出国比例：
echo | awk '{printf("%.2f%%\n",145052/2482552*100)}'
5.84%
5）跨国旅行的人喜欢用什么手机，首先需要找到有过跨国旅行的人，然后去5月17日那一天的微博数据中去兑出他们可能的手持设备，计算结果是这样一个排行榜，同类型设备需要归并，比如小米各种型号要归并成小米（要用到正则），苹果各种型号也要归并到苹果，其他杂牌手机不要求合并，只合并小米、苹果、华为、Oppo和Vivo这五个：
   
手机设备名 \t 出国次数
#先找到5月出国人员的userID
cat weibo_locate.2018-05ok.txt | awk -F'|' '$3!="中国"&&$3!=""{print $2}' | sort | uniq >chuguo_uerid.txt
#然后找设备信息
awk -F'\t' -v CODE_DIR=chuguo_uerid.txt    '{
     if( FILENAME == CODE_DIR  )  d[$1]=$1 ;
         else if ( FILENAME != CODE_DIR && ($5 in d) ) print   $5,$15 ;      
        }'     chuguo_uerid.txt  weibo_freshdata.2018-05-17 > zuoye10.5_tmp1.txt
#然后排重
 cat zuoye10.5_tmp1.txt | head
#然后分别对小米、苹果、华为、Oppo和Vivo品牌归并
#小米
cat zuoye10.5_tmp2.txt | grep -iE "小米|红米|mi" >zuoye10.5_xiaomi.txt
awk '{print $1}' zuoye10.5_xiaomi.txt |sort -u | wc -l
     699
#苹果
   cat zuoye10.5_tmp2.txt | grep -iE "iPhone|苹果" >zuoye10.5_apple.txt
   awk '{print $1}' zuoye10.5_apple.txt |sort -u | wc -l
   36549
#华为
cat zuoye10.5_tmp2.txt | grep -iE "华为|huawei" >zuoye10.5_huawei.txt
   awk '{print $1}' zuoye10.5_huawei.txt |sort -u | wc -l
   1751
#Oppo
cat zuoye10.5_tmp2.txt | grep -iE "欧珀|oppo" >zuoye10.5_oppo.txt
   awk '{print $1}' zuoye10.5_oppo.txt |sort -u | wc -l
     655
 #Vivo
 cat zuoye10.5_tmp2.txt | grep -iE "维沃|vivo" >zuoye10.5_vivo.txt
  awk '{print $1}' zuoye10.5_vivo.txt |sort -u | wc -l
     434
 #结果
 苹果 36549
 华为 1751
 小米 699
 oppo 655
 vivo 434
   
  
   
