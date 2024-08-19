# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)

# Exercise Step 2
ints <- c(0:5)
dbls <- c(0, .5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5)

typeof(ints)
typeof(dbls)

length(ints)
length(dbls)

summary(ints)
summary(dbls)

range(ints) 
range(dbls)

vs <- 
  readRDS("./data/adslvs.rds") %>% 
  filter(avisitn == 2) %>% 
  select(subjid, age, base_temp) %>% 
  mutate(age_mean = mean(age),
         age_median = median(age),
         age_ntile = ntile(age, 5)) %>% 
  arrange(age_ntile, age)
