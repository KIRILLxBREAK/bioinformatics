#!/usr/bin/python3

import os
import numpy as np
import pandas as pd
import sys

# in '/bioinformatics/data/sarus'
#print(os.getcwd())
motifThresholdPath = '../HOCOMOCO/HOCOMOCOv11_core_standard_thresholds_HUMAN_mono.txt'
#print(motifThresholdPath)

thresholds = pd.read_table(motifThresholdPath)
thresholds.columns = ['motif', '0.001', '0.0005', '0.0001']
thresholds['motif'] = thresholds['motif'].apply( lambda x: x.split("_")[0] )

print(thresholds.loc[thresholds['motif']==str(sys.argv[1]),'0.0001'].tolist()[0])