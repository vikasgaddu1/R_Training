
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
library(haven)

advs <-
  read_sas('_data/abc_adam_advs.sas7bdat') |>
  mutate(dt = Sys.time() + ADY*3600*24 + ADY*60 + ADY,
         frac_chg = AVAL/BASE,
         pct_chg = 100*(AVAL / BASE)) |>
  select(SUBJID, ADT, ADY, dt, PARAMCD, AVAL, BASE, CHG, pct_chg, frac_chg) |>
  filter(SUBJID == "049" & ADY < 50 & (PARAMCD == "BMI" | PARAMCD == "TEMP"))


# Exercise step 2
info_date_style()


# Exercise step 3
advs |>
  select(SUBJID, ADT) |>
  gt() %>%
  fmt_date(
    columns    = ADT,
    date_style = "day_m_year")

# Exercise step 4
info_time_style()


# Exercise step 5
# Part a.
advs |>
  select(SUBJID, dt) |>
  gt() %>%
  fmt_datetime(
    columns    = dt,
    date_style = "yMd",
    time_style = "h_m_p")

# Exercise step 5
# Part b.
advs |>
  select(SUBJID, dt) |>
  gt() %>%
  fmt_datetime(
    columns    = dt,
    format = "%d/%m/%Y %H:%M")


# Exercise step 6
# Part a.
advs |>
  select(SUBJID, ADY) |>
  gt() |>
  fmt_integer(
    columns = ADY,
    pattern = "Day {x}")


# Exercise step 6
# Part b.
advs |>
  select(SUBJID, ADY) |>
  gt() |>
  fmt_integer(
  rows    = ADY < 0,
  columns = ADY,
  scale_by = -1,
  pattern = '{x} day(s) (pre-baseline).') |>
  fmt_integer(
    rows    = ADY == 1,
    columns = ADY,
    pattern = 'Baseline!') |>
  fmt_integer(
    rows    = ADY > 1,
    columns = ADY,
    pattern = 'Day {x}')



# Exercise step 7
# Part a.
advs |>
  select(SUBJID, pct_chg) |>
  gt() |>
  cols_label(pct_chg = "% CFB") |>
  fmt_number(
    columns  = pct_chg,
    decimals = 3,
    pattern  = "{x}%")


# Exercise step 7
# Part b.
advs |>
  select(SUBJID, frac_chg) |>
  gt() |>
  cols_label(frac_chg = "% CFB") |>
  fmt_percent(frac_chg, decimals = 3)


# Exercise step 8
advs |>
  select(SUBJID, CHG) |>
  gt() |>
  sub_missing(
    columns = CHG,
    missing_text = "missing")
