create tablespace tbs_tj datafile '/data/app/oracle/oradata/wreportdb/tbs_tj_dat_01.dbf' size 10240M uniform size 1280K; 



ALTER database   datafile '/data/app/oracle/oradata/wreportdb/tbs_tj_dat_06.dbf' 
autoextend on next 1280K  Maxsize  30480M; 
