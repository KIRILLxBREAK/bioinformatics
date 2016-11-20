def LeavesCount(i, nodes):
    if nodes[i][0] == -1:
        return 1
    lCount = 0
    for k in nodes[i]:
        lCount = lCount + LeavesCount(k, nodes)
    return lCount