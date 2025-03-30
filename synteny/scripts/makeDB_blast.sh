#!/bin/bash

# script to build a blast able database for MCScanX 
# usage: bash makeDB_blastp.sh dbFile outputFolder dbType

# load necessary modules for ND CRC servers
#module load bio/2.0

# retrieve input paths
dbFile=$1

# retrieve output paths
outputFolder=$2

# retrieve input db type
dbType=$3

# status message
echo "Building blastable databases..."

# make the blast able database
makeblastdb -in $dbFile -out $outputFolder -dbtype $dbType

# status message
echo "Analysis complete!"
