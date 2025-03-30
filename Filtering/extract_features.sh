#!/bin/bash

# script to extract CDS and protein sequences from a chloroplast fasta using a gff created with CHLOROBOX online
# usage: bash extract_features.sh speciesTag
# usage ex: for i in /Users/bamflappy/GBCF/JRS/chloroplast/JRS_CHLOROBOX/*GFF3.gff3; do species=$(basename $i | sed "s/JRS_chloro_long_//g" | sed "s/_GFF3.gff3//g"); bash extract_features.sh $species; done

# retrieve input species
#speciesTag="Jailantifolia_144"
speciesTag=$1

# retrieve chloroplast annotations
chloroAnnot=$(grep "annotationsChloroplasts:" ../inputs/inputs_local.txt | tr -d " " | sed "s/annotationsChloroplasts://g")

# retrieve input species annotations
#inputAnnot="/Users/bamflappy/GBCF/JRS/chloroplast/annotations/chloroplast_144/GeSeqJob-144_chloroplast_GFF3.gff3"
inputAnnot=$(ls $chloroAnnot"/"*$speciesTag"_"*"GFF3.gff3")

# retrieve chloroplast sequences
chloroSeq=$(grep "longChloroplasts:" ../inputs/inputs_local.txt | tr -d " " | sed "s/longChloroplasts://g")

# setup outputs directory
#outputsDir="/Users/bamflappy/GBCF/JRS/chloroplast/annotations/chloroplast_144"
outputsDir=$(grep "outputs:" ../inputs/inputs_local.txt | tr -d " " | sed "s/outputs://g")
outputsDir=$outputsDir"/features_gffread"
mkdir $outputsDir

# move to outputs directory
cd $outputsDir

# retrieve input species chloroplast
#inputSeq="/Users/bamflappy/GBCF/JRS/chloroplast/filtered/chloroplast_regions_renamed/re_oriented/JcinereaNB_144.fa"
inputSeq=$outputsDir"/"$speciesTag".fa"
cat $chloroSeq | grep -A1 $speciesTag"$" > $inputSeq

# status message
echo "Processing $speciesTag ..."

# extract features using cufflinks gffread utility
gffread $inputAnnot -g $inputSeq -x $outputsDir"/"$speciesTag"_cds.fa" -y $outputsDir"/"$speciesTag"_proteins.fa" -W -F

# status message
echo "Analysis complete!"
