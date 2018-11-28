library(dplyr)
library(magrittr)

path_to_samples_train <- "../analysis/samples_train.txt"
samples_train <- read.table(path_to_samples_train, stringsAsFactors = F, header = F)[[1]]
rm(path_to_samples_train)

path_to_samples_test <- "../analysis/samples_test.txt"
samples_test <- read.table(path_to_samples_test, stringsAsFactors = F, header = F)[[1]]
rm(path_to_samples_test)

path_to_samples_replic_train <- "../analysis/samples_replic_train.txt"
samples_replic_train <- read.table(path_to_samples_replic_train, stringsAsFactors = F, header = F)[[1]]
rm(path_to_samples_replic_train)



test_s <- sapply(as.list(samples_test), function(y) strsplit(y, 'rep3')[[1]][[1]] )
train_replic_s <- sapply(as.list(samples_replic_train), function(y) strsplit(y, 'rep[1-2]')[[1]][[1]] )

test_s <- data.frame(sample=test_s, cell=samples_test)
test_s_count <- test_s %>% group_by(sample) %>% summarise(n())
test_s[which(test_s$sample=='tpm.H9%20Embryoid%20body%20cells%2c%20melanocytic%20induction%2c%20day12%2c%20biol_') , ]

train_replic_s <- data.frame(sample=train_replic_s, cell=samples_replic_train)
train_replic_s_count <- train_replic_s %>% group_by(sample) %>% summarise(n())
train_replic_s[which(train_replic_s$sample=='tpm.H9%20Embryoid%20body%20cells%2c%20melanocytic%20induction%2c%20day12%2c%20biol_') , ]

load('../data/temp_rdata/EA_train.rd')
EA <- as.data.frame(base::t(EA))
EA$sample <- train_replic_s$sample[match(rownames(EA), train_replic_s$cell)]
EA <- na.omit(EA)
EA %<>% group_by(sample) %>% summarise_all(mean, na.rm = TRUE)
rownames(EA) <-  EA[['sample']]
EA %<>% dplyr::select(-sample)
EA <- base::t(EA)
save(EA, file='../data/temp_rdata/EA_samples.rd')


load('../data/temp_rdata/dfM_norm.rd')
dfE <- dfM %*% EA
save(dfE, file='../data/temp_rdata/dfE_samples.rd')
