#!/bin/bash

# script to subset and rename genome sequences
# usage: bash maf2phy_driver.sh regionInput analysisType
# usage ex: bash maf2phy_driver.sh all
# usage ex: bash maf2phy_driver.sh subset
# usage ex: bash maf2phy_driver.sh LSC regions
# usage ex: bash maf2phy_driver.sh IRa regions
# usage ex: bash maf2phy_driver.sh SSC regions
# usage ex: bash maf2phy_driver.sh IRb regions
# usage ex: bash maf2phy_driver.sh LSC regions_inverted
# usage ex: bash maf2phy_driver.sh IRa regions_inverted
# usage ex: bash maf2phy_driver.sh SSC regions_inverted
# usage ex: bash maf2phy_driver.sh IRb regions_inverted

# retrieve region inputs
regionInput=$1

# retrieve analysis type
analysisType=$2

# retrieve inputs
inputsPath="/Users/bamflappy/GBCF/JRS/chloroplast/outputs_HPC/aligned_"$regionInput"_"$analysisType

# retrieve analysis outputs absolute path
outputsPath=$inputsPath

# move to script directory
cd ../util

# status message
echo "Beginning analysis..."

# convert phy to newick using FastTree
python maf2phy.py $inputsPath"/chloroplasts_pg_"$regionInput".maf" $outputsPath"/cactus_output_multiline_"$regionInput".phy"

# status message
echo "Analysis complete!"
