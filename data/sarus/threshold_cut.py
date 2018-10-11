#!/usr/bin/python3

import os
import numpy as np
import pandas as pd

df = pd.read_csv('../../analysis/csv/result.csv', index_col='promoters')
#df.set_index(['promoters'], inplace=True)

df = df.mask(df.lt(df['thresholds'], axis=0), 0)    # обнулить все значения ниже порога
#df.iloc[:,1:] = df.iloc[:,1:].apply(lambda x: np.where(x > df.thresholds, x, 0), axis=0)

cols = df.columns.values.tolist()
cols.insert(0, "motifs")
df = df.reset_index()
df.drop(['thresholds'], axis=1, inplace=True)

print(df.shape)
df.to_pickle('df.pkl') #pd.read_pickle('foo.pkl')



# сделать фильтрацию (оставить только f1 и si)
"""df['suffix'] = df['promoters'].apply(lambda x: x.split('_')[1])
df['prom'] = df['promoters'].apply(lambda x: x.split('_')[0])
df2 = df.iloc[:, -2:].copy()
suffix_score = {"si" : 1, "f1" : 2, "f2" : 3, "do" : 4}
suffix_score_obr = {"1" : "si", "2" : "f1", "3" : "f2", "4" : "do"}
df2['suffix_score'] = df2['suffix'].map(suffix_score)
#print(df2.head(10))
grouped = df2['suffix_score'].groupby(df['prom'])
df3 = grouped.min()
df3 = df3.to_frame().reset_index()
suffix_score_obr = {1 : "_si", 2 : "_f1", 3 : "_f2", 4 : "_do"}
df3["suffix"] = df3['suffix_score'].map(suffix_score_obr)
df3['promoters'] = df3['prom'] + df3['suffix']
promoters_list = df3['promoters'].tolist()"""

overall_motifs_path = '../../analysis/filter_motifs.txt'
#overall_motifs_path = '../../analysis/overall_motifs.txt'
overall_motifs = pd.read_csv(overall_motifs_path)
promoters_list = overall_motifs['motif'].tolist()

# список промотеров в файле
"""with open("promoters_list.txt", 'w') as f:
    for s in promoters_list:
        f.write(str(s) + '\n')"""

df = df[df.promoters.isin(promoters_list)]
#df = df.set_index(['promoters'])
"""df.drop(['suffix','prom'], axis=1, inplace=True)"""


M = df.values
M = M.T
print(M.shape)
cols.remove('thresholds')#; cols.remove('motifs')
#print(len(cols))
df = pd.DataFrame(M, index=cols)
#print(df.head(10))

df.to_csv('../../analysis/csv/M.csv', sep=',', header=False)
