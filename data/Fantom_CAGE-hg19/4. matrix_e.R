#system.time({

#!/usr/local/bin/Rscript
library(magrittr)
library(dplyr)

load('../temp_rdata/df.rd')
#dfE <- df %>% select(-X1, -X3, -X4, -X5, -X6, -X7)
dfE <- df[, colnames(df)!="X1" & colnames(df)!="X3" & colnames(df)!="X4"
          & colnames(df)!="X5" & colnames(df)!="X6"& colnames(df)!="X7"]
rm(df)


sample_names <- read.table('../../analysis/samples.txt', stringsAsFactors = F)[[1]]
colnames(dfE) <- c('description', sample_names) ; rm(sample_names)

rownames(dfE) <-  dfE[['description']]
dfE %<>% dplyr::select(-description)

path_to_E <- "../../analysis/csv/E.csv"
write.table(dfE, file=path_to_E, sep=',', row.names = T, col.names = T) ; rm(path_to_E)

path_to_promoters = '../../analysis/promoters.txt'
write.table(rownames(dfE), file=path_to_promoters, quote = F, sep = ',', row.names = F, col.names = F)
rm(path_to_promoters)

dfE <- as.matrix(dfE)
save(dfE, file='../temp_rdata/dfE.rd') ; rm(dfE)
#})