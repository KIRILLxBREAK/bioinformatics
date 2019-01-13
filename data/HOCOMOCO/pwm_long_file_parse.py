#!/usr/bin/python3

import os
import numpy as np

# in '/data/MARA/HOCOMOCO/'
motifPath =  'HOCOMOCOv11_core_pwms_HUMAN_mono.txt'  #HOCOMOCOv9_AD_PLAINTEXT_V_PWM_hg19.txt'

if not os.path.exists('PWMv11'):
    os.makedirs('PWMv11')
    
file_obj = open(motifPath, 'r')
name = ''
data_list = list(file_obj)

file_pwm = open('PWMv11/' + data_list[0][1:].split('_')[0], 'w')
file_pwm.write(data_list[0].split('_')[0]  + '\n')

for i in range(1,len(data_list)):
    if data_list[i][:1] == '>':
        file_pwm.close()
        name = data_list[i][1:].split('_')[0] #.strip()
        file_pwm = open('PWMv11/' + name, 'w')
        s = data_list[i].split('_')[0]  + '\n'
    else:
    	s = data_list[i]
    file_pwm.write(s)

file_pwm.close()
