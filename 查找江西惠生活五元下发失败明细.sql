25上
进入下发当天目录
[gateway@wtraffic /data/match/mm7/20170714]$ cat outputumessage_003_wuxian_20170714_mm7.out | awk -F',' '$5=="0791"&&$15=="10511055"&&$(NF-2)!=1000&&(NF-2)!="2000"&&$(NF-2)!="4446"{print $12",HSH_05_MMS"}' | sort -u>JX_HSH5_0714_fail_final.txt
