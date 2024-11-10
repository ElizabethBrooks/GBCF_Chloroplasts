#!/bin/bash

# script to extract CDS and protein sequences from a chloroplast fasta using a gff created with CHLOROBOX online
# usage: bash extract_features.sh speciesTag
# test
# usage ex: bash extract_features.sh Jailantifolia_136
# problematic set
# usage ex: bash extract_features.sh Jcinerea_138
# usage ex: bash extract_features.sh Jcinerea_140
# usage ex: bash extract_features.sh JcinereaNB_142
# usage ex: bash extract_features.sh JcinereaNB_144
# usage ex: bash extract_features.sh JcinereaNB_145

# retrieve input species
speciesTag=$1

# retrieve chloroplast annotations
chloroAnnot=$(grep "annotationsChloroplasts:" ../inputs/inputs_local.txt | tr -d " " | sed "s/annotationsChloroplasts://g")

# retrieve input species annotations
inputAnnot=$(ls $chloroAnnot"/"*$speciesTag"_"*"GFF3.gff3")

# retrieve chloroplast sequences
chloroSeq=$(grep "longChloroplasts:" ../inputs/inputs_local.txt | tr -d " " | sed "s/longChloroplasts://g")

# setup outputs directory
outputsDir=$(grep "outputs:" ../inputs/inputs_local.txt | tr -d " " | sed "s/outputs://g")
outputsDir=$outputsDir"/features_gffread"
mkdir $outputsDir

# move to outputs directory
cd $outputsDir

# retrieve input species chloroplast
inputSeq=$outputsDir"/"$speciesTag".fa"
cat $chloroSeq | grep -A1 $speciesTag"$" > $inputSeq

# status message
echo "Processing $speciesTag ..."

# extract features using cufflinks gffread utility
gffread $inputAnnot -g $inputSeq -x $outputsDir"/"$speciesTag"_cds.fa" -y $outputsDir"/"$speciesTag"_proteins.fa" -W -F

# status message
echo "Analysis complete!"
