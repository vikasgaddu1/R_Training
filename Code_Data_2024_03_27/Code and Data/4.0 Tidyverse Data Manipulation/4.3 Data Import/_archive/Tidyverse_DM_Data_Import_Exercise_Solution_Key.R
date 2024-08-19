

# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

# Exercise Step 4
library(tidyverse)

# Exercise Step 5
spec_csv(file = 'data/dm.csv')

# Exercise Step 6
dm_allvars <- readr::read_csv(file = 'data/dm.csv')

# Exercise Step 8
glimpse(dm_allvars)

# Exercise Step 9
# Exercise Step 9.b
coldefs <-
  cols(
    USUBJID   = col_character(),
    SUBJID    = col_integer(),
    BRTHDTC   = col_date(format = ""),
    AGE       = col_integer(),
    SEX       = col_factor(levels = c("M", "F", include_na = TRUE)),
    RACE      = col_character(),
    ARM       = col_character()
  )

# Exercise Step 9.a
dm_somevars <- read_csv(
  file = 'data/dm.csv',
  col_names = TRUE,
  col_types = coldefs
)

# Keep only the variables in the definition.
dm_somevars <-
  dm_somevars[c("USUBJID", "SUBJID", "BRTHDTC", "AGE", "SEX", "RACE", "ARM")]

# Exericse Step 10
write_csv(dm_somevars, file = 'data/dm_subset.csv')

glimpse(dm_somevars)


# Exercise Step 12
library(writexl)

# Exercise Step 13
write_xlsx(dm_somevars,
           path = "data/dm_subset.xlsx")

# Exercise Step 14
library(haven)

# Exercise Step 15
dm_sasds <-
  read_sas(
    data_file = "data/dm.sas7bdat",
    col_select = c("USUBJID", "SUBJID", "BRTHDTC", "AGE", "SEX", "RACE", "ARM")
  )

# Exericse Step 16
library(labelled)

# Exericse Step 17
var_label(dm_sasds$BRTHDTC) <- "Date of Birth"
var_label(dm_sasds$ARM) <- "Treatment Group"

# Exercise Step 18
dm_vl <- unlist(var_label(dm_sasds))

# Exercise Step 19
write_rds(dm_sasds, file = 'data/dm_r.rds')
