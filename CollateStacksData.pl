#!/usr/bin/env perl
## USE: perl ./CollateStacksData.pl denovo_map.log
## RPeery 2018

use strict;
use warnings;

my $input = shift;
open FH, "<$input";
open OUT, ">$input.parameters.txt";
my $flag = 0;
while (<FH>) {
	if (/Sample\s\d+\sof\s\d+\s'\S+'|Coverage after assembling stacks|Final coverage: mean=/) {	
		print OUT; }
	}

close FH;
close OUT;
