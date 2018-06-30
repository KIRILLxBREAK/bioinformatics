library(readr)
library(dplyr)

EA <- read_csv("../analysis/EA.csv", col_names = FALSE)
A <- read_csv("../analysis/A.csv", col_names = FALSE)
A <- A %>%  select(-X1)


zeroCount <- function(x) {
  cnt <- apply(x, 1, function(y) sum(y))
  cnt
}

df_nulls <- data.frame()

for(i in seq_along(A)) {
  for ( j in seq(to=dim(A)[1]) ) {
    if (!is.na(EA[j,i]) && EA[j,i] != 0 && A[j,i] == 0) {
      #df_nulls[nrow(df_nulls)+1, ] <- c(i, j)
      df_nulls <- rbind(df_nulls, c(j, i))
    }
  }
}
