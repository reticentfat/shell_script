import MySQLdb
import time
print "hello"
host='192.#.45'
user='w_#_db'
passwd='i#c'
db='w#b'
port = 3#6
conn = MySQLdb.connect(host, user, passwd, db, port)
cur = conn.cursor()
local_time=time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
print local_time
#sql = "update wzcx_sub w set MOBILE_MODIFY_STATE=0 , w.MOBILE_MODIFY_TIME='' where w.OPT_ADDR='NEIMENGGU' and w.MOBILE_MODIFY_STATE=3" 
#cur.execute(sql)
cur.execute("""
   update wzcx_sub
   SET MOBILE_MODIFY_STATE=0, MOBILE_MODIFY_TIME=%s
   WHERE MOBILE_MODIFY_STATE=3 and OPT_ADDR='NEIMENGGU'
""", (local_time))


#print "Del Over"
conn.commit()

cur.close()
conn.close()
