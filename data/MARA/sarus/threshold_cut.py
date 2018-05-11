#!/usr/bin/python3

import os
import numpy as np
import pandas as pd

# in '/bioinformatics/data/MARA/sarus'
#print(os.getcwd())

#M = np.loadtxt('result.csv', delimiter=",", dtype=np.unicode_)
df = pd.read_csv('result.csv', index_col='promoters')
#df.set_index(['promoters'], inplace=True)

print(df.shape)
print(df.head(10))
print(df['>entrezgene:60495.4'].dtype)
df = df.mask(df.lt(df['thresholds'], axis=0), 0)
#df.iloc[:,1:] = df.iloc[:,1:].apply(lambda x: np.where(x > df.thresholds, x, 0), axis=0)

cols = df.columns.values.tolist()
cols.insert(0, "motifs")

df = df.reset_index()
M = df.values
M = M.T
df = pd.DataFrame(M, index=cols)
#np.insert(M, 0, np.array(cols), axis=1)
print(df.head(10))
df.to_csv('test.csv', sep=',')
#np.savetxt('test.txt', M)#, delimiter=',')  