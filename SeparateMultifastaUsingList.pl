#!/usr/bin/env perl
## USE: perl ./SeparateMultifastaUsingList.pl inputlistfile fastafile

use strict;
use warnings;

my %list=();
my $count = 0;
my $inputfile = shift;

open FH, "<$inputfile";
while (<FH>) {
	if (/(^\S+)/) {
		my $ID = $1;
		$list{$ID} = 1;
		$count++;
		}
	}
print "$count\n";

my $fastafile = shift;
#my $outputfile = shift;

open FH1, "<$fastafile";
open OUT, ">$fastafile.CtgsPulled.fasta";
#open OUT1, ">$fastafile.Other.fasta";

my $flag = 0;
while (<FH1>) {
	if (/^>(\S+)/) {	
		my $ID = $1; $flag = 0;
		if (exists $list{$ID}) {
			$flag = 1; }
		}
	if ($flag == 1) {
		print OUT; }
	#else {
	#print OUT1;
	#}
}

close FH;
close FH1;
close OUT;
#close OUT1;