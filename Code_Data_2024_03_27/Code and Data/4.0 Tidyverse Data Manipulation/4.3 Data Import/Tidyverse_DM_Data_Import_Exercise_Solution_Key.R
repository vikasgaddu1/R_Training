

# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key


# CSV Files ---------------------------------------------------------------

# Exercise Step 4
library(tidyverse)

# Exercise Step 5
spec_csv(file = '_data/dm.csv')

# Exercise Step 6
dm_allvars <- readr::read_csv(file = '_data/dm.csv')

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
  file = '_data/dm.csv',
  col_names = TRUE,
  col_types = coldefs
)

# Keep only the variables in the definition.
dm_somevars <-
  dm_somevars[c("USUBJID", "SUBJID", "BRTHDTC", "AGE", "SEX", "RACE", "ARM")]

glimpse(dm_somevars)

# Exericse Step 10
write_csv(dm_somevars, file = 'dm_subset.csv')


# Excel files -------------------------------------------------------------

# Exercise Step 4
library(writexl)

# Exercise Step 6
sheet_list <-
  list(all_vars = dm_allvars,
       some_vars = dm_somevars)


# Exercise Step 7
write_xlsx(sheet_list,
           path = "dm_all_some.xlsx")

# Exercise Step 8
abc_data_dict <-
  readxl::read_excel("_data/study abc data dictionary.xlsx",
                     sheet = 1,
                     .name_repair = "universal")

# Exercise Step 9
write_xlsx(abc_data_dict,
           path = "abc_data_dict.xlsx")


# SAS data sets -----------------------------------------------------------

# Exercise Step 3
library(tidyverse)

# Exercise Step 4
library(haven)

# Exercise Step 5
dm_sasds <-
  read_sas(
    data_file = "_data/dm.sas7bdat",
    col_select = c("USUBJID", "SUBJID", "BRTHDTC", "AGE", "SEX", "RACE", "ARM")
  )

# Exericse Step 6
library(labelled)

# Exericse Step 7
var_label(dm_sasds$BRTHDTC) <- "Date of Birth"
var_label(dm_sasds$ARM) <- "Treatment Group"

# Exercise Step 8
dm_vl <- unlist(var_label(dm_sasds))

# Exercise Step 9
write_rds(dm_sasds, file = 'dm_r.rds')
