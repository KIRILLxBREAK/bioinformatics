#!/usr/bin/python3

import numpy as np
import pandas as pd

# Matrix reading
M = pd.read_csv('../analysis/M.csv', index_col='motifs').values
E = pd.read_csv('../analysis/E.csv', header=None, index_col=0).values
A = pd.read_csv('../analysis/A.csv', header=None, index_col=0).values

np.save('M.npy', M)
np.save('E.npy', E)
np.save('A.npy', A)

U, D, Vt = np.linalg.svd(M, full_matrices=False)
D = np.diag(D)

from scipy import linalg
temp = np.dot( linalg.inv(D.T.dot(D)), D.T ).dot(U.T)
EA = np.dot(np.dot(Vt.T, temp), E)

ACT = EA/A

np.savetxt('act.csv', ACT, delimiter=',')
