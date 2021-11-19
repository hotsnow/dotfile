remote_cmd="
    # get cpu info
    echo -ne 'cpu core num:\t'; grep -c 'model name' /proc/cpuinfo

    # get meminfo
    grep MemTotal /proc/meminfo

    # get network info
    echo -ne 'eth0:\t'; ethtool eth0 | grep Speed
    echo -ne 'eth1:\t'; ethtool eth1 | grep Speed

    # uptime
    echo -ne 'uptime:\t'; uptime |cut -c 2-22

    # os type
    echo -ne 'os type:\t'; uname -pi

    # crontab
    echo -ne 'cron num 17:\t'; crontab -l |egrep -v '^#|^$' |wc -l

    # disk
    df -h |grep data
"
log_file=log/check_init.log
