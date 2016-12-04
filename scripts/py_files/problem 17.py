# S = {A, B}, E = {x, y, z}
A = [[0.194, 0.681, 0.125], [0.065, 0.073, 0.862]]
D = "xxyzyyyzyyxzzyxyyzyyyyyzyyxzxyxxyyyyyyxyxxyyzxxyzy"
Q = "ABABBAAAABABBABABAAAABBBABBABBAABBABABABABBABABAAB"

import collections
cx = collections.Counter()
cp = collections.Counter()

cx['x'] = 0
cx['y'] = 1
cx['z'] = 2

cp['A'] = 0
cp['B'] = 1


def outcomeProbability(D, Q):
    p  = 1
    for i in range(0, len(D)):
        p *= A[cp[Q[i]]][cx[D[i]]]
    return p

print outcomeProbability(D, Q)
