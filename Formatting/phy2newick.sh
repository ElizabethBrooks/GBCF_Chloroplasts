#!/bin/bash

# script to subset and rename genome sequences
# usage: bash phy2newick.sh regionInput analysisType
# usage ex: bash phy2newick.sh all
# usage ex: bash phy2newick.sh subset
# usage ex: bash phy2newick.sh LSC regions
# usage ex: bash phy2newick.sh IRa regions
# usage ex: bash phy2newick.sh SSC regions
# usage ex: bash phy2newick.sh IRb regions
# usage ex: bash phy2newick.sh LSC regions_inverted
# usage ex: bash phy2newick.sh IRa regions_inverted
# usage ex: bash phy2newick.sh SSC regions_inverted
# usage ex: bash phy2newick.sh IRb regions_inverted

# retrieve region inputs
regionInput=$1

# retrieve analysis type
analysisType=$2

# retrieve inputs
inputsPath="/Users/bamflappy/GBCF/JRS/chloroplast/outputs_HPC/aligned_"$regionInput"_"$analysisType

# retrieve analysis outputs absolute path
outputsPath=$inputsPath

# status message
echo "Beginning analysis..."

# convert phy to newick using FastTree
FastTree -nt $inputsPath"/cactus_output_multiline_"$regionInput".phy" > $outputsPath"/cactus_tree_renamed_"$regionInput".newick"

# status message
echo "Analysis complete!"
