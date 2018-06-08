####################################
# Input: Info van alle gen IDs uit KEGG. Alle informatie per ID is gescheiden door ///
# Dit script zoekt lp nummers met dezelfde KO, wanneer ze hetzelfde KO nummer hebben zijn ze orthologen van elkaar.
# Output: Een dataframe met in de eerste kolom KO nummers en in de 2de kolom de lp nummers die deze KO hebben.
####################################

kegg <- snakemake@input[[1]]
file <- readChar(kegg, file.info(kegg)$size)

#Maak lege dataframe en vector aan
df_lp_KO <- data.frame()
all_KO <- c()

# De informatie uit kegg is gescheiden met "///". Hierop wordt gesplit.
indexes <- strsplit(file, "///")
indexes <- indexes[[1]][1:(length(indexes[[1]])-1)]

# Ophalen van de KO en lp
for(i in indexes){
  # Ophalen van het KO nummer
  reg_KO <- regmatches(i, regexpr("ORTHOLOGY.*ORGANISM",i))
  KO <- gsub(" ","", regmatches(reg_KO, regexpr("K\\d.*?\\s", reg_KO)))
  # Ophalen van het lp nummer bij het bijbehorende KO nummer
  reg_lp <- regmatches(i, regexpr("ENTRY.*CDS",i)) 
  lp <- gsub(" ", "", regmatches(reg_lp, regexpr("lp_\\d.*?\\s",reg_lp)))
  # Wanneer er maar 1 KO aanwezig is worden deze toegevoegd aan het dataframe.
  # Wanneer er meer dan 1 KO aanwezig is wordt alleen de eerste KO (eerste index) gepakt en in het dataframe gezet.
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
# Er wordt per uniek KO gekeken welke lp nummers er bij horen.
for(KO in 1:length(uniKO)){
  # Orthologen wordt steeds leeg gemaakt bij een nieuw KO nummer.
  orthologen <- ""
  # Wanneer het KO uit het dataframe gelijk is aan KO uit de vector met unieke KOs wordt het lp nummer toegevoegd aan een vector.
  for(id in 1:nrow(df_lp_KO)){
    if(df_lp_KO[id, 2] == uniKO[KO]){
      orthologen <- paste(orthologen, df_lp_KO[id, 1], sep = ",")
    }
  }
  # Het KO nummer en een vector met lp nummers wordt toegevoegd aan het dataframe.
  orthologen_df[KO, 1] <- uniKO[KO]
  orthologen_df[KO, 2] <- orthologen
}
# De kolomnamen worden veranderd.
colnames(orthologen_df) <- c("KO", "lp")
write.table(orthologen_df, "orthologen.txt", row.names = FALSE, quote = FALSE)

orthologen.txt  <- snakemake@output[[1]]