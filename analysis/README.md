Can contain many smaller analyses — for example:
* analyzing the quality of raw sequences
* the aligner output
* the final data that will produce figures and tables for a paper. 

It allows collaborators to see these high-level analyses without having to dig deeper into subproject directories.

Files:
* motifx.txt - collection of all motifs in HOCOMOCO
* filter_motifs.txt - duplicates' filtered collection of motifs in HOCOMOCO
* overall_motifs.txt - motitfs and coresponded TFs with assoiation with entrezgene_id
* cluster_list.txt - list of promoters' clusters
* samples.txt - list of tisssues from FANTOM expression data

The _samples.txt_ contains all samples, and it has been devided into 2 parts:
* samples_test.txt  - contains replic 3 of samples
* samples_train.txt - contains all samples but replic 3
* samples_replic_train.txt - contains all samples with replic but replic 3

