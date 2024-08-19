
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2022 Anova Groups All rights reserved

# Title: Working with Data - Summarize Data

# Packages & Functions on Display:
# - {base  4.2.0}: max(), min(), sum(), mean(), summary(), nrow(), str(), is.na(),
# - {readr 2.1.2}: read_rds()
# - {dplyr 2.1.2}: glimpse(), summarize(), across(), where(), n(), n_distinct()


# Setup -------------------------------------------------------------------

# Load Packages
library(tidyverse)

# Load Data
df_vs <- read_rds("data/adslvs.rds") %>% print()


# Summaries in Base R -----------------------------------------------------

df_vs$age %>% max()
df_vs %>% summary()
df_vs %>% nrow()
df_vs %>% str()


# Summaries in Tidyverse --------------------------------------------------

df_vs %>% glimpse()
df_vs %>% summarize(avg_pulse = mean(aval_pulse))

# Intermediate Tidyverse --------------------------------------------------
# Using variables in subsequent operations

df_vs %>%
  summarize(
    n          = n(),
    n_missing  = sum(is.na(aval_temp)),
    n_distinct = n_distinct(aval_temp),
    avg_temp_c = mean(aval_temp, na.rm = T),
    avg_temp_f = avg_temp_c * (9/5) + 32,
    max_temp   = max(aval_temp, na.rm = T),
    min_temp   = min(aval_temp, na.rm = T))



# Advanced Tidyverse ------------------------------------------------------
# Summarizing across many variables at once

df_vs %>% summarize(across(where(is.numeric), mean))
df_vs %>% summarize(across(where(is.numeric), ~mean(., na.rm = T)))

df_vs %>%
  summarize(
    across(
      .cols = where(is.numeric),
      .fns  = c(varmean = mean,
                varsd   = sd,
                varmin  = min,
                varmax  = max))) %>%
  glimpse()



# Documentation -----------------------------------------------------------
# There are many functions that can be used inside summarize, see cheatsheet

# Vignettes
vignette("dplyr")
vignette("colwise")

# Help Pages
help("summarize")

# Website References
# - https://r4ds.had.co.nz/transform.html
# - https://www.rstudio.com/resources/cheatsheets/

# -------------------------------------------------------------------------
