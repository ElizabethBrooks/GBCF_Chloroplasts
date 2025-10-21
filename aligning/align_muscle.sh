#!/bin/bash
#$ -M ebrooks5@nd.edu
#$ -m abe
#$ -r n
#$ -N align_muscle_jobOutput
#$ -q largemem

# script to run cactus
# usage: qsub align_muscle.sh geneID

# load software
module load bio/2.0

# retrieve inputs and outputs directory path
outputDir=$(grep "outputs:" ../inputs/inputs_local.txt | tr -d " " | sed "s/outputs://g")

# setup inputs directory
inputsDir=$outputDir"/features_gffread"

# retrieve chloroplast annotations
chloroAnnot=$(grep "annotationsChloroplasts:" ../inputs/inputs_local.txt | tr -d " " | sed "s/annotationsChloroplasts://g")

# setup inputs paths
queryFileIn=$inputsDir"/"$queryTag"_proteins.fa"

# setup outputs directory
outputFolder=$outputDir"/aligned_muscle"

# make output subdirectory
mkdir $outputFolder
# check if the folder already exists
if [ $? -ne 0 ]; then
	echo "The $outputFolder directory already exsists... please remove before proceeding."
	exit 1
fi

# move to the new directory
cd $outputFolder

# setup formatted inputs directory
dataFolder=$outputFolder"/data"

# make output subdirectory
mkdir $dataFolder

# set cleaned input file names
queryFile=$queryFileIn".cleaned.fa"

# retrieve the selected gene and clean up IDs by removing hyphens
#cat $queryFileIn | sed "s/^.*gene=/>/g" | sed "s/^.*gene=/>$queryTag\_/g" > $queryFile
cat $queryFileIn | grep $queryTag > $queryFile

# setup outputs file
outputsFile=$inputsDir"/"$queryTag"_proteins.fa"

# status message
echo "Beginning analysis..."

# run muscle and align protein sequences for the current gene
muscle -in $queryFile -out $outputsFile

# status message
echo "Analysis complete!"
