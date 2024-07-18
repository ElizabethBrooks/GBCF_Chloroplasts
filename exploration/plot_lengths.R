
# load libraries
library(ggplot2)

# import length data
lengthData <- read.csv("/Users/bamflappy/GBCF/JRS/chloroplast/genome_lengths.reFmt.csv")

# plot lengths
ggplot(data=lengthData, mapping = aes(x=length)) +
  geom_histogram(aes(y = after_stat(count))) +
  #geom_vline(xintercept = 159700, color = "red") +
  #geom_vline(xintercept = 160400, color = "blue") +
  theme_minimal()
