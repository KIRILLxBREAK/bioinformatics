def heapsort(lst):
    ''' Heapsort. Note: this function sorts in-place (it mutates the list). '''
    # in pseudo-code, heapify only called once, so inline it here
    for start in range(int(len(lst)/2), -1, -1):#range(int((len(lst)-2)/2), -1, -1):
        siftdown(lst, start, len(lst)-1)
 
    for end in range(len(lst)-1, 0, -1):
        lst[end], lst[0] = lst[0], lst[end]
        siftdown(lst, 0, end-1)
    return lst
 
def siftdown(lst, start, end):
    root = start
    while True:
        child = root * 2 + 1
        if child > end: break
        if child + 1 <= end and lst[child] < lst[child + 1]:
            child += 1
        if lst[root] < lst[child]:
            lst[root], lst[child] = lst[child], lst[root]
            root = child
        else:
            break

from Bio import SeqIO

D = []
for seq_record in SeqIO.parse("fasta_example.fasta", "fasta"):
    print(seq_record.id, len(seq_record))
    print(repr(seq_record.seq))
    D.append(str(seq_record.seq))

print(heapsort(D))
