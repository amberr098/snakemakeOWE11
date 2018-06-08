##############################################
# Input: GenID, naam gen
# Dit script zoekt of er genen samen voorkomen in een artikel. Op basis van de namen van de genIDs 
# zijn er combinaties gemaakt. De combinaties in een URL toegevoegd en er is gekeken of de combinatie voorkomt
# Output: GenIDs die samen in een artikel voorkomen
##############################################


# Input is een file met: genID, naam gen
titles <- snakemake@input[[1]]

library(RCurl)

# Inlezen bestand 
titles <- read.delim(titles, header = FALSE)
all_names <- c()
all_ids <- c()

# Het ID eruit halen en de naam van het gen ophalen en in twee aparte vectoren zetten.
for (row in titles) {
  name <- gsub("^, ", "", regmatches(row, regexpr(",.*",row)))
  id <- gsub("^,", "", regmatches(row, regexpr(".*?,",row)))
  all_ids <- c(all_ids, gsub(",", "",id))
  all_names <- c(all_names, gsub(" ", "%20", name))
}

# Combinaties maken van alle mogelijke gennamen. 
all_comb <- combn(all_names, 2)
all_good_comb <- c()

# Elke combinatie zoeken in pubmed waarna er een XML format wordt gecreëerd.
for(col in 1:ncol(all_comb)){
  urlname <- paste0(all_comb[1,col], "+AND+", all_comb[2,col])
  url <- paste0("https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=", urlname)
  brows <- getURL(url)
  
  # Wanneer er in de XML format <Id> staat worden deze opgehaald.
  if(isTRUE(grepl("<Id>", brows))){
    y_first <- gsub("\\+AND\\+", "",regmatches(urlname, regexpr(".*\\+AND\\+", urlname))) 
    y_second <- gsub("\\+AND\\+", "",regmatches(urlname, regexpr("\\+AND\\+.*", urlname))) 
    
    index_all_names_first <- match(y_first, all_names)
    index_all_names_second <- match(y_second, all_names)
    
    good_comb <- paste(all_ids[index_all_names_first], all_ids[index_all_names_second])
    all_good_comb <- c(all_good_comb, good_comb)
  }
}

# De ids van de pubmed artikelen waarbij er twee genen in voor komen (gebaseerd op de naam van het gen), worden weggeschreven.
write(all_good_comb, "combinations.txt")
combinations.txt <- snakemake@output[[1]]

