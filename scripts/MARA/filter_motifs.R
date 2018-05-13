path_to_motif <- "../../analysis/motif.txt"
motifs <- read.table(path_to_motif, stringsAsFactors = F, header = T)
colnames(motifs) <- c("motif")

motif_suffix <- function(motif) {
  strsplit(motif, "_")[[1]][2]
}

motif_name <- function(motif) {
  sub('./', '', strsplit(motif, "_")[[1]][1])
}


motifs$name <- apply(motifs[1], 1, motif_name)
motifs$suffix <- apply(motifs[1], 1, motif_suffix)

suffix_score <- list(si=1, f1=2, f2=3, do=4)
motifs$suffix_score <- unlist(suffix_score[motifs$suffix])

suf <- sapply(  split(motifs, motifs$name) , function(x) min(as.numeric(unlist(x['suffix_score']))) )


motif_filterd <- data.frame(motif_name=names(suf), suffix_score=suf)
score_suffix <- list("1"="si", "2"="f1", '3'="f2", '4'="do")
motif_filterd$suffix <- unlist(score_suffix[motif_filterd$suffix_score])
motif_filterd$motif <-  paste(motif_filterd$motif_name, motif_filterd$suffix, sep="_")

path_to_filterd_motif <- "../../analysis/filter_motifs.txt"
fileConn<-file(path_to_filterd_motif)
writeLines(motif_filterd$motif, fileConn)
close(fileConn)
