# get establish ip more than 100
remote_cmd="
    netstat -nat |awk -F':|[ ]+' '{print \$6}' |sort -n |uniq -c |sort -rn |awk '{if (\$1 > 100) print \$0 }'
"
log_file=log/ip_link_`date +%Y%m%d%H%M%S`.log
