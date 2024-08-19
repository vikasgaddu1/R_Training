# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)
library(writexl)
library(haven)
library(labelled)

# Exercise Step 2
patient <- c(1:5)
sex <- c("M", "F", "F", "F", "M")
age <- c(26, 29, 43, 36, 49)

demo_df <-
  data.frame(patient, sex, age)

# Exercise Step 3
# see current labels
var_label(demo_df)

# set new labels
var_label(demo_df) <- 
  list(patient = "Patient #", 
       sex     = "Gender",
       age     = "Age")

# see new labels
var_label(demo_df)

# Exercise Step 4
write_csv(demo_df, "data/demo_df.csv")

# Exercise Step 5
write_xlsx(demo_df, "data/demo_df.xlsx")

# Exercise Step 6
saveRDS(demo_df, "data/demo_df.rds")

# Exercise Step 7
demo_from_sas <- read_sas("data/dm.sas7bdat")

