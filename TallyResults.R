setwd("~/Documents/CRCexample/results/") ### Set the working directory to the results folder

res <- lapply(list.files(), function(x){
    read.table(x,header = T)
})

res <- do.call(rbind,res)
rownames(res) <- 1:dim(res)[1] ### Just because

pValueAgg <- aggregate(res[,"p.value"],by = list(N = res[,"N"],d = res[,"d"],sigma = res[,"sigma"]), FUN = mean)

tStatisticAgg <- aggregate(res[,"statistic"],by = list(N = res[,"N"],d = res[,"d"],sigma = res[,"sigma"]), FUN = mean) 

decisionAgg  <- aggregate(res[,"decision"],by = list(N = res[,"N"],d = res[,"d"],sigma = res[,"sigma"]), FUN = mean) 


