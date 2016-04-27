#!/bin/awk -f
##统计字段重复数量，默认$1
##将原始文件分成不重复的号码和重复号码两个文件
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
