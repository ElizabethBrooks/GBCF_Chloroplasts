#!/bin/bash

# retrieve the gene names for each genome
# and add a unique number to each gene name for duplicates
for i in /Users/bamflappy/GBCF/JRS/chloroplast/JRS_CHLOROBOX/formatted_blatX_hits/*J*_chloroplast_genes.gff; do 
	echo $i; cat $i | cut -f2 | cut -d"_" -f1 |  awk '{print $0 (/^/ ? "_" (++c[$1]) : "")}' >> /Users/bamflappy/Repos/GBCF_Chloroplasts/inputs/sample_genes.txt
done

# filter to the unique gene names
cat /Users/bamflappy/Repos/GBCF_Chloroplasts/inputs/sample_genes.txt | sort -u > /Users/bamflappy/Repos/GBCF_Chloroplasts/inputs/sample_genes_unique.txt 
