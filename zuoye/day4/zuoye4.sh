#任务1
grep  "^\S\+\s\+12\b" mubiao.file
#任务2
grep  "^\S\+\s\+\S\+\s\+5\b" mubiao.file
#任务3
#mubiao2.file
#梁斌    好人
#学习    进步
#人生    苦短
#好好    学习
#天天    向上
 
#如何grep 同时“学习”或者“好好”记录结果。
grep -e "学习" -e "好好" mubiao2.file
 
#如果需要匹配的关键词足够多，比如敏感词表，怎么用grep来做，敏感词表是按行写在一个文件中的，需要grep出所有包含敏感词的句子。
#mubiao3.file
#梁斌
#学习
grep -wf mubiao3.file mubiao2.file
 
#任务4
grep -C 1 "进步" mubiao2.file |grep -v "进步"
