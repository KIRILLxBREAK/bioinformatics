from suffix_tree import SuffixTree
stree = SuffixTree('TATATG')

for l in stree.leaves:
	print l.pathLabel 
