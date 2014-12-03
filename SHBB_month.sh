#!bin/sh

#----------------------
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/home/wuying/;
export PATH
#export PATH=/home/wuying/
if [ $# -eq 4 ];then
   INDATE=$1
   INDATE_1=$2
   INDATE_2=$3
   INDATE_3=$4
fi

if [ ${INDATE:=999} = 999 ];then
DEALDATE=`date -v-1d  +%Y%m%d`
DEALDATE_M=`date -v-1d  +%Y%m`

DEALDATE_D=`date -v-0d  +%d`
DEALDATE3=`date -v-4d  +%Y%m%d`
DEALDATE_1=`date -v-1d  +%Y-%m-%d`
DEALDATE3_1=`date -v-4d  +%Y-%m-%d`
else
DEALDATE=$INDATE
DEALDATE_M=$INDATE_1
DEALDATE_D=$INDATE_2
DEALDATE_NM=$INDATE_3
DEALDATE3_1=$INDATE_1
fi
CODE_DIR='/data0/match/orig/profile'


###上海10086操作统计
bzcat /logs/bak205/log/10086_magzine/${DEALDATE_M}*/205/10086_magzine.log.0.bz2 | grep "shanghai" | awk '{print $6}' |awk -F "|" '{print $1}'|sort |uniq -c > ~/month/shanghai_${DEALDATE_M}_10086_count.txt
bzcat /logs/20120115/outputumessage_001_meiti_20120115_snapshot.bz2 | awk -F "|" '{if($4>="20111215000000"&&$3=="06"&&$8=="028"&&$14=="YZLX") print $1","$2","$4","$7}' > ~/month/sichuan_20120115_user.txt


###.......1..15..

if [ ${DEALDATE_D} -eq 16 ];then

k=1
while [ $k -le 15 ]
do
        if [ $k -lt 10 ];then
           echo $k
           echo /logs/${DEALDATE_M}*/outputumessage_002_meiti_${DEALDATE_M}0${k}_usa.action.log.bz2
       bzcat /logs/${DEALDATE_M}*/outputumessage_002_meiti_${DEALDATE_M}0${k}_usa.action.log.bz2 | awk -F "|" '{if($2=="pause"&&$4=="021"&&($10=="4442"||$10=="4441")) print $3,$6}'|sort -u  >> ~/month/shanghai_01_15_${DEALDATE_M}.txt

         else
           echo $k
        bzcat /logs/${DEALDATE_M}*/outputumessage_002_meiti_${DEALDATE_M}${k}_usa.action.log.bz2 | awk -F "|" '{if($2=="pause"&&$4=="021"&&($10=="4442"||$10=="4441")) print $3,$6}'|sort -u  >> ~/month/shanghai_01_15_${DEALDATE_M}.txt
         fi
       k=`expr $k + 1`
done
fi

if [ ${DEALDATE_D} -eq 01 ];then

				##福建计费用户
						cat /logs/${DEALDATE}/meiti_payuser_list.txt | awk -F "," -v date=${DEALDATE_M}  '{if($4=="591") print date,$1,$6,$7,$2}'|awk 'BEGIN{OFS="\200"; ORS="\r\n"}  {if($5=="22200030") $5="125820";if($5=="22200032") $5="125821";if($5=="22200040") $5="125859";if($5=="22200041") $5="125860";if($5=="22220032") $5="125821";if($5=="22220033") $5="125856";if($5=="22220037") $5="125849";if($5=="22220038") $5="125850";if($5=="22220039") $5="125874";if($5=="22220040") $5="125883";if($5=="22220042") $5="125834";if($5=="22230033") $5="125833";if($5=="22230034") $5="125872";if($5=="22230035") $5="125873";if($5=="22209061") $5="1258100"; print $1,$2,$3,$4,$5}'>~/month/fujian_jfyh_${DEALDATE}_month.txt
				
				##月武汉生活播报3元版订购用户明细
						bzcat /logs/${DEALDATE}/outputumessage_001_meiti_${DEALDATE}_snapshot.bz2 | awk -F "|"  -v date=${DEALDATE_M}  '{if($8=="027"&&$2=="22220032"&&(substr($5,1,6)==date)) print }'>~/month/hubei_${DEALDATE_M}_shbb_3ysub_m.txt 
				##..............-...............22220032.............2.....1.....
				##.本月新增包月用户数
						cat ~/month/hubei_${DEALDATE_M}_shbb_3ysub_m.txt  | awk -F "|"   -v date=${DEALDATE_M} '{if(substr($5,1,6)==date)print $9}'|sort |uniq -c > ~/month/hubei_${DEALDATE_M}_xzsub_count.txt 
				##.本月新增退定用户数
						cat ~/month/hubei_${DEALDATE_M}_shbb_3ysub_m.txt  | awk -F "|" -v date=${DEALDATE_M}  '{if($3=="07"&&(substr($4,1,6)==date))print $9}' | sort | uniq -c >~/month/hubei_${DEALDATE_M}_xzunsub_count.txt 
				##.本月免费期退定用户数
						cat ~/month/hubei_${DEALDATE_M}_shbb_3ysub_m.txt  |awk -F "|" -v date=${DEALDATE_M} '{if($3=="07"&&(substr($4,1,6)==date&&((substr($6,1,6)==date)))&&(((substr($4,7,2)*24*3600)+(substr($4,9,2)*3600)+(substr($4,11,2)*60)+(substr($4,13,2)))-((substr($6,7,2)*24*3600)+(substr($6,9,2)*3600)+(substr($6,11,2)*60)+(substr($6,13,2)))<259200)) print $9}' |sort |uniq -c >~/month/hubei_${DEALDATE_M}_mfq_unsub_count.txt 
				###丽水每月最后一天的生活播报清单.xuying@umessage.com.cn.
				  	bzcat /logs/${DEALDATE}/outputumessage_001_meiti_${DEALDATE}_snapshot.bz2 | awk -F "|" '{if($14=="SHBB"&&$8=="0571"&&$9=="578"&&$3=="06") print $1}'   >~/month/lishui_${DEALDATE}_m.txt
            bzcat /logs/${DEALDATE}/outputumessage_001_meiti_${DEALDATE}_snapshot.bz2 | awk -F '|' -v first_date=${DEALDATE_M}'01000000' -v last_date=${DEALDATE_NM}'01000000' '{ if ($8=="022" &&  $2=="22220040" &&  $3 == "06" && $5 >= first_date && $5 < last_date  ) print $8","$1","$2","$3","$5",99991230000000,xzyh" ; else if ( $8=="022" &&  $2=="22220040" && $3 == "07" &&  $5 >= first_date && $5 < last_date   ) print $8","$1","$2","$3","$5","$4",xzyh"  }' > ~/month/tianjin_TLH_xzyh.txt                
			    ####请帮忙提取安徽每个月末最后一天生活播报及专刊定制且发送正常的号码
			      bzcat /logs/${DEALDATE}/outputumessage_001_meiti_${DEALDATE}_snapshot.bz2 | awk -F "|" '{if($3=="06"&&$8=="0551"&&$7=="1") print $1}'| sort -u >~/month/anhui_${DEALDATE_M}_zcxf_user.txt
			      ###肇庆每个月有过定制关系的的生活播报（包括主刊和新刊）清单 
			      bzcat /logs/${DEALDATE}/outputumessage_001_meiti_${DEALDATE}_snapshot.bz2 | awk -F "|"  -v date=${DEALDATE_M}  '{if($8=="020"&&$9=="758"&&$3=="06") print $9,$14,$2,801174,$1,$3,$4,$4,$7 ;else if($8=="020"&&$9=="758"&&$3=="07"&&(substr($4,1,6)>=date)) print $9,$14,$2,801174,$1,$3,$6,$4,$7 }' >~/month/zhaoqing_${DEALDATE_M}.txt
			     ####陕西月底在线用户
			      bzcat /logs/${DEALDATE}/outputumessage_001_meiti_${DEALDATE}_snapshot.bz2 | awk -F "|" '{if($3=="06"&&$8=="029"&&$7=="1") print $1","$2}'|sort -u >~/month/shanxi_${DEALDATE_M}.txt
		       ###陕西CI推荐用户
			bzcat /logs/${DEALDATE}/outputumessage_001_meiti_${DEALDATE}_snapshot.bz2| awk -F'|' -v first_date=${DEALDATE_M}'01000000' -v last_date=${DEALDATE_NM}'01000000' '{if($11 == "CI" || $11 == "CITJ") print}' | awk -F'|' '{ if( $2~/^2/ && $3 == "06" && $8 == "029" && $4>=first_date )  print $1","$2","$3","$5",99991230000000,"$11","$13","$14","$7 ; else if ( $2~/^2/ && $3 == "07" && $8 == "029" && $5>=first_date) print $1","$2","$3","$5","$4","$11","$13","$14","$7 }'  > ~/month/shanxi_${DEALDATE_M}_zxtj.txt
                        ###..CI....
		        bzcat /logs/${DEALDATE}/outputumessage_001_meiti_${DEALDATE}_snapshot.bz2| awk -F'|' -v first_date=${DEALDATE_M}'01000000' -v last_date=${DEALDATE_NM}'01000000' '{if($11 == "CI" || $11 == "CITJ") print}' | awk -F'|' '{ if( $2~/^2/ && $3 == "06" && $8 == "021" && $4>=first_date )  print $1","$2","$3","$5",99991230000000,"$11","$13",1,1" ; else if ( $2~/^2/ && $3 == "07" && $8 == "021" && $5>=first_date) print $1","$2","$3","$5","$4","$11","$13",1,1" }'  > ~/month/shanghai_${DEALDATE_M}_zxtj.txt


                ####zhejaingshbb_new_cancle##

         bzcat /logs/${DEALDATE}/outputumessage_001_meiti_${DEALDATE}_snapshot.bz2 | awk -F'|'  -v first_date=${DEALDATE_M}'01000000' -v last_date=${DEALDATE_NM}'01000000'  '{if( $3=="06" && $8=="0571"  && $14=="SHBB" && $4 >=first_date && $4 <=last_date  ) print $1","$2",06,"$4",99991231000000,"$7","$11 ; else if ( $3=="07"  && $8=="0571" && $14=="SHBB" && $5 >=first_date && $5 <=last_date )  print $1","$2",07,"$5","$4","$7","$11 ;  }' |  bzip2 > zhejiang_${DEALDATE_M}_new.txt.bz2

        bzcat /logs/${DEALDATE}/outputumessage_001_meiti_${DEALDATE}_snapshot.bz2   | awk -F'|'  -v first_date=${DEALDATE_M}'01000000' -v last_date=${DEALDATE_NM}'01000000' '{if( $3=="07" && $8=="0571"  && $14=="SHBB" && $4 >=first_date && $4 <=last_date  ) print $1","$2",07,"$5","$4","$7","$11 ;  }' |  bzip2 > zhejiang_${DEALDATE_M}_cancle.txt.bz2

		
                   k=16
			while [ $k -le 31 ]
			do
			        if [ $k -lt 10 ];then
			           echo $k
			           echo /logs/${DEALDATE_M}*/outputumessage_002_meiti_${DEALDATE_M}0${k}_usa.action.log.bz2
			       bzcat /logs/${DEALDATE_M}*/outputumessage_002_meiti_${DEALDATE_M}0${k}_usa.action.log.bz2 | awk -F "|" '{if($2=="pause"&&$4=="021"&&($10=="4442"||$10=="4441")) print $3,$6}'|sort -u  >> ~/month/shanghai_16_31_${DEALDATE_M}.txt
			
			         else
			           echo $k
			        bzcat /logs/${DEALDATE_M}*/outputumessage_002_meiti_${DEALDATE_M}${k}_usa.action.log.bz2 | awk -F "|" '{if($2=="pause"&&$4=="021"&&($10=="4442"||$10=="4441")) print $3,$6}'|sort -u  >> ~/month/shanghai_16_31_${DEALDATE_M}.txt
			         fi
			       k=`expr $k + 1`
			done
fi




