#!/bin/bash

# script to convert an input multiline fasta to single
# usage: bash convert_multiline_fasta.sh inputFile
# usage: bash convert_multiline_fasta.sh /Users/bamflappy/GBCF/JRS/chloroplast/Juglanschlorosaln.fasta

# retrieve input file
inputFile=$1

# set output file name
outputFile=$(echo $inputFile | sed "s/\.fasta//g" | sed "s/\.fa//g")
outputFile=$outputFile".fmt.fa"

# set tmp output file name
tmpFile=$(echo $inputFile | sed "s/\.fasta//g" | sed "s/\.fa//g")
tmpFile=$tmpFile".tmp.fa"

# add 'NEWLINE' tags to the start and end of each sequence header, then remove new lines
cat $inputFile | sed '/^>/s/$/NEWLINE/' | sed '/^>/s/^/NEWLINE/' | tr -d '\n' | sed "s/NEWLINE/\n/g" > $tmpFile

# re-place the removed EoF newline
echo -e "\n" >> $tmpFile

# remove the extra BoF newline
tail -n+2 $tmpFile | sed '$d' > $outputFile

# clean up
rm $tmpFile
