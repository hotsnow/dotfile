#!/bin/bash

export PATH=/usr/local/bin:/bin:/usr/bin:/usr/sbin:/sbin

# go to run dir
cd -P -- "$(dirname "$0")"

##########
# base function
##########
err() {
    date +"[%F %T] $@" >&2
}

sub_usage() {
    sed -rn '/^=head1 NAME/,${s/(=head1 |README_EOF)//;p}' $0
	exit 0
}

# arg check
# must more than 1 arg in case run by accident
if [[ $# -lt 1 ]]; then
    sub_usage
    exit 1

elif echo "$1" |grep -qi -- '^\(-h\|--help\)$'; then
    sub_usage
	exit 0
fi

# log defined
#for dir in log tmp data; do
#   [[ -d "$dir" ]] || mkdir $dir
#done
#log_file="log/${0%%.sh}.log"

user_name=`whoami`
win_path=/drives/c/Windows/system32
pid_file=/tmp/ssh_tunel_$user_name.pid

source admin.env

line=$1

# clean old tunel
if [[ -f $pid_file ]]; then
    ssh_pid=`cat $pid_file`
    if [[ -n $ssh_pid ]]; then
        /drives/c/Windows/system32/taskkill.exe /F /PID $ssh_pid >/dev/null 2>&1
        rm -f $pid_file

        [[ $line == clean ]] && exit 0
    fi
fi


if echo $line |grep -Ewq '^(2|3|5|6|7|8|9|44|tst)$'; then
    if [[ $line == "tst" ]]; then
        name=xxx
    else
        name=${WASHOSTS_L[$line]%% *}
    fi
    if [[ -z $name ]]; then
        echo "host of line: $line not found"
        exit 1
    fi

    old_pid_list=`$win_path/tasklist /NH |awk '/^_ssh/{m=m"|"$2} END{print m}'`

    # ssh tunnel
    ssh -f -N -L 9043:127.0.0.1:9043 ${user_name}@${name}.xxxx.net >/dev/null 2>&1
    if [[ $? == 0 ]]; then
        echo line $i: https://localhost:9043/admin
        # open the web page
        $win_path/cmd /c start "C:\Program Files (x86)\Internet Explorer\iexplore.exe" "https://localhost:9043/admin"
    else
        echo ERR: tunnel to line $i failed
    fi

    # xxx just to make grep syntax correct
    new_pid=`$win_path/tasklist /FI "ImageName eq _ssh.exe" /NH |grep -Ev "xxx$old_pid_list" |awk '{print $2}'`

    echo -n $new_pid > $pid_file
else
    echo no line: $line
    exit 1
fi



##########################
# README here
# read this document by command: perldoc this_file
##########################
: << 'README_EOF'
__END__

=head1 NAME

    tunnel.sh

=head1 SYNOPSIS

    ./tunnel.sh -h       # show these help messages
    ./tunnel.sh 2|3|5... # line number
    ./tunnel.sh clean    # clean the last tunnel

=head1 DESCRIPTION

    1. open tunel to connect to the WebSphere
    2. open the web brower of the link

=head1 EXAMPLES

    ##### EXAMPLE 1 #####
    # make a tunnel with Deployment Manager
    ./tunnel.sh 2|3|5...

    ##### EXAMPLE 2 #####
    # clean the last tunnel
    ./tunnel.sh clean

=head1 BUGS

    Unknow

=head1 AUTHOR

    Weiwei Lai   laiweiwei@gmail.com

=head1 VERSION

    Create: 2017-01-26

    Version 0.10

=head1 SEE ALSO

    bash(1)

README_EOF

