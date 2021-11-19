# change host name
ip_list='
172.17.132.42       QXZB_GDB_sh1
172.17.132.43       QXZB_GDR_sh1
'
remote_cmd="
    ip=\`ip addr ls eth1 |awk -F'/|[ ]+' '/inet/{print \$3}'\`
    echo \"$ip_list\" |grep -w \$ip |awk '{print \$2}'
    hostname
"
log_file=log/farm_stop_`date +%Y%m%d%H%M%S`.log
