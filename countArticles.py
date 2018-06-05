"""
Input: genID: alle pubmed ids
Het sorteren van de gen IDs op basis van het aantal pubmed IDs die het gen heeft.
Van laag naar hoog gerankschikt.
Output: genID: alle pubmed IDs
"""

PMids = snakemake.input[0]

# Bestand openen en een output file aanmaken
file = open(PMids, "r")
file_output = open("sortedLijst.txt", "a")

articlesCount = file.readlines()
lijst =[]
i = 0

# Elke regel splitten op , en het aantal elementen tellen.
for ID in articlesCount:
    if ":" in ID:
        counts = len(ID.split(","))
        IDcounts = counts - 1
        splitID = ID.split(",")

        # Toevoegen van de counts op index 0 aan splitID en toevoegen aan een lijst
        splitID.insert(0,IDcounts)
        lijst.append(splitID)

# Lijst word gesorteerd op basis van de eerste index van de lijsten die erin zitten.
sortedNestedLijst = sorted(lijst)

# Output artikel schrijven
for artikellijst in sortedNestedLijst:
    # Verwijderen van de count
    sortedNestedLijst[i].pop(0)
    i+=1
    artikellijstt = (', '.join(map(str, artikellijst)))
    file_output.write(str(artikellijstt))
file_output.close()

file_output = snakemake.output[0]
