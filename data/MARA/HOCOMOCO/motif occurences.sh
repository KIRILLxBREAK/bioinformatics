#!/bin/bash
set -e
set -u
set -o pipefail

# in /data/MARA/sarus

# как пользоваться сарусом
# java -cp sarus.jar ru.autosome.SARUS SP1_peaks.mfa SP1_example.pwm besthit > result.log
# java -jar sarus.jar SP1_peaks.mfa SP1_example.pwm besthit > result.log


# переменные
motifs=$"../HOCOMOCO/PWM"
motifs1=$"../HOCOMOCO/PWM1"

# предподготовка pwm для sarus (замена пробелов на табы, удаление пустых строк, замена LF на CRLF)
for i in ${motifs}/*
do
results_file="$(basename $i).pwm"
cat $i | tr -s ' ' '\t' | sed -e '/^\s*$/d' | sed 's/$'"/`echo \\\r`/" > "${motifs}/$results_file"
done




# debug
(echo "promoters" && echo "thresholds"; cat hg19_promoters.mfa | grep ">") | tee result.log | paste -s -d ',' > result.csv
cat result.log result.csv
for i in ${motifs}/*.pwm #shell expansion (filename expansion)
do
motifPath="$(basename $i .pwm)"
threshold="$(python3 motif_treshold_finding.py ${motifPath})"
(echo "${motifPath}" && echo "${threshold}" ; java -cp sarus.jar ru.autosome.SARUS hg19_promoters.mfa $i besthit \
 | grep -v ">" | cut -f 1 | sed 's/-Infinity/0/') | paste -s -d ',' >> result.csv
done
