#!/bin/bash

# add by your to your multiprocess script
# by weiweilai 20101217

cd `dirname $0`
[[ `whoami` == 'root' ]] && { echo 'root not permit to run this script'; exit 1; }

for dir in tmp log; do
    [[ -d "$dir" ]] || mkdir $dir
done

# get iplist
if [[ -s "$1" ]]; then
    ip_list=$1
elif [[ $1 =~ "([0-9]\.){1,3}" ]]; then
    ip_list="tmp/${USER}_ip_tmp_$$.iplist"
    echo "$1" > $ip_list
else
    sub_usage 2>/dev/null || echo "ERR: get ip failed. exit ..."
    exit 1
fi

