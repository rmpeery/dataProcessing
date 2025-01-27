#!/bin/bash

for f in *.bam; do
  base_name=$(basename "$f" _trim.map.bam)
  samtools flagstat -@ 16 -O tsv $f >"$base_name.flagstat.tsv"
  echo "Metrics for $base_name completed."
done

echo "Mapping metrics calculated."

outFile="flagstat_summary.txt"
# Output header to the TSV file
echo -e "totalRds\tprimary mapped\tmapped\tnPairs\tpairs mapped\tproperly paired\tsplit pairs\tsingletons" > "$outFile"

# Loop through all TSV files in the current directory
for f in *.tsv; do
    # gather values
    totalRds=$(sed -n '1p' "$f" | awk '{print $1}')
    primary_mapped=$(sed -n '2p' "$f" | awk '{print $1}')
    mapped=$(sed -n '7p' "$f" | awk '{print $1}')
    nPairs=$(sed -n '12p' "$f" | awk '{print $1}')
    pairs_mapped=$(sed -n '16p' "$f" | awk '{print $1}')
    properly_paired=$(sed -n '14p' "$f" | awk '{print $1}')
    split_pairs=$(sed -n '19p' "$f" | awk '{print $1}')
    singletons=$(sed -n '17p' "$f" | awk '{print $1}')

    # print out metrics to txt file
    echo -e "$totalRds\t$primary_mapped\t$mapped\t$nPairs\t$pairs_mapped\t$properly_paired\t$split_pairs\t$singletons" >> "$outFile"
done

echo "Metrics have been saved to $outFile."
