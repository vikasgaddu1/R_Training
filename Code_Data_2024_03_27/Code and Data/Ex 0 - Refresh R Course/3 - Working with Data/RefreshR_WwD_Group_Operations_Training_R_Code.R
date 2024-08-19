
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2022 Anova Groups All rights reserved

# Title: Working with Data - Group Operations

# Packages & Functions on Display:
# - {base  4.2.0}: aggregate()
# - {readr 2.1.2}: read_rds()
# - {dplyr 1.0.8}: group_by(), ungroup(), slice_max(), slice_sample(), summarize(),
#                 mutate(), transmute(), rowwise(), select(), contains(), where(),
#                 across(), c_across()


# Setup -------------------------------------------------------------------

# Load Packages
library(tidyverse)

# Load Data
df_vs <- read_rds("data/adslvs.rds") %>% print()


# Base R Group Operation  -------------------------------------------------

aggregate(
  df_vs[c("age", "base_resp")],
  by = list("group_level" = df_vs$arm),
  FUN = mean)


# Tidyverse Group Operations ----------------------------------------------

df_vs %>% group_by(arm)

df_vs %>%
  group_by(arm) %>%
  slice_max(base_pulse, with_ties = F)

df_vs %>%
  group_by(arm) %>%
  slice_sample(n = 2)

df_vs %>%
  group_by(arm) %>%
  summarize(mean_age = mean(age)) %>%
  ungroup()

df_vs %>%
  group_by(arm) %>%
  transmute(
    age            = age,
    mean_age       = mean(age),
    diff_from_mean = age - mean_age) %>%
  ungroup()


# Intermediate Group Operations -------------------------------------------
# Summarize can automatically remove all groups, or regroup

df_vs %>%
  group_by(arm, agegr1) %>%
  summarize(
    n          = n(),
    avg_temp_c = mean(aval_temp, na.rm = T),
    avg_temp_f = avg_temp_c * (9/5) + 32,
    max_temp   = max(aval_temp, na.rm = T),
    min_temp   = min(aval_temp, na.rm = T))


# Advanced Group Operations -----------------------------------------------
# Mutate or summarize across many variables, by group

df_vs %>%
  group_by(arm) %>%
  summarize(across(where(is.numeric), ~ mean(., na.rm = T)))


# Tidyverse - Shortcut
df_vs %>% count(arm)
df_vs %>% count(arm, agegr1)


# Row Wise Operations -----------------------------------------------------

df_vs %>%
  select(contains("aval_")) %>%
  rowwise() %>%
  mutate(
    horizontal_sum  = sum(c_across(cols = c(aval_resp, aval_temp))),
    horizontal_mean = mean(c_across(everything())))


# Documentation -----------------------------------------------------------

# Vignettes
vignette("rowwise")
vignette("grouping")

# Website References
# - https://r4ds.had.co.nz/transform.html
# - https://www.rstudio.com/resources/cheatsheets/

# -------------------------------------------------------------------------
