#!/bin/bash

# script to format gff file data for gene order comparison
# usage: bash format_features_unique_genes.sh

# setup inputs path
inputsPath="/Users/bamflappy/GBCF/JRS/chloroplast/JRS_CHLOROBOX/formatted_blatX_hits/sorted/"

# pre clean up
rm -r $inputsPath

# create inputs directory
mkdir $inputsPath

# sort gene locations
for i in /Users/bamflappy/GBCF/JRS/chloroplast/JRS_CHLOROBOX/formatted_blatX_hits/*J*_chloroplast_genes.gff; do echo $i; newName=$(basename $i | sed "s/\.gff//g"); cat $i | sort -k3 -n > $inputsPath"/"$newName"_sorted.gff"; done

# setup outputs file path
outputsPath="/Users/bamflappy/GBCF/JRS/chloroplast/JRS_CHLOROBOX/formatted_blatX_hits/formatted_locations"

# pre clean up
rm -r $outputsPath

# create outputs directory
mkdir $outputsPath

# retrieve the gene names for each genome
for i in $inputsPath"/"*J*; do
	# status message
	echo $i
	# create new file name
	newName=$(basename $i | sed "s/\.gff//g")
	# and add a unique number to each gene name for duplicates
	cat $i | cut -f2 | cut -d"_" -f1 |  awk '{print $0 (/^/ ? "_" (++c[$1]) : "")}' > $outputsPath"/"$newName"_locations.tmp.gff"
	# retrieve gene locations
	cut -f3,4 $i > $outputsPath"/"$newName"_gene_locations.tmp.gff"
	# create the re-formatted gff
	paste $outputsPath"/"$newName"_locations.tmp.gff" $outputsPath"/"$newName"_gene_locations.tmp.gff" > $outputsPath"/"$newName"_locations.gff"
	# clean up
	rm $outputsPath"/"$newName"_gene_locations.tmp.gff"
	rm $outputsPath"/"$newName"_locations.tmp.gff"
done
