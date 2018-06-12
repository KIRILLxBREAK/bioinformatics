#!/usr/local/bin/Rscript

path_to_motif <- '../../analysis/filter_motifs.txt'
motifs <- read.csv(path_to_motif, header = T, stringsAsFactors = F)
load("genes.rd") 
genes <- genes[ which(genes$hgnc_symbol %in% motifs$motif_name) ,]
rm(motifs)

load('dfA.rd')
rownames(dfA) <- dfA$X5
dfA <- dfA[ genes$entrezgene_id,]
dfA <- dfA[ which(!is.na(dfA$X5)),]
rm(genes)
path_to_A <- "../../analysis/A.csv"
write.table(dfA, file=path_to_A, sep=',', row.names = F, col.names = F)
save(dfA, file='dfA.rd') ; rm(dfA)