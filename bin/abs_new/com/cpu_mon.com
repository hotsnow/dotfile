push_file_list="/usr/local/monitor/cpu_mon"
push_remote_dir="/usr/local/monitor/"
remote_cmd="
    pkill cpu_mon
    cd /usr/local/monitor/cpu_mon; ./cpu_mon.pl reload >>log/cpu_mon.log 2>&1 &
    sleep 1
    ps -ef |grep 'cpu_mo[n]'
"
log_file=log/cpu_mon_`date +%Y%m%d%H%M%S`.log
