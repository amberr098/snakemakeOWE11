# De Main van de snakemake. Wanneer je deze aanroept roep je alles aan (behalve de clean).
rule all:
	input:
		"report.html"

# Lezen van bestand met gene ids + converteren naar entrez ids.
rule entrezID:
	input:
		"RNAseq.txt"
	output:
		"RNAseq_acc.txt",
		"NCBI_tags.txt"
	script:
		"read_file.R"

# lp IDs wegschrijven om later te gebruiken in verschillende API.
rule lpID:
	input:
		"RNAseq.txt"
	output:
		"lpLink.txt"
	script:
		"getLp.R"

# Haal de functie van een gen op uit de uniprot API.
rule function:
	input:
		"NCBI_tags.txt"
	output:
		"Function.txt"
	run:
		with open(input[0]) as in_file:
			ids = set()
			for line in in_file:
				ids.add('"GeneID+' + line.strip() + '"')
			ids = "+OR+".join(ids)
			shell("wget 'http://www.uniprot.org/uniprot/?query={ids}&format=tab&columns=id,comment(FUNCTION)' --output-document {output}")

# Haal de sequentie van een gen op uit de uniprot API.
rule sequentie:
	input:
		"NCBI_tags.txt"
	output:
		"sequences.txt"
	shell: "perl uniprot.pl {input} > {output}"

# Haal de namen op van het gen (dmv rentrez library in python).
rule names:
	input:
		"NCBI_tags.txt"
	output:
		"Names_IDs.txt"
	script:
		"names.py"

# Haal de pmid ids op per gen vanuit NCBI API.
rule pmids:
	input:
		"Names_IDs.txt"
	output:
		"pmids.txt"
	run:
		with open(input[0]) as in_file:
			for line in in_file:
				name = line.split(",")[1].replace(" ", "%20").replace("\n","")
				geneid = line.split(",")[0]
				list  = []
				for pmid in shell("curl 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term={name}' | grep '<Id>'", iterable = True):
					ids = pmid.replace("<Id>", "").replace("</Id>","")
					list.append(ids)
				new_line = str(geneid + ": ") + str(', '.join(list)) + "\n"
				with open(output[0], "a") as out:
					out.write(new_line)

# Sorteer de genen op aantal pmid ids (artikel).
rule sort:
	input:
		"pmids.txt"
	output:
		"sortedLijst.txt"
	script:
		"countArticles.py"

# Zoeken welke locus tags samen voorkomen in een artikel.
rule comb:
	input:
		"Names_IDs.txt"
	output:
		"combinations.txt"
	script:
		"combinationsGenes.R"

# Haal alle Kegg informatie op per gen met de KEGG api.
rule kegginf:
	input:
		"lpLink.txt"
	output:
		"kegg_info.txt"
	run:
		with open(input[0]) as in_file:
			for line in in_file:
				line = line
		shell("wget 'http://rest.kegg.jp/get/{line}' --output-document {output}")

# Haal de pathway(s) (in de vorm van KEGG id) op per gen met de KEGG api.
rule pathway:
	input:
		"lpLink.txt"
	output:
		"pathways.txt"
	run:
		with open(input[0]) as in_file:
			for line in in_file:
				line = line
		shell("wget 'http://rest.kegg.jp/link/pathway/{line}' --output-document {output}")

# Haal de KO nummers uit de Kegg informatie. De lp's met dezelfde KO zijn orthologen van elkaar.
rule ortho:
	input:
		"kegg_info.txt"
	output:
		"orthologen.txt"
	script:
		"orthologen.R"

# Maken workflow
rule workflow:
	output:
		"workflow.svg"
	shell:
		"snakemake entrezID lpID function sequentie names pmids sort comb kegginf pathway ortho --dag | dot -Tsvg > {output}"

# Rapport maken de genen
rule report:
	input:
		Functie = "Function.txt",
		Sequentie = "sequences.txt",
		Pubmed_ids = "sortedLijst.txt",
		Orthologen = "orthologen.txt",
		Pathways = "pathways.txt",
		Workflow = "workflow.svg"
	output:
		"report.html"
	run:
		from snakemake.utils import report
		report("""OWE 11: Workflows \n\n\n\n In dit report staan de belangrijkste output files.\n\n In Functie staan de functies opgehaald uit uniprot per gen. \n\n In Sequentie staan de sequenties per gen opgehaald uit uniprot.  \n\n In Pubmed_ids staan de pubmed_ids (artikel nummers) per gen aangegeven gesorteerd van weinig naar veel pubmedids, opgehaald via NCBI. \n\n In orthologen staan de KO nummers met daarachter de genen (lp nummers) die dat KO nummer bevatten. \n\n In pathways staan de pathway nummers per gen aangegeven. \n\n In workflow staat met een afbeelding onze workflow afgebeeld.""", output[0], metadata="Author: Amber, Anne, Danique", **input)

# Alle aangemaakte bestanden verwijderen.
rule clean:
        shell:
                """
                rm report.html RNAseq_acc.txt NCBI_tags.txt lpLink.txt Function.txt sequences.txt Names_IDs.txt pmids.txt sortedLijst.txt kegg_info.txt pathways.txt orthologen.txt workflow.svg
                """
