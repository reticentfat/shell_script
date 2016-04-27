
#!/bin/awk -f
##统计字段重复数量，默认$1
##将原始文件分成不重复的号码和重复号码两个文件
#提取的成功与失败的号码会出现重复，所以要将失败号码中的在成功号码中存在的号码剔除，才是完全失败的号码
#awk -F'\t' '{if(FILENAME~/foshan_repeat\.txt$/) repeat[$1]=$1; else{if(!($1 in repeat)) print $1}}' foshan_repeat.txt foshan_failed.txt > foshan_real_failed.txt
#awk -F'\t' -v info=foshan_real_failed_car_info.txt -v yidong=foshan_real_failed_yidong.txt '{if(FILENAME~/foshan_car_no\.txt/) no[$1]=$0; else{if($1 in no) print no[$1]>>info; else print $1>>yidong;}}' foshan_car_no.txt foshan_real_failed.txt 
#./analysis_repeat.awk 10086.txt foshan_real_failed_yidong.txt 如果_repeat文件数量与_yidong数据量相同则表示都是10086挽留用户里的
	
BEGIN{
	FS=OFS="\t"
}
{
	if($1 in url)
	{
		url[$1]++
	}
	else
	{
		url[$1] = 1
	}
}
END{
	split(FILENAME,tmp,"/")
	temp = tmp[length(tmp)]
	split(temp,file,".")
	for(col in url)
	{
		if(url[col] > 1)
		{
			print col >> file[1]"_repeat.txt"
		}
		else
		{
			print col >> file[1]"_no_repeat.txt"
		}
	}
}
