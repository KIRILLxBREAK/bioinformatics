Here you can find several files demonstraring various
PWM formats to be used with the SPRY-SARUS:

1. SP1_example.dpwm - simple dinucleotide PWM to be used with di.SARUS
2. SP1_example_transposed.dpwm - transposed dinucleotide PWM to be used with di.SARUS with "transpose" modifier
3. SP1_dichipmunk_output.example - diChIPMunk output that can be directly supplied to di.SARUS as a PWM file
4. SP1_example.pwm - simpe mononucleotide PWM to be used with SARUS
5. SP1_peaks.mfa - an example test set of SP1 ChIP-Seq peaks in multifasta format

Please note, all provided matrices are PWMs (i.e. they are already log-transformed and contain additive weights).

In the current version you cannot directly supply frequency or count matrices to SARUS
(only weight matrices, e.g. log-odds transformed, are supported).

The nucleotide order for mono-PWMs is alphabetical A-C-G-T.
The dinucleotide order for di-PWMs is also alphabetical AA-AC-AG-..-TT.
