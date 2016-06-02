	awk -F'^' '{if($5~/,/){split($5,tmp,",");for(t in tmp) print $1"^"$2"^"$3"^"$4"^"tmp[t]"^"$6;} else print;}' users_shenzhen.txt | unix2dos > users_shenzhen_ret.txt
