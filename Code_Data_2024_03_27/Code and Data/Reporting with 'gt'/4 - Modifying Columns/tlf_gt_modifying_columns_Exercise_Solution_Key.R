
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2024 Anova Groups All rights reserved

# Course: Clinical Tables with 'gt'
# Lesson: Modifying Columns

# Packages & Functions on Display:
# - {gt 0.10.0}: gt_preview, gt, opt_interactive


# Setup -------------------------------------------------------------------
# Load Packages

# Exercise step 1
library(tidyverse)
library(gt)

# May need to install latest version of labelled package.
library(labelled)

addv_pdanym <-
  rx_addv |>
  select(USUBJID, TRTA, AGE, SEX, PARAMCD, AVAL) |>
  filter(PARAMCD == "PDANYM" &
           (substr(USUBJID, 1, 5) == 'GT100' |
            substr(USUBJID, 1, 5) == 'GT109')) |>
  select(USUBJID, TRTA, AGE, SEX, AVAL)


# Exercise step 2
addv_pdanym |>
  get_variable_labels()


# Exercise step 3
addv_pdanym |>
  gt() |>
  cols_label(USUBJID = "Subject ID",
             TRTA    = "Treatment",
             AGE     = "Age",
             SEX     = "Sex",
             AVAL    = md("Any Major<br> Protocol Violations")
            )

# Exercise step 4
addv_pdanym |>
  gt() |>
  cols_label(USUBJID = "Subject ID",
             TRTA    = "Treatment",
             AGE     = "Age",
             SEX     = "Sex",
             AVAL    = md("Any Major<br> Protocol Violations")) |>
  tab_spanner(label   = "Demographics",
              columns = c(SEX, AGE))

# Exercise step 5
addv_pdanym |>
  gt() |>
  cols_merge(
    columns = c(SEX, AGE),
    pattern = "{1} [{2}]") |>
  cols_label(USUBJID = "Subject ID",
             TRTA    = "Treatment",
             SEX     = "Sex [Age]",
             AVAL    = md("Any Major<br> Protocol Violations"))


# Exercise step 6
# Part a.
addv_pdanym_summ <-
  addv_pdanym |>
  mutate(apv = case_when(AVAL == 0 ~ "No",
                         AVAL == 1 ~ "Yes"),
         apvf = factor(apv, levels = c("No", "Yes"))) |>
  group_by(TRTA, SEX, apvf) |>
  summarize(
    mean_age = mean(AGE),
    n       = n(),
    frac    = n / nrow(addv_pdanym),
    .groups = "drop") |>
  ungroup() |>
  mutate(TRTA = case_when(TRTA == lag(TRTA) ~ "",
                          .default = TRTA),
         SEX  = case_when(SEX == lag(SEX) ~ "",
                          .default = SEX)
         )

# Exercise step 6
# Part b.
addv_pdanym_summ |>
  gt() |>
  cols_merge_n_pct(
    col_n   = n,
    col_pct = frac) |>
  cols_label(n = "n (%)")

# Exercise step 6
# Part c.
addv_pdanym_summ |>
  gt() |>
  fmt_percent(frac, decimals = 1) |>
  cols_merge_n_pct(
    col_n   = n,
    col_pct = frac) |>
  cols_label(n = "n (%)")

