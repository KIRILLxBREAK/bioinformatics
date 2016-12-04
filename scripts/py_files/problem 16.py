# S = {A, B}, p = (0.5, 0.5)
A = [[0.754, 0.246], [0.352, 0.648]]
Q = "BABABAABABAAABBAABABBABBAABABABBBBABABBBAAAABBBBAB"

import collections
c = collections.Counter()
c['A'] = 0
c['B'] = 1

def pathProbability(s):
    p = 0.5
    pred = s[0]
    for i in range(1, len(s)):
        p *= A[c[s[i-1]]][c[s[i]]]
    return p

print pathProbability(Q)
