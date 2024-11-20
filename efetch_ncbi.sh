#!/usr/bin bash

# https://www.biostars.org/p/3297/
# User: cmdcolin
# https://github.com/cmdcolin

cat UniProt_embryophyta_accessionList.txt | while read p; do echo $p; efetch -db protein -id $p -format fasta >> UniProt_embryophyta_accession.fasta; done;
