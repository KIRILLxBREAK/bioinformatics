def TreeCreation(S):
	S = S + "$"
	nodes = []
	nodes.append(0)
    nodes.append(-1) 					# nodes[1] = -1
    edges = []
    edges.append("$")  					# esges[0] = "$"
    for i in range(1, len(S)-1):
    	suf = S[i:]
    	j = 0
    	cur_node = 0
    	isAdded = False

    	while !isAdded:
    		to_node = −1
    		for k in nodes[cur_node]:
    			if suf[j] == edges[k][0]:
    				to_node = k

    		if to_node == −1:
    			nodes.append([−1]) 		# Добавляем новый лист
    			edges.append(suf[j:]) 	# Ребро к новому листу
    			nodes[cur_node].append(len(nodes)−1) 			# Ссылка на новый
    			isAdded = True
    		else:
    			for p in range(1, len(edges[to_node])−1):
					if suf[j + p]! = edges[to_node][p]:
						nodes.append([−1]) 						# Добавляем новый лист
						edges.append(suf[j+p:]) 				# Ребро к новому листу
						nodes.append([to_node, len(nodes)−1]) # Внутренний узел
						edges.append(edges[to_node][:p]) 		# Ребро к узлу
 						# Обновить ссылку из текущего на внутренний
						nodes[cur_node].remove(to_node)
						nodes[cur_node].append(len(nodes)−1)
						edges[to_node] = edges[to_node][p:] 	# Обновить ребро
						isAdded = True
 						break
 				j += len(edges[to_node])
 				cur_node = to_node		

	return [nodes, edges]

def LeavesLabel(i, nodes, edges, suff):
    suff += edges[i]
    if nodes[i][0] == -1:
        print suff
        return suff
    lCount = 0
    for k in nodes[i]:
        suff += + LeavesLabel(k, nodes, edges, suff)
    return suff

file_obj = open('example_utf8.txt', 'r')
s = file_obj.readline()
nodes, edges = TreeCreation(s)
LeavesLabel(0, nodes, edges, "")