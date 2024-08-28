#!/bin/bash
#$ -M ebrooks5@nd.edu
#$ -m abe
#$ -r n
#$ -N hal2maf_chloroplasts_cactus-pg_jobOutput

# script to run cactus
# usage: qsub hal2maf_chloroplasts_cactus-pg.sh

# retrieve software path
softEnv=$(grep "cactus_env:" ../"inputs/software_HPC.txt" | tr -d " " | sed "s/cactus_env://g")

# retrieve inputs
inputRef=$(grep "cactus_ref:" ../"inputs/inputs_HPC.txt" | tr -d " " | sed "s/cactus_ref://g")

# retrieve analysis outputs absolute path
outputsPath=$(grep "outputs:" ../"inputs/inputs_HPC.txt" | tr -d " " | sed "s/outputs://g")

# make a new directory for analysis
alignOut=$outputsPath"/aligned_cactus-pg"

# move to the new directory
cd $alignOut

# activate python environment
source $softEnv

# status message
echo "Beginning analysis..."

# To run:
cactus-hal2maf $alignOut"/js" $alignOut"/chloroplasts-pg/chloroplasts-pg.full.hal" $alignOut"/chloroplasts-pg.maf.gz" --refGenome $inputRef --chunkSize 500000 --binariesMode singularity 

# status message
echo "Analysis complete!"
