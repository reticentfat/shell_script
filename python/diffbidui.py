#/usr/local/bin/python
#coding=utf-8
import os, sys
from datetime import datetime, timedelta

yesterday = datetime.today() + timedelta(-1)
yesterday = yesterday.strftime('%Y%m%d')

#snapshot="/data/match/mm7/"+yesterday+"/outputumessage_001_wuxian_"+yesterday+"_snapshot.bz2 /data/match/mm7/"+yesterday+"/outputumessage_001_meiti_"+yesterday+"_snapshot.bz2"
snapshot="/data/chenyj/snapshot.txt.bz2"
inputfile=sys.argv[1]

phonenums={}
nophonenums=[]
for line in open(inputfile, 'r'):
    #print line.strip()
    items=line.strip().split('|')
#    for appcode in ('10511051', '10301079'):
    key=str(items[0])+"|"+str(items[8])
    phonenums[key]={}
    phonenums[key]['value']=0
    phonenums[key]['detail1']=line.strip()

#pipeline =  "bzcat "+ snapshot + "|awk -F '|' '{if($3==\"07\" || $3==\"06\")print $1\"|\"$2\"|\"$5}'"
pipeline =  "bzcat "+ snapshot + "|awk -F '|' '{if($3==\"06\")print $1\"|\"$2\"|\"$5\"|\"$14\"|\"$15\"|\"$18}'"
for line in os.popen(pipeline):
    items=line.strip().split('|')
    key = str(items[0])+"|"+str(items[1])
    if key in phonenums:
        if int(items[2]) <= 20180415010000:
            if phonenums[key]['value'] == 0:
                phonenums[key]['value'] = 1
                phonenums[key]['detail2']= line.strip()

output_online='/data/chenyj/datas/output_zhengxiang_online.txt'
output_unline='/data/chenyj/datas/output_zhengxiang_unline.txt'

f1 = open(output_online, 'w')
f2 = open(output_unline, 'w')
for key in phonenums:
    if phonenums[key]['value'] == 1:
        print >> f1, phonenums[key]['detail1']+"|"+phonenums[key]['detail2']
    else:
        print >> f2, key 
