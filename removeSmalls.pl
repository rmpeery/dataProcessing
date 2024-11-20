## RMPeery                                          ##
## Counts length of fasta sequence in a multi-fasta ##
## file and removes those under a provided value    ##
## References: https://www.biostars.org/p/79202/    ##
## https://www.biostars.org/u/3728/                 ##

## USE: perl removeSmalls.pl 200 input.fasta > output.fasta

#!/usr/bin/perl
use strict;
use warnings;

my $minlen = shift or die "Error: `minlen` parameter not provided\n";
{
    local $/=">";
    while(<>) {
        chomp;
        next unless /\w/;
        s/>$//gs;
        my @chunk = split /\n/;
        my $header = shift @chunk;
        my $seqlen = length join "", @chunk;
        print ">$_" if($seqlen >= $minlen);
    }
    local $/="\n";
}
