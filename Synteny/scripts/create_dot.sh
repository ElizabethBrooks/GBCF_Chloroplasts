#!/bin/bash

# script to create dot plots
# usage: bash create_dot.sh

# retrieve software location
softLoc="/Users/bamflappy/MCScanX-master/downstream_analyses"

# set species comparison tag
compTag="arabadopsis_ailanthifolia"

# retrieve inputs
cntlFile=$(ls ../InputData/inputs_dual_synteny.ctl)

# setup outputs directory
outputFolder=$(grep "outputs:" ../InputData/inputs_local.txt | tr -d " " | sed "s/outputs://g")
outputFolder=$outputFolder"/orthology_MCScanX"

# setup outputs subdirectory
outputFolder=$outputFolder"/"$compTag

# setup MCScanX inputs directory
dataFolder=$outputFolder"/data"

# move to software location
cd $softLoc

# Using the same set of input files from Step 24A(i and ii), run the Java program dot_plotter to generate a dot plot for all the colinear blocks on two sets of chromosomes
java dot_plotter -g $dataFolder"/master.gff" -s $dataFolder"/master.collinearity" -c $cntlFile -o $dataFolder"/dot.png"
