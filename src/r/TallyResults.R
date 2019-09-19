setwd("../res/") ### Set the working directory to the results folder

library(tidyverse)

res <- lapply(list.files(), function(x){
    read.table(x,header = T)
})

do.call(rbind,res) %>%
  data.frame() %>%
  as_tibble() -> res

res %>%
  select(-rep) %>% 
  group_by(N, sigma, alph, d) %>%
  summarize_all(list(mean = mean, var = var)) -> res_summary

res_summary %>%
  ggplot(aes(x = N, y = decision_mean, shape = as.factor(d), linetype = as.factor(sigma))) +
  geom_point() +
  geom_line() +
  theme_bw()

res_summary %>%
  ggplot(aes(x = N, y = statistic_mean, shape = as.factor(d), linetype = as.factor(sigma))) +
  geom_point() +
  geom_line() +
  theme_bw()
