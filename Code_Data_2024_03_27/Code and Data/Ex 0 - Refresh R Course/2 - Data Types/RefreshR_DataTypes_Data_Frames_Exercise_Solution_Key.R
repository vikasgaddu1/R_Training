# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)

# Exercise Step 2
patient <- c('001', '002', '003', '004', '005')
sex     <- c('M', 'F', 'M', 'F', 'F')
smoker  <- c('Y', 'N', 'N', 'N', 'Y')

df <- data.frame(patient, sex, smoker)

# Exercise Step 2
tb <- tibble(patient, sex, smoker)


# Exercise Step 3
class(df)
class(tb)


# Exericise Step 4
tb_sub1 <- tb["patient"]
tb_sub2 <- tb$patient
