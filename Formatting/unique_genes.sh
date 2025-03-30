#!/bin/bash

# script to retrieve the gene names for each genome
# and add a unique number to each gene name for duplicates
# usage: bash unique_genes.sh

# set inputs directory
#inputsDir="/Users/bamflappy/GBCF/JRS/chloroplast/JRS_CHLOROBOX/formatted_blatX_hits"
inputsDir="/Users/bamflappy/GBCF/JRS/chloroplast/annotations/JRS_CHLOROBOX_re_oriented/formatted_blatX_hits"

# set inputs path
inputsPath="/Users/bamflappy/Repos/GBCF_Chloroplasts/inputs"

# set inputs file name
#inputsName="sample_genes.txt"
#inputsUnique="sample_genes_unique.txt"
inputsName="sample_genes_re_oriented.txt"
inputsUnique="sample_genes_unique_re_oriented.txt"

# pre clean up
rm $inputsPath"/"$inputsName

# loop over each annotation file
for i in $inputsDir"/"*"_chloroplast_genes.gff"; do 
	echo $i; cat $i | cut -f2 | cut -d"_" -f1 |  awk '{print $0 (/^/ ? "_" (++c[$1]) : "")}' >> $inputsPath"/"$inputsName
done

# filter to the unique gene names
cat $inputsPath"/"$inputsName | sort -u > $inputsPath"/"$inputsUnique
