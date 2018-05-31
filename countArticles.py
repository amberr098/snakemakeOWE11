# -*- coding: utf-8 -*-
"""
Created on Sun May 27 16:06:10 2018

@author: Danique
"""

PMids = snakemake.input[0]

file = open(PMids, "r")
file_output = open("sortedLijst.txt", "a")

articlesCount = file.readlines()
lijst =[]
i = 0

for ID in articlesCount:
    if ":" in ID:
        counts = len(ID.split(","))
        IDcounts = counts - 1
        splitID = ID.split(",")

        splitID.insert(0,IDcounts)
        lijst.append(splitID)

sortedNestedLijst = sorted(lijst)

for artikellijst in sortedNestedLijst:
    sortedNestedLijst[i].pop(0)
    i+=1
    artikellijstt = (', '.join(map(str, artikellijst)))
    file_output.write(str(artikellijstt))
file_output.close()

file_output = snakemake.output[0]
