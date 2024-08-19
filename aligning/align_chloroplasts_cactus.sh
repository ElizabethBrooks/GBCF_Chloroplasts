#!/bin/bash
#$ -M ebrooks5@nd.edu
#$ -m abe
#$ -r n
#$ -N align_chloroplasts_cactus_jobOutput

# script to run cactus
# usage: qsub align_chloroplasts_cactus.sh

# activate python environment
source /scratch365/ebrooks5/cactus/cactus_env/bin/activate

# retrieve inputs
inputsPath=$(grep "long:" ../"inputs/inputs_HPC.txt" | tr -d " " | sed "s/long://g")

# retrieve analysis outputs absolute path
outputsPath=$(grep "outputs:" ../"inputs/inputs_HPC.txt" | tr -d " " | sed "s/outputs://g")

# make a new directory for analysis
alignOut=$outputsPath"/aligned"
mkdir $alignOut

# move to the new directory
cd $alignOut

# status message
echo "Beginning analysis..."

# To run:
cactus ./js ./examples/evolverMammals.txt ./evolverMammals.hal --binariesMode singularity 

# status message
echo "Analysis complete!"
