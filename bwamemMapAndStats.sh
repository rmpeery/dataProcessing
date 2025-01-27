#!/bin/bash

  # Define reference genome and directory containing FASTQ files
  reference="<file>"
  directory="<dir>"

  set -e

  # gather fwd file name
  for forward_file in "$directory"/*_1P.fastq.gz; do
      # grab the reverse file (replace _1P with _2P)
      reverse_file="${forward_file/_1P/_2P}"

      # base name for the output file
      base_name=$(basename "$forward_file" _1P.fastq.gz)

      # map -> bam
      echo "Mapping $base_name..."
      bwa-mem2 mem -M -t 16 "$reference" "$forward_file" "$reverse_file" | samtools view -@ 16 -bS - > "$base_name.map.bam" # NO underscores for file extension

      # calculate metrics
      echo "Calculating mapping metrics for $base_name...beep beep boop"
      echo "Creating coverage file: $base_name.twistcds.geneCoverage.txt"
      bedtools coverage -a Dfir_twistTargets.bed -b "$base_name.twistcds.map.bam" > "$base_name.twistcds.geneCoverage.txt"
      echo "Creating flagstat file: $base_name.twistcds.flagstat.tsv"
      samtools flagstat -@ 16 -O tsv "$base_name.twistcds.map.bam" >"$base_name.twistcds.flagstat.tsv"
      # check loop
     echo "Tada! Mapping & metrics for $base_name completed."
  done

  echo "Mapping and metrics calculated for all files."
  
