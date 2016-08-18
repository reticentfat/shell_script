----导入jf_2
 select A.MOBILE
    from (select j.mobile
        from jf_2 j ) A
    left join bjwz b on A.MOBILE = b.mobile_sn
                       
   where b.mobile_sn is  null
