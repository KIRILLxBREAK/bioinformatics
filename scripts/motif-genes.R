library(dplyr)

motif <- read.csv('../analysis/overall_motifs.txt')
load('../data/temp_rdata/genes.rd')

df <- merge(motif, genes, by.x = 'motif_name', by.y = 'hgnc_symbol')
rm(motif, genes)

est_s_count <- df %>% group_by(motif_name) %>% summarise(n())

bad_entrez <- c(100379661, 440982, 388289, 100506403)
df <- df[-which(df$entrezgene %in% bad_entrez),] ; rm(bad_entrez, est_s_count)

write.csv(df, '../analysis/motif-genes.csv', row.names = F)
