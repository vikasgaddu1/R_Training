# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

# Exercise Step 4
library(tidyverse)

# Exercise Step 5
# Create a data frame called adae from the adae.rds data file in the course directory
adae <- base::readRDS('_data/adae.rds')
adae <- readr::read_rds('_data/adae.rds')

# Exercise Step 6
# using the pipe function to reduce the number of arguments to the
# subset function, output a subset of adae where AETERM is equal to 'HEADACHE'
# to the console
subset(adae, AETERM == "HEADACHE")
adae %>% subset(AETERM == "HEADACHE")

# Exercise Step 7
# using the pipe function to reduce the number of arguements to the
# subset function, output a subset of adae where AETERM is equal to 'HEADACHE'
# and create a data frame named adae_headache
adae_headaches <-
  adae %>% subset(AETERM == "HEADACHE")

