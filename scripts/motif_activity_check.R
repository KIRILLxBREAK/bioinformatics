library(readr)
library(dplyr)
library(sqldf)

EA <- read_csv("../../analysis/csv/EA.csv", col_names = T)
A <- read_csv("../../analysis/csv/A.csv", col_names = T)
A <- A %>%  select(-X1)


# zeroCount <- function(x) {
#   cnt <- apply(x, 1, function(y) sum(y))
#   cnt
# }
# 
# df_nulls <- data.frame()
# 
# for(i in seq_along(A)) {
#   for ( j in seq(to=dim(A)[1]) ) {
#     if (!is.na(EA[j,i]) && EA[j,i] != 0 && A[j,i] == 0) {
#       #df_nulls[nrow(df_nulls)+1, ] <- c(i, j)
#       df_nulls <- rbind(df_nulls, c(j, i))
#     }
#   }
# }

sqldf("SELECT 1, 2 
            UNION ALL
      SELECT 3, 4")

sqldf("SELECT * FROM df WHERE X > 10")


df <- data.frame(x = 1:3, y=c(6,7,5), z=c(1,1,2))
df %>% group_by(z) %>%mutate(rnk=row_number(y)) %>% arrange(rnk) 

ind <- which(A$entrezgene_id=='entrezgene:6927')
rnk_all <- sapply(A, rank, ties.method='first')[ind,]
summary(rnk_all)

liver <- c('tpm.liver%2c%20adult%2c%20pool1.CNhs10624.10018-101C9'
          ,'tpm.liver%2c%20fetal%2c%20pool1.CNhs11798.10086-102B5'
          ,'tpm.embryonic%20kidney%20cell%20line%3a%20HEK293%2fSLAM%20infection%2c%2024hr.CNhs11047.10451-106G1'
          ,'tpm.embryonic%20kidney%20cell%20line%3a%20HEK293%2fSLAM%20untreated.CNhs11046.10450-106F9'
          ,'tpm.kidney%2c%20adult%2c%20pool1.CNhs10622.10017-101C8'
          ,'tpm.kidney%2c%20fetal%2c%20pool1.CNhs10652.10045-101F9'
          ,'tpm.stomach%2c%20fetal%2c%20donor1.CNhs11771.10062-101H8'
          ,'tpm.small%20intestine%2c%20adult%2c%20pool1.CNhs10630.10024-101D6'
          ,'tpm.small%20intestine%2c%20fetal%2c%20donor1.CNhs11773.10064-101I1'
          )
rnk_liver <- sapply(A, rank, ties.method='first')[ind, colnames(A) %in% liver]
rsummary(rnk_liver)
