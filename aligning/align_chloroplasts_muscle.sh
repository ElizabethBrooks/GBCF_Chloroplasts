#!/bin/bash
#$ -M ebrooks5@nd.edu
#$ -m abe
#$ -r n
#$ -N align_chloroplasts_jobOutput
#$ -pe smp 20

# script to align sequences using muscle
# usage: qsub align_chloroplasts_muscle.sh

# load the egapx software module (contains nextflow)
#module load bio/2.0

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

# align reads
muscle -align $inputsPath -output $alignOut"/aligned.fasta"
#muscle -in $alignOut"/combined.fasta" -out $alignOut"/aligned.fasta"

# status message
echo "Analysis complete!"
