# read file ----
setwd('/home/kirill/Documents/Projects/bioinformatics/bioinformatics/data/MARA/Fantom CAGE-hg19/')
# http://fantom.gsc.riken.jp/5/datafiles/phase2.0/extra/CAGE_peaks/hg19.cage_peak_phase1and2combined_tpm_ann.osc.txt.gz
# tail -n +1841 robust_phase1_pls_2.tpm.desc121113.osc.txt.gz.tmp | head -n 1
# 1 - 
# 2-
# 3- 
# 4- 
# 5- 
# 6- 
# 7- 
# 1838 - column namesss
# 1839 - 01STAT:MAPPED	
# 1840 - 02STAT:NORM_FACTOR
# 1841 - chr10:100013403..100013414,-
if( !any(grepl("readr", installed.packages())) ) {
  install.packages("readr")
}
library(readr)
df <- read_table2("robust_phase1_pls_2.tpm.desc121113.osc.txt.gz.tmp", col_names = FALSE, skip=1840, n_max = 100)
#problems(df)
df <- df[,1:100]


# parse TSS (transcription starting sites) ranges ----
chr <- df[[1]]
save(df, file="df.rd"); 
rm(df)#; load("df.rd") 
chr <- gsub(",", ":", chr) # меняем запятую на двоеточие
print(head(chr))

if( !any(grepl("GenomicRanges", installed.packages())) ) {
  install.packages("GenomicRanges")
}
library('GenomicRanges')
chr <- as(chr, "GRanges") # http://web.mit.edu/~r/current/arch/i386_linux26/lib/R/library/GenomicRanges/html/GRanges-class.html
print(head(chr))
sum(width(chr))/length(chr) # средняя длина
save(chr, file="chr.rd")#load("chr.rd") 



# Human Genome 19  promoters compare ----
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
peaks <- reduce(chr)
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


# Seqs ----
if( !any(grepl("BSgenome.Hsapiens.UCSC.hg19", installed.packages())) ) {
  library(BiocInstaller)
  biocLite("BSgenome")
  biocLite("BSgenome.Hsapiens.UCSC.hg19")
}
library(BSgenome.Hsapiens.UCSC.hg19)
hg = BSgenome.Hsapiens.UCSC.hg19
#organism(hg)
#providerVersion(hg)
#provider(hg)
#seqinfo(hg)
#hg[[25]]

library(Biostrings)
#matchPattern("GGCGC", hg[[25]])
#gr <- GRanges(c("chr1", "chr2"), IRanges(start=c(3, 4), width=10))
#seqlevels(gr)
pm_seq = getSeq(hg, chr)
writeXStringSet(pm_seq, file="hg19_promoters.fasta", format="fasta")
rm(ch)

# group by transcriptiom (matrix E), second branch ----
if( !any(grepl("dplyr", installed.packages())) ) {
  install.packages("dplyr")
}
library(dplyr)

load('df.rd')
#varNames <- paste('var', 1:1837)
df1 <-  df %>%  select(-X1, -X2, -X3, -X4, -X6, -X7) %>% filter(substr(X5,1,11) =="entrezgene:") %>%
group_by(X5)  %>%  summarise_all(sum, na.rm = TRUE)
rm('df.rd')
save(df1, 'df1.rds')

# group by transcriptiom (matrix M), first branch ----
load('df.rd')

chr <- df[, colnames(df)=="X1" | colnames(df)=="X5"]
chr %>% filter(substr(X5,1,11) =="entrezgene:")