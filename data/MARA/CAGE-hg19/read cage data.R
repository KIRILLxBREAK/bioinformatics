# read file
setwd('/home/kirill/Documents/Projects/bioinformatics/data/MARA/')
if( !any(grepl("readr", installed.packages())) ) {
  install.packages("readr")
}
library(readr)
# http://fantom.gsc.riken.jp/5/datafiles/phase2.0/extra/CAGE_peaks/hg19.cage_peak_phase1and2combined_tpm_ann.osc.txt.gz
# tail -n +1841 robust_phase1_pls_2.tpm.desc121113.osc.txt.gz.tmp | head -n 1
df <- read_table2("robust_phase1_pls_2.tpm.desc121113.osc.txt.gz.tmp", skip=1839, n_max = 100)
#problems(df)

# parse TSS (transcription starting sites) ranges
chr <- df[[1]]
#save(chr, file="chr.rd"); load("chr.rd") 
print(chr)
chr = sapply(chr, function(y) gsub(",", ":", y))
if( !any(grepl("GenomicRanges", installed.packages())) ) {
  install.packages("GenomicRanges")
}
library('GenomicRanges')
chr = as(chr, "GRanges") # http://web.mit.edu/~r/current/arch/i386_linux26/lib/R/library/GenomicRanges/html/GRanges-class.html
print(head(chr))

# http://www.bioconductor.org/packages/release/data/annotation/manuals/BSgenome.Hsapiens.UCSC.hg19/man/BSgenome.Hsapiens.UCSC.hg19.pdf
if( !any(grepl("TxDb.Hsapiens.UCSC.hg19.knownGene", installed.packages())) ) {
  library(BiocInstaller)
  biocLite("TxDb.Hsapiens.UCSC.hg19.knownGene")
}
library(TxDb.Hsapiens.UCSC.hg19.knownGene)
txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene
promoters(txdb)



# Seqs
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