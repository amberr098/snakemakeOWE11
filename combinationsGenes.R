titles <- snakemake@input[[1]]

library(RCurl)

titles <- read.delim(titles, header = FALSE)
all_names <- c()
all_ids <- c()

for (row in titles) {
  name <- gsub("^, ", "", regmatches(row, regexpr(",.*",row)))
  id <- gsub("^,", "", regmatches(row, regexpr(".*?,",row)))
  all_ids <- c(all_ids, gsub(",", "",id))
  all_names <- c(all_names, gsub(" ", "%20", name))
}

all_comb <- combn(all_names, 2)
all_good_comb <- c()
for(col in 1:ncol(all_comb)){
  urlname <- paste0(all_comb[1,col], "+AND+", all_comb[2,col])
  url <- paste0("https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=", urlname)
  brows <- getURL(url)

  if(isTRUE(grepl("<Id>", brows))){
    y_first <- gsub("\\+AND\\+", "",regmatches(urlname, regexpr(".*\\+AND\\+", urlname))) 
    y_second <- gsub("\\+AND\\+", "",regmatches(urlname, regexpr("\\+AND\\+.*", urlname))) 
    
    index_all_names_first <- match(y_first, all_names)
    index_all_names_second <- match(y_second, all_names)
    
    good_comb <- paste(all_ids[index_all_names_first], all_ids[index_all_names_second])
    all_good_comb <- c(all_good_comb, good_comb)
  }
}

write(all_good_comb, "combinations.txt")
combinations.txt <- snakemake@output[[1]]

