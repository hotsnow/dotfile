#!/bin/bash

#export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin/:/sbin

if echo "$1" |grep -qi '^\(-h\|--help\)$'; then
    sed -rn '/^=head1 NAME/,${s/(=head1 |README_EOF)//;p}' $0
    exit 0
fi

# go to run dir
cd `dirname $0`

# log defined
#for dir in log tmp data; do
#   [[ -d "$dir" ]] || mkdir $dir
#done
log_file="log/${0%%.sh}.log"






##########################
# README here
# read this document by command: perldoc this_file
##########################
: << 'README_EOF'
__END__

=head1 NAME

    script

=head1 SYNOPSIS

    use 


=head1 DESCRIPTION

    desc

=head1 EXAMPLES

    ##### EXAMPLE 1 #####


    ##### EXAMPLE 2 #####


=head1 BUGS

    Unknow

=head1 AUTHOR

    laiweiwei   laiweiwei@gmail.com

=head1 VERSION

    Version 0.10  (2013-01-10)

=head1 SEE ALSO

    bash(1)

README_EOF
