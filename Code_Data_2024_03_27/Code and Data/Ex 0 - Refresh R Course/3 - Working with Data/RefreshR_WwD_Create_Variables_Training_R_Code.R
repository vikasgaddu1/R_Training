
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2022 Anova Groups All rights reserved

# Title: Working with Data - Create Variables

# Packages & Functions on Display:
# - {base    4.2.0}: paste(), mean(), ifelse()
# - {readr   2.1.2}: read_rds()
# - {dplyr   1.0.8}: select(), contains(), mutate(), transmute(), across(), everything(), where()
# - {stringr 1.4.0}: str_glue()


# Setup -------------------------------------------------------------------

# Load Packages
library(tidyverse)

# Load Data
df_tidy <- read_rds("data/adslvs.rds")
df_base <- df_tidy


# The Basics --------------------------------------------------------------

## Base R ----
df_base$tempf_1 <- df_base$aval_temp * 9
df_base$tempf_2 <- df_base$tempf_1   / 5
df_base$tempf_3 <- df_base$tempf_2   + 32
df_base$TEMPF_4 <- paste(df_base$tempf_3, "(F)")

df_base %>% select(contains("temp"), contains("TEMP"))


## Tidyverse ----
df_tidy %>%
  mutate(
    tempf_1 = aval_temp * 9,
    tempf_2 = tempf_1   / 5,
    tempf_3 = tempf_2   + 32,
    TEMPF_4 = paste(tempf_3, "(F)")) %>%
  select(contains("temp"), contains("TEMP"))

df_tidy %>%
  mutate(tempf = paste(aval_temp * (9/5) + 32, "(F)")) %>%   # Do it all at once
  select(contains("temp"))


# Intermediate Tidyverse --------------------------------------------------
# Using variables in subsequent operations

df_tidy %>%
  select(subjid, arm, sex, age, base_pulse) %>%
  mutate(
    mean_overall   = mean(base_pulse),
    diff_from_mean = base_pulse - mean(base_pulse),
    diff_label     = ifelse(diff_from_mean < 0, "below", "above"),
    diff_string    = str_glue("The value pulse {base_pulse} is {diff_label} the mean"))


# Advanced Tidyverse ------------------------------------------------------
# Transmute combines mutate, select, rename, relocate into a single function

df_tidy %>%
  transmute(
    subjid,
    arm,
    age,
    sex_ind   = ifelse(sex == "Male", 0, 1),
    temp_base = base_temp,
    temp_aval = aval_temp,
    temp_f    = paste(temp_aval * (9/5) + 32, "(F)"))


# Mutate across many columns at once
df_tidy %>% mutate(across(.cols = everything(),      .fns = as.character))
df_tidy %>% mutate(across(.cols = where(is.numeric), .fns = as.character))
df_tidy %>% mutate(across(.cols = contains("temp"),  .fns = ~ paste(., "(C)")))
df_tidy %>% mutate(across(.cols = contains("temp"),  .fns = ~ (. * 9 / 5) + 32))


# Documentation -----------------------------------------------------------
# There are many functions that can be used inside mutate, transmute, filter, etc.

# Vignettes
vignette("dplyr")
vignette("colwise")
vignette("window-functions")

# Help Pages
help(mutate)

# Website References
# - https://r4ds.had.co.nz/transform.html
# - https://www.rstudio.com/resources/cheatsheets/

# -------------------------------------------------------------------------
