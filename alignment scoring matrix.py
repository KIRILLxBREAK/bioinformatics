from Bio.SubsMat import MatrixInfo
blosum = MatrixInfo.blosum62

def scoringLevDistance(v, w):
    n = len(v)
    m = len(w)
    D = [[0] * (m+1) for i in range(n+1)] #double dimension matrix (list comprehension)
    
    #first string and first column
    for i in range(n+1):
        D[i][0] = -i*5
    for j in range(m+1):
        D[0][j] = -j*5
        
    for i in range(1, n+1):
        for j in range(1, m+1):
            a = v[i-1]
            b = w[j-1]
            if (a,b) in blosum.keys():
                D[i][j] = max(D[i-1][j]-5, D[i][j-1]-5, D[i-1][j-1]+blosum[(a,b)])
                #print blosum[(a,b)]
            else:
                D[i][j] = max(D[i-1][j]-5, D[i][j-1]-5, D[i-1][j-1]+blosum[(b,a)])
                #print blosum[(b,a)]
    return D[n][m]

from Bio import SeqIO
fasta_sequences = SeqIO.parse(open("rosalind_glob.txt"),'fasta')
name = []
sequence = []
for fasta in fasta_sequences:
    name.append(fasta.id)
    sequence.append(str(fasta.seq))
v = sequence[0]
w = sequence[1]

S = scoringLevDistance(v, w)
print