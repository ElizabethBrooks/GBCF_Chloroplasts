# Mapping of IDfileorder# to species names with numbers
id_to_species = {
    1: "Jmandshurica", 2: "Jmandshurica", 3: "Jmandshurica", 4: "Jmandshurica", 5: "Jmandshurica",
    6: "Jmandshurica", 7: "Jmandshurica", 8: "Jmandshurica", 9: "Jmandshurica", 10: "Jhopeiensis",
    11: "Jhopeiensis", 12: "Jhopeiensis", 13: "Jcathayensis", 14: "Jcathayensis", 15: "Jcathayensis",
    16: "Jcathayensis", 17: "Jcathayensis", 18: "Jcathayensis", 19: "Jcathayensisvf", 20: "Jcathayensisvf",
    21: "Jcathayensisvf", 22: "Jcathayensisvf", 23: "Jailantifolia", 24: "Jailantifolia", 25: "Jailantifolia",
    26: "Jailantifolia", 27: "Jailantifolia", 28: "Jmajor", 29: "Jmajor", 30: "Jmajor", 31: "Jmajor", 
    32: "Jmajor", 33: "Jmajor", 34: "Jcinerea", 35: "Jcinerea", 36: "Jcinerea", 37: "Jcinerea", 
    38: "Jcinerea", 39: "Jcinerea", 40: "Jcinerea", 41: "Jmicrocarpa", 42: "Jmicrocarpa", 43: "Jmicrocarpa",
    44: "Jmicrocarpa", 45: "Jmicrocarpa", 46: "Jmicrocarpa", 47: "Jmicrocarpa", 48: "Jcinerea", 
    49: "Jcinerea", 50: "Jcinerea", 51: "Jcinerea", 52: "Jcinerea", 53: "Jcinerea", 54: "Jcinerea", 
    55: "Jcinerea", 56: "Jcinerea", 57: "Jcinerea", 58: "Jcinerea", 59: "Jcinerea", 60: "Jcinerea",
    61: "Jcinerea", 62: "Jcinerea", 63: "Jcinerea", 64: "Jmajor", 65: "Jmajor", 66: "Jmajor", 
    67: "Jmajor", 68: "Jmajor", 69: "Jmajor", 70: "Jmajor", 71: "Jnigra", 72: "Jnigra", 
    73: "Jnigra", 74: "Jnigra", 75: "Jnigra", 76: "Jnigra", 77: "Jnigra", 78: "Jnigra", 
    79: "JmajorxJregia", 80: "JmajorxJregia", 81: "JmajorxJregia", 82: "JmajorxJregia", 83: "JmajorxJregia",
    84: "JmajorxJregia", 85: "JmajorxJregia", 86: "Jhindsii", 87: "Jhindsii", 88: "Jhindsii", 
    89: "Jhindsii", 90: "Jhindsii", 91: "Jhindsii", 92: "Jhindsii", 93: "Jmicrocarpa", 94: "Jmicrocarpa", 
    95: "Jmicrocarpa", 96: "Jmicrocarpa", 97: "Jmicrocarpa", 98: "Jmicrocarpa", 99: "Jmicrocarpa", 
    100: "Jhindsii", 101: "Jhindsii", 102: "Jhindsii", 103: "Jhindsii", 104: "Jhindsii", 
    105: "Jhindsii", 106: "Jhindsii", 107: "Jhindsii", 108: "Jhindsii", 109: "Jregia", 
    110: "Jregia", 111: "Jregia", 112: "Jregia", 113: "Jregia", 114: "Jregia", 115: "Jregia", 
    116: "Jregia", 117: "Jregia", 118: "Jregia", 119: "Jregia", 120: "Jregia", 121: "Jregia",
    122: "Jregia", 123: "Jregia", 124: "Jregia", 125: "Jregia", 126: "Jregia", 127: "Jailantifolia",
    128: "Jmandshurica", 129: "Jmandshurica", 130: "Jmandshurica", 131: "Jcinerea", 132: "Jcinerea",
    133: "Jcinerea", 134: "Jcathayensis", 135: "Jcathayensis", 136: "Jailantifolia", 137: "Jcinerea",
    138: "Jcinerea", 139: "Jcinerea", 140: "Jcinerea", 141: "JcinereaNB", 142: "JcinereaNB",
    143: "JcinereaNB", 144: "JcinereaNB", 145: "JcinereaNB", 146: "JcinereaNB", 147: "JcinereaNB",
    148: "JcinereaNB", 149: "JcinereaUSA", 150: "JcinereaUSA", 151: "JcinereaUSA", 152: "JcinereaUSA",
    153: "JcinereaUSA", 154: "JcinereaUSA", 155: "JcinereaUSA", 156: "JcinereaUSA", 157: "JcinereaUSA",
    158: "JcinereaUSA", 159: "JcinereaUSA", 160: "JcinereaUSA", 161: "JnigraWGS", 162: "JnigraWGS", 
    163: "JcinereaNB", 164: "JcinereaNB"
}

# Replace the species name in the Phylip file based on the mapping
def replace_idfileorder_in_phylip(phylip_file, output_file):
    with open(phylip_file, 'r') as infile, open(output_file, 'w') as outfile:
        for line in infile:
            # Strip the line of any leading/trailing whitespace
            line = line.strip()

            # Split the line into parts (assuming the format: IDfileorder# SEQUENCE)
            parts = line.split()
            
            # Check if the first part of the line matches 'IDfileorder'
            if len(parts) > 0 and parts[0].startswith('IDfileorder'):
                try:
                    # Extract the IDfileorder number
                    order_number = int(parts[0].replace('IDfileorder', ''))

                    # Find the corresponding species name from the dictionary
                    species = id_to_species.get(order_number)
                    if species:
                        # Construct the new name with species and number
                        new_name = f"{species}.{order_number}"

                        # Ensure the sequence part is retained, and write the new name + sequence to the output file
                        sequence = parts[1] if len(parts) > 1 else ""
                        outfile.write(f"{new_name.ljust(20)} {sequence}\n")
                    else:
                        # If the species is not found in the mapping, keep the original line
                        outfile.write(line + "\n")
                except ValueError:
                    # Handle any unexpected format (e.g., non-numeric in IDfileorder)
                    outfile.write(line + "\n")
            else:
                # For lines that don't match IDfileorder, write them as-is
                outfile.write(line + "\n")

# Example usage
replace_idfileorder_in_phylip('/home/sheri/Downloads/cactus_output_multiline.phy', '/home/sheri/Downloads/cactus_output_multiline_renamed.phy')
