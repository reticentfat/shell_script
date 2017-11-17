
 select b.mobile_sn, o.jfcode
   from (select *
           from (select t.*,
                        row_number() over(partition by t.appcode order by t.mobile_sn desc) RN
                   from new_wireless_subscription t 
                   where 
                    t.mobile_sub_time< to_date('2017-07-01', 'yyyy-mm-dd'))
          where RN <= 5) b,
        opt_code o
  where b.appcode = o.appcode
  and o.jfcode in ('-UMGYYBK',
'-UMGYYZL',
'-UMGJKSX',
'-UMGFLZS',
'-UMGQNZL',
'-UMGCSSQ',
'-UMGFCSD',
'-UMGCQLC',
'-UMGCDLT',
'-UMGPLSW',
'-UMGCQXC',
'-UMGGXTA',
'-UMGDYJL',
'-UMGSQHYBY',
'-UMGSWJXBY',
'125812',
'1258146',
'1258147',
'125813',
'125811',
'125847',
'125838',
'125837',
'125823',
'125824',
'125846',
'1258150',
'1258182')

 
  

  
   
