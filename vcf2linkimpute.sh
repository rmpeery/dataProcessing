#!/bin/bash

########################################################
# Objective: Convert vcf output from prior analysis to #
#         file format accepted by LinkImputeR.         #
#            written by RPeery 2024.04.08              #
########################################################
## USE: ./vcf2linkimpute.sh

echo "This pipeline works for vcf files containing the following fields in this order: GT:GL:GOF:GQ:DP:NV";
echo "There is feedback along the way to let you know the process is still working and not stuck in any loops";
echo "The pipeline will make a lot of temporary files - make sure there is 3x the HD space of the original file size."
echo "Please enter the name and path of the vcf file if it is not in the current directory:"
read userInput
# /mnt/d/EAB/PLATfltr_POSTfltr.vcf
NAME=$userInput
echo "Move vcf heading information into a temporary file - takes a while";
awk '/^#/' $NAME >header.tmp;
echo "Check that this is a reasonable size for a header - about 50 lines";
echo "lines" | wc -l header.tmp;

echo "Add the AD format line to the vcf header information";
sed -i 's/ID=GL/ID=PL/g' header.tmp;
sed -i '$i\##FORMAT=<ID=AD,Number=.,Type=Integer,Description="Allelic depths for the reference and alternate alleles in the order listed">' header.tmp;
# echo "Check over header file to make sure insert etc. went well"
# cat header.tmp;
# clear;
echo "Gather the data columns into a temporary file"
awk '!/^#/' $NAME >vcf.tmp;
# referenced: https://stackoverflow.com/questions/4956873/how-to-cut-first-n-and-last-n-columns
echo "Set asside the columns with locus information";
cut -f -9 <vcf.tmp >vcf_cols.txt;
echo "Add the AD field to the definition, reaorder the terms, and reduce the number of terms";
sed -i 's/GT:GL:GOF:GQ:DP:NV/GT:AD:DP:GQ:PL/g' vcf_cols.txt;
cut -f 10- <vcf.tmp >tmp.txt;
echo "QC the text manipulations, the size vcf_cols.txt should be much smaller than tmp.txt";
ls -lh *.txt | awk '{print $5,$9}';

echo "Parse the data to be manipulated. This takes 15-30 min for a large dataset on a standard laptop." 
# prints by row to each file so they are all populated simulatiously takes a while
awk '{
 COUNT=1
 for(i=1;i<NF;i++) { 
   if(i%1==0) {
     print $i > "sample"COUNT".temp"
     COUNT+=1
     continue 
   }
 printf "%s ",$i >"sample"COUNT".temp"
 } 
print $NF > "sample"COUNT".temp"}' <tmp.txt;
# 
# NOT faster AT. ALL
# input_file="tmp.txt" # FASTER? - modified from chatGPT's modification of my loop suggestion
# num_columns=$(head -n 1 "$input_file" | awk '{print NF}')
# for ((i=1; i<=$num_columns; i++)); do
#     cut -f "$i" "$input_file" > "column_$i.temp"
# done;

echo "This should generate one file for every sample. Check that number of files equals sample number"
ls *.temp | wc -l;
echo "Generate AD field, reduce, and rearrange step";
for i in *.temp
  do
    awk -F":" '{print $1":"$5-$6","$6":"$4":"$3":"$2}' <$i >$i.text
    rm $i
  done;

echo "This should have deleted all the .temp files and generated the same number of .text files"
ls *.text | wc -l;

echo "Merge the sample columns back together"
ls -1v *.text | paste >merge_tmp.sh; # make a list with natural sorting
sed -i 's/$/ \\/g' merge_tmp.sh; # fix the return char
sed -i '$ s/\\/ >> merge_tmp.txt/g' merge_tmp.sh; # modify the last line to close the script
sed -i '1s/^/paste \\\n/' merge_tmp.sh; # add the shebang and paste command
sed -i '1s/^/\#!\/bin\/bash \n/' merge_tmp.sh;
chmod +x merge_tmp.sh;
sh merge_tmp.sh;
rm *.text;
rm merge_tmp.sh;

echo "Reassemble modified vcf file"
echo "Check file lengths before combining. Expect mod_tmp.txt=vcf_cols.txt"
wc -l merge_tmp.txt vcf_cols.txt;
paste vcf_cols.txt merge_tmp.txt > tmp.vcf;
# rm merge_tmp.txt vcf_cols.txt;
cat header.tmp tmp.vcf > mod_tmp.vcf;
# rm tmp.vcf;
echo "The file should have one more line than the original and be nearly equal in size"
wc -l $userInput mod_tmp.vcf;
ls -lh *.vcf;
# rm *.txt *.tmp;
echo "What do you want to call the output file? No need to include .vcf"
read userInput
mv mod_tmp.vcf $userInput.vcf;
echo "File manipulation complete and ready for LinkImputeR"
