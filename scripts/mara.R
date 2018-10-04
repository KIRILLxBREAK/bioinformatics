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
M_inv <- s$v %*% diag(d_1) %*% t(s$u)
EA <- M_inv %*% as.matrix(dfE) #; rm(s)
save(EA, file='../data/temp_rdata/EA.rd')

# Regularisd regression ----
lambda <- 1  # regulirasation parameter
d_1_2 <- d / (d^2 + lambda) 
M_inv_1 <- s$v %*% diag(d_1_2) %*% t(s$u)
EA_1 <- M_inv_1 %*% as.matrix(dfE) #; rm(s)
save(EA_1, file='../data/temp_rdata/EA_1.rd')
