勾兑
 awk -F'[|,]' 
    'BEGIN
      {  if (FILENAME=="1.txt") 
             {a[$1]=$2;b[$1]=$3}
         else {c[$1]=$2} 
    
       } 
      END 
       { for (i in a) 
           {print i,a[i],b[i],c[i] }
       } ' 1.txt  2.txt         

awk -F',' '{if(FILENAME=="appproxy-debug0308.log" ){d[$3]=$0}else if($5 in d){print $0","d[$5]}}' appproxy-debug0308.log appproxy_102_0308.log> ~/bossdata/0308_102.txt 
awk -F'[ |]' '{if(FILENAME=="appcode1128.txt" ){d[$5]=$0}else if($2 in d){print d[$2]","$0}}' appcode1128.txt 20120313_mtF.txt |head 
cat 1.txt| awk '{if(NF!=1);FS=","; OFS=","; a[$5]+=$12; b[$5]+=$10 }  END { for (i in a)  {print i,a[i],b[i]}}' 
计算求和
awk   'BEGIN { FS='[|,]'; OFS=","; a[$4]+=1; b[$4]+=$5 }  END { for (i in a)  {print i,a[i],b[i]}}'   1.txt

以第一个数组为基准，用第二个数据的列去对应第一个数据
awk '{if(NF==3){a[$1]=$2" "$3}else{if(substr($1,1,7) in a){print $1" "a[substr($1,1,7)]}}}' number_segment.data phone.txt | head
