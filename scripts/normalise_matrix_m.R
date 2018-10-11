#!/usr/local/bin/Rscript

library(magrittr)
library(dplyr)

dfM <- read.csv('../analysis/csv/M.csv')

rownames(dfM) <-  dfM[['motifs']]
dfM %<>% dplyr::select(-motifs)

dfM <- scale(dfM, scale = F)#x - сolMeans()

path_to_M_norm <- "../analysis/csv/M_norm.csv"
write.table(dfM, file=path_to_M_norm, sep=',', row.names = T, col.names = T)
save(dfM, file='../data/temp_rdata/dfM_norm.rd') ; rm(dfM) ; rm(path_to_M_norm)
