Algemeen
Er is een workflow gecreëerd waarbij er informatie wordt opgehaald van verschillende webservices en er scripts zijn geschreven. Het doel van deze workflow is om vanaf verschillende sites informatie te verkrijgen en om scripts van andere programmeertalen aan elkaar te koppelen. 

Gebruik container
Snakemake wordt uitgevoerd in een container (Vagrant). Start de Powershell en ga naar de map waarin waarin de snakemake bestanden staan. Om deze container op te starten kunnen de volgende commands in de Powershell gebruikt worden:
vagrant up
vragrant ssh
cd /vagrant

Snakemake
Om vervolgens snakemake te activeren gebruik de volgende command:
source activate snakemake

De Snakefile bestaat uit elf rules die nodig zijn om uiteindelijk een rapport te genereren. Er drie verschillende webservices gebruikt (KEGG, UniProt en NCBI) en daarnaast zijn er drie verschillende programmeertalen gebruikt (Python, R en Perl). Ook is er een rule gemaakt die een rapport genereert van de elf rules. Om alle aangemaakte bestanden te verwijderen is er een clean rule gemaakt. Als laatste is er een rule all gemaakt, deze roept alle rules aan behalve de clean rule. 
Een overzicht van alle koppelingen worden weergeven in een workflow, deze wordt gecreëerd doormiddel van de rule workflow. 

Wanneer het script niet werkt, zijn alle outputs voor de zekerheid opgeslagen in het mapje “output”.
