#!/bin/bash - 
#===============================================================================
#
#          FILE: n2n.sh
# 
#         USAGE: ./n2n.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 10/05/2018 10:27
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

whoami |grep -qw root || {
    echo "ERR: sudo to run this script"
    exit 1
}

if pkill -0 -x edge; then
    echo "INFO: n2n running, no need to run again"
    exit 0
else
    export N2N_KEY=xxxxxx
    sudo -E /data/app/n2n/sbin/edge -a 10.1.2.6 -c n1.community.flag -l xxx.xxx.xxx:11113 -u 4294967294 -g 4294967294
    sleep 2

    if pkill -0 -x edge; then
        echo "INFO: n2n start success"
    else
        echo "ERR: n2n start failed"
    fi
fi
