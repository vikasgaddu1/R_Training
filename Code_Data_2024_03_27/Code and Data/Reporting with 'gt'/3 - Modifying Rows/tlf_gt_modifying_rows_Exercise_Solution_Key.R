
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2024 Anova Groups All rights reserved

# Course: Clinical Tables with 'gt'
# Lesson: Modifying Rows

# Packages & Functions on Display:
# - {gt 0.10.0}: gt_preview, gt, opt_interactive


# Setup -------------------------------------------------------------------
# Load Packages

# Exercise step 1
library(tidyverse)
library(gt)

addv <-
  rx_addv |>
  select(USUBJID, TRTA, AGE, SEX, PARAMCD, PARAM, AVAL) |>
  filter(PARAMCD == "PDANYM")


# Exercise step 2
addv |>
  gt(rowname_col = 'USUBJID')


# Exercise step 3
addv |>
  gt(rowname_col = 'USUBJID') |>
  tab_stubhead('Subject ID')

# Exercise step 4
# Part a.
addv |>
  gt(groupname_col = 'TRTA')

# Exercise step 4
# Part b.
addv |>
  gt(groupname_col = 'TRTA',
     row_group_as_column = TRUE)

# Exercise step 4
# Part c.
addv |>
  gt(groupname_col = 'TRTA',
     row_group_as_column = TRUE) |>
  tab_stubhead('Actual Treatment')

# Exercise step 5
# Part a.
addv_summ <-
  addv |>
  arrange(TRTA, SEX, PARAMCD, PARAM, AVAL) |>
  group_by(TRTA, SEX, PARAMCD, PARAM, AVAL) |>
  summarize(
    Mean_Age   = mean(AGE),
    Count = n()) |>
    mutate(Prot_Violation =
             case_when(AVAL == 0 ~"No Major Protocol Violation",
                       AVAL == 1 ~ "At Least One Protocol Violation")) |>
    ungroup() |>
    select(TRTA, SEX, Prot_Violation, Mean_Age, Count)


# Exercise step 5
# Part b.
addv_summ |>
  gt(groupname_col = c('TRTA', 'SEX'))

# Exercise step 5
# Part c.
addv_summ |>
  arrange(TRTA, SEX) |>
  mutate(
    SEX =
      case_when(
        lag(SEX) == SEX ~ "",
        .default = SEX),
    TRTA =
      case_when(
        lag(TRTA) == TRTA  ~ "",
        .default = TRTA)) |>
  gt()
