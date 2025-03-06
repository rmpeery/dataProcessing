#!/usr/bin/perl

## usage: perl gclustOut2summary.pl
## file names are hard coded - update at some point to use shift

use strict;
use warnings;

my $input_file = "transcriptomes_gclust98.out.txt";
my $output_file = "transcriptomes_gclust98_summary.tsv";

open my $in_fh, '<', $input_file or die "Cannot open $input_file: $!";
open my $out_fh, '>', $output_file or die "Cannot open $output_file: $!";

print $out_fh "Cluster\tRep.Seq\tLength\tClusterMembers\n";

# Variables for parsing clusters
my $cluster_number = "";
my $rep_seq = "";
my $length = "";
my $cluster_members = "";

# Read through the input file line by line
while (my $line = <$in_fh>) {
    chomp $line;

    # If line starts with '>Cluster', it's a new cluster
    if ($line =~ /^>Cluster (\d+)/) {
        # If we have an existing representative sequence, print the previous cluster
        if ($rep_seq ne "") {
            print $out_fh "Cluster$cluster_number\t$rep_seq\t$length\t$cluster_members\n";
        }

        # Start a new cluster
        $cluster_number = $1;
        $rep_seq = "";
        $length = "";
        $cluster_members = "";
    }
    # If line starts with a '0', capture the Rep.Seq
    elsif ($line =~ /^0\s+(\d+nt),\s+>(\S+)\.\.\.\s+\*/) {
        $length = $1;  # Correctly assign length
        $rep_seq = $2; # Capture the sequence ID
    }
    # If line starts with any other number, collect cluster members
    elsif ($line =~ /^[1-9]+\s+\d+nt, >(\S+)\.\.\.\s+at\s+\S+/) {
        my $seq_id = $1;

        # Add sequence to the list of cluster members
        $cluster_members = ($cluster_members eq "") ? $seq_id : "$cluster_members,$seq_id";
    }
}

# Print the last cluster
if ($rep_seq ne "") {
    print $out_fh "Cluster$cluster_number\t$rep_seq\t$length\t$cluster_members\n";
}

# Close filehandles
close $in_fh;
close $out_fh;

print "Output written to $output_file\n";
