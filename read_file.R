####################################
# Input: RNAseq data
# Van alle lp_tags de gen ids opgehaald via Entrez. Doormiddel van de Entrez ids kunnen andere
# webservices gebruikt worden en informatie opgehaald worden.
# Output: RNAseq_acc.txt is de RNAseq data die ingeladen is met als laatste kolom de Gen ids
#         NCBI_tags.txt zijn alleen de Gen ids onder elkaar
####################################

# Inlezen van het bestand
RNAseq <- snakemake@input[[1]]
library(rentrez)
RNAseq <- read.delim(RNAseq)

# Locus tags ophalen en daarachter [GENE] toevoegen om een goede zoekterm.
locus_tags <- RNAseq[,1]
locus_tags <- paste0(locus_tags,"[GENE]")

NCBI_tags <- c()

# Voor elke locus tag worden de gen ids opgehaald
for (tags in locus_tags) {
  
  r_search <- entrez_search(db = "gene", term = tags)
  NCBI_tags <-c(NCBI_tags, r_search$ids)
}

RNAseq$NCBI_tags <- NCBI_tags
# Wegschrijven bestanden. RNAseq_acc. txt heeft als laatste kolom de genIDs en NCBI_tags zijn alleen de gen ids
write.table(RNAseq, "RNAseq_acc.txt", sep=";", row.names = FALSE)
write(NCBI_tags, "NCBI_tags.txt")

RNAseq_acc.txt  <- snakemake@output[[1]]
NCBI_tags.txt <- snakemake@output[[2]]
