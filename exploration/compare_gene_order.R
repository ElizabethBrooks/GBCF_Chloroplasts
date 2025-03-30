#!/usr/bin/env Rscript

# script to compare gene order across chloroplasts

# load libraries
library(tidyverse)

# retrieve list of gff files
#file_list <- read.delim("/Users/bamflappy/Repos/GBCF_Chloroplasts/inputs/samples_files_blastx_hits.txt", header = FALSE)
file_list <- read.delim("/Users/bamflappy/Repos/GBCF_Chloroplasts/inputs/samples_files_blastx_hits_re_oriented.txt", header = FALSE)

# retrieve list of gene names
#gene_list <- read.delim("/Users/bamflappy/Repos/GBCF_Chloroplasts/inputs/sample_genes_unique.txt", header = FALSE)
gene_list <- read.delim("/Users/bamflappy/Repos/GBCF_Chloroplasts/inputs/sample_genes_unique_re_oriented.txt", header = FALSE)

# remove gene number tags
#gene_list <- str_split_i(gene_list$V1, pattern = "_", i = 1)

# create gene name data frame
gene_names <- data.frame(
  gene = gene_list[,1]
)

# initialize results data frame
samples_merged <- data.frame(
  gene = gene_list[,1]
)

# loop over each sequence
for (file_num in 1:nrow(file_list)) {
  # read in gene order data
  sample_data <- read.delim(file=file_list[file_num,2], header = FALSE)
  
  # add header
  colnames(sample_data) <- c("gene", "start", "end")

  # sort by gene start positions
  sample_data_cleaned <- sample_data %>% arrange(sample_data$start)

  # record the gene order
  sample_data_cleaned$order <- seq(from = 1, to = nrow(sample_data_cleaned), by = 1)

  # clean gene names
  sample_data_cleaned$gene <- paste(str_split_i(sample_data_cleaned$gene, pattern = "_", i = 1), str_split_i(sample_data_cleaned$gene, pattern = "_", i = 2), sep = "_")
 
  # setup order tag
  order_tag <- paste("order", file_list[file_num,1], sep="_")
  
  # add header
  colnames(sample_data_cleaned) <- c("gene", "start", "end", order_tag)
  
  # retrieve genes and order
  sample_data_subset <- sample_data_cleaned[,c(1,4)]

  # merge data sets by gene name
  sample_data_merged <- merge(gene_names, sample_data_subset, by="gene", all = TRUE)
  
  # setup previous header
  prev_header <- colnames(samples_merged)
  
  # add the data from the current sample to the outputs
  samples_merged <- cbind(samples_merged, sample_data_merged[,2])
  
  # update column header
  colnames(samples_merged) <- c(prev_header, order_tag)
}

# re order colimns based on row with ndhF gene orders
samples_merged_sorted <- samples_merged[,order(unlist(samples_merged[20,]))]

# output table of gene orders
#write.csv(samples_merged_sorted, file = "/Users/bamflappy/Repos/GBCF_Chloroplasts/inputs/gene_location_comparison.csv", row.names = FALSE, quote = FALSE)
write.csv(samples_merged_sorted, file = "/Users/bamflappy/Repos/GBCF_Chloroplasts/inputs/gene_location_comparison_re_oriented.csv", row.names = FALSE, quote = FALSE)
