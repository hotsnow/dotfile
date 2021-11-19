#!/bin/bash

# take a local at /usr/local/tools/comm_lib/README !!!!
# add password here

# may be you want to select root passwd and ip check
#source $abs_dir/addme.inc

# push file here
#push_file_list="ip.list"
#push_remote_dir="/data/tmp"

# pull file here
#pull_file_list="/data/tmp/php.ini"
#pull_local_dir="/data/tmp"

ip_list=ip.list

ABSUSER=Administrator
abs_dir=./

# remote cmd here
remote_cmd="
    uptime
"
source $abs_dir/multi_process
