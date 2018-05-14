#!/bin/bash
set -e
set -u
set -o pipefail


motifs=$"PWM"
motifs1=$"PWM1"

# предподготовка pwm для sarus (замена пробелов на табы, удаление пустых строк, замена LF на CRLF)
for i in ${motifs}/*
do
results_file="$(basename $i).pwm"
cat $i | tr -s ' ' '\t' | sed -e '/^\s*$/d' | sed 's/$'"/`echo \\\r`/" > "${motifs1}/$results_file"
done