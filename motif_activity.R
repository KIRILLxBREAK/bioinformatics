library(readr)
library(dplyr)

EA <- read_csv("Documents/study/bioinformatics/analysis/EA.csv", col_names = FALSE)
A <- read_csv("Documents/study/bioinformatics/analysis/A.csv", col_names = FALSE)
A <- A %>%  select(-X1)


zeroCount <- function(x) {
  cnt <- apply(x, function(x) c)
}