Contains general project-wide scripts. 
If scripts contain many files (e.g., multiple Python modules), they should reside in their own subdirectory. Isolating scripts in their own subdirectory also keeps project directoriestidy while developing these scripts (when they produce test output files).

# 1. filter_motifs.R

# 2-4. Нормализация матриц
The matrix E_norm is obtained by subtracting the row and column averages from the entries of E.
Similarly, M_morm is obtained by sub- tracting the column averages, i.e., the average number of sites Mps for each motif m, from the entries of M.
Finally, the activities A_norm are obtained by subtracting the average motif activities Am across the samples from the activities Ams.
Files - `normalise_matrix_a.R`, `normalise_matrix_e.R`, `normalise_matrix_m.R`.

# 5. MARA.py
Realisation of MARA inference

```
E = M * EA

Mt = V*Dt*Ut

OLS: EA = (Mt*M)-1 * Mt * B
SVD: M = U*D*Vt => EA = (V*Dt*Ut*U*D*Vt)-1*V*Dt*Ut *B = (V*Dt*D*Vt)-1*V*Dt*Ut *B = #т.к. матррица U - унитарна
 = ( (DVt)t*(DVt) )-1*V*Dt*Ut *B = (V*(Dt*D)*Vt)-1*V*Dt*Ut *B = Vt-1*(Dt*D)-1*V-1*V*Dt*Ut *B =
 = V * (Dt*D)-1 * Dt *Ut * B = V * D-1 * Ut * B
```