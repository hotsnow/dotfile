if [[ $0 == $BASH_SOURCE ]]; then
    echo "You should source this script but not run "
    exit 1
fi

#############
# variable
#############
work_dir=$(dirname $BASH_SOURCE)
log_file=$work_dir/log/${0##*/}_${USER}_$(date "+%F")_$$.log
ip_list=$work_dir/log/${0##*/}_${USER}_$(date "+%F")_$$.iplist

#pull_local_dir="/tmp"
#push_remote_dir="/tmp"
abs_dir=$work_dir/abs_new
source_ip_list=$work_dir/module.list

#export ABSBWLIMIT=20480
#export ABSSCPTIMEOUT=1800

#############
# get ip from set and module
#############
sub_get_ip() {
    local set_name=$1
    local module_name=$2

    if [[ $module_name != "all" ]]; then
        # 20101201 add support for multi ip at one module
        local match_line=`grep -i "$set_name.*$module_name" $source_ip_list`

        if [[ $(basename $0) == to && $(echo "$match_line" |wc -l) -gt 1 ]]; then
            #echo -e "$match_line" |cat -n 1>&2
            echo -e "$match_line" |awk '{printf "%03d %s\n", NR, $0}' 1>&2
            read -p "input number [all|id|id,id...]: " answer
            if [[ $answer == all ]]; then
                echo -e "$match_line"
            else
                answer=`echo -e "$answer" |sed 's/,/p\;/g;s/$/p/'`
                echo -e "$match_line" |sed -n "${answer}"
            fi
        else
            echo -e "$match_line"
        fi
    else
        grep -i "$set_name" $source_ip_list
    fi
}

# clean log
sub_clean() {
    rm -f $ip_list
    find $work_dir/log -name ${log_file%.*}* -mtime +1 -exec rm {} \; 2>/dev/null
}

#############
# specific user
#############
if [[ "$1" == 'Administrator' || "$1" == "admin" ]]; then
    export ABSPASSWD=$ROOT_PASSWD
    export ABSUSER=Administrator
    shift
elif [[ "$1" =~ root|fbadmin ]]; then
    sudo_user=$1
    shift
fi


#############
# get ip list
#############
if [[ $1 =~ ([0-9]{1,3}\.){3}[0-9]{1,3} ]]; then
    echo "$1" > $ip_list
    shift
elif [[ -f "$1" ]]; then
    cat $1 |sort -k2,2 > $ip_list
    shift
else
    sub_get_ip $1 $2 | sort -k2,2 > $ip_list
    #shift 2

    if [[ -s $ip_list ]]; then
        shift 2
    else
        host $1 |awk '/has address/{print $NF, $1}' > $ip_list
        shift 1
    fi
fi

# just list the host
if [[ $1 == list ]]; then
    #cat -n $ip_list
    awk '{printf "%03d %s\n", NR, $0}' $ip_list
    sub_clean
    exit 0
fi


#############
# get file list for rput and rget
#############
if echo "$0" |grep -wq 'rput' || [[ -n $push_file_list ]]; then
    dir_now=`pwd`

    push_file_list_tmp=${push_file_list:-$@}
    unset push_file_list

    for file in $push_file_list_tmp; do
        if [[ -f "$file" || -d "$file" ]]; then
            if [[ $file =~ ^/ ]]; then
                push_file_list="$push_file_list $file"
            else
                push_file_list="$push_file_list $dir_now/$file"
            fi
        else
            echo "ERR: file $file not found"
            exit 1
        fi
    done
fi

