!#/usr/bin/bash

###
# make SAF formatted file from fasta for featureCounts
# uses a trinity assembly that has gone through gclust
###

bioawk -c fastx '{ print $name, length($seq) }' <DfirPanTome.fasta >temp.SAF
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
cat head.txt temp.SAF >DfirPanTome.SAF
#check file
head DfirPanTome.SAF
rm head.txt temp.SAF chr.txt
