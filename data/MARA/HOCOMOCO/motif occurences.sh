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

# предподготовка pwm для sarus (замена пробелов на табы, удаление пустых строк, замена LF на CRLF)
for i in ${motifs}/*
do
results_file="$(basename $i).pwm"
cat $i | tr -s ' ' '\t' | sed -e '/^\s*$/d' | sed 's/$'"/`echo \\\r`/" > "${motifs}/$results_file"
done



# через файл и цикл globbing'ом 
#1 promoter's list
cat hg19_promoters.mfa | grep ">" > result.txt
for i in ${motifs1}/* #shell expansion (filename expansion)
do
    paste result.txt <(java -cp sarus.jar ru.autosome.SARUS hg19_promoters.mfa $i besthit | grep -v ">" | cut -f 1) > result.txt
done
# finish: remove all temporary



#debug
(echo "promoters"; cat hg19_promoters.mfa | grep ">") | tee result.log | paste -s -d ',' > result.txt
cat result.log result.txt
for i in ${motifs}/*.pwm #shell expansion (filename expansion)
do
(echo "$(basename $i .pwm)" ; java -cp sarus.jar ru.autosome.SARUS hg19_promoters.mfa $i besthit \
 | grep -v ">" | cut -f 1) | tee result2.txt | paste -s -d ',' >> result.txt
done
wc -l result.txt
head result.txt