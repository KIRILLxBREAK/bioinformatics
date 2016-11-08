def levDistanceWithWay(v, w):
    n = len(v)
    m = len(w)
    D = [[0] * (m+1) for i in range(n+1)] #list comprehension
    B = [[0] * (m+1) for i in range(n+1)] #backtracker
    for i in range(n+1):
        D[i][0] = i
        B[i][0] = "|"
    for j in range(m+1):
        D[0][j] = j
        B[0][j] = "-"
        
    for i in range(1, n+1):
        for j in range(1, m+1):
            k = (v[i-1]!=w[j-1])
            D[i][j] = D[i-1][j-1] + int(k)
            B[i][j] = "C"                                       # "C" - move diagonal
            if D[i][j] > D[i-1][j]+1:
                D[i][j] = D[i-1][j]+1
                B[i][j] = "|"                                   # "|" - move down
            if D[i][j] > D[i][j-1]+1:
                D[i][j] = D[i][j-1]+1
                B[i][j] = "-"                                   # "-" - move right
    print D[n][m]            
    return B

from Bio import SeqIO
fasta_sequences = SeqIO.parse(open("example.fasta"),'fasta')
name = []
sequence = []
for fasta in fasta_sequences:
    name.append(fasta.id)
    sequence.append(str(fasta.seq))
v = sequence[0]
w = sequence[1]

B = levDistanceWithWay(v, w)
#print B
i = len(B)-1
j = len(B[0])-1

while i!=0 and j!=0:
    if B[i][j] == "C":
        i -= 1
        j -= 1
    elif B[i][j] == "|":
        i -= 1
        str1 = w[:i]
        str2 = w[i:]
        w = str1 + '-' + str2
    else:
        j -= 1
        str1 = v[:j]
        str2 = v[j:]
        v = str1 + '-' + str2
    
print v
print w