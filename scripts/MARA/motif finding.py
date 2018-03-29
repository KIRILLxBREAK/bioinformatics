import os
import numpy as np

# in '/bioinformatics/scripts/MARA/'

def motif_tresholds_binds(motif='AHR_si_thresholds.txt'):
    motifPath = '../../data/MARA/HOCOMOCO/HOCOMOCOv9_AD_thresholds_PWM_hg19/' + motif
    tresholds = np.genfromtxt(motifPath)
    return tresholds[5,0]

print(motif_tresholds_binds(motif='AIRE_f2_thresholds.txt'))

