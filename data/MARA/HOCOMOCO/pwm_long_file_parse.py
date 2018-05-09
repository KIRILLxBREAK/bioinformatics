import os
import numpy as np

# in '/bioinformatics/scripts/MARA/HOCOMOCO/'
motifPath = '../../data/MARA/HOCOMOCO/HOCOMOCOv9_AD_PLAINTEXT_V_PWM_hg19.txt'

file_obj = open('HOCOMOCOv9_AD_PLAINTEXT_V_PWM_hg19.txt', 'r')
#file_obj.readline()

name = ''


#for line in file_obj:
#    if line[:2] == '> ':
#        file_obj.close()
#        name = line[2:].strip()
#        file_pwm = open(name, 'w')
#    file_obj.write(line)

data_list = list(file_obj)
file_pwm = open(data_list[0][2:].strip(), 'w')
for i in range(1,len(data_list)): 
    if data_list[i][:2] == '> ':
        file_pwm.close()
        name = data_list[i][2:].strip()
        file_pwm = open('PWM/' + name, 'w')
    file_pwm.write(data_list[i])



