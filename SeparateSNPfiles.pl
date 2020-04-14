## USE: SeparateSNPfiles.pl inputlistfile snpCallFile
##Written by RM Peery

#!/usr/bin/env perl ## or whatever the path to your perl env is
use strict;
use warnings;
my %list=();
my $count = 0;
my $inputlistfile = shift;
open FH, "<$inputlistfile";
while (<FH>) {
	if (/^(AX-\d+)/) {
		my $ID = $1;
		$list{$ID} = 1;
		$count++;
		}
	}
print "$count\n";
my $snpCallFile = shift;
open FH1, "<$snpCallFile";
open OUT, ">$snpCallFile.keep.txt";
open OUT1, ">$snpCallFile.toss.txt";
my $flag = 0;
while (<FH1>) {
	if (/^(AX-\d+)/) {	
		my $ID = $1; $flag = 0;
		if (exists $list{$ID}) {
			$flag = 1; }
		}
	if ($flag == 1) {
		print OUT; }
	else {
	print OUT1;
	}
}
close FH;
close FH1;
close OUT;
close OUT1;
