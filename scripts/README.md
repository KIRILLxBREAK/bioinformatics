Contains general project-wide scripts. 
If scripts contain many files (e.g., multiple Python modules), they should reside in their own subdirectory. Isolating scripts in their own subdirectory also keeps project directoriestidy while developing these scripts (when they produce test output files).

```
E = M * EA

Mt = V*Dt*Ut

OLS: EA = (Mt*M)-1 * Mt * B
SVD: M = U*D*Vt => EA = (V*Dt*Ut*U*D*Vt)-1*V*Dt*Ut *B = (V*Dt*D*Vt)-1*V*Dt*Ut *B = #т.к. матррица U - унитарна
 = ( (DVt)t*(DVt) )-1*V*Dt*Ut *B = (V*(Dt*D)*Vt)-1*V*Dt*Ut *B = Vt-1*(Dt*D)-1*V-1*V*Dt*Ut *B =
 = V * (Dt*D)-1 * Dt *Ut * B = V * D-1 * Ut * B
```