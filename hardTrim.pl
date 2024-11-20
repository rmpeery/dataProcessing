#!/usr/bin/perl
# An adaptation of an earlier read-trimming script presumably from the
# Mockler lab at Oregon State University. Modified by Tim chumley to
# operate on a specific file rather than a folder of files, and to 
# specify one or up to four custom trim lengths.

# define command line arguments

( $file, $lgth, $lgth0, $lgth1, $lgth2 ) = @ARGV;

if (!defined($file)) {
	print "usage: trim.pl <file> <trim_length> <optional_trim_length> <optional_trim_length> <optional_trim_length>\n";
	exit;
}

my $id;
my $seq = '-1';

	# Open file
	open(DAT, "$file") or die("Error opening $file - $!");
	open(SEQX, ">$file.$lgth.fas") or die("Error opening $file - $!");
	if ($lgth0 ne '') {
		open(SEQ0, ">$file.$lgth0.fas") or die("Error opening $file - $!");
	}
	if ($lgth1 ne '') {
		open(SEQ1, ">$file.$lgth1.fas") or die("Error opening $file - $!");
	}
		if ($lgth2 ne '') {
		open(SEQ2, ">$file.$lgth2.fas") or die("Error opening $file - $!");
	}


	# Read main sequence file, and write out the trimmed versions...
	while (my $line = <DAT>) {
		chomp $line;

		# Skip empty lines
		next if $line =~ m/^\s*$/;

		if ($line =~ m/^>(.+)$/) {
			if ($seq ne '-1' && $seq ne '') {
				my ($seq_X) = $seq =~ m/^(.{$lgth})/;
				if ($lgth0 ne ''){
					my ($seq_0) = $seq =~ m/^(.{$lgth0})/;
						if ($seq_0 =~ m/^[ACGT]+/i) {
							print SEQ0 ">$id\n$seq_0\n";
						}
				}
				if ($lgth1 ne ''){
					my ($seq_1) = $seq =~ m/^(.{$lgth1})/;
						if ($seq_1 =~ m/^[ACGT]+/i) {
							print SEQ1 ">$id\n$seq_1\n";
						}
				}
				if ($lgth2 ne ''){
					my ($seq_2) = $seq =~ m/^(.{$lgth2})/;
						if ($seq_2 =~ m/^[ACGT]+/i) {
							print SEQ2 ">$id\n$seq_2\n";
						}
				}
				if ($seq_X =~ m/^[ACGT]+/i) {
					print SEQX ">$id\n$seq_X\n";
				}
			}
			$id = $1;
			$seq = '';
		} else {
			$seq .= $line;
		}
	}

	# Catch Last sequence and put into trimmed versions of files...
	if ($seq ne '-1' && $seq ne '') {
		my $seq_X = $seq =~ m/^(.{$lgth})/;
		if ($lgth0 ne ''){
			my $seq_0 = $seq =~ m/^(.{$lgth0})/;
			if ($seq_0 =~ m/^[ACGT]+/i) {
				print SEQ0 ">$id\n$seq_0\n";
			}
		}
		if ($lgth1 ne ''){
			my $seq_1 = $seq =~ m/^(.{$lgth1})/;
			if ($seq_1 =~ m/^[ACGT]+/i) {
				print SEQ0 ">$id\n$seq_1\n";
			}
		}
		if ($lgth2 ne ''){
			my $seq_2 = $seq =~ m/^(.{$lgth2})/;
			if ($seq_2 =~ m/^[ACGT]+/i) {
				print SEQ2 ">$id\n$seq_2\n";
			}
		}
		if ($seq_X =~ m/^[ACGT]+/i) {
			print SEQX ">$id\n$seq_X\n";
		}
	}

	close(SEQX);
	if ($lgth0 ne '') {
		close(SEQ0)
	}
	if ($lgth1 ne '') {
		close(SEQ1)
	}
	if ($lgth2 ne '') {
		close(SEQ2)
	}
	close(DAT);
#The end
