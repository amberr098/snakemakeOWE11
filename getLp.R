####################################
# Input: RNAseq data
# Het vormt een bestand met 1 regel die gelijk gebruikt kan worden om in KEGG webservices te zoeken 
# Output: Bestand met 1 regel met alle lpl:lp_000X tags.
####################################

# Ophalen/inlezen van de input 
file <- snakemake@input[[1]]
rnaseq <- read.delim(file, skip=1,header=TRUE, sep="\t", row.names=1)

# Alle lp_ tags ophalen 
names <- rownames(rnaseq)
newnames <- "" 

# Alle lp_tags achter elkaar plakken door: lpl:lp_0001+lpl:lp_0002+ etc.
for (x in names) {
  newnames <- paste0(newnames,"lpl:", x, "+" )
}

# Wegschrijven van het bestand
lpLink <- substr(newnames, 1, nchar(newnames)-1)
write(lpLink, "lpLink.txt")

lpLink.txt <- snakemake@output[[1]]
