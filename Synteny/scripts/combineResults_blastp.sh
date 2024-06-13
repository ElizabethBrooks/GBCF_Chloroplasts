#!/bin/bash

# script to combine blastp results for MCScanX 
# usage: bash combineResults_blastp.sh outputFolder resultsFile
# usage ex: bash combineResults_blastp.sh /scratch365/ebrooks5/GBCF/JRS/chloroplast/orthology_MCScanX/arabadopsis_ailanthifolia /scratch365/ebrooks5/GBCF/JRS/chloroplast/orthology_MCScanX/arabadopsis_ailanthifolia/arabadopsis_ailanthifolia_master.blast

# retrieve output paths
outputFolder=$1
resultsFile=$2

# move to output folder
cd $outputFolder

# status message
echo "Combining blastp results..."

# 20. Concatenate the .blast files to generate a single ‘master.blast’ file
cat $outputFolder"/"*.blast > $resultsFile

# status message
echo "Analysis complete!"
