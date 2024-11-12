#!/bin/bash

# script to format the chloroplast protein coding gene features for MCScanX
# usage: bash format_features.sh speciesTag inputFeat
# usageEx: bash format_features.sh atC /Users/bamflappy/GBCF/JRS/chloroplast/ArabidopsisThaliana/Arabidopsis_thaliana_chloroplast_NC_000932.1_ncbi/sequence.gff3
# usageEx: bash format_features.sh jaC /Users/bamflappy/GBCF/JRS/chloroplast/JuglansAilanthifolia/Juglans_ailanthifolia_chloroplast_NC_046433.1_ncbi/sequence.gff3
# usageEx: bash format_features.sh Jailantifolia_136 /Users/bamflappy/GBCF/JRS/chloroplast/JRS_CHLOROBOX/JRS_chloro_long_Jailantifolia_136_GFF3.gff3
# usageEx: for i in /Users/bamflappy/GBCF/JRS/chloroplast/JRS_CHLOROBOX/*GFF3.gff3; do species=$(basename $i | sed "s/JRS_chloro_long_//g" | sed "s/_GFF3.gff3//g"); bash format_features.sh $species $i; done

# retrieve species and chromosome tag
speciesTag=$1

# set input files
inputFeat=$2

# name and create outputs dir
outputsDir=$(dirname $inputFeat)
outputsDir=$outputsDir"/formatted"
mkdir $outputsDir

# set output file
outputFeat=$outputsDir"/"$speciesTag"_chloroplast_genes.gff"

# retrieve chloroplast protein coding gene features
cat $inputFeat | awk -F '\t' '$3=="gene" && match($9, "gene_biotype=protein_coding")' | cut -f4,5,9 | sed "s/^/$speciesTag\t/g" | sed "s/ID=.*gene=//g" | sed "s/;.*$/_$speciesTag/g" | awk -v OFS='\t' '{print $1,$4,$2,$3}' > $outputFeat
