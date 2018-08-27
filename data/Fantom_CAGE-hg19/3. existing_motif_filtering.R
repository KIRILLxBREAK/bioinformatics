#!/usr/local/bin/Rscript

path_to_motif <- '../../analysis/filter_motifs.txt'
motifs <- read.csv(path_to_motif, header = T, stringsAsFactors = F)
load("../temp_rdata/genes.rd") 
genes <- genes[ which(genes$hgnc_symbol %in% motifs$motif_name) ,]
rm(motifs)

load('../temp_rdata/dfA.rd')
rownames(dfA) <- dfA$X5
dfA <- dfA[ genes$entrezgene_id,]
dfA <- dfA[ which(!is.na(dfA$X5)),]

overall_motifs <- genes[ which(genes$entrezgene_id %in% dfA$X5), 'hgnc_symbol']
path_to_filterd_motif <- "../../analysis/filter_motifs.txt"
filtered_motifs <- read.csv(path_to_filterd_motif, stringsAsFactors = F)
filtered_motifs <- filtered_motifs[ which(filtered_motifs$motif_name %in% overall_motifs), ]
path_to_overall_motif <- "../../analysis/overall_motifs.txt"
write.table(filtered_motifs, file=path_to_overall_motif, quote = F, sep = ',', row.names = F, col.names = T)
rm(genes) ; rm(overall_motifs) ; rm(filtered_motifs)

path_to_A <- "../../analysis/сsv/A.csv"
write.table(dfA, file=path_to_A, sep=',', row.names = F, col.names = F)
save(dfA, file='../temp_rdata/dfA.rd') ; rm(dfA)