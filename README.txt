{\rtf1\ansi\ansicpg1252\cocoartf1561\cocoasubrtf400
{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww14160\viewh18000\viewkind0
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0

\f0\b\fs24 \cf0 Algemeen\

\b0 Er is een workflow gecre\'eberd waarbij er informatie wordt opgehaald van verschillende webservices en er scripts zijn geschreven. Het doel van deze workflow is om vanaf verschillende sites informatie te verkrijgen en om scripts van andere programmeertalen aan elkaar te koppelen. \

\b \
Gebruik container
\b0 \
Snakemake wordt uitgevoerd in een container (Vagrant). Start de Powershell en ga naar de map waarin waarin de snakemake bestanden staan. Om deze container op te starten kunnen de volgende commands in de Powershell gebruikt worden:\
vagrant up\
vragrant ssh\
cd /vagrant\
\

\b Snakemake
\b0 \
Om vervolgens snakemake te activeren gebruik de volgende command:\
source activate snakemake\
\
De Snakefile bestaat uit elf rules die nodig zijn om uiteindelijk een rapport te genereren. Er drie verschillende webservices gebruikt (KEGG, UniProt en NCBI) en daarnaast zijn er drie verschillende programmeertalen gebruikt (Python, R en Perl). Ook is er een rule gemaakt die een rapport genereert van de elf rules. Om alle aangemaakte bestanden te verwijderen is er een 
\i clean rule 
\i0 gemaakt. Als laatste is er een 
\i rule all 
\i0 gemaakt, deze roept alle rules aan behalve de clean rule. \
Een overzicht van alle koppelingen worden weergeven in een workflow, deze wordt gecre\'eberd doormiddel van de rule 
\i workflow
\i0 . }