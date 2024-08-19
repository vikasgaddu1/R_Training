# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)
library(haven)

# Exercise Step 2
# Code to build tibble data frame
advs <- 
  read_sas("data/abc_adam_advs.sas7bdat") %>% 
  filter(PARAMCD == "PULSE" | PARAMCD == "TEMP" | PARAMCD == "RESP") %>% 
  select(SUBJID, TRTP, ADT, PARAMCD, AVAL, CHG)

# Exercise Step 3
advs_by_PARAMCD_firstdot <-
  advs %>%
  arrange(SUBJID, PARAMCD, ADT) %>% 
  group_by(SUBJID, PARAMCD) %>%
  slice_head(n = 1)

# Exercise Step 4
advs_by_PARAMCD_lastdot <-
  advs %>%
  arrange(SUBJID, PARAMCD, ADT) %>% 
  group_by(SUBJID, PARAMCD) %>%
  slice_tail(n = 1)

# Exercise Step 5
advs_summ_by_PARAMCD <-
  advs %>%
  group_by(PARAMCD, TRTP) %>% 
  summarize(n = n(),
            nCHG       = sum(!is.na(CHG)),
            n_missCHG  = sum(is.na(CHG)),
            minCHG     = min(CHG, na.rm = T),
            meanCHG    = mean(CHG, na.rm = T),
            medianCHG  = median(CHG, na.rm = T),
            maxCHG     = max(CHG, na.rm = T),
            sdCHG      = sd(AVAL, na.rm = T)
            )
