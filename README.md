# GBCF_Chloroplasts

1. Filter by length and format for downstream analysis
	- There needs to be separate fasta files for each genome (for cactus) with the same header for each chloroplast sequence (for sequenceTubeMap)
	- There needs to be a combined fasta file with all the chloroplast sequences (for mafft) with the file name for each genome as the sequence header (for cactus)
2. Create bifurcating tree using https://mafft.cbrc.jp/ and format for input to cactus
3. Run cactus-pangenome
4. Use the cactus output "d2.gbz" file as input to https://vgteam.github.io/sequenceTubeMap/
