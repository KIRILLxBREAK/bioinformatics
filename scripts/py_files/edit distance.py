from Bio import SeqIO
fasta_sequences = SeqIO.parse(open("rosalind_edit.txt"),'fasta')
name = []
sequence = []
for fasta in fasta_sequences:
    name.append(fasta.id)
    sequence.append(str(fasta.seq))
v = sequence[0]
w = sequence[1]

def levDistance(v, w):
    n = len(v)
    m = len(w)
    D = [[0] * (m+1) for i in range(n+1)] #double dimension matrix (list comprehension)
    
    #first string and first column
    for i in range(n+1):
        D[i][0] = i
    for j in range(m+1):
        D[0][j] = j
        
    for i in range(1, n+1):
        for j in range(1, m+1):
            k = (v[i-1]!=w[j-1]) #check if i-symbol in v = j-symbol in w
            D[i][j] = min(D[i-1][j]+1, D[i][j-1]+1, D[i-1][j-1]+int(k))
    print D[n][m]
   
levDistance(v,w)