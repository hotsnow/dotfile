#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

#use File::Basename;
#my ($script,$path,$suffix) = fileparse($fullname);
#chdir $path;

if (@ARGV > 0 and $ARGV[0] =~ /^(?:-h|--help)$/) {
    pod2text $0;
}

# go to script dir
my ($basic_dir) = $0 =~ m{(.+)/};
chdir $basic_dir if $basic_dir;

## log defined
#for (qw/log data/) {
#    mkdir $_ unless -d "$_";
#}
#my $log_file    = "log/$0.log";
#my $data_file   = "data/$0.data";
#$log_file   =~ s/pl.log$/.log/;
#$data_file  =~ s/pl.data$/.data/;





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

    perl(1)

