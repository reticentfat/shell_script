                           
LOAD DATA  INFILE 'F:\work\jilin_shbb_ci_dttime.txt' 
BADFILE 'F:\work\dingzhi.txt.bad'
truncate INTO TABLE  jf_1
FIELDS TERMINATED BY '	' OPTIONALLY ENCLOSED BY '"' 
 TRAILING NULLCOLS
(opt_code,mobile,cartype,subtime,opttime,serial,job_num,biz_code
 )

  　
2016-4-6	13403732821	当月生效	新乡
select A.opt_code,
       A.mobile,
       A.cartype,
       A.subtime
    from (select j.subtime, j.mobile, j.opt_code, j.cartype
        from jf_1 j
       ) A
    left join (select t.mobile_sn, t.prior_time, o.opt_cost
           from new_wireless_subscription t, opt_code o
          where t.appcode = o.appcode
          and t.appcode in
            ('10511050')) B on B.mobile_sn =
                                   A.mobile
  where B.mobile_sn is null
