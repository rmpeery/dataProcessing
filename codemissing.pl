#########################################################################
#To compare a sequence (expSeq) to a reference (refSeq)
#and if expSeq has an N, compare to refSeq at that same site
#if refSeq has an N then replace N in expSeq with 0 else replace N with 1
# RPeery 2010
#USE perl ./codemissing.pl reference.fasta expSeq.fasta
#########################################################################

#!/usr/bin/env perl

use strict;
use warnings;

my $refseqfile = shift;
my $expseqfile = shift;

$expseqfile =~ s/\.fasta//g;
open OUT, ">$expseqfile.coded.fasta";

my @refseq=();
open FH, "<$refseqfile" or die "Can't open file";
while (<FH>) {
	#print;
	if (/\S+/ && ! /^>/) {
	 	my $seq=$_;
		chomp $seq;
		#print;
		@refseq = split(//, $seq);
		#print "$refseq[0]\n";
	}
}

my @expseq=();
open FH1, "<$expseqfile.fasta"  or die "Can't open file";
while (<FH1>) {
	if (/^>/) {
		print OUT;
	}
	else {
	 	my $seq=$_;
		chomp $seq;
		@expseq = split //, $seq;
		 #print "$expseq[0]\n";
		
	}
}

my $lengthref = scalar(@refseq);  #print "length ref $lengthref\n";
my $lengthexp = scalar(@expseq);  #print "length exp $lengthexp\n";

if ($lengthref != $lengthexp) { print  "Reference length does not equal the length of the experimental sequence\n"; }

print "The length of the two sequences is $lengthref\n";


#### note to self: check for capital and small N

for (0 .. ($lengthref - 1)) {
	my $pos=$_; 
	if ($expseq[$pos] eq "N") { 
		if ($refseq[$pos] eq "N") {
			print OUT "0";
		}
		else { print OUT "1"; }
	}
	else { print OUT "$expseq[$pos]"; }
}	

print OUT "\n";


