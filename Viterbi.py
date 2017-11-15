def Viterbi(A, B, p, D):
	V = [] # Массив для хранения наиболее вероятных путей
	T = [] # Массив для хранения направлений перехода
	for s in range(0, k − 1):
	V [0, s] ← π[s] ∗ B[D[0], s]
	for n in range(1, N):
		for t ← 0, k − 1 do
			V [n, t] ← max s (V [n − 1, s] ∗ A[s, t]) ∗ B[D[n], t]
			T [n, t] ← argmax s (V [n − 1, s] ∗ A[s, t])
	S← argmax s (V [N, s])
	return T, Ss
