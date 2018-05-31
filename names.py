# -*- coding: utf-8 -*-
"""
Created on Tue May 22 11:25:51 2018

@author: Danique
"""
NCBI_tags  = snakemake.input[0]

from Bio import Entrez
Entrez.email = "Your.Name.Here@example.org"

file = open(NCBI_tags, "r")
file_output = open("Names_IDs.txt", "w")

ids = file.readlines()

for idd in ids:
    idd = idd.replace("\n", "")
    handle = Entrez.efetch(db="gene", id=idd, rettype="gb", retmode="text")
    name_id = handle.readlines()[2]
    id_name = idd +", " +name_id
    file_output.write(id_name)

file_output.close()
handle.close()

file_output  = snakemake.output[0]
