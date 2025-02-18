# initial base script written by Akriti Bhattarai #
# akriti.bhattarai[at]uconn[dot]edu #
# 16 May 2022 #
# modified by #
# RMPeery to generate subclusters #
# 20 Sept 2024 #

library(dplyr)
library(tidyr)

# Set the working directory
setwd("/home/usr/data/example")

# Read in the gmap output
bed_file <- read.delim("example.bed", header = FALSE, sep = "\t", stringsAsFactors = FALSE)

# add column names
colnames(bed_file) <- c("refCtg", "matchstart", "matchend", "asblyCtg", "score", "strand")

# check file
head(bed_file)

# find the singletons and overlaps
mkgrps <- bed_file %>%
  group_by(refCtg) %>%
  arrange(refCtg,matchstart) %>%
  mutate(index= c(0, cumsum(as.numeric(lead(matchstart)) >
                              cummax(as.numeric(matchend)))[-n()])) %>% #For each ref ctg, identify the overlapping hits based on start/stop coord. and assign an index
  group_by(refCtg, index) %>% #Group by ref ctg followed by index, which creates one group for each unique hit or set of overlapping hits
  mutate(group_size = n(), #get the size of each group
         group_id = cur_group_id()) #create a unique ID for each unique hit and set of overlapping hits

# flag to track changes in the loop
changes_occurred <- TRUE

# loop through groups until no new groups are made
while (changes_occurred) {
  mkNewgrps <- mkgrps %>%
    group_by(group_id) %>%
    arrange(refCtg, matchstart) %>%
    mutate(new_group_split = ifelse(matchstart >= first(matchstart) & matchstart <= first(matchend),
                                    group_id,
                                    group_id + 0.00001)) # Adjust if not within the first occurrence

  # Check for changes by comparing the new group_split with the old one
  changes_occurred <- any(mkNewgrps$new_group_split != mkgrps$group_id)

  # Update mkgrps with the new groups if changes occurred
  if (changes_occurred) {
    mkgrps <- mkNewgrps %>%
      mutate(group_id = new_group_split) # Keep the updated group_split for the next iteration
  }
}

# clean up
mkNewgrps <- mkNewgrps %>%
  #select(-new_group_split) %>%
  group_by(new_group_split) %>% # Group by the new group split
  mutate(new_group_size = n()) %>% # Count the number of occurrences in each group
  ungroup() # Ungroup if you want to work with the entire dataframe again

#create output directory
dir.create("clusteringFromBedOutputs")
setwd("clusteringFromBedOutputs")

#filter out all unique hits (group_size == 1)
singletons <- mkNewgrps %>%
  filter(new_group_size == 1) %>%
  ungroup() %>%
  select(-c(index, group_size, group_id, new_group_size, new_group_split)) # cleaning up dataframe
#write to file
write.table(singletons, sep="\t", "alignments_not_overlapping.tsv", quote = FALSE, row.names = FALSE, col.names = TRUE)
#filter out all overlapping hits (group_size > 1)
overlapping <- mkNewgrps %>%
  filter(new_group_size > 1) %>%
  unite("con_group_id", refCtg, new_group_split, sep= "-", remove=FALSE) %>%  #create a new column with an ID that combines the ref contig with the group ID
  ungroup() %>%
  select(-c(index,group_size,group_id,new_group_size, new_group_split)) # cleaning up dataframe
#write to a separate file for each set of overlapping hits
overlapping %>%
  group_by(con_group_id) %>%
  group_walk(~ write.table(.x, sep="\t", quote = FALSE, row.names = FALSE, col.names = TRUE, file = paste0(.y$con_group_id, ".tsv")))
q()
