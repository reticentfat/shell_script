find ./ -type f -name "*.php" -exec grep "172.16.89.252:8866" '{}' \; -exec sed -i.bak 's/172.16.89.252:8866/192.100.7.250:8866/g' {} \;
