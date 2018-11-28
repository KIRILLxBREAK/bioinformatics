#!/usr/local/bin/Rscript

library(magrittr)
library(dplyr)

#dfA <- read.csv('../analysis/csv/A.csv')
load('../data/temp_rdata/dfA.rd')

rownames(dfA) <-  dfA[['entrezgene_id']]
dfA %<>% dplyr::select(-entrezgene_id)

path_to_samples_train <- "../analysis/samples_train.txt"
samples_train <- read.table(path_to_samples_train, stringsAsFactors = F, header = F)[[1]]

dfA <- dfA[ , which((names(dfA) %in% samples_train)==TRUE)]
rm(samples_train, path_to_samples_train)

dfA  <- dfA - rowMeans(dfA)

path_to_A_norm_train <- "../analysis/csv/A_norm_train.csv"
write.table(dfA, file=path_to_A_norm_train, sep=',', row.names = T, col.names = T)
save(dfA, file='../data/temp_rdata/dfA_norm_train.rd') ; rm(dfA) ; rm(path_to_A_norm_train)
