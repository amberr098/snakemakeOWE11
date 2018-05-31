RNAseq <- snakemake@input[[1]]
library(rentrez)
RNAseq <- read.delim(RNAseq)

locus_tags <- RNAseq[,1]
locus_tags <- paste0(locus_tags,"[GENE]")

NCBI_tags <- c()

for (tags in locus_tags) {
  
  r_search <- entrez_search(db = "gene", term = tags)
  NCBI_tags <-c(NCBI_tags, r_search$ids)
}

RNAseq$NCBI_tags <- NCBI_tags

write.table(RNAseq, "RNAseq_acc.txt", sep=";", row.names = FALSE)
write(NCBI_tags, "NCBI_tags.txt")

RNAseq_acc.txt  <- snakemake@output[[1]]
NCBI_tags.txt <- snakemake@output[[2]]
