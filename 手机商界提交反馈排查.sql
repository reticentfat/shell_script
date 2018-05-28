7.25上
[gateway@wtraffic /data/sjsj_return_submit_analysis]$ bzcat /data/monster/20171206/monster_shangjie_20171206{08,09,11,10,12}00_cmpp_ok.txt.bz2 /data/sjsj_return_submit_analysis/75/sjsj_sjyl_hsh_submit_collect_2017120610.txt.bz2 | awk -F','     '{if(NF==6&&($2=="10201072"||$2=="10201073"||$2=="10101062")) aa[$5$2$1]=$0 ; else if !($1$2$3  in aa)  print   $0 ;   }' >~/sjsj_120610.txt
    3717
[gateway@wtraffic /data/sjsj_return_submit_analysis]$ bzcat /data/monster/20171206/monster_shangjie_201712061000_cmpp_ok.txt.bz2 /data/sjsj_return_submit_analysis/75/sjsj_sjyl_hsh_submit_collect_2017120610.txt.bz2 | awk -F','     '{if(NF==6&&($2=="10201072"||$2=="10201073"||$2=="10101062")) aa[$5$2$1]=$0 ; else if ($1$2$3  in aa)  print   $0 ;   }' | wc -l 
    3696
[gateway@wtraffic /data/sjsj_return_submit_analysis]$  bzcat /data/sjsj_return_submit_analysis/75/sjsj_sjyl_hsh_submit_collect_2017120610.txt.bz2 | awk -F',' '$2=="10201072"||$2=="10201073"||$2=="10101062"{print $0}' | wc -l
    6074
    --7.5上查看提交日志--------------------
    [gateway@wtraffic /data/sjsj_return_submit_analysis]$ bzcat /data/sjsj_return_submit_analysis/75/sjsj_sjyl_hsh_submit_collect_2017120610.txt.bz2 | head -5
15144487556,10201071,20171206100014SMS01020107110012aad468c2ecf56
15803513058,10201071,<!DOCTYPE
15834030039,10201070,20171206100029SMS0102010701001432a4b99031e50
15266477119,10201070,<!DOCTYPE
18235552709,10201071,<!DOCTYPE
[gateway@wtraffic /data/sjsj_return_submit_analysis]$ bzcat /data/sjsj_return_submit_analysis/75/sjsj_sjyl_hsh_submit_collect_2017062406.txt.bz2 | head -10
15070182307,10101063,20170624060135SMS2101010631001d5fc4fb4f4fce9
13458175652,10101063,20170624065410SMS21010106310019b2e4b8dea5688
13897150534,10201070,20170624065624SMS0102010701001107444bd8fabd2
13897150534,10201070,20170624065656SMS010201070100199c24d84ffe339
13897150534,10201070,20170624065749SMS0102010701001a8b949af04ebba
13897150534,10201070,20170624065754SMS0102010701001602b42847b0c42
13897150534,10201070,20170624065857SMS0102010701001a80b458d3cf1da
15949948502,10201070,20170624065924SMS0102010701001a9e544ae06c290
13897150534,10201070,20170624070019SMS010201070100188b34fb1f07d0f
18709148812,10201071,20170624070054SMS010201071100120e248843fc3b1
You have new mail in /var/mail/gateway
[gateway@wtraffic /data/sjsj_return_submit_analysis]$ bzcat /data/sjsj_return_submit_analysis/75/sjsj_sjyl_hsh_submit_collect_2017120611.txt.bz2 | head -5
13522044338,10611016,20171206110901MMS210611016100129684fb14bfdf5
15054983501,10201070,20171206110003SMS0102010701001cb7f45958c3679
18334751814,10201070,<!DOCTYPE
15964328179,10201070,<!DOCTYPE
-------------------
