#!/bin/bash

# script to use tblastn to search for chloroplast genes in genomes 
# usage: bash search_chloroplast_pipeline.sh queryFileIn
# usage ex: bash search_chloroplast_pipeline.sh MF167457.1_Juglans_cathayensis_chloroplast,_complete_genome.fa
# usage ex: for i in /Users/bamflappy/GBCF/JRS/chloroplast/chloroplast_genomes/*; do bash search_chloroplast_pipeline.sh $i; done

# retrieve inputs
queryFileIn=$1
dbFileIn=$(grep "ailanthifoliaPep:" ../inputs/inputs_local.txt | tr -d " " | sed "s/ailanthifoliaPep://g")

# setup outputs directory
outputFolder=$(grep "outputs:" ../inputs/inputs_local.txt | tr -d " " | sed "s/outputs://g")
outputFolder=$outputFolder"/orthology_blast"

# make output directory
mkdir $outputFolder

# name results directory
outName=$(basename $queryFileIn | sed "s/\.fa//g")

# setup outputs subdirectory
outputFolder=$outputFolder"/"$outName

# make output subdirectory
mkdir $outputFolder
# check if the folder already exists
if [ $? -ne 0 ]; then
	echo "The $outputFolder directory already exsists... please remove before proceeding."
	exit 1
fi

# setup MCScanX inputs directory
dataFolder=$outputFolder"/data"

# make output subdirectory
mkdir $dataFolder

# set cleaned input file names
queryFile=$queryFileIn".cleaned.fa"
dbFile=$dbFileIn".cleaned.fa"

# clean up input files and remove hyphens for blast
# CFastaReader: Hyphens are invalid and will be ignored
cat $queryFileIn | sed "s/ /_/g" | sed "s/-/~/g" > $queryFile
cat $dbFileIn | sed "s/^.*gene=/>/g" | sed "s/] \[locus_tag.*$/_jaC/g" | sed "s/-/_/g" > $dbFile

# move to the scripts directory
cd scripts

# status message
echo "Beginning analysis of $outName ..."

# build the BLASTP database and place it in the ‘ncbiDB’ folder
# make the first blast able nucleotide database
bash makeDB_blast.sh $queryFile $outputFolder"/chloroplast_nucl" "nucl"

# make the second blast able protein database
bash makeDB_blast.sh $dbFile $outputFolder"/ailanthifolia_prot" "prot"

# run tblastn protein sequence search against translated nucleotide sequences
bash search_blast.sh $dbFile $outputFolder"/chloroplast_nucl" $outputFolder $outputFolder"/chloroplast_nucl_ailanthifolia_prot.blast" 5 "tblastn"

# run blastx translated nucleotide sequence search against protein sequences
bash search_blast.sh $queryFile $outputFolder"/ailanthifolia_prot" $outputFolder $outputFolder"/ailanthifolia_prot_chloroplast_nucl.blast" 5 "blastx"


# status message
echo "Analysis complete!"
