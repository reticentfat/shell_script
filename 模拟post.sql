gateway@wmessage ~ $ curl -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"id":"13581960272","oprcode":"07","efftime":"19700101080000","spid":"801174","bizcode":"125820","feetype":"2","source":"R1"}' http://192.100.6.247:7004/transaction
{"oprnumb": "1258BIP2B24720180206113453307929", "result": true, "seq": "20180206113453307929"}
curl -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"id":"13581960272","oprcode":"06","efftime":"19700101080000","spid":"801174","bizcode":"125883","feetype":"2","source":"R1"}' http://192.100.6.247:7004/transaction
gateway@wmessage ~ $ curl -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"id":"13581960272","oprcode":"06","efftime":"19700101080000","spid":"801174","bizcode":"125883","feetype":"2","source":"R1"}' http://192.100.6.247:7004/transaction
{"oprnumb": "1258BIP2B24720180206113725428558", "result": true, "seq": "20180206113725428558"}
[shujuyzx@wbird2] /data/logs/bossproxy> bzcat bossproxy.log.0.bz2 | grep '13815885427'
Feb  6 10:54:04 192.100.6.31 bossproxy[1695]: BIP2B247,BOSS=>PROXY,P250T20180206105403S290037,13815885427,wuxian,901808,-UMGHSHT,07,08,20180124155429,250,0,0000,0000,0.291144132614
Feb  6 10:54:05 192.100.6.33 bossproxy[54481]: BIP2B247,BOSS=>PROXY,P250T20180206105403S290041,13815885427,wuxian,901808,-UMGHSHT,06,08,20180206105341,250,0,0000,0000,0.641473054886
[shujuyzx@wbird2] /data/logs/bossproxy> cat bossproxy.log  | grep '13581960272'
[shujuyzx@wbird2] /data/logs/bossproxy> cat appproxy.log | grep '13581960272'
Feb  6 11:25:38 192.100.6.31 appproxy[11258]: BIP2B247,APPS=>PROXY,20180206112536886745,13581960272,media,801174,125820,06,R1,19700101080000,100,0,0000,0000,2.18032503128
Feb  6 11:34:54 192.100.6.33 appproxy[54351]: BIP2B247,APPS=>PROXY,20180206113453307929,13581960272,media,801174,125820,07,R1,19700101080000,100,0,0000,0000,1.27601599693
Feb  6 11:37:26 192.100.6.33 appproxy[54351]: BIP2B247,APPS=>PROXY,20180206113725428558,13581960272,media,801174,125883,06,R1,19700101080000,100,0,0000,0000,1.77715110779
