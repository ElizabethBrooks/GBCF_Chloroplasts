#!/bin/bash

# script to retrieve the chloroplast protein coding gene features from a gff
# usage: bash keep_features.sh spChromTag inputFeat
# usageEx: bash keep_features.sh atC /Users/bamflappy/GBCF/JRS/chloroplast/ArabidopsisThaliana/Arabidopsis_thaliana_chloroplast_NC_000932.1_ncbi/sequence.gff3
# usageEx: bash keep_features.sh jaC /Users/bamflappy/GBCF/JRS/chloroplast/JuglansAilanthifolia/Juglans_ailanthifolia_chloroplast_NC_046433.1_ncbi/sequence.gff3

# retrieve species and chromosome tag
spChromTag=$1

# set input files
#inputSeq=$1
inputFeat=$2

# set output file
outputFeat=$(dirname $inputFeat)
outputFeat=$outputFeat"/chloroplast_genes.gff"

# retrieve chloroplast chromosome tag
#chromTag=$(cat $inputSeq | grep "chloroplast" | cut -d" " -f1 | sed "s/>//g")

# retrieve chloroplast protein coding gene features
#cat $inputFeat | awk -F '\t' '$1=="$chromTag" && $3=="gene" && match($9, "gene_biotype=protein_coding")' > $outputFeat
cat $inputFeat | awk -F '\t' '$3=="gene" && match($9, "gene_biotype=protein_coding")' | cut -f4,5,9 | sed "s/^/$spChromTag\t/g" | sed "s/ID=.*Name=//g" | sed "s/;.*$/_$spChromTag/g" | awk -v OFS='\t' '{print $1,$4,$2,$3}' > $outputFeat
