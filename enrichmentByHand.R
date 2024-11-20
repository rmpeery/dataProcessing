# R code from Colleen Fortier - modified from excel code by L. Mahn and L. Normington
# further modified by RPeery to make correct overlap comparisons
# followed logic from this example:
# https://seqqc.wordpress.com/2019/07/25/how-to-use-phyper-in-r/
library(dplyr)

testCtgs <- read.delim("testCtgs.results.filtered.Rfmt.txt")
bgrndCtgs <- read.delim("backgroundCtgs.results.filtered.Rfmt.txt")

testCtgs_Mercv4_bin_count <- testCtgs %>%
  count(Primary_BINCODE) %>% 
  rename(testCtgs_bin_count = n) 

bgrndCtgs_Mercv4_bin_count <- bgrndCtgs %>% 
  count(Primary_BINCODE) %>%
  rename(bgrnd_bin_count = n) 

count_total = sum(testCtgs_Mercv4_bin_count$testCtgs_bin_count) + sum(bgrndCtgs_Mercv4_bin_count$bgrnd_bin_count) #10671

# underrepresentation:
# phyper(Overlap, group2, Total-group2, group1, lower.tail= TRUE)

## overlap would be zero vs 2 in common vs 122 for bin 1

underRepBins <- left_join(testCtgs_Mercv4_bin_count, bgrndCtgs_Mercv4_bin_count, by=c("Primary_BINCODE")) %>%
  rename(mapman_bin = Primary_BINCODE) %>%
  mutate(phyper_value = phyper((testCtgs_bin_count), (bgrnd_bin_count-testCtgs_bin_count),
                               (count_total-(bgrnd_bin_count-testCtgs_bin_count)), 0, lower.tail=T, log.p=F)) %>%
  mutate(adj_pvalue = p.adjust(phyper_value, method="fdr")) %>% 
  mutate(significant = ifelse(adj_pvalue < 0.05, "TRUE", "FALSE")) %>% 
  dplyr::filter(significant == "TRUE")
underRepBins # none

# overrepesentation (enriched):
# phyper(Overlap-1, group2, Total-group2, group1,lower.tail= FALSE)

overRepBins <- left_join(testCtgs_Mercv4_bin_count, bgrndCtgs_Mercv4_bin_count, by=c("Primary_BINCODE")) %>%
  rename(mapman_bin = Primary_BINCODE) %>%
  mutate(phyper_value = phyper((testCtgs_bin_count-1), (bgrnd_bin_count-testCtgs_bin_count),
                               (count_total-(bgrnd_bin_count-testCtgs_bin_count)), 0, lower.tail=T, log.p=F)) %>%
  mutate(adj_pvalue = p.adjust(phyper_value, method="fdr")) %>% 
  mutate(significant = ifelse(adj_pvalue < 0.05, "TRUE", "FALSE"))%>% 
  dplyr::filter(significant == "TRUE")
overRepBins # none

