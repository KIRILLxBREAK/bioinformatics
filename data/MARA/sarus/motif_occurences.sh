#!/bin/bash
set -e
set -u
set -o pipefail

# как пользоваться сарусом
# java -cp sarus.jar ru.autosome.SARUS SP1_peaks.mfa SP1_example.pwm besthit > result.log
# java -jar sarus.jar SP1_peaks.mfa SP1_example.pwm besthit > result.log


# переменные
motifs=$"../HOCOMOCO/PWM"
motifs1=$"../HOCOMOCO/PWM1"


(echo "promoters" && echo "thresholds"; cat "../../seqs/hg19_promoters.mfa" | grep ">") | paste -s -d ',' > result.csv
for i in ${motifs1}/*.pwm #shell expansion (filename expansion)
do
motifPath="$(basename $i .pwm)"
threshold="$(python3 motif_treshold_finding.py ${motifPath})"
(echo "${motifPath}" && echo "${threshold}" ; java -cp sarus.jar ru.autosome.SARUS "../../seqs/hg19_promoters.mfa" $i besthit \
 | grep -v ">" | cut -f 1 | sed 's/-Infinity/0/') | paste -s -d ',' >> result.csv
done
