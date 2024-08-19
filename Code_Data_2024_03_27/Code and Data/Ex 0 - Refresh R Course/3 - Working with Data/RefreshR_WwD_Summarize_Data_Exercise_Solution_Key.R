# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)
library(haven)

# Exercise Step 2
# Code to build tibble data frame
pulse <- 
  read_sas("data/abc_adam_advs.sas7bdat") %>% 
  filter(PARAMCD == "PULSE") %>% 
  select(SUBJID, AVISIT, AVAL)


# Exercise Step 3
summary(pulse)

# Exercise Step 4
pulse_summ <-
  pulse %>% 
  summarize(n = n(),
            nAVAL       = sum(!is.na(AVAL)),
            n_missAVAL  = sum(is.na(AVAL)),
            minAVAL     = min(AVAL, na.rm = T),
            meanAVAL    = mean(AVAL, na.rm = T),
            medianAVAL  = median(AVAL, na.rm = T),
            maxAVAL     = max(AVAL, na.rm = T),
            sdAVAL      = sd(AVAL, na.rm = T)
            )
  
