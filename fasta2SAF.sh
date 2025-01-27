#########################
# From TRINITY assembly #
#########################

!#/usr/bin/bash

###
# make SAF formatted file from fasta for featureCounts
# uses a trinity assembly that has gone through gclust
###

bioawk -c fastx '{ print $name, length($seq) }' <infile.fasta >temp.SAF
awk '{print $1}' temp.SAF >chr.txt
sed -i 's/=\[/=/g' chr.txt
sed -i 's/\]//g' chr.txt
sed -i 's/_TRINITY//g' chr.txt
sed -ie 's/_len=305_path=\[0\:0-304\]//g' chr.txt # sed will not find replace this string
sed -i -E 's/_len=305_path=\[[0-9]:[0-9]-[0-9]+\]//g' chr.txt
sed -iE 's/_len=[0-9]+_path=\[[0-9+]\:[0-9]+]-[0-9]+\]//g' chr.txt
awk -F'_' '{print $1"_"$2"_"$3"_"$4"_"$5}' chr.txt | head
awk -F'_' '{print $1"_"$2"_"$3"_"$4"_"$5}' chr.txt >tmp && mv tmp chr.txt
paste chr.txt temp.SAF >tmp && mv tmp temp.SAF
awk '{print $1,$2,"1-"$3,"+"}' <temp.SAF >tmp && mv tmp temp.SAF
echo "GeneID  Chr Start End Strand" >head.txt
cat head.txt temp.SAF >outfile.SAF
#check file
head outfile.SAF
rm head.txt temp.SAF chr.txt

##############################
# From gtf for gene features #
##############################
# this example uses the gtf avail. from Psme.1_0 on the TreeGenesDB

!#/usr/bin/bash

bioawk -c fastx '{ print $name, length($seq) }' <Psme.1_0.cds.fa >temp.SAF; # could use faidx from samtools as alt. if bioawk is not avail.
grep gene Psme.1_0.gtf >Psme.1_0.CDS.gtf;
paste temp.SAF Psme.1_0.CDS.gtf >tmp.SAF;
rm temp.SAF Psme.1_0.CDS.gtf;
awk '{print $1, $1, "1", $2, "+"}' tmp.SAF >tmp && mv tmp tmp.SAF;
echo "GeneID Chr Start End Strand" >head.txt;
cat head.txt tmp.SAF >Psme.1_0.CDS.SAF;
# check file
head Psme.1_0.CDS.SAF;
rm tmp.SAF head.txt;
sed -i 's/ /\t/g' Psme.1_0.CDS.SAF;
