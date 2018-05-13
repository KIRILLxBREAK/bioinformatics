# 1.read file ----
setwd('/home/kirill/Documents/Projects/bioinformatics/bioinformatics/data/MARA/Fantom CAGE-hg19/')

if( !any(grepl("readr", installed.packages())) ) {
  install.packages("readr")
}
library(readr)
df <- read_table2("robust_phase1_pls_2.tpm.desc121113.osc.txt.gz.tmp", col_names = FALSE, skip=1840)#, n_max = 10000)#problems(df)
#df <- df[,1:100]
save(df, file="df.rd"); #load('df.rd)
rm(df)

# 2.group by transcriptiom (matrix E), second branch ----
if( !any(grepl("dplyr", installed.packages())) ) {
  install.packages("dplyr")
}
library(dplyr)

load('df.rd')
#varNames <- paste('var', 1:1837)
dfA <-  df %>%  select(-X1, -X2, -X3, -X4, -X6, -X7) %>% filter(substr(X5,1,11) =="entrezgene:") %>%
  group_by(X5)  %>%  summarise_all(sum, na.rm = TRUE)
rm('df')
save(dfA, file='dfA.rd') #load("dfA.rd") 
rm(dfA)

# 3.genes ids and genes symbols ----
if( !any(grepl("biomaRt", installed.packages())) ) {
  install.packages("biomaRt")
}
library("biomaRt")
# listMarts(); listDatasets(ensembl)
# ensembl = useMart("ensembl"); ensembl = useDataset("hsapiens_gene_ensembl", mart=ensembl) # 
ensembl <- useMart("ensembl", dataset="hsapiens_gene_ensembl")
#filters = listFilters(ensembl); attributes = listAttributes(ensembl)
genes <- getBM(attributes=c('entrezgene', 'hgnc_symbol'),  # getGene()
               #filters = 'hgnc_symbol', #'with_entrezgene', 
               #values = 'AIRE', 
               mart = ensembl)
rm(ensembl)
genes <- genes[complete.cases(genes), ]
genes$entrezgene_id <- paste('entrezgene', genes$entrezgene, sep=":")
save(genes, file='genes.rd') #load("genes.rd") 
rm(genes)



# 4.existing motif filtering ----
path_to_motif <- '../../../analysis/filter_motifs.txt'
motifs <- read.csv(path_to_motif, header = T, stringsAsFactors = F)
load("genes.rd") 
genes <- genes[ which(genes$hgnc_symbol %in% motifs$motif_name) ,]
rm(motifs)

load('dfA.rd')
#dfA <- dfA[ which(dfA$X5 %in% genes$entrezgene_id) ,]
rownames(dfA) <- dfA$X5
dfA <- dfA[ genes$entrezgene_id,]
dfA <- dfA[ which(!is.na(dfA$X5)),]
rm(genes)
path_to_A <- "../../../analysis/A.csv"
write.table(dfA, file=path_to_A, sep=',', row.names = F, col.names = F)
save(dfA, file='dfA.rd')
rm(dfA)


# 5. parse TSS (transcription starting sites) ranges ----
if( !any(grepl("dplyr", installed.packages())) ) {
  install.packages("dplyr")
}
library(dplyr)
load(df)
chr <- df[, colnames(df)=="X1" | colnames(df)=="X5"] %>% filter(substr(X5,1,11) =="entrezgene:")
rm(df)#; load("df.rd") 

if( !any(grepl("GenomicRanges", installed.packages())) ) {
  install.packages("GenomicRanges")
}
library('GenomicRanges')
range <- as(gsub(",", ":", chr[[1]]), "GRanges") # http://web.mit.edu/~r/current/arch/i386_linux26/lib/R/library/GenomicRanges/html/GRanges-class.html
print(head(range))
#seqlevels(gr)
sum(width(range))/length(range) # средняя длина
#as.data.frame(range) - Granges to dataframe

mcols(range)$entrezgene_id <- chr[[2]]
grl = split(range, values(range)$entrezgene_id) #GRangesList
#table(elementLengths(grl))
merged = unlist(reduce(grl))#, min.gapwidth=100L) #unsplit(grl, values(range)$entrezgene_id)
prom <- promoters(merged) #flank
#export(prom, con="promoteromes.gtf", format="GTF")
# export(prom, con="promoteromes.bed", format="BED")
#motifs <- data.frame(chr=chr[[2]], ranges=range)# %>% subset(range, substr(X5,1,11) =="entrezgene:")
save(chr, file="chr.rd")#load("chr.rd")
mcols(prom)$entrezgene_id <- se
prom <- as.data.frame(prom)



# 6. Human Genome 19  promoters compare ----
# http://www.bioconductor.org/packages/release/data/annotation/manuals/BSgenome.Hsapiens.UCSC.hg19/man/BSgenome.Hsapiens.UCSC.hg19.pdf
if( !any(grepl("TxDb.Hsapiens.UCSC.hg19.knownGene", installed.packages())) ) {
  library(BiocInstaller)
  biocLite("TxDb.Hsapiens.UCSC.hg19.knownGene")
}
library(TxDb.Hsapiens.UCSC.hg19.knownGene)
txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene
promoters <- promoters(txdb)
sum(width(promoters))/length(promoters)

#ov <- findOverlaps(chr, promoters) # any type of overlap (start, end, within, equal)
# length(unique(queryHits(ov))) / length(promoters)
# length(unique(subjectHits(ov))) / length(promoters)
prom <- reduce(promoters, ignore.strand = FALSE)
peaks <- reduce(range)
both <- intersect(prom, peaks)
only.prom <- setdiff(prom, both)
only.peaks <- setdiff(peaks, both)
overlapMat <- matrix(0,, ncol = 2, nrow = 2)
colnames(overlapMat) <- c("in.peaks", "out.peaks")
rownames(overlapMat) <- c("in.promoters", "out.promoter")
overlapMat[1,1] <- sum(width(both))
overlapMat[1,2] <- sum(width(only.prom))
overlapMat[2,1] <- sum(width(only.peaks))
overlapMat[2,2] <- 1.5*10^9 - sum(overlapMat)
#round(overlapMat / 10^6, 2)
oddRatio <- overlapMat[1,1] * overlapMat[2,2] / (overlapMat[2,1] * overlapMat[1,2])
oddRatio


# 7. Seqs ----
if( !any(grepl("BSgenome.Hsapiens.UCSC.hg19", installed.packages())) ) {
  library(BiocInstaller)
  biocLite("BSgenome")
  biocLite("BSgenome.Hsapiens.UCSC.hg19")
}
library(BSgenome.Hsapiens.UCSC.hg19)
hg = BSgenome.Hsapiens.UCSC.hg19
print( c(organism(hg), providerVersion(hg), provider(hg), seqinfo(hg)) )

library(Biostrings)
pm_seq <-  getSeq(hg, merged)
writeXStringSet(pm_seq, file="hg19_promoters.mfa", format="fasta") #readDNAStringSet

