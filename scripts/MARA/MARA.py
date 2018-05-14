import numpy as np
import pandas as pd

# Matrix reading
M = pd.read_csv('../../analysis/M.csv', index_col='motifs').values
E = pd.read_csv('../../analysis/E.csv', header=None, index_col=0).values
A = pd.read_csv('../../analysis/A.csv', header=None, index_col=0).values