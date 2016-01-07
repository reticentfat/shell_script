---27上
cat sxtj.txt  | sort |uniq -c | sort -rn | awk -F',''{print $2","$3","$1}'>sxtj_result.txt
cat sxtj.txt  | sort | uniq -c | sort -rn | awk -F',' '{print $2","$3","$1}'>sxtj_result.txt
cat sxtj_result.txt | sed -n '99,110p'
