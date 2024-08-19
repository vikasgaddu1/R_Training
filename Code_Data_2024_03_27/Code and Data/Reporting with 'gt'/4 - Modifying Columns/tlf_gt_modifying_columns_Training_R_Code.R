
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2024 Anova Groups All rights reserved

# Course: Clinical Tables with 'gt'
# Lesson: Modifying Columns

# Packages & Functions on Display:
# - {gt       0.10.1}:  gt, tab_spanner, cols_merge, tab_info, cols_merge_n_pct,
#                      fmt_percent
# - {labelled 0.12.0}:  get_variable_labels


# Setup -------------------------------------------------------------------

# Load the packages necessary for this lesson.
library(gt)
library(tidyverse)
library(labelled)

# Data
# rx_adsl is a sample ADaM data frame that is included in the gt package.
# Let's filter it down to just a few variables and rows and save it as
# a data frame called adsl.
adsl <-
  rx_adsl |>
  select(TRTA, SEX, AGE, BLBMI) |>
  filter(BLBMI < 35 & !is.na(TRTA))


# Modifying Columns -------------------------------------------------------

# You'll notice by default, gt will grab any existing column labels and apply
# them to the column header
adsl |> gt()


# We can see embedded labels with 'labelled' package
adsl |> get_variable_labels()


# We can change these labels using 'cols_label'
adsl |>
  gt() |>
  cols_label(
    TRTA  = "Treatment (Actual)",
    SEX   = "Sex",
    AGE   = "Age (yrs)",
    BLBMI = "BMI")

# We can also add labels that span over multiple columns using tab_spanner()
adsl |>
  gt() |>
  cols_label(
    TRTA  = "Treatment (Actual)",
    SEX   = "Sex",
    AGE   = "Age (yrs)",
    BLBMI = "BMI") |>
  tab_spanner(
    label   = "Demographics",
    columns = c(SEX, AGE)) |>
  tab_spanner(
    label   = "Measurement",
    columns = BLBMI)



# Merging Columns ---------------------------------------------------------

# The gt package also has the cols_merge() function for merging columns
# together. The resulting column will be the name of the first column in the
# merge.
adsl |>
  gt() |>
  cols_merge(
    columns = c(SEX, AGE)) |>
  cols_label(
    TRTA  = "Treatment (Actual)",
    SEX   = "Sex Age",
    BLBMI = "BMI")


# We can add the pattern argument to format the resulting merged column. Here we
# separate the SEX and AGE variables with a slash.
adsl |>
  gt() |>
  cols_merge(
    columns = c(SEX, AGE),
    pattern = "{1} / {2}") |>
  cols_label(
    TRTA  = "Treatment (Actual)",
    SEX   = "Sex / Age",
    BLBMI = "BMI")


# We can add the pattern argument to format the resulting merged column. Here we
# put the AGE values in parentheses.
adsl |>
  gt() |>
  cols_merge(
    columns = c(SEX, AGE),
    pattern = "{1} ({2})") |>
  cols_label(
    TRTA  = "Treatment (Actual)",
    SEX   = "Sex (Age)",
    BLBMI = "BMI")


# A variation of the cols_merge() function is the cols_merge_n_pct(). The
# fmt_percent() function helps us with formatting for the percentage.
adsl |>
  group_by(TRTA, SEX) |>
  summarize(
    n       = n(),
    frac    = n / nrow(adsl),
    .groups = "drop") |>
  gt() |>
  fmt_percent(frac, decimals = 1) |>
  cols_merge_n_pct(
    col_n   = n,
    col_pct = frac) |>
  cols_label(n = "n (%)")



# Table Info --------------------------------------------------------------

# Our gt tables are beginning to get a little more complex. One handy function
# to know about is tab_info(). This function will return a description of your
# current table information.

adsl |>
  gt() |>
  cols_merge(
    columns = c(SEX, AGE),
    pattern = "{1} ({2})") |>
  cols_label(
    TRTA = "Treatment (Actual)",
    SEX = "Sex (Age)",
    BLBMI = "BMI") |>
  tab_info()


# Documentation -----------------------------------------------------------

# Help Pages
help("tab_info",         "gt")
help("cols_merge",       "gt")
help("tab_spanner",      "gt")
help("fmt_percent",      "gt")
help("cols_merge_n_pct", "gt")

# Website References
# https://gt.rstudio.com/articles/gt.html
# -------------------------------------------------------------------------
