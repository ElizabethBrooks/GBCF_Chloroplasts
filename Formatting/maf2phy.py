from bx.align import maf

def maf_to_phylip(maf_file, output_file):
    species_to_alignment = {}
    alignment_length = 0

    # Read the MAF file
    with open(maf_file, 'r') as maf_fh:
        reader = maf.Reader(maf_fh)

        # Loop over each alignment block in the MAF file
        for block in reader:
            block_len = block.text_size  # Length of the current block
            alignment_length += block_len

            # Loop over each species in the alignment block
            for component in block.components:
                species = component.src.split('.')[0]  # Extract species name
                sequence = component.text.upper()      # Extract aligned sequence
                
                if species not in species_to_alignment:
                    species_to_alignment[species] = []

                # Append the aligned sequence for this block to the species list
                species_to_alignment[species].append(sequence)

            # For species not in the current block, append gaps ("-" for alignment gaps)
            for species in species_to_alignment:
                if species not in [component.src.split('.')[0] for component in block.components]:
                    species_to_alignment[species].append('-' * block_len)

    # Now write the Phylip output in multiline format (split every 100 bases)
    with open(output_file, 'w') as phy_fh:
        num_species = len(species_to_alignment)
        phy_fh.write(f"{num_species} {alignment_length}\n")

        # Write the sequences in chunks of 100 base pairs
        max_line_length = 100
        sequences = {species: ''.join(seq_blocks) for species, seq_blocks in species_to_alignment.items()}
        
        # Get the maximum length of the sequence
        max_seq_length = max(len(seq) for seq in sequences.values())
        
        for i in range(0, max_seq_length, max_line_length):
            for species, full_sequence in sequences.items():
                phy_fh.write(f"{species.ljust(10)} {full_sequence[i:i + max_line_length]}\n")
            phy_fh.write("\n")  # Add a blank line between blocks of 100 bp

# Example usage
#maf_to_phylip("/home/sheri/Downloads/chloroplasts-pg.maf", "/home/sheri/Downloads/cactus_output_multiline.phy")
maf_to_phylip("/Users/bamflappy/GBCF/JRS/chloroplast/aligned_cactus-pg_subset/chloroplasts-pg.maf", "/Users/bamflappy/GBCF/JRS/chloroplast/aligned_cactus-pg_subset/cactus_output_multiline.phy")
