# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

# Load the Tidyverse package.
library(tidyverse)

# Exercise Step 4
# Read in the adae rds file from the course directory.
adae <- readRDS('data/adae.rds')

# Exercise Step 5
# adae[c('SUBJID', 'TRTEDT', 'TRTSDT', 'AETERM)]
# Create a 70% random sample of the data frame adae and name the resulting data frame adae_ss.
adae_ss <-
  select(adae, "SUBJID", 'AETERM', contains("DT")) %>%
  slice_sample(prop = 0.7)

# Exercise Step 6
# create variables days_duration = TRTEDT - TRTSDT and ae_duration = AEENDTC - AESTDTC
adae_ss$days_duration <- adae_ss$TRTEDT - adae_ss$TRTSDT

adae_ss$ae_duration <-
  as.Date(adae_ss$AEENDTC) - as.Date(adae_ss$AESTDTC)

# Exercise Step 7
# pipe the following operations together
# relocate the duration variables you just calculated to be right after the variables used in the calculations.
# filter the data to only include records with adverse events that last more than 10 days
# sort the data by SUBJID and descending ae_duration.
adae_ss <- adae_ss %>%
  relocate(days_duration, .after = TRTEDT) %>%
  relocate(ae_duration, .after = AEENDTC) %>%
  filter(ae_duration > 10) %>%
  arrange(SUBJID, desc(ae_duration))


# Exercise Step 8
ae_list <-
  adae %>%
  distinct(AEBODSYS, AEHLGT, AEHLT, AETERM) %>%
  relocate(AEBODSYS, AEHLGT, AEHLT, AETERM) %>%
  arrange(AEBODSYS, AEHLGT, AEHLT, AETERM)

# Exercise Step 8.c
library(writexl)
write_xlsx(ae_list,
           path = "data/adae_aelist.xlsx")

