#----------------------
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/home/wuying/;
export PATH
rm /data/wuying/4_y_cm_city.txt

k=1 
while [ $k -le 19 ]
do
        if [ $k -lt 10 ];then

        cat  /data/match/mm7/2015040$k/*meiti*.out |  awk -F',' '{if($(NF-2) != 1000 && $(NF-2) != 2000 && $(NF-2) != 4446 ) print $12","$15","$5","$(NF-2)}'     >> /data/wuying/4_y_cm_city.txt

        else
        
        cat  /data/match/mm7/201504$k/*meiti*.out |  awk -F',' '{if($(NF-2) != 1000 && $(NF-2) != 2000 && $(NF-2) != 4446 ) print $12","$15","$5","$(NF-2)}'   >> /data/wuying/4_y_cm_city.txt

        fi
       k=`expr $k + 1`
done
