# Chloroplasts Project

The data are sequenced chloroplast genomes, identified by species. The purpose of this investigation is to address a phylogenetic puzzle.

For a description of the analysis and results so far, see the REPORT.md file.

For more information about the project, see the PROJECT.md file.

## Analysis Workflow

See the NOTES.md file for additional details.

### Whole Chloroplast Alignment

1. Filter by length and identify longest sequence for potential reference. Also, plot the distribution sequence lengths
2. Format input sequences and create input files for [MCScanX](https://github.com/wyp1125/MCScanX)
- The [CHLOROBOX GeSeq](https://chlorobox.mpimp-golm.mpg.de/geseq.html) online tool and [Cufflinks gffread](https://ccb.jhu.edu/software/stringtie/gff.shtml#gffread) was used to annotate the chloroplast sequences and create the necessary gff and protein sequences files for the MCScanX synteny analysis
3. Investigate longest sequence gene content and order using [MCScanX](https://github.com/wyp1125/MCScanX) and the NCBI reference [Arabadopsis thaliana](https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000001735.4/) chloroplast genome assembly (see "annotations" directory)
4. Fix orientation of sequences contained in the inverted repeat regions and format longest sequences for downstream analysis
5. Create an inputs file for cactus that has the names and file paths to sequences
6. Create alignments using [cactus-pangenome](https://github.com/ComparativeGenomicsToolkit/cactus/blob/master/doc/pangenome.md) and convert the hal files using cactus-hal2maf
7. Evalute alignments with 

- tube maps using [sequenceTubeMap](https://vgteam.github.io/sequenceTubeMap/) and the cactus output vg file in the "chrom_alignments" sub-directory
- sequence alignments using [IGV](https://igv.org/download/html/oldtempfixForDownload.html) desktop application with the maf file and reference sequence (Jailantifolia_136)

### Chloroplast CDS Alignments

1. Format the GeSeq annotations to only use the blatx hits for each gene
2. Use gffread and the formatted GeSeq annotations to retrieve the CDS for each gene in all the samples
3. For all samples, create individual gene CDS files and align each CDS using the [muscle](https://www.ebi.ac.uk/jdispatcher/) command line tool
4. Format sequence headers in the indiviual CDS alignment files to prepare for downstream analysis with BEAUti
5. Use the [SequenceMatrix](https://www.ggvaidya.com/taxondna/) application to concatenate all CDS across samples and create a non-interleaved nexus file appropriate for analysis with BEAUti

## Code

The code for the above workflow can be found [HERE](https://github.com/ElizabethBrooks/GBCF_Chloroplasts.git).
