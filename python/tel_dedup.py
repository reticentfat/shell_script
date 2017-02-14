#-*- coding: utf-8 -*-
"""
normalize webdata and give an id for it.
@modify by zhanglin
 date:2010-09-06
"""
from  umg.ne.tel_parser import TelParser

def tel_statistic_by_id():
    '''
    '''
    output_file  = file('/home/data/tel_statistic.csv', 'w')
    data_file = file('/home/data/tel_process/all_telnos.csv')
    tel_dict = {}
    for line in data_file:
        line = line.strip()
        field_list = line.split(',')
        tel = field_list[1]
        id  = field_list[0]
        if tel not in tel_dict:
            tel_dict[tel] =  set()
            tel_dict[tel].add(id)
        else:
            tel_dict[tel].add(id)
    
    for key in tel_dict:
        output_file.write(key + "," + ' '.join(list(tel_dict[key])) + "\n")
    output_file.close()
    data_file.close()

def tel_statistic_num():
    '''
    '''
    output_file  = file('/home/data/tel_statistic.csv', 'w')
    data_file = file('/home/data/tel_process/all_telnos.csv')
    tel_dict = {}
    for line in data_file:
        line = line.strip()
        field_list = line.split(',')
        tel = field_list[1]
        id  = field_list[0]
        if tel not in tel_dict:
            tel_dict[tel] =  set()
            tel_dict[tel].add(id)
        else:
            tel_dict[tel].add(id)
    
    for key in tel_dict:
        output_file.write(key + "," + ' '.join(list(tel_dict[key])) + "\n")
    output_file.close()
    data_file.close()

def tel_statistic_id_num():
    '''
    '''
    output_file  = file('/home/data/tel_statistic_num.csv', 'w')
    data_file = file('/home/data/tel_statistic.csv')
    tel_list = [] 
    #data_file = file('/home/data/tel_process/test')
    for line in data_file:
        line = line.strip()
        field_list = line.split(',')
        tel = field_list[0]
        ids  = field_list[1]
        tel_list.append([tel,len(ids.split())])
    tel_list.sort(key=lambda x:x[1], reverse=True) 
    for tel in tel_list:
        output_file.write(tel[0] +"," + str(tel[1]) + "\n")
    output_file.close()
    data_file.close()

def tel_dedup():
    '''
    '''
    tp = TelParser()
    output_file  = file('/home/data/tel_process/all_telno_dedup.csv', 'w')
    data_file = file('/home/data/tel_process/all_telnos.csv')
    tel_dict = set()
    for line in data_file:
        line = line.strip()
        field_list = line.split(',')
        tel = field_list[1]
        if tel not in tel_dict:
            tel_dict.add(tel)
            output_file.write(line + "\n")
    
    output_file.close()
    data_file.close()

def filter_telno():
    '''
    '''
    tp = TelParser()
    input_file = file("/home/data/tel_process/telno.csv")
    for line in input_file:
        line = line.strip()
        field_list = line.split(',')
        id = field_list[0]
        telno = field_list[1]
        province = field_list[2]
        city = field_list[3]
        tmp_tel = telno.replace('*', "-")
        tel_dict , ret = tp.parse(tmp_tel)
        code1 = tp.get_code_by_city(city)
        t_str = ""
        if not ret:
            telno_list = telno.split('-')
            numlist = []
            if len(telno_list) > 1:
                numlist = telno_list[1].split()
            else:
                numlist = telno_list[0].split()
            if _is_free_telno(numlist):
                t_str = 'freetel:' + id + "," + telno
            else:
                t_str = "parser error: " + id + "," + telno
                print id
            continue
        else:
            code2 = tel_dict['citycode']
            if len(code2)>0 and code1!=None and code1 !=code2:
                t_str = "conflict:" + id + "," + telno
                #print t_str
                print id
                continue

    input_file.close()

def _is_free_telno(telno_list):
    '''
    check is free telno
    '''
    ret = False
    length = len(telno_list)
    if length < 1:
        return ret
    free_length = 0
    for telno in telno_list:
        if len(telno) == 10 and (telno.startswith('400') or telno.startswith('800')):
            free_length += 1

    if free_length >0:
        ret = True
    return ret

def telno_filter():
    '''
    '''
    tp = TelParser()
    input_file = file("/home/data/tel_process/telno.csv")
    file_dict = {}
    for line in input_file:
        line = line.strip()
        field_list = line.split(',')
        id = field_list[0]
        telno = field_list[1]
        province = field_list[2]
        city = field_list[3]
        tmp_tel = telno.replace('*', "-")
        tel_dict , ret = tp.parse(tmp_tel)
        code1 = tp.get_code_by_city(city)
        if not ret:
            print "parser: ", field_list[0] + " " + telno
            continue
        else:
            code2 = tel_dict['citycode']
            if len(code2)>0 and code1!=None and code1 !=code2:
                print "conflict",field_list[0]
                continue

        if province not in file_dict:
            tmp_file = "/home/data/tel_process/province/" + province + '.csv'
            pro_f = file(tmp_file, 'w')
            file_dict[province] = pro_f
            file_dict[province].write('telno'+ '\n')
            file_dict[province].write(telno + '\n')
        else:
            file_dict[province].write(telno + '\n')
    for key in file_dict:
        file_dict[key].close()

if __name__ == '__main__':
    #tel_dedup()
    filter_telno()
    #split_by_province()
    #tel_statistic_id_num()
    #tel_statistic_by_id()
