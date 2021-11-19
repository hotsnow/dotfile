push_file_list="/usr/local/monitor/swap_mon"
push_remote_dir="/usr/local/monitor"
remote_cmd="
    cd /usr/local/monitor/swap_mon; ./swap_mon.pl reload >>log/swap_mon.log 2>&1 &
    sleep 1
    ps -ef |grep 'swap_mo[n]'
"
log_file=log/swap_mon_`date +%Y%m%d%H%M%S`.log
