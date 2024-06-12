#!/bin/bash

# script to retrieve the chloroplast protein coding gene features from a gff
# usage: bash keep_features.sh inputSeq inputFeat
# usage: bash keep_features.sh /Users/bamflappy/GBCF/JRS/chloroplast/TAIR10_1_ncbi_dataset/ncbi_dataset/data/GCF_000001735.4/GCF_000001735.4_TAIR10.1_genomic.fna /Users/bamflappy/GBCF/JRS/chloroplast/TAIR10_1_ncbi_dataset/ncbi_dataset/data/GCF_000001735.4/genomic.gff

# set input files
inputSeq=$1
inputFeat=$2

# set output file
outputFeat=$(dirname $inputFeat)
outputFeat=$outputFeat"/chloroplast_genes.gff"

# retrieve chloroplast chromosome tag
chromTag=$(cat $inputSeq | grep "chloroplast" | cut -d" " -f1 | sed "s/>//g")

# retrieve chloroplast protein coding gene features
cat $inputFeat | awk -F '\t' '$1=="$chromTag" && $3=="gene" && match($9, "gene_biotype=protein_coding")' > $outputFeat
