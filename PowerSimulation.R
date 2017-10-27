library(parallel)

i <- as.numeric(Sys.getenv("SGE_TASK_ID")) ### Get the task ID
nCores <- as.numeric(Sys.getenv("NSLOTS")) ### Get the number of alloted cores

print(nCores)

if(is.na(i)) i <- 1 # for testing
if(is.na(nCores)) i <- 4 # for testing

################################################################################
### Variable Conditions
################################################################################

conditions <- expand.grid(N=c(20,50,100,200,500), sigma=c(1,2,3,4), d = c(0,.01,.05,.1,.2,.5,.75,1))

cond <- conditions[i, ]
N <- cond[,"N"]
sigma <- cond[,"sigma"]
d <- cond[,"d"]


################################################################################
### Fixed Conditions
################################################################################
alph <- .05

################################################################################
### Simulation Function
################################################################################

do.one <- function(rep,N,sigma,d,alph){
    x1 <- rnorm(n = N, mean = 0,sd = sigma)
    x2 <- rnorm(n = N, mean = d/sigma,sd = sigma)
    mean(x1)
    mean(x2)
    out <- t.test(x1,x2)
    p.value <- out["p.value"]
    t.statistic <- out["statistic"]
    decision <- ifelse(p.value < alph,1,0)
    return(data.frame(rep = rep,N = N,
                      sigma = sigma,
                      d = d,
                      alph = alph,
                      p.value = p.value,
                      t.statistic = t.statistic,
                      decision = decision))
}


################################################################################
### Parallelized Simulation
################################################################################

nreps <- 100
res <- mclapply(1:nreps, do.one, N = N, sigma = sigma, d = d, alph = alph, mc.cores=nCores)

res <- do.call(rbind,res)

################################################################################
### Write Results
################################################################################

### Make Sure this folder exits!!!!
### saveRDS may be preferable
write.table(res, file=paste0(getwd(),"/results/res_", i, ".txt"))
