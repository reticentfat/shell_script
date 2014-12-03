#!/bin/sh
cd /cygdrive/f/qftj/
filter_filename=$1
unix2dos *.txt
files="`ls *.txt`" 
for File in $files 
do
	file_name_arr=($(echo $File | tr '.' ' ' | tr -s ' '))
	file_name=`echo ${file_name_arr[0]}`
	f=($(echo $file_name | tr '_' ' ' | tr -s ' '))
	filename=${f[0]}
	province=${f[1]}
	city=${f[2]}
	isblack=${f[3]}
	split=${f[4]}
	echo "#################"$filename","$province","$city","$isblack","$split

	file_gserr=$filename"_1_gserr.txt"
	file_gsok=$filename"_1_gsok.txt"
	file_cf=$filename"_2_cf.txt"
	file_pcf=$filename"_2_pcf.txt"
	file_gsderr=$filename"_3_gsderr.txt"
	file_gsdok=$filename"_3_gsdok.txt"
	file_black=$filename"_4_black.txt"
	file_clear=$filename"_4_clear.txt"
	file_test_num=$filename"_5_test_num.txt"
  file_last=$filename"_4_last.txt"
	echo "待过滤号码总量 : "
	cat $File | wc -l
	
	##1 电话格式过滤
	##输出非数字号码
	##cat $File | sed 's/\"//g'  | awk -F '[ :\t|,\r]' '{print substr($1,1,11) }' | awk '/[^0-9]/'  >  $file_gserr 
	##cat $File | sed 's/\"//g'  | awk -F '[ :\t|,\r]' '{print substr($1,1,11) }' | awk '{if ( length($1) != 11 ) print $1 }' >> $file_gserr 
	cat $File | sed 's/\"//g'  | awk -F '[ :\t|,\r]' '{if (!($1~/^1[0-9]+$/ && length($1)==11)) print $1 }' >  $file_gserr 
	##输出数字组合11位
	##cat $File | awk -F '[ :\t|,\r]' '{print substr($1,1,11) }' | awk '$1~/^([0-9])+$/' | awk '{if ( length($1) == 11 ) print $1 }' >  $file_gsok
	cat $File | sed 's/\"//g'  | awk -F '[ :\t|,\r]' '{if ($1~/^1[0-9]+$/ && length($1)==11) print $1 }' >  $file_gsok 

	echo "格式错误数量 : "
	cat $file_gserr | sort | uniq | wc -l
	echo "格式正确数量 : "
	cat $file_gsok | wc -l
	
	##2 排重
	cat $file_gsok  | sort | uniq -c  | awk '{if ( $1 >= 2) print $2 }' >  $file_cf
	cat $file_gsok  | sort | uniq -c  | awk '{ print $2 }' >  $file_pcf

	echo "重复数量 : "
	cat $file_cf | wc -l
	echo "排重后数量 : "
	cat $file_pcf | wc -l
	
	##3 过归属
	##awk -F',' -v yes=yes.txt -v no=no.txt '{if(FILENAME~/nodist\.txt$/)nodist[$3]=$2;else{beginno=substr($1,1,7);if(nodist[beginno]=="717")print $1>>yes;else print $1>>no;}}' nodist.txt yichang1.txt

	if [ $province == '000' ];then
	
		awk -F',' -v CODE_DIR=/cygdrive/f/qftj/dictionary/nodist.txt '{ 
		if(FILENAME == CODE_DIR)  d[substr($3,1,7)]=$1 ;
		else if ( FILENAME != CODE_DIR &&  substr($1,1,7) in d ) print  "YES,"$1 ;
		else  if ( FILENAME != CODE_DIR &&  !(substr($1,1,7) in d) ) print "NO,"$1        
		}' /cygdrive/f/qftj/dictionary/nodist.txt $file_pcf | 
		awk -F ',' -v REPORTFILE_OK=$file_gsdok  -v REPORTFILE_NO=$file_gsderr '{if ($1 == "YES" ) print $2 >> REPORTFILE_OK ; else print $2  >>  REPORTFILE_NO  }'  ;
	
	elif [ $city == '000'  ];then 

		awk -F',' -v CODE_DIR=/cygdrive/f/qftj/dictionary/nodist.txt  -v PROVINCENO=$province '{ 
		if(FILENAME == CODE_DIR && PROVINCENO == $1 )  d[substr($3,1,7)]=$1 ;
		else if ( FILENAME != CODE_DIR &&  substr($1,1,7) in d ) print  "YES,"$1 ;
		else  if ( FILENAME != CODE_DIR &&  !(substr($1,1,7) in d) ) print "NO,"$1        
		}' /cygdrive/f/qftj/dictionary/nodist.txt $file_pcf | 
		awk -F ',' -v REPORTFILE_OK=$file_gsdok  -v REPORTFILE_NO=$file_gsderr '{if ($1 == "YES" ) print $2 >> REPORTFILE_OK ; else print $2  >>  REPORTFILE_NO  }'  ;

	else

		awk -F',' -v CODE_DIR=/cygdrive/f/qftj/dictionary/nodist.txt  -v PROVINCENO=$province  -v CITYNO=$city '{ 
		if(FILENAME == CODE_DIR && PROVINCENO == $1 && CITYNO == $2 )  d[substr($3,1,7)]=$1","$2 ;
		else if ( FILENAME != CODE_DIR &&  substr($1,1,7) in d ) print  "YES,"$1 ;
		else  if ( FILENAME != CODE_DIR &&  !(substr($1,1,7) in d) ) print "NO,"$1        
		}' /cygdrive/f/qftj/dictionary/nodist.txt $file_pcf | 
		awk -F ',' -v REPORTFILE_OK=$file_gsdok  -v REPORTFILE_NO=$file_gsderr '{if ($1 == "YES" ) print $2 >> REPORTFILE_OK ; else print $2  >>  REPORTFILE_NO  }'  ;

	fi


	echo "归属地错误数量 : "
	cat $file_gsderr | wc -l
	echo "过归属后数量 : "
	cat $file_gsdok | wc -l
	
	##4 过红黑
    if [ $isblack == '1' ];then
        
		##awk  -v CODE_DIR=/cygdrive/f/qftj/dictionary/black.txt '{
        ##if( FILENAME == CODE_DIR  )  d[$1]=$1 ;
        ## else if ( FILENAME != CODE_DIR && $1 in d ) print  "YES,"$1 ;
        ## else if ( FILENAME != CODE_DIR && !($1 in d) ) print "NO,"$1;        
        ##}'  /cygdrive/f/qftj/dictionary/black.txt $file_gsdok | 
        ##awk -F ',' -v REPORTFILE_OK=$file_clear -v REPORTFILE_NO=$file_black '{if ($1 == "YES" ) print $2 >> REPORTFILE_NO   ; else print $2  >>  REPORTFILE_OK  }'  ;
    
		awk  -v CODE_DIR=/cygdrive/f/qftj/dictionary/black.txt '{
        if( FILENAME != CODE_DIR  )  d[$1]=$1 ;
         else if ( FILENAME == CODE_DIR && $1 in d ) print $1 ;      
        }'  $file_gsdok /cygdrive/f/qftj/dictionary/black.txt > $file_black
		
		awk  -v REPORTFILE_NO=$file_black '{
        if( FILENAME == REPORTFILE_NO  )  d[$1]=$1 ;
         else if ( FILENAME != REPORTFILE_NO && !( $1 in d ) ) print $1 ;      
        }'  $file_black $file_gsdok > $file_clear
	
	elif [ $isblack == '0' ];then

        cat $file_gsdok  >  $file_clear 
     
    fi

	echo "红黑数量 : "
	cat $file_black | wc -l
	echo "过红黑后数量 : "
	cat $file_clear | wc -l
	
	clear_num=`cat $file_clear | wc -l`


	
	                     
	 echo "过滤业务后数量 : "
	 
	cat $file_clear | wc -l
	
	clear_num=`cat $file_clear | wc -l`

	if [ $split -gt '0' ];then
	
		split -l $split $file_clear ${filename}_
		mv ${filename}_a[a-z] /cygdrive/f/qftj/cache/
		
		##添加群发测试号
		cd /cygdrive/f/qftj/cache/
		tfiles="`ls *_a[a-z]`" 
		for tFile in $tfiles 
		do 
			
			tf=($(echo $tFile | tr '_' ' ' | tr -s ' '))
			tfilename=${tf[0]}
			flag=${tf[1]}
			tfnum=`cat $tFile | wc -l`
			testnum=`cat /cygdrive/f/qftj/testnum/$province.txt /cygdrive/f/qftj/testnum/test_num.txt | wc -l`
			outfile=`echo ${tfilename}-${clear_num}_${flag}_${tfnum}+${testnum}.txt | sed 's/ //g'`

			cat /cygdrive/f/qftj/testnum/$province.txt /cygdrive/f/qftj/testnum/test_num.txt $tFile > /cygdrive/f/qftj/$outfile

		done
		
		rm /cygdrive/f/qftj/cache/*
		
	else

		cf=($(echo $file_clear | tr '_' ' ' | tr -s ' '))
		cfilename=${cf[0]}
		testnum=`cat /cygdrive/f/qftj/testnum/$province.txt /cygdrive/f/qftj/testnum/test_num.txt | wc -l`
		outfile=`echo $cfilename-$clear_num+$testnum.txt | sed 's/ //g'`
		
		cat /cygdrive/f/qftj/testnum/$province.txt /cygdrive/f/qftj/testnum/test_num.txt $file_clear > /cygdrive/f/qftj/$outfile
		
	fi
	
	cd /cygdrive/f/qftj/

done

unix2dos /cygdrive/f/qftj/*.txt
##unix2dos /cygdrive/f/qftj/*_1_gserr.txt
##unix2dos /cygdrive/f/qftj/*_2_cf.txt
##unix2dos /cygdrive/f/qftj/*_3_gsderr.txt

