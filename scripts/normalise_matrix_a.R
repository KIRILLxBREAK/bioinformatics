library(magrittr)
library(dplyr)

#dfA <- read.csv('../analysis/csv/A.csv')
load('../data/temp_rdata/dfA.rd')

rownames(dfA) <-  dfA[['entrezgene_id']]
dfA %<>% select(-entrezgene_id)

dfA  <- dfA - rowMeans(dfA)

path_to_A_norm <- "../analysis/csv/A_norm.csv"
write.table(dfA, file=path_to_A_norm, sep=',', row.names = T, col.names = T)
save(dfA, file='../data/temp_rdata/dfA_norm.rd') ; rm(dfA)
