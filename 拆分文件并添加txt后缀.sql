split sjsj_black.txt -l 1 -d -a 2 sjsj_black_&&ls|grep sjsj_black_|xargs -n1 -i{} mv {} {}.txt
-l：按行分割，上面表示将urls.txt文件按2000行一个文件分割为多个文件
-d：添加数字后缀，比如上图中的00，01，02
-a 2：表示用两位数据来顺序命名
sjsj_black_：看上图就应该明白了，用来定义分割后的文件名前面的部分。
&&后边为增加.txt,即是所有文件*替换成*.txt
-I {} 表示把当前处理的参数用{}表示
{}是默认的参数列表标记
-n 选项限制单个命令行的参数个数
