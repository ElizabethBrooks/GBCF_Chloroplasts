#!/bin/bash

# script to use tblastn to search for chloroplast genes in genomes 
# usage: bash search_chloroplast_pipeline.sh

# retrieve inputs
queryFileIn=$(grep "ailanthifoliaPep:" ../inputs/inputs_local.txt | tr -d " " | sed "s/ailanthifoliaPep://g")
dbFile=$(grep "thalianaRef:" ../inputs/inputs_local.txt | tr -d " " | sed "s/thalianaRef://g")

# setup outputs directory
outputFolder=$(grep "outputs:" ../inputs/inputs_local.txt | tr -d " " | sed "s/outputs://g")
outputFolder=$outputFolder"/orthology_blast"

# make output directory
mkdir $outputFolder

# setup outputs subdirectory
outputFolder=$outputFolder"/ailanthifolia_test"

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

# clean up input files and remove hyphens for blast
# CFastaReader: Hyphens are invalid and will be ignored
cat $queryFileIn | sed "s/^.*gene=/>/g" | sed "s/] \[locus_tag.*$/_jaC/g" > $queryFile

# move to the scripts directory
cd scripts

# status message
echo "Beginning analysis..."

# build the BLASTP database and place it in the ‘ncbiDB’ folder
# make the first blast able nucleotide database
bash makeDB_blast.sh $dbFile $outputFolder"/ailanthifolia_nucl" "nucl"

# make the second blast able protein database
bash makeDB_blast.sh $queryFile $outputFolder"/ailanthifolia_prot" "prot"

# run tblastn protein sequence search against translated nucleotide sequences
bash search_blast.sh $queryFile $outputFolder"/ailanthifolia_nucl" $outputFolder $outputFolder"/ailanthifolia_nucl_prot.blast" 5 "tblastn"

# run blastx translated nucleotide sequence search against protein sequences
bash search_blast.sh $dbFile $outputFolder"/ailanthifolia_prot" $outputFolder $outputFolder"/ailanthifolia_prot_nucl.blast" 5 "blastx"


# status message
echo "Analysis complete!"
