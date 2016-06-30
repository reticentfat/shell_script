rename() {
        for fname in FLAT_*; do
                n=$(wc -l $fname|awk '{print $1}')
                newname=$fname.$(printf "%010d" $n)
                echo $newname
                mv $fname $newname
                gzip $newname
        done
}
-------------------------------------------
import sys
import os
import nds


day = sys.argv[1]
hour= sys.argv[2]
max_day = "%s%s0000" %(day,hour)
name = "FLAT_%s_0042%%s" % max_day
unknown = '000'

fps = {}

for line in sys.stdin:
  phone, type, starttime, _, _, code, _ = line.strip().split('|', 6)

  if starttime > max_day:
    continue

  if type not in ("00","01"):
    continue

  result = nds.get(phone)  
  prov = unknown
  if result is not None:
    prov = result['provid']
  
  if prov not in fps:
    fps[prov] = open(name%prov, "w")

  fps[prov].write(line)


for fp in fps.values():
  fp.close()
  --------------------------------------------
  #!/usr/bin/python
#!/bin/bash

day=$1
hour=$2
cwd=/logs/shujuyzx/consist/$day
py=/usr/local/cutter/current/cutter/full_scale
cd $cwd


split() {
        bzcat $day'_all_orderusers.txt.bz2' | python $py/split_provnew.py $day $hour
}


rename() {
        for fname in FLAT_*; do
                n=$(wc -l $fname|awk '{print $1}')
                newname=$fname.$(printf "%010d" $n)
                echo $newname
                mv $fname $newname
                gzip $newname
        done
}

split
rename
