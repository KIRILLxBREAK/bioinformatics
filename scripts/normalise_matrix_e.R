#!/usr/local/bin/Rscript

load('../data/temp_rdata/dfE.rd')

dfE  <- dfE - rowMeans(dfE)
dfE <- data.frame( scale(dfE, scale = F) ) #x - сolMeans()
#y <- matrix(apply(x, 1, mean), ncol = 3)  - rowMeans(x)
#y <- matrix(apply(x, 2, mean), ncol = 3)  - colMeans(x)

path_to_E_norm <- "../analysis/csv/E_norm.csv"
write.table(dfE, file=path_to_E_norm, sep=',', row.names = T, col.names = T)
save(dfE, file='../data/temp_rdata/dfE_norm.rd') ; rm(dfE)
