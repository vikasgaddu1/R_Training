
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2020 Anova Groups All rights reserved

# Title: Tidyverse Capstone

# Packages & Functions on Display:
# - {dplyr 1.0.1}: count, summarize, mutate, group_by, left_join, bind_rows
# - {tidyr 1.1.0}: pivot_wider, pivot_longer
# - {haven 2.3.0}: read_sas


# Setup -------------------------------------------------------------------

# Load Packages
library(tidyverse)
library(haven)

# Load Data
data_demo <-
  read_sas("dm.sas7bdat")


# Data Validation ---------------------------------------------------------

data_demo %>% glimpse()
data_demo %>% count(ARM)

data_clean <-
  data_demo %>%
  filter(ARM != "SCREEN FAILURE")


# Continuous Summary ------------------------------------------------------

continuous_totals <-
  data_clean %>%
  summarize(AGE_N           = sprintf("%.f", n()),
            `AGE_Mean (SD)` = sprintf("%.1f (%.1f)", mean(AGE, na.rm = TRUE), sd(AGE, na.rm = TRUE)),
            AGE_Median      = sprintf("%.1f", median(AGE, na.rm = TRUE)),
            AGE_Range       = paste(min(AGE), max(AGE), sep = " - "),
            `AGE_Q1 - Q3`   = paste(quantile(AGE, 0.25), quantile(AGE, 0.75), sep = " - ")) %>%
  print()

continuous_groups <-
  data_clean %>%
  group_by(ARM) %>%
  summarize(AGE_N           = sprintf("%.f", n()),
            `AGE_Mean (SD)` = sprintf("%.1f (%.1f)", mean(AGE, na.rm = TRUE), sd(AGE, na.rm = TRUE)),
            AGE_Median      = sprintf("%.1f", median(AGE, na.rm = TRUE)),
            AGE_Range       = paste(min(AGE), max(AGE), sep = " - "),
            `AGE_Q1 - Q3`   = paste(quantile(AGE, 0.25), quantile(AGE, 0.75), sep = " - ")) %>%
  print()


# Continuous Summary - Pivot ----------------------------------------------

continuous_totals_long <-
  continuous_totals %>%
  pivot_longer(cols = everything(),
               names_to = c("var", "label"),
               names_sep = "_",
               values_to = "Total") %>%
  print()

continuous_groups_long <-
  continuous_groups %>%
  pivot_longer(cols = -ARM,
               names_to = c("var", "label"),
               names_sep = "_",
               values_to = "value") %>%
  print()


# Pivot Tables - Wide
continuous_groups_wide <-
  continuous_groups_long %>%
  pivot_wider(names_from = ARM,
              values_from = value,
              names_repair = "universal") %>%
  print()


# Continuous Summary - Join -----------------------------------------------

continuous_summary <-
  continuous_groups_wide %>%
  left_join(continuous_totals_long, by = c("var", "label")) %>%
  print()


# Categorical Summary - Totals --------------------------------------------

categorical_race_total <-
  data_clean %>%
  count(RACE) %>%
  mutate(var = "RACE",
         p = n / sum(n),
         Total = sprintf("%5d (%5.1f%%)", n, 100*p)) %>%
  rename(label = RACE) %>%
  arrange(-n) %>%
  select(var, label, Total) %>%
  print()


categorical_sex_total <-
  data_clean %>%
  count(SEX) %>%
  mutate(var = "SEX",
         p = n / sum(n),
         Total = sprintf("%5d (%5.1f%%)", n, 100*p)) %>%
  rename(label = SEX) %>%
  arrange(-n) %>%
  select(var, label, Total) %>%
  print()


categorical_total <-
  bind_rows(categorical_race_total, categorical_sex_total) %>%
  print()


# Categorical Summary - Groups --------------------------------------------

categorical_race_group <-
  data_clean %>%
  count(ARM, RACE) %>%
  mutate(var = "RACE",
         p = n / sum(n),
         Total = sprintf("%5d (%5.1f%%)", n, 100*p)) %>%
  rename(label = RACE) %>%
  arrange(-n) %>%
  select(ARM, var, label, Total) %>%
  print()

categorical_sex_group <-
  data_clean %>%
  count(ARM, SEX) %>%
  mutate(var = "SEX",
         p = n / sum(n),
         Total = sprintf("%5d (%5.1f%%)", n, 100*p)) %>%
  rename(label = SEX) %>%
  arrange(-n) %>%
  select(ARM, var, label, Total) %>%
  print()


# Pivot Tables - Wide
categorical_race_wide <-
  categorical_race_group %>%
  pivot_wider(names_from   = ARM,
              values_from  = Total,
              names_sort   = TRUE,
              names_repair = "universal",
              values_fill  = sprintf("%5d (%5.1f%%)", 0, 0)) %>%
  print()

categorical_sex_wide <-
  categorical_sex_group %>%
  pivot_wider(names_from   = ARM,
              values_from  = Total,
              names_sort   = TRUE,
              names_repair = "universal",
              values_fill  = sprintf("%5d (%5.1f%%)", 0, 0)) %>%
  print()


# Categorical Summary - Combined ------------------------------------------

categorical_groups <-
  bind_rows(categorical_sex_wide, categorical_race_wide) %>%
  print()


# Join Tables
categorical_summary <-
  categorical_groups %>%
  left_join(categorical_total, by = c("var", "label")) %>%
  print()


# Complete Summary Table --------------------------------------------------

complete_summary <-
  continuous_summary %>%
  bind_rows(categorical_summary) %>%
  print()

View(complete_summary)


# Documentation -----------------------------------------------------------

# Vignettes
vignette("dplyr",     package = "dplyr")
vignette("pivot",     package = "tidyr")
vignette("grouping",  package = "tidyr")
vignette("two-table", package = "tidyr")

# Website References
# https://dplyr.tidyverse.org
# https://github.com/tidyverse/dplyr
# https://rstudio.com/resources/cheatsheets/

# -------------------------------------------------------------------------
