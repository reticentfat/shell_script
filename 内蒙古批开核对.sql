 select  j.mobile ,job_num, TO_CHAR(6,'09')
 from jf_1 j , bjwz n,opt_code o
where  j.mobile = n.mobile_sn
 and o.opt_type=n.opt_type
 and j.job_num=o.jfcode
 and n.mobile_sub_state='3'
 and n.cp_id='NEIMENGGU'
 ----------------
     select * from bjwz b where b.mobile_sn in 

('13904772720','13947943194','13948443473')
---------------
select  j.mobile ,job_num, TO_CHAR(6,'09')
 from jf_1 j , new_wireless_subscription_shbb n
where  j.mobile = n.mobile_sn
 and j.opt_code=n.appcode
 and n.mobile_sub_state='3'
----------------------------------------
select  j.mobile ,job_num, TO_CHAR(6,'09')
 from jf_1 j , new_wireless_subscription n
where  j.mobile = n.mobile_sn
 and j.opt_code=n.appcode
 and n.mobile_sub_state='3'
