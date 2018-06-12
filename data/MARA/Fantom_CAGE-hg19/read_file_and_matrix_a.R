if( !any(grepl("readr", installed.packages())) ) {
  install.packages("readr")
}
library(readr)
df <- read_table2("../../raw_data/robust_phase1_pls_2.tpm.desc121113.osc.txt.gz.tmp", col_names = FALSE, skip=1840)#, n_max = 10000)#problems(df)
#df <- df[,1:100]
save(df, file="df.rd"); rm(df)

if( !any(grepl("dplyr", installed.packages())) ) {
  install.packages("readr")
}
library(dplyr)
#load('df.rd') #varNames <- paste('var', 1:1837)
dfA <-  df %>%  select(-X1, -X2, -X3, -X4, -X6, -X7) %>% filter(substr(X5,1,11) =="entrezgene:") %>%
  group_by(X5)  %>%  summarise_all(sum, na.rm = TRUE)
save(df, file="df.rd"); rm(df)
save(dfA, file='dfA.rd') ; rm(dfA)