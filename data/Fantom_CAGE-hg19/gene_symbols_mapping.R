#!/usr/local/bin/Rscript

if( !any(grepl("biomaRt", installed.packages())) ) {
  library(BiocInstaller)
  biocLite("biomaRt")
}
library(biomaRt) # listMarts(); listDatasets(ensembl); ilters = listFilters(ensembl); attributes = listAttributes(ensembl)
ensembl <- useMart("ensembl", dataset="hsapiens_gene_ensembl") # ensembl = useMart("ensembl"); ensembl = useDataset("hsapiens_gene_ensembl", mart=ensembl)
genes <- getBM(attributes=c('entrezgene', 'hgnc_symbol'), mart = ensembl) # getGene()
rm(ensembl)
genes <- genes[complete.cases(genes), ]
genes$entrezgene_id <- paste('entrezgene', genes$entrezgene, sep=":")
save(genes, file='genes.rd') ;rm(genes)