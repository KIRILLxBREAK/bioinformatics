#!/usr/local/bin/Rscript

load('../temp_rdata/df.rd')
chr <- df[, colnames(df)=="X1" | colnames(df)=="X2" | colnames(df)=="X5"] #%>% filter(substr(X5,1,11) =="entrezgene:")
rm(df)

if( !any(grepl("GenomicRanges", installed.packages())) ) {
  library(BiocInstaller)
  biocLite("GenomicRanges")
}
library(GenomicRanges)
range <- as(gsub(",", ":", chr[[1]]), "GRanges") # http://web.mit.edu/~r/current/arch/i386_linux26/lib/R/library/GenomicRanges/html/GRanges-class.html
#sum(width(range))/length(range) # средняя длина
mcols(range)$entrezgene_id <- paste(chr[[2]], chr[[3]], sep=';')
save(range, file='../temp_rdata/range.rd') ; rm(range) ; rm(chr)



if( !any(grepl("BSgenome.Hsapiens.UCSC.hg19", installed.packages())) ) {
  library(BiocInstaller)
  biocLite("BSgenome")
  biocLite("BSgenome.Hsapiens.UCSC.hg19")
}
library(BSgenome.Hsapiens.UCSC.hg19)
hg = BSgenome.Hsapiens.UCSC.hg19
print( c(organism(hg), providerVersion(hg), provider(hg), seqinfo(hg)) )


if( !any(grepl("Biostrings", installed.packages())) ) {
  library(BiocInstaller)
  biocLite("Biostrings")
}
library(Biostrings)
load('../temp_rdata/range.rd')
prom <- promoters(range); rm(range) #flunk
#sum(width(prom))/length(prom) # средняя длина
pm_seq <-  getSeq(hg, prom); save(prom, file='../temp_rdata/prom.rd'); rm(prom)
writeXStringSet(pm_seq, file="../seqs/hg19_promoters.mfa", format="fasta") #readDNAStringSet
rm(pm_seq) ; rm(hg)
#export(prom, con="../seqs/promoteromes.gtf", format="GTF")
#export(prom, con="../seqs/promoteromes.bed", format="BED")