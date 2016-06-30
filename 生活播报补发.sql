如果需要补发（一种情况是下发失败较多的情况，需要用下发列表号码与实际下发号码比较，找到没有下发的号码明细进行补发。） 
   最新的下发列表地址 http://192.100.6.31:9999/data/dump/SHBB/ 下面的user.txt.bz2 是主刊号码。 与刘彦华核对一下总量，
财富经http://192.100.6.31:9999/data/dump/CFZZ/
cat ZSHK.txt | awk -F' ' '{print $1}' | sort -u|dos2unix >ZSHK+1.txt
cat DCNEW.txt | awk -F' ' '{print $1}' | sort -u|dos2unix >DCNEW+1.txt
cat NRZNEW.txt | awk -F' ' '{print $1}' | sort -u|dos2unix >NRZNEW+1.txt
cat CFZZ.txt | awk -F' ' '{print $1}' | sort -u|dos2unix >CFZZ+1.txt
cat YYHK.txt | awk -F' ' '{print $1}' | sort -u|dos2unix >YYHK+1.txt
cat YZLX.txt | awk -F' ' '{print $1}' | sort -u|dos2unix >YZLX+1.txt
MZONE.txt
cat MZONE.txt | awk -F' ' '{print $1}' | sort -u|dos2unix >MZONE+1.txt
YZLX.txt
NRZNEW.txt
然后提取第一行，拆分50万一个文件
split -l 450000 MZONE+1.txt MZONE
split -l 450000 YYHK+1.txt YYHK
split -l 450000 YZLX+1.txt YZLX
YZLX+1.txt
