#!/bin/bash
#$ -M ebrooks5@nd.edu
#$ -m abe
#$ -r n
#$ -N searchBetween_blastp_jobOutput
#$ -pe smp 4

# script to use blastp to search to build a blast file for MCScanX 
# usage: qsub searchBetween_blastp.sh queryFile dbFolder outputFolder outputFile

# load necessary modules for ND CRC servers
#module load bio/2.0

# retrieve input paths
queryFile=$1
dbFolder=$2

# retrieve output paths
outputFolder=$3
outputFile=$4

# move to output folder
cd $outputFolder

# status message
echo "Beginning first blastp search..."

# perform blastp search
blastp -num_threads 4 -query $queryFile -db $dbFolder -outfmt 6 -evalue 1e-10 -num_alignments 5 -out $outputFile

# status message
echo "Analysis complete!"
