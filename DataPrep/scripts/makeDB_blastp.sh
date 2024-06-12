#!/bin/bash

# script to build a blast able database for MCScanX 
# usage: bash makeDB_blastp.sh dbFile outputFolder

# load necessary modules for ND CRC servers
module load bio/2.0

# retrieve input paths
dbFile=$1

# retrieve output paths
outputFolder=$2

# status message
echo "Building blast able databases..."

# make the blast able database
# makeblastdb -in ncbi/species1.fa -out ncbiDB/species1 -dbtype prot
makeblastdb -in $dbFile -out $outputFolder -dbtype prot

# status message
echo "Analysis complete!"
