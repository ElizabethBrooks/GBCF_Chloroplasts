#!/bin/bash
#$ -M ebrooks5@nd.edu
#$ -m abe
#$ -r n
#$ -N search_blast_jobOutput
#$ -pe smp 4

# script to use blast to search to build a blast file for MCScanX 
# usage: qsub searchBetween_blastp.sh queryFile dbFolder outputFolder outputFile numAlignments analysisType

# load necessary modules for ND CRC servers
#module load bio/2.0

# retrieve input paths
queryFile=$1
dbFolder=$2

# retrieve output paths
outputFolder=$3
outputFile=$4

# retrieve the number of alignments
numAlignments=$5

# retrieve input analysis type
analysisType=$6

# move to output folder
#cd $outputFolder

# status message
echo "Beginning blast search..."

# perform blast search
#$analysisType -num_threads 4 -query $queryFile -db $dbFolder -outfmt 6 -evalue 1e-10 -num_alignments $numAlignments -out $outputFile
$analysisType -query $queryFile -db $dbFolder -outfmt 6 -evalue 1e-10 -num_alignments $numAlignments -out $outputFile

# status message
echo "Analysis complete!"
