#!/usr/bin/python3

import os
import numpy as np

# in '/data/MARA/HOCOMOCO/'
motifPath = 'HOCOMOCOv9_AD_PLAINTEXT_V_PWM_hg19.txt'

file_obj = open(motifPath, 'r')
name = ''
data_list = list(file_obj)

file_pwm = open(data_list[0][2:].strip(), 'w')
for i in range(1,len(data_list)): 
    if data_list[i][:2] == '> ':
        file_pwm.close()
        name = data_list[i][2:].strip()
        file_pwm = open('PWM/' + name, 'w')
    file_pwm.write(data_list[i])