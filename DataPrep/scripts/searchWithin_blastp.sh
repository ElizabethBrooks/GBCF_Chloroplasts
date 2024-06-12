#!/bin/bash
#$ -M ebrooks5@nd.edu
#$ -m abe
#$ -r n
#$ -N searchWithin_blastp_jobOutput
#$ -pe smp 4

# script to use blastp to search to build a blast file for MCScanX 
# usage: qsub searchWithin_blastp.sh queryFile dbFolder outputFolder outputFile

# load necessary modules for ND CRC servers
module load bio/2.0

# retrieve input paths
queryFile=$1
dbFolder=$2

# retrieve output paths
outputFolder=$3
outputFile=$4

# move to output folder
cd $outputFolder

# status message
echo "Beginning within genome blastp search..."

# 18. Because colinear genes may exist in the same genomes, perform within a genome all-against-all BLASTP for each genome, with the best six hits being kept.
blastp -num_threads 4 -query $dbFile -db $dbFolder -outfmt 6 -evalue 1e-10 -num_alignments 6 -out $outputFile

# status message
echo "Analysis complete!"
