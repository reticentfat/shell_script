#coding:utf-8
import MySQLdb
'''
tel_type:0: 未识别 1: 座机 2. 手机 3. 400/800电话 4.5位或者3位全国性质电话 9. 不能识别电话
全国400/800 '99000000','99990000'
'''
class PhoneArea():
    ph = ''
    pid = 0
    cid = 0
    tel_type = 9
    dc = {}
    dd = {}
    pid_allCountry = 99000000
    cid_allCountry = 99990000

    def __init__(self, phone,dict_cell, dict_desk):
        self.phone = phone
        self.dc = dict_cell
        self.dd = dict_desk
        self.getArea()

    def getArea(self):
        self.get_tel_type()
        self.pid,self.cid = self.get_city()

    def get_is_cell(self):
        if self.phone.startswith('1'):
            return True
        else:
            return False

    def get_tel_type(self):
        if not self.phone:
            self.tel_type = 9
        elif len(self.phone) == 5 or len(self.phone) == 3:
            self.tel_type = 4
        elif len(self.phone) < 10:
            self.tel_type = 9
        elif self.phone.startswith('1'):
            self.tel_type = 2
        elif self.phone.startswith('400') or self.phone.startswith('800'):
            self.tel_type = 3
        else:
            self.tel_type = 1

    def get_city(self):
        pid,cid = 0,0
        if len(self.phone) == 5 or len(self.phone) == 3:
            pid  = self.pid_allCountry
            cid = self.cid_allCountry
        elif len(self.phone) >= 10:
            if self.get_is_cell():
                phone_head = self.phone[0:7] 
                cid_s = self.dd.get(phone_head, '0')
                if cid_s != '0':
                    cid = int(cid_s)
                    pid = int(cid[0:2] + '000000')
            else:
                phone_head = self.phone[0:4] 
                if phone_head.startswith('0'):
                    phone_head = phone_head[1:4]
                cid_str= self.dc.get(phone_head,'0')
                if cid_str == '0':
                    phone_head = phone_head[0:2]+'0' 
                    cid_str = self.dd.get(phone_head,'0')
                if cid_str != '0':
                    cid = int(cid_str)
                    pid = int(cid_str[0:2] + '000000')
        return pid,cid

class AreaCalc():
    host = '172.16.18.203'
    usr = 'data'
    pwd = 'opensesame'
    table = 'telno_normal'
    db = 'telno'
    mycs = 'utf8'
    unhandlecsv = 'telno_normal.csv'
    phonePath = 'phone_number.csv'
    sqlcon = MySQLdb.connect(host=host, user=usr, passwd=pwd, db=db,port=3306,charset=mycs)
    cur = sqlcon.cursor()

    dict_phone = {}
    dict_cell = {}
    nFetchRow = 10000

    def __init__(self):
        self.get_phonedict()

    def get_phonedict(self):
        cellp_dict = {}
        deskp_dict = {}
        src = open(self.phonePath, 'r')
        head = src.readline()
        while 1:
            lines = src.readlines(self.nFetchRow)
            if not lines:
                break
            for line in lines:
                tmp = line.split(',')
                areaID = tmp[2]
                phone = tmp[3]
                areacode = tmp[4]
                code  = tmp[5]
                if phone:
                    self.dict_cell[phone] = code
                if areaID:
                    self.dict_phone[areaID] = code
        src.close()    
    
    def handleOneData(self,line):
        data = line.strip('\n').split(',')
        pa = PhoneArea(data[0], self.dict_cell, self.dict_phone)
        pid = int(data[1])
        cid = int(data[2])
        if data[2] == '0':
            pid = pa.pid
            cid = pa.cid
        tel_type = pa.tel_type
        self.set_area(data[0],pid,cid,tel_type)
        
    def set_area(self, tel, pid,cid,tel_type):
        try:
            updatesql = "update %s set province_id=%d,city_id=%d,tel_type=%d where tel='%s'"  % (self.table, pid, cid, tel_type, tel)
            self.cur.execute(updatesql)
            self.sqlcon.commit()
        except Exception, e:
            print e

    def update(self):
        with open(self.unhandlecsv, 'r') as rf:
            head = rf.readline()
            while 1:
                rows = rf.readlines(self.nFetchRow)
                if not rows:
                    break
                for line in rows:
                    self.handleOneData(line)
        

if __name__ == "__main__":
#    import pdb
#    pdb.set_trace()
    area = AreaCalc()
    area.update()

