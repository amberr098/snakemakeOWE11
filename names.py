# -*- coding: utf-8 -*-
"""
Input: bestand met alle gen IDs onder elkaar.
Het toevoegen van de namen van de gen ids.
Output: gen id, naam gen id
"""
NCBI_tags  = snakemake.input[0]

from Bio import Entrez
Entrez.email = "Your.Name.Here@example.org"

# Openen van de input en het maken van een output file.
file = open(NCBI_tags, "r")
file_output = open("Names_IDs.txt", "w")

ids = file.readlines()

# Van elk gen ID de naam ophalen en wegschrijven naar de output file.
for idd in ids:
    idd = idd.replace("\n", "")
    handle = Entrez.efetch(db="gene", id=idd, rettype="gb", retmode="text")
    name_id = handle.readlines()[2]
    id_name = idd +", " +name_id
    file_output.write(id_name)

file_output.close()
handle.close()

file_output  = snakemake.output[0]
