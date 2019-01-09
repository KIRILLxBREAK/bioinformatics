library(dplyr)
library(magrittr)

# списки обучающих и тестовых реплик ----
path_to_samples_train <- "../analysis/samples_train.txt"
samples_train <- read.table(path_to_samples_train, stringsAsFactors = F, header = F)[[1]]
rm(path_to_samples_train)

path_to_samples_test <- "../analysis/samples_test.txt"
samples_test <- read.table(path_to_samples_test, stringsAsFactors = F, header = F)[[1]]
rm(path_to_samples_test)

path_to_samples_replic_train <- "../analysis/samples_replic_train.txt"
samples_replic_train <- read.table(path_to_samples_replic_train, stringsAsFactors = F, header = F)[[1]]
rm(path_to_samples_replic_train)


# получаем ткани с третьей репликой и с первыми двумя
test_s <- sapply(as.list(samples_test), function(y) strsplit(y, 'rep3')[[1]][[1]] ) 
train_replic_s <- sapply(as.list(samples_replic_train), function(y) strsplit(y, 'rep[1-2]')[[1]][[1]] )

# таблица с тканью для каждой тестовой реплики
test_s <- data.frame(sample=test_s, cell=samples_test)
test_s_count <- test_s %>% group_by(sample) %>% summarise(n())
test_s[which(test_s$sample=='tpm.H9%20Embryoid%20body%20cells%2c%20melanocytic%20induction%2c%20day12%2c%20biol_') , ]

# таблица с тканью для каждой обучающей реплики
train_replic_s <- data.frame(sample=train_replic_s, cell=samples_replic_train)
train_replic_s_count <- train_replic_s %>% group_by(sample) %>% summarise(n())
train_replic_s[which(train_replic_s$sample=='tpm.H9%20Embryoid%20body%20cells%2c%20melanocytic%20induction%2c%20day12%2c%20biol_') , ]



# модель для обучающей выборки -----
load('../data/temp_rdata/dfE_norm_train.rd')
load('../data/temp_rdata/dfM_norm.rd')
motif_names <- colnames(dfM)

s <- svd(dfM) ; rm(dfM)
d <- s$d

d_1 <- 1/d
M_inv <- s$v %*% diag(d_1) %*% t(s$u) ; rm(d_1)
EA <- M_inv %*% as.matrix(dfE) ; rm(M_inv)
rownames(EA) <- motif_names
save(EA, file='../data/temp_rdata/EA.rd') ; rm(EA)



# проверка ----
load('../data/temp_rdata/EA_train.rd')
EA <- as.data.frame(base::t(EA))
EA$cell <- rownames(EA)
EA <- merge(EA, train_replic_s, by.x = 'cell', by.y='cell')
#EA$sample <- train_replic_s$sample[match(rownames(EA), train_replic_s$cell)]
#EA <- na.omit(EA)
EA_count <- EA %>% group_by(sample) %>% summarise(n())
EA %<>% select(-cell)
EA %<>% group_by(sample) %>% summarise_all(mean, na.rm = TRUE)
rownames(EA) <- EA$sample
EA %<>% select(-sample)

genes <- read.csv('../analysis/motif-genes.csv')
load('../data/temp_rdata/dfA_norm.rd')
dfA['entrezgene_id'] <- rownames(dfA)
dfA <- merge(dfA, genes) ; rm(genes)
rownames(dfA) <- dfA$motif
dfA %<>% dplyr::select( -c('entrezgene', 'entrezgene_id', 'motif_name', 'motif') )
dfA <- as.data.frame(base::t(dfA))
dfA$cell <- rownames(dfA)
dfA <- merge(dfA, test_s, by.x = 'cell', by.y='cell')
dfA_count <- dfA %>% group_by(sample) %>% summarise(n())
dfA %<>% select(-cell)
dfA %<>% group_by(sample) %>% summarise_all(mean, na.rm = TRUE)
rownames(dfA) <- dfA$sample
dfA %<>% select(-sample)

all_motifs <- intersect(colnames(dfA), colnames(EA))
EA <- EA[, all_motifs]
dfA <- dfA[, all_motifs]
all_samples <- intersect(rownames(dfA), rownames(EA))
EA <- EA[all_samples,]
dfA <- dfA[all_samples,]

corr_list <- list()
for (i in rownames(dfA)) {
  #print(i)
  corr_list[[i]] <- cor( unlist(EA[i,]), unlist(dfA[i,]), method = 'spearman' )
}
corr_list <- unlist(corr_list)


# проверка через экспресию ----
rownames(EA) <-  EA[['sample']]
EA %<>% dplyr::select(-sample)
EA <- base::t(EA)
save(EA, file='../data/temp_rdata/EA_samples.rd')


load('../data/temp_rdata/dfM_norm.rd')
dfE <- dfM %*% EA
save(dfE, file='../data/temp_rdata/dfE_samples.rd')
