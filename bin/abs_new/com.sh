#!/bin/bash

sub_usage() {
    echo ""
    echo "USAGE: $0 iplist|ip remote_cmd.file"
    echo "    default: ABSBWLIMIT=1024"
    exit 1
}

source ~/lib/${USER}_passwd.lib

# root passwd and ip check
source $abs_dir/addme.inc

# get remote_cmd and iplist
config_file=$2

if [[ "$script_file" =~ ".com$" ]]; then
    [[ -f "$config_file" ]] || sub_usage
    source $script_file
elif [[ "$script_file" =~ ".sh$" ]]; then
    [[ -f "$config_file" ]] || sub_usage
    push_file_list="$script_file"
    push_remote_dir="/data/tmp"
    remote_cmd="
        chmod 750 /data/tmp/$script_file
        cd /data/tmp/ && ./$script_file
        cd /data/tmp/ && rm -rf $script_file
    "
else
    # $script_file only a command, not a file
    remote_cmd="$script_file"
fi

# do my com
source $abs_dir/multi_process
