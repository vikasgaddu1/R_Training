# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)

# Exercise Step 2
tb <- tibble(patient = c('001', '002', '003', '004', '005'), 
             arm     = c('TRTA', 'TRTB', 'TRTD', 'TRTC', 'TRTB'), 
             smoker  = c('Y', 'N', 'N', 'N', 'Y'))

# Exercise Step 3
tb2 <-
  tb %>% 
  mutate(arm = factor(arm, levels = (c("TRTA", "TRTB", "TRTC", "TRTD", "N/A"))))

# Exercise Step 4
table(tb$arm)
table(tb2$arm)
