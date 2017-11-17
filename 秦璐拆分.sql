cat app.txt | awk -F',' '{d="app/"substr($3,5,4)".txt";print $0>> d;}'
cat boss.txt | awk -F',' '{d="boss/"substr($2,1,6)".txt";print $0>> d;}'
