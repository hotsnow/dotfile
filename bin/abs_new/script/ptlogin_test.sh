#!/bin/bash

sub_usage() {
    echo ""
    echo "USAGE: $0 -l iplist [ -u uin ] [ -s skey ]"
    echo "    default: log_file=ptlogin_test.date.log"
    echo "    default: max_process=30"
    echo "    default: ABSBWLIMIT=1024"
    exit 1
}

# get ABS value
source /usr/local/tools/comm_lib/passwd.lib

while getopts u:s:l: arg; do
    case $arg in
        u) uin=$OPTARG ;;
        s) skey=$OPTARG ;;
        l) ip_list=$OPTARG ;;
        *) sub_usage ;;
    esac
done

[ -s "$ip_list" ] || sub_usage
# default uin and skey, skye get from firebug
[ -z "$uin" ] && uin=1403149570
[ -z "$skey" ] && skey=''

# get file list
ptlogin_file=/usr/local/tools/comm_lib/ptlogin_test

export ABSUSER=root
export ABSPASSWD=''
# use file cmd
file_md5=`md5sum $ptlogin_file |cut -d' ' -f1`
remote_ptlogin_file=${ptlogin_file##*/}   # remove file dir
remote_cmd="
    if md5sum /tmp/$remote_ptlogin_file |grep -qw $file_md5; then
        rm /tmp/$remote_ptlogin_file;
    else
        echo 'FAIL_FLAG /tmp/$remote_ptlogin_file not found or md5 not match. exit ...'
        exit 1
    fi
"
push_file_list="$ptlogin_file"

source ./multi_process
