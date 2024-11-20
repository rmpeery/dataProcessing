#!/usr/bin/bash

# Written by RPeery 2024
# Creates a dada2 formatted database from a UNITE database
# USE: ./UNITE2dada2.sh


# make a copy jic
cp first10.fasta toy.fasta
# put everything on one line
awk '{printf "%s%s", $0, (NR%2 ? "\t" : "\n")}' toy.fasta > tmp && mv tmp toy.fasta
echo "progress check"
head toy.fasta
# separate on the ";" to create a tab delited file
sed -i s'/;/\t/g' toy.fasta
# sep k_fungi from the rest of the genbank info
sed -i s'/|k__/\tk__/g' toy.fasta
# get rid of the first column
awk '{$1=""; print substr($0, 2)}' <toy.fasta >tmp && mv tmp toy.fasta
# add the > back in
sed -i 's/^/>/g' toy.fasta
# get the fasta format back
awk 'BEGIN{OFS="\t"} {for (i=1; i<NF; i++) printf "%s%s", $i, (i<NF-1 ? OFS : ""); print ""; print $NF}' toy.fasta >tmp && mv tmp toy.fasta
# get rid of extra info interatively so it is easier to understand :)
sed -i 's/k__//g' toy.fasta
sed -i 's/p__//g' toy.fasta
sed -i 's/c__//g' toy.fasta
sed -i 's/o__//g' toy.fasta
sed -i 's/f__//g' toy.fasta
sed -i 's/g__//g' toy.fasta
sed -i 's/s__//g' toy.fasta
# put in ";"
sed -i 's/\t/;/g' toy.fasta
echo "check file"
head(toy.fasta)
mv toy.fast first10_dada2fmt.fasta
