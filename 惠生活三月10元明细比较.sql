--用邮件里两个文件分别比出平台比boss多与boss比平台多的
------------先找出惠生活10元三月领券明细
SELECT
	 DISTINCT u.mobile
FROM
	flbk_hsh_order f ,flbk_hsh_user u  
WHERE
	 u.id = f.userid
and   f.right= 10
and f.month=201803
------------先找出惠生活10元四月领券明细
SELECT
	 DISTINCT u.mobile
FROM
	flbk_hsh_order f ,flbk_hsh_user u  
WHERE
	 u.id = f.userid
and   f.right= 10
and f.month=201804
------------------然后25上找下发条数
 /data/chenyj/HSH10_SUCCESS/20180331]$ cat hsh10_success_number.txt | head
 15152525691|7
18251308334|4
13914176436|6
18795956450|10
----然后找出月底的留存hsh10用户
---27上
--3月底
bzcat /data/match/orig/20180329/snapshot.txt.bz2 | awk -F'|' '$2=="10120013"&&$3=="06"{print $1}' | sort -u >hsh10_0331_online.txt  
--4月底
bzcat /data/match/orig/20180428/snapshot.txt.bz2 | awk -F'|' '$2=="10120013"&&$3=="06"{print $1}' | sort -u >hsh10_0430_online.txt 
--5月底
bzcat /data/match/orig/20180506/snapshot.txt.bz2 | awk -F'|' '$2=="10120013"&&$3=="06"{print $1}' | sort -u >hsh10_0508_online.txt
----------留存新增用如下脚本
oracle@wreport:/home/oracle$ sh /home/oracle/etl/bin/hsh10_lcxz.sh 20180329  20180301000000 20180401000000
oracle@wreport:/home/oracle$ sh /home/oracle/etl/bin/hsh10_lcxz.sh 20180428  20180401000000 20180501000000
oracle@wreport:/home/oracle$ sh /home/oracle/etl/bin/hsh10_lcxz.sh 20180506  20180501000000 20180601000000

----hsh10_lcxz.sh----
usage () {
    echo "usage: $0 REPORT_DIR " 1>&2
    exit 2
}

if [ $# -lt 3 ] ; then
    usage
fi


###20101130
DATE_LAST=$1
###20101101000000
DATE_START=$2 
###20101201000000
DATE_END=$3
 
##创建目录
cd /data/match/hsh10_xzlc/
if [ ! -d "$DATE_LAST" ]; then
   mkdir $DATE_LAST   
fi    
cd $DATE_LAST 
###留存用户
bzcat /data/match/orig/${DATE_LAST}/snapshot.txt.bz2 | awk -F '|' -v start_date=${DATE_START} '{ if(  $3 == "06" && $5 < start_date && $2 == "10120013" )  print $1","$2","$3","$5",99991230000000,lcyh,"$7","$11 ; else if (  $3 == "07" &&  $4 >=start_date && $5 < start_date && $2 == "10120013" ) print $1","$2","$3","$5","$4",lcyh,"$7","$11 }'  > hsh10_${DATE_LAST}_lcxz.txt
###新增用户
bzcat /data/match/orig/${DATE_LAST}/snapshot.txt.bz2 | awk -F '|' -v start_date=${DATE_START} -v end_date=${DATE_END} '{ if (  $3 == "06" && $5 >= start_date && $5 < end_date && $2 == "10120013") print $1","$2","$3","$5",99991230000000,xzyh,"$7","$11 ; else if ( $3 == "07" &&  $5 >= start_date && $5 < end_date && $2 == "10120013" ) print $1","$2","$3","$5","$4",xzyh,"$7","$11 }'  >> hsh10_${DATE_LAST}_lcxz.txt
 
-------------------------------
[shujuyzx@wbird2] /logs/monster> bzcat /logs/archives/monster/201803{19,20,21}/monster-cmppmt.log.201803*.bz2 | grep 13401245264
Mar 19 19:55:43 192.100.6.7 Monster-CMPP20MT[30860]: 20180319195542SMS2101010005310ec7947bddd73e6,0,1,000,0531,25483,N,wuxian_qianxiang,,10658880,03,13401245264,1,13401245264,10101000,1,,,UMGYWCXX,01,0,0,0,0,0,8,031992c7eb8431f57706ac4fc8a5bcf9d312,0,5,0,901808,03191955390101064700,0,144,12580惠生活动态密码为：266262，10分钟内有效。请尽快登录，切勿泄露或转发他人。【中国移动　12580惠生活】
Mar 19 19:56:13 192.100.6.7 Monster-CMPP20MT[30858]: 20180319195613SMS2101010002501955148860567bb,0,1,000,025,23385,I,wuxian_qianxiang,0,1065888080,03,13401245264,1,13401245264,10101000,1,,,UMGYWCXX,01,0,0,0,0,0,8,0319ce8f53edb2dfd9c33d00021d0894fb7e,0,5,0,901808,03191956090101054485,0,129,您已经开通了惠生活10元短信包月业务，请勿重复订购，详询12580，本条免费。【中国移动　12580】
Mar 19 19:56:13 192.100.6.9 Monster-CMPP20MT[60822]: 20180319195613SMS2101200132501ab474fbda88d82,0,1,000,025,26911,I,wuxian_qianxiang,0,1065888080,03,13401245264,1,13401245264,10120013,1,,,-UMGHSHT,03,1000,0,0,1,2,8,031917f1f9ab1fcd7ca06bfd83e4ace80650,0,5,0,901808,03191956070101002924,0,103,券方式稍后短信通知，请注意查收！详询10086【中国移动  12580惠生活】 (130:2/2)
Mar 19 19:56:13 192.100.6.9 Monster-CMPP20MT[60822]: 20180319195613SMS2101200132501ab474fbda88d82,0,1,000,025,151086,I,wuxian_qianxiang,0,1065888080,03,13401245264,1,13401245264,10120013,1,,,-UMGHSHT,03,1000,0,0,1,2,8,0319888b7fb83dc59f0fe38ed1fc1f67d58e,0,5,0,901808,03191956040101016196,0,204,尊敬的客户，您好！您已订购惠生活超级会员（10元/月），惠员权益劲爽升级，精品优惠超值聚享，大牌代金券月月领、随心兑！会员资格生效及领(130:1/2)
Mar 19 19:56:18 192.100.6.7 Monster-CMPP20MT[30858]: 20180319195618SMS210101000250179ba4691e76c58,0,1,000,025,23309,I,wuxian_qianxiang,0,1065888080,03,13401245264,1,13401245264,10101000,1,,,UMGYWCXX,01,0,0,0,0,0,8,031972c76e6a1482657f4ae790f393ced3f2,0,5,0,901808,03191956140101035911,0,144,您已成功开通惠生活彩信包月业务，信息费5元/月。欢迎您的使用，详询12580，本条免费。【中国移动　12580】
Mar 19 21:00:04 192.100.6.7 Monster-CMPP20MT[30858]: 20180319210003SMS2101200132501e41c43ab7a10e6,0,1,000,025,24950,I,wuxian_qianxiang,0,1065888080,03,13401245264,1,13401245264,10120013,1,,,-UMGHSHT,03,1000,0,0,1,2,8,03195a18d2a65f631ba6ebac705344bd219b,0,5,0,901808,03192059560101017196,0,210,【生活小贴士】阳春三月是万物始生的季节，要做到心胸开阔，豁达乐观；身体要放松，要舒坦自然，充满生机。饮食上应多吃一些味甘性平且富含蛋白(230:1/2)
Mar 19 21:00:04 192.100.6.11 Monster-CMPP20MT[80222]: 20180319210003SMS21012001325015555449b3ca1fc,0,1,000,025,29675,I,wuxian_qianxiang,0,1065888080,03,13401245264,1,13401245264,10120013,1,,,-UMGHSHT,03,1000,0,0,0,0,8,0319b76f048bb70b27b2aa3371b7eb16cc3f,0,5,0,901808,03192100020101044945,0,170,美好生活，源自朋友的交谈/父母的嘱咐/孩子的欢笑！惠生活，感恩有您陪伴，2018为用心生活的你点赞！【中国移动12580惠生活】
Mar 19 21:00:04 192.100.6.7 Monster-CMPP20MT[30858]: 20180319210003SMS2101200132501e41c43ab7a10e6,0,1,000,025,145586,I,wuxian_qianxiang,0,1065888080,03,13401245264,1,13401245264,10120013,1,,,-UMGHSHT,03,1000,0,0,1,2,8,03194573353ac5bc37b71a2edff40dd58db3,0,5,0,901808,03192059560101017197,0,167,质、糖类、维生素和矿物质的食物，如瘦肉、禽蛋、牛奶、蜂蜜、豆制品、新鲜蔬菜、水果等。【中国移动12580惠生活】(230:2/2)
Mar 19 22:00:02 192.100.6.7 Monster-CMPP20MT[30858]: 20180319220001SMS2101200132501e7df449af08546,0,1,000,025,145919,I,wuxian_qianxiang,0,1065888080,03,13401245264,1,13401245264,10120013,1,,,-UMGHSHT,03,1000,0,0,0,0,8,031956052ade18f64ecea84d880f223a33c9,0,5,0,901808,03192159540101053699,0,174,尊敬的客户，您好！您的惠生活超级会员资格已生效，超级会员每月可免费领取大牌代金券一张，详询10086【中国移动  12580惠生活】
Mar 19 22:00:02 192.100.6.9 Monster-CMPP20MT[60822]: 20180319220002SMS210120013250135a04387f3ce43,0,1,000,025,28403,I,wuxian_qianxiang,0,1065888080,03,13401245264,1,13401245264,10120013,1,,,-UMGHSHT,03,1000,0,0,1,2,8,031914a9177bd3464ff230d79a175d6f9a0c,0,5,0,901808,03192159570101028580,0,143,尊敬的惠生活超级会员，您的专属权益已送达，快戳 http://hsh.12580.com 领券，详询10086 【中国移动12580惠(67:1/2)
Mar 19 22:00:03 192.100.6.9 Monster-CMPP20MT[60822]: 20180319220002SMS210120013250135a04387f3ce43,0,1,000,025,151901,I,wuxian_qianxiang,0,1065888080,03,13401245264,1,13401245264,10120013,1,,,-UMGHSHT,03,1000,0,0,1,2,8,0319da11c8de55a0d77d6703da2ae44ab523,0,5,0,901808,03192159540101028261,0,17,生活】(67:2/2)
Mar 21 14:07:04 192.100.6.9 Monster-CMPP20MT[60824]: 20180321140703SMS2101200135310d96d40be7bfa7e,0,1,000,0531,30673,N,wuxian_qianxiang,,10658880,03,13401245264,1,13401245264,10120013,1,,,-UMGHSHT,03,1000,0,0,0,0,8,0321d07459529689d097e5f343e40fa7e8eb,0,5,0,901808,03211406560101038214,0,144,12580惠生活动态密码为：930197，10分钟内有效。请尽快登录，切勿泄露或转发他人。【中国移动　12580惠生活】
Mar 21 14:08:06 192.100.6.11 Monster-CMPP20MT[80224]: 20180321140805SMS2101200135310a3b84a9e3c9d92,0,1,000,0531,28003,N,wuxian_qianxiang,,10658880,03,13401245264,1,13401245264,10120013,1,,,-UMGHSHT,03,1000,0,0,0,0,8,032105ba628ebafa2d38affaadd0793283f7,0,5,0,901808,03211408040101059254,0,144,12580惠生活动态密码为：152988，10分钟内有效。请尽快登录，切勿泄露或转发他人。【中国移动　12580惠生活】
Mar 21 14:09:09 192.100.6.7 Monster-CMPP20MT[30860]: 20180321140907SMS21012001353106e22489489bf69,0,1,000,0531,32472,N,wuxian_qianxiang,,10658880,03,13401245264,1,13401245264,10120013,1,,,-UMGHSHT,03,1000,0,0,1,2,8,0321dcf390164aad5f3a5751a3762ce1cd53,0,5,0,901808,03211409010101018405,0,158,尊敬的客户，您好！您已成功抽取一张来伊份代金券20元VIP尊享券，具体使用规则及有效期请点击 http://hsh.12580.com(105:1/2)
Mar 21 14:09:09 192.100.6.7 Monster-CMPP20MT[30860]: 20180321140907SMS21012001353106e22489489bf69,0,1,000,0531,159718,N,wuxian_qianxiang,,10658880,03,13401245264,1,13401245264,10120013,1,,,-UMGHSHT,03,1000,0,0,1,2,8,0321633a521046c83e5dea4fb2a3edd50fe8,0,5,0,901808,03211409060101005281,0,51, 查询【中国移动　12580惠生活】(105:2/2)
------------
[shujuyzx@wbird2] /logs/archives/monster/20180319> bzcat monster-cmpp-report.log.20180319*.bz2 | grep 13401245264
Mar 19 19:55:49 192.100.6.3 Monster-CMPP20REPORT[37518]: 000000,03191955390101064700,0,0,13401245264,201803191955,201803191955
Mar 19 19:56:24 192.100.6.1 Monster-CMPP20REPORT[49351]: 000000,03191956140101035911,0,0,13401245264,201803191956,201803191956
Mar 19 19:56:27 192.100.6.3 Monster-CMPP20REPORT[37518]: 000000,03191956090101054485,0,0,13401245264,201803191956,201803191956
Mar 19 19:56:30 192.100.6.13 Monster-CMPP20REPORT[31384]: 000000,03191956040101016196,0,0,13401245264,201803191956,201803191956
Mar 19 19:56:32 192.100.6.1 Monster-CMPP20REPORT[49351]: 000000,03191956070101002924,0,0,13401245264,201803191956,201803191956
-----
再核查.0文件
cat /data/match/orig/mm7/20180331/stats_month.wuxian_qianxiang.0 | grep 13401245264
--25上
/data/match/cmpp/20180319下的outputumessage_005_wuxian_20180319_cmpp.out
