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


for script in $@; do
    if [[ ! -f $script ]]; then
        echo "ERR: script:$script not found"
        exit 1
    fi
done

vars=`grep -P -o '(?<={{)[^}]+(?=}})' $@ |tr -d ' \t' |sort -u |tr '\n' ' '`
facter_vars=`facter --json $vars`

for var in $vars; do
    val=`echo "$facter_vars" |grep -wq "\"$var\":"`
    val=`echo ${val#*:} |sed 's/^\("\| \)//g;s/\( \|,\|"\)$//g'`
    sed 's/{{ *'"$var"' *}}/'"$val"'/g' $@
done



##########################
# README here
# read this document by command: perldoc this_file
##########################
: << 'README_EOF'
__END__

=head1 NAME

    facter4abs.sh

=head1 SYNOPSIS

    ./facter4abs.sh -h

=head1 DESCRIPTION

    desc

=head1 EXAMPLES

    ##### EXAMPLE 1 #####


    ##### EXAMPLE 2 #####


=head1 BUGS

    Unknow

=head1 AUTHOR

    Weiwei Lai   laiweiwei@gmail.com

=head1 VERSION

    Create: 2016-11-23

    Version 0.10

=head1 SEE ALSO

    bash(1)

README_EOF

