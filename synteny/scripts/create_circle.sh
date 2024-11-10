#!/bin/bash

# script to create dot plots
# usage: bash create_circle.sh

# set species comparison tag
compTag="arabadopsis_ailanthifolia"

# retrieve inputs
cntlFile=../../"inputs/inputs_circle.ctl"

# setup outputs directory
outputFolder=$(grep "outputs:" ../../"inputs/inputs_local.txt" | tr -d " " | sed "s/outputs://g")
outputFolder=$outputFolder"/orthology_MCScanX"

# setup outputs subdirectory
outputFolder=$outputFolder"/"$compTag

# setup MCScanX inputs directory
dataFolder=$outputFolder"/data"

# create a circle plot
java circle_plotter -g $dataFolder"/master.gff" -s $dataFolder"/master.collinearity" -c $cntlFile -o $dataFolder"/circle.png"
