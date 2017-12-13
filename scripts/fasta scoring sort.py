from Bio import SeqIO

D = []
S = {}
for seq_record in SeqIO.parse("fasta_example.fasta", "fasta"):
    print(seq_record.id, len(seq_record))
    print(repr(seq_record.seq))
    D.append(str(seq_record.seq))
    S[str(seq_record.id)]= str(seq_record.seq)

print(len(S))

mat = {('A', 'A'): 1, ('A', 'T'): 0.5, ('A', 'G'): 0.1, ('A', 'C'): 0.1,
    ('T', 'A'): 0.5, ('T', 'T'): 1, ('T', 'G'): 0.1, ('T', 'C'): 0.1,
    ('G', 'A'): 0.1, ('G', 'T'): 0.1, ('G', 'G'): 1, ('G', 'C'): 0.5,
    ('C', 'A'): 0.1, ('C', 'T'): 0.1, ('C', 'G'): 0.5, ('C', 'C'): 1}

indel= 0.5 

def scoringLevDistance(v, w, is_print=False):
    n = len(v)
    m = len(w)
    D = [[0] * (m+1) for i in range(n+1)] #double dimension matrix (list comprehension)
    opt = [[0] * (m+1) for i in range(n+1)] # 1 = right, 2 = down, 3 = diag, 0 = diag non subst

    #first column just indel
    for i in range(n+1):    
        D[i][0] = -i*indel # D[i-1][0]-indel
        opt[i][0] = 2; # just go down
    
    #first string just indel
    for j in range(1,m+1):
        D[0][j] = -j*indel # D[0][j-1]-indel
        opt[0][j] = 1; # just go right
        
    for i in range(1, n+1):
        for j in range(1, m+1):
            a = v[i-1]
            b = w[j-1]
            
            D[i][j] = D[i-1][j-1]+mat[(a,b)]
            if a==b:
                opt[i][j] = 0 # NO SUBSTITUTE   
            else:
                opt[i][j] = 3 # DIAGONAL
            if (D[i][j] < D[i-1][j]-indel):
                D[i][j] = D[i-1][j]-indel
                opt[i][j] = 2 # DOWN
            if (D[i][j] < D[i][j-1]-indel):
                D[i][j] = D[i][j-1]-indel
                opt[i][j]= 1 # RIGHT


    i=len(v)
    j=len(w)
    alignedV=""
    alignedW=""
    while i>0 or j>0:
        if opt[i][j] == 0: #"no subst":
            alignedV+=v[i-1]
            alignedW+=w[j-1]
            i-=1
            j-=1
        elif opt[i][j] == 3: #"diag":
            alignedV+=v[i-1]
            alignedW+=w[j-1].lower()
            i-=1
            j-=1
        elif opt[i][j] == 1:#"right":
            #print(i-1, v, i, j)
            alignedV+="-"
            alignedW+=w[i-1]
            j-=1
        elif opt[i][j] == 2:#"down":
            alignedW+= "-"
            alignedV+=v[j-1]
            i-=1

    if (is_print):        
        #print(alignedV[::-1])
        print(alignedW[::-1])
        #print(D[n][m])
        #print(D)
        #print(opt)
    return D[n][m]

seqNominal = "TAAACAATTTACCCAACCTC" # seqNominal = input()
print("seqNominal: ", seqNominal)
#print(scoringLevDistance(seqNominal, S['seq0']))

dictScore =  {key: scoringLevDistance(seqNominal, S[key]) for key in S} # dictionary comprehension
print(dictScore)
sortDictScore = {key: dictScore[key] for key in sorted(dictScore, key=dictScore.get, reverse=False)}
print(sortDictScore)

for k in sortDictScore:
    print(k)
    scoringLevDistance(seqNominal, S[k], True)
    print()
