#!/usr/local/bin/Rscript
#system.time({
  
path_to_motif <- '../../analysis/filter_motifs.txt'
motifs <- read.csv(path_to_motif, header = T, stringsAsFactors = F) ; rm(path_to_motif)
load("../temp_rdata/genes.rd") 
genes <- genes[ which(genes$hgnc_symbol %in% motifs$motif_name) ,]
rm(motifs)

load('../temp_rdata/dfA.rd')
dfA <- dfA[ which(dfA[[1]] %in% genes$entrezgene_id),]
dfA <- dfA[ which(!is.na(dfA[[1]])) , ]
rownames(dfA) <- dfA[[1]]

overall_motifs <- genes[ which(genes$entrezgene_id %in% dfA[[1]]), 'hgnc_symbol']
path_to_filterd_motif <- "../../analysis/filter_motifs.txt"
filtered_motifs <- read.csv(path_to_filterd_motif, stringsAsFactors = F)
filtered_motifs <- filtered_motifs[ which(filtered_motifs$motif_name %in% overall_motifs), ]
path_to_overall_motif <- "../../analysis/overall_motifs.txt"
write.table(filtered_motifs, file=path_to_overall_motif, quote = F, sep = ',', row.names = F, col.names = T)
rm(genes) ; rm(overall_motifs) ; rm(filtered_motifs) ; rm(path_to_overall_motif); rm(path_to_filterd_motif)

path_to_A <- "../../analysis/csv/A.csv"
write.table(dfA, file=path_to_A, sep=',', row.names = F, col.names = T) ; rm(path_to_A)
save(dfA, file='../temp_rdata/dfA.rd') ; rm(dfA)
#})