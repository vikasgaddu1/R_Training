# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

# Exercise Step 3
library(tidyverse)
library(pwr)
library(effectsize)
library(haven)
library(broom)

# Exercise Step 4
ptt <- 
  pwr.t.test(
    n           = NULL,         
    d           = 0.75,         
    sig.level   = 0.10,         
    power       = 0.85,         
    type        = "two.sample", 
    alternative = "two.sided")  

plot(ptt)



# Exercise Step 5
pat <- 
  pwr.anova.test(k = 3, 
                 n = 30, 
                 f = .35, 
                 sig.level = 0.025, 
                 power = NULL)  

plot(pat)


# Exercise Step 6
pct <- 
  pwr.chisq.test(w = 0.2, 
                 df = (2 - 1)*(3 - 1), 
                 N = NULL, 
                 sig.level = 0.01,
                 power = 0.80)  

plot(pct)



# Exercise Step 7
bmi <-
  read_sas('data/abc_adam_advs.sas7bdat') %>% 
  filter(TRTA != "" & 
         PARAMCD == "BMI") %>% 
  select(SUBJID, TRTA, AVAL)


table(bmi$TRTA)

bmi %>% 
  group_by(TRTA) %>% 
  summarize(mean = mean(AVAL))

bmibytrta <-
  aov(AVAL ~ TRTA, data = bmi) 

tidy(bmibytrta)

bmibytrta %>% cohens_f() 


