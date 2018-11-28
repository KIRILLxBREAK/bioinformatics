#!/usr/local/bin/Rscript

load('../data/temp_rdata/dfE.rd')

path_to_samples_train <- "../analysis/samples_train.txt"
samples_train <- read.table(path_to_samples_train, stringsAsFactors = F, header = F)[[1]]

dfE <- dfE[ , which((colnames(dfE) %in% samples_train)==TRUE)]
rm(samples_train, path_to_samples_train)


dfE <- dfE - rowMeans(dfE)

dfE <- scale(dfE, scale = F) #x - сolMeans()

path_to_E_norm_train <- "../analysis/csv/E_norm_train.csv"
write.table(dfE, file=path_to_E_norm_train, sep=',', row.names = T, col.names = T)
save(dfE, file='../data/temp_rdata/dfE_norm_train.rd') ; rm(dfE) ; rm(path_to_E_norm_train)