任务1：如何对mubiao.file grep第二列是12的结果

运行
sh task1.sh 12

#task1.sh:
value=$1
str=$\''\t'${value}'\t'\'
cmd="grep "${str}" mubiao.file"
echo $cmd
eval $cmd


任务2：如何对mubiao.file grep出第三列是5的结果

运行
sh task2.sh 5

#task2.sh:
value=$1
str=$\''\t'${value}'$'\'
cmd="grep "${str}" mubiao.file"
echo $cmd
eval $cmd


任务3：
运行：
grep -e "学习" -e "好好” wenben.file

wenben.file：
梁斌 好人
学习 进步
人生 苦短
好好 学习
天天 向上

当有多个敏感词时：

运行：
grep -f key.words wenben.file

key.words为敏感词文件，每行一个敏感词

任务4：
运行：
grep "进步" -A 1 -B 1 wenben.file | grep -v “进步"

wenben.file见任务三中定义
