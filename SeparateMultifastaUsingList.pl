#!/opt/local/bin/perl
## USE: perl ./ParseMultifastaUsingList.pl inputlistfile fastafile

use strict;
use warnings;

my %list = ();
my $count = 0;
my $inputfile = shift;
my $fastafile = shift;

# Read input list file
open my $fh_input, '<', $inputfile or die "Cannot open $inputfile: $!";
while (<$fh_input>) {
    if (/(^\S+)/) {
        my $ID = $1;
        $list{$ID} = 1;
        $count++;
    }
}
close $fh_input;

# quick QC
print "$count\n";

# Read FASTA file
open my $fh_fasta, '<', $fastafile or die "Cannot open $fastafile: $!";
open my $out_subset, '>', "$inputfile.subset.fasta" or die "Cannot open output file for subset: $!";
open my $out_remainder, '>', "$inputfile.remainder.fasta" or die "Cannot open output file for remainder: $!";

my $flag = 0;
while (my $line = <$fh_fasta>) {
    if ($line =~ /^>(\S+)\.\d\s/) {
        my $ID = $1; 
        $flag = exists $list{$ID} ? 1 : 0;

        # parse multifasta into matches and non-matches
        if ($flag) {
            print $out_subset $line;  # Print the matching fasta to the subset output file
        } else {
            print $out_remainder $line;  # Print the non-matching fasta to the other output file
        }

        # print the sequence too
        while (my $seq_line = <$fh_fasta>) {
            if ($seq_line =~ /^>/) {
                seek($fh_fasta, -length($seq_line), 1);  # Move back to re-read the fasta
                last;  # Exit the sequence reading loop
            }
            if ($flag) {
                print $out_subset $seq_line;  # Print sequence lines to the subset output file
            } else {
                print $out_remainder $seq_line;  # Print sequence lines to the other output file
            }
        }
    }
}

close $fh_fasta;
close $out_subset
