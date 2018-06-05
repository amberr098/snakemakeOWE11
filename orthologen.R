####################################
# Input: Info van alle gen IDs uit KEGG. Alle informatie per ID is gescheiden door ///
#  
# Output: 
####################################

kegg <- snakemake@input[[1]]
file <- readChar(kegg, file.info(kegg)$size)

df_lp_KO <- data.frame()
all_KO <- c()

indexes <- strsplit(file, "///")
indexes <- indexes[[1]][1:(length(indexes[[1]])-1)]

# Ophalen van de KO en lp
for(i in indexes){
  reg_KO <- regmatches(i, regexpr("ORTHOLOGY.*ORGANISM",i))
  KO <- gsub(" ","", regmatches(reg_KO, regexpr("K\\d.*?\\s", reg_KO)))
  
  reg_lp <- regmatches(i, regexpr("ENTRY.*CDS",i)) 
  lp <- gsub(" ", "", regmatches(reg_lp, regexpr("lp_\\d.*?\\s",reg_lp)))
  
  if(length(KO) == 1){
    df_lp_KO[i, 1] <- lp
    df_lp_KO[i, 2] <- KO
    all_KO <- c(all_KO, KO)
  }else if(length(KO) > 1){
    df_lp_KO[i, 1] <- lp
    df_lp_KO[i, 2] <- KO[1]
    all_KO <- c(all_KO, KO[1])
  }
}

# Alle unieke KOs pakken.
uniKO <- unique(all_KO)

orthologen_df <- data.frame()
for(KO in 1:length(uniKO)){
  orthologen <- ""
  for(id in 1:nrow(df_lp_KO)){
    if(df_lp_KO[id, 2] == uniKO[KO]){
      orthologen <- paste(orthologen, df_lp_KO[id, 1], sep = ",")
    }
  }
  orthologen_df[KO, 1] <- uniKO[KO]
  orthologen_df[KO, 2] <- orthologen
}

colnames(orthologen_df) <- c("KO", "lp")
write.table(orthologen_df, "orthologen.txt", row.names = FALSE, quote = FALSE)

orthologen.txt  <- snakemake@output[[1]]