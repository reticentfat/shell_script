25上
1.	改名                                                                                                
格式如下niemengnrz_mm7_10611000_1065888090_20140724.txt                                                 
只改第一个字段和最后一个时间（时间是群发日期即SQL导出当天）                                             
每个文件末尾添加^                                                                                       
用UE列模式从第一行最后拉到最后行添加                                                                    
                                                                                                        
2.	打开211，25服务器                                                                                   
上传文件到/data/wuying/qftj                                                                             
注意选择auto select模式                                                                                 
运行bash addsend.sh                                                                                     
3在/data/wuying/qftj/result下载类似文件                                                                 
niemengcfj_mm7_10611000_1065888090_20140715_qf.txt                                                      
4把类似niemengcfj_mm7_10611000_1065888090_20140715_qf.txt的文件改名为servercode的文件类似于（DCNEW.txt）
5进入Cygwin进入F:\work\neimenggu执行file.sh
----             13400001637,10611000,12580002,4705,DCNEW                                                
--http://192.100.6.247:8888/activate?id=13400625826&servcode=CFZZ 
然后生成激活串
       cat all_ok.txt | awk -F',' '$4=="1000"||$4=="2000"||$4=="4446" {print "http://192.100.6.247:8888/activate?id="$1"&servcode="$5; }' >
       拆分
       传到25上  /data/www/sjyl_sjsj_url/url
       







