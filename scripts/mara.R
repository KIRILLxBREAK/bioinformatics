#!/usr/local/bin/Rscript

# Matrix reading ----
load('../data/temp_rdata/dfA_norm.rd')
load('../data/temp_rdata/dfE_norm.rd')
load('../data/temp_rdata/dfM_norm.rd')


# SVD ----
s <- svd(dfM) ; rm(dfM)
d <- s$d

# Ordinary regression ----
d_1 <- 1/d
M_inv <- s$v %*% diag(d_1) %*% t(s$u) ; rm(d_1)
EA <- M_inv %*% as.matrix(dfE) ; rm(M_inv)
save(EA, file='../data/temp_rdata/EA.rd') ; rm(EA)

# Regularisd regression ----
lambda <- 1  # regulirasation parameter
d_1_2 <- d / (d^2 + lambda) ; rm(lambda)
M_inv_1 <- s$v %*% diag(d_1_2) %*% t(s$u) ; rm(d_1_2)
EA_1 <- M_inv_1 %*% as.matrix(dfE) ; rm(M_inv_1)
save(EA_1, file='../data/temp_rdata/EA_1.rd') ; rm(EA_1)

rm(s) ; rm(d) ; rm(dfE)
