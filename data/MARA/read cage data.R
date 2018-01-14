setwd('/home/kirill/Documents/Projects/bioinformatics/data/MARA/')

if( !any(grepl("readr", installed.packages())) ) {
  install.packages("readr")
}
library(readr)

# http://fantom.gsc.riken.jp/5/datafiles/phase2.0/extra/CAGE_peaks/hg19.cage_peak_phase1and2combined_tpm_ann.osc.txt.gz
# tail -n +1838 robust_phase1_pls_2.tpm.desc121113.osc.txt.gz.tmp | head -n 1
df = read_table2("robust_phase1_pls_2.tpm.desc121113.osc.txt.gz.tmp", skip=1837, n_max = 10)

#problems(df)
