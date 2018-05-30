cut -f5,6,9,19,20,22 weibo.top10wan | sort -k3,3 | uniq > ../homework7/weibo.file

cat weibo.file | awk -F "\t" '{
if($4!=""){
str=$1" "$4
arr[str]++;
}}
END{
for(key in arr){
    if(flag[key]==1) {
        continue;
    }
    split(key,output," ")
    if(output[1]==output[2]) {
        continue;
    }
    key2=output[2]" "output[1]
    if(arr[key] < arr[key2]) {
        min=arr[key]
    }
    else {
        min=arr[key2]
    }
    if(min!=0){
        ans[key]=min*2
    }
    flag[key]=1;
    flag[key2]=1;
   # print arr[key],arr[key2]
   # print output[1],output[2]
   # print key,arr[key]
}
for(key in ans) {
    print key,ans[key]
}
}' | sort -k3,3nr | head -100

