# raid buttery
remote_cmd="
   #/usr/local/ieod-public/raid_monitor/bin/MegaCli32 adpallinfo -a0 | grep -i bbu
   #rm /usr/local/tools/monitor/farm_mon/bin/m_free.sh 
    uname -a
"
log_file=log/raid_buttery_check_`date +%Y%m%d%H%M%S`.log
