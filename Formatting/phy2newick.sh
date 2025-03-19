#!/bin/bash

# script to subset and rename genome sequences
# usage: bash phy2newick.sh analysisType
# usage ex: bash phy2newick.sh all
# usage ex: bash phy2newick.sh subset
# usage ex: bash phy2newick.sh LSC
# usage ex: bash phy2newick.sh IRa
# usage ex: bash phy2newick.sh SSC
# usage ex: bash phy2newick.sh IRb

# retrieve analysis type
analysisType=$1

# setup outputs name
outputsName="chloroplasts_pg_"$analysisType

# retrieve inputs
inputsPath="/Users/bamflappy/GBCF/JRS/chloroplast/outputs_HPC/aligned_"$analysisType

# retrieve analysis outputs absolute path
outputsPath=$inputsPath

# status message
echo "Beginning analysis..."

# convert phy to newick using FastTree
FastTree -nt $inputsPath"/cactus_output_multiline_"$analysisType".phy" > $outputsPath"/cactus_tree_renamed_"$analysisType".newick"

# status message
echo "Analysis complete!"
