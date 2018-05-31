file <- snakemake@input[[1]]
rnaseq <- read.delim(file, skip=1,header=TRUE, sep="\t", row.names=1)

names <- rownames(rnaseq)
newnames <- "" 

for (x in names) {
  newnames <- paste0(newnames,"lpl:", x, "+" )
}

lpLink <- substr(newnames, 1, nchar(newnames)-1)
write(lpLink, "lpLink.txt")

lpLink.txt <- snakemake@output[[1]]
