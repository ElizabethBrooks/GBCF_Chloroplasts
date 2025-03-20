#!/bin/bash
#$ -M ebrooks5@nd.edu
#$ -m abe
#$ -r n
#$ -N hal2maf_cactus-pg_jobOutput
#$ -q largemem

# script to run cactus
# usage: qsub hal2maf_cactus-pg.sh regionInput analysisType
# regions (non-inverted IRa and IRb for problematic samples)
# usage ex: qsub hal2maf_cactus-pg.sh LSC regions
## job 
# usage ex: qsub hal2maf_cactus-pg.sh IRa regions
## job 
# usage ex: qsub hal2maf_cactus-pg.sh SSC regions
## job 
# usage ex: qsub hal2maf_cactus-pg.sh IRb regions
## job 
# inverted (inverted IRa and IRb for problematic samples)
# usage ex: qsub hal2maf_cactus-pg.sh LSC regions_inverted
## job 
# usage ex: qsub hal2maf_cactus-pg.sh IRa regions_inverted
## job 
# usage ex: qsub hal2maf_cactus-pg.sh SSC regions_inverted
## job 
# usage ex: qsub hal2maf_cactus-pg.sh IRb regions_inverted
## job 

# retrieve region inputs
regionInput=$1

# retrieve analysis type
analysisType=$2

# setup outputs name
outputsName="chloroplasts_pg_"$regionInput

# retrieve software path
softEnv=$(grep "cactus_env:" ../"inputs/software_HPC.txt" | tr -d " " | sed "s/cactus_env://g")

# retrieve inputs
inputsPath=$(grep $regionInput":" ../"inputs/inputs_"$analysisType".txt" | tr -d " " | sed "s/$regionInput\://g")

# retrieve inputs
inputRef=$(grep "cactus_ref:" ../"inputs/inputs_HPC.txt" | tr -d " " | sed "s/cactus_ref://g")

# retrieve analysis outputs absolute path
outputsPath=$(grep "outputs:" ../"inputs/inputs_HPC.txt" | tr -d " " | sed "s/outputs://g")

# make a new directory for analysis
alignOut=$outputsPath"/aligned_"$regionInput"_"$analysisType

# move to the new directory
cd $alignOut

# activate python environment
source $softEnv

# status message
echo "Beginning analysis..."

# To run:
cactus-hal2maf $alignOut"/js" $alignOut"/"$outputsName"/"$outputsName".full.hal" $alignOut"/"$outputsName".maf.gz" --refGenome $inputRef --chunkSize 500000 --binariesMode singularity 

# status message
echo "Analysis complete!"
