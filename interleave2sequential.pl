#!/usr/bin/env perl

## USE: perl interleave2sequential.pl fastafile ###
## written by R Peery July 2019

use strict;
use warnings;
my $fastafile = shift;

open FH1, "<$fastafile";
$fastafile =~ s/.fasta//g;
open NEW, ">$fastafile.sequential.fasta";
while (<FH1>) {
	if (/^>/) { 
		my $line=$_;
		print NEW "\n$line"; 
	}
	else { 
		my $seq=$_;
		chomp $seq;
		print NEW "$seq";
	}
}
