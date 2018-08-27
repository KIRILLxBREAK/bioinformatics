#!/usr/local/bin/Rscript

load('../temp_rdata/df.rd')
#dfE <- df %>% select(-X1, -X3, -X4, -X5, -X6, -X7)
dfE <- df[, colnames(df)!="X1" & colnames(df)!="X3" & colnames(df)!="X4"
          & colnames(df)!="X5" & colnames(df)!="X6"& colnames(df)!="X7"]
rm(df)
path_to_E <- "../../analysis/E.csv"
write.table(dfE, file=path_to_E, sep=',', row.names = F, col.names = F)
save(dfE, file='../temp_rdata/dfE.rd') ; rm(dfE)