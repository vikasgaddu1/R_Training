
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2024 Anova Groups All rights reserved

# Course: Clinical Tables with 'gt'
# Lesson: Table Styles

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
  select(SUBJID, ADT, ADY, PARAMCD, AVAL, BASE, CHG) |>
  filter(SUBJID == "049" & (PARAMCD == "BMI" | PARAMCD == "TEMP"))


# Exercise step 2
advs |>
  gt() |>
  tab_header(title = "ADVS Listing") |>
  tab_footnote(footnote = "Confidential") |>
  cols_label(SUBJID = "Subject ID") |>
  tab_style(style = cell_borders(
    sides = "top",
    color = "blue"),
    locations = cells_body()) |>
  tab_style(style = cell_borders(
    sides = "right",
    color = "red"),
    locations = cells_body())

# Exercise step 3
advs |>
  gt() |>
  tab_header(title = "ADVS Listing") |>
  tab_footnote(footnote = "Confidential") |>
  cols_label(SUBJID = "Subject ID") |>
  tab_style(style = cell_borders(
    sides = "top",
    color = "blue"),
    locations = cells_body()) |>
  tab_style(style = cell_borders(
    sides = "right",
    color = "red"),
    locations = cells_body()) |>
  tab_style(
    style = cell_borders(
      weight = 2,
      sides  = "all",
      color  = "green"),
    locations = cells_title()) |>
  tab_style(
    style = cell_borders(
      weight = 2,
      sides  = "all",
      color  = "yellow"),
    locations = cells_footnotes())


# Exercise step 4
advs |>
  gt() |>
  tab_header(title = "ADVS Listing") |>
  tab_footnote(footnote = "Confidential") |>
  cols_label(SUBJID = "Subject ID") |>
  tab_style(style = cell_borders(
    sides = "top",
    color = "blue"),
    locations = cells_body()) |>
  tab_style(style = cell_borders(
    sides = "right",
    color = "red"),
    locations = cells_body()) |>
  tab_style(
    style = cell_borders(
      weight = 2,
      sides  = "all",
      color  = "green"),
    locations = cells_title()) |>
  tab_style(
    style = cell_borders(
      weight = 2,
      sides  = "all",
      color  = "yellow"),
    locations = cells_footnotes()) |>
  tab_style(
    style = list(
      cell_fill(color  = "red"),
      cell_text(color  = 'white', weight = "bold")),
    locations = cells_body(
      columns = CHG,
      rows = CHG >= .1))


# Exercise step 5
advs |>
  gt() |>
  tab_header(title = "ADVS Listing") |>
  tab_footnote(footnote = "Confidential") |>
  cols_label(SUBJID = "Subject ID") |>
  tab_style(style = cell_borders(
    sides = "top",
    color = "blue"),
    locations = cells_body()) |>
  tab_style(style = cell_borders(
    sides = "right",
    color = "red"),
    locations = cells_body()) |>
  tab_style(
    style = cell_borders(
      weight = 2,
      sides  = "all",
      color  = "green"),
    locations = cells_title()) |>
  tab_style(
    style = cell_borders(
      weight = 2,
      sides  = "all",
      color  = "yellow"),
    locations = cells_footnotes()) |>
  tab_style(
    style = list(
      cell_fill(color  = "red"),
      cell_text(color  = 'white', weight = "bold")),
    locations = cells_body(
      columns = CHG,
      rows = CHG >= .1)) |>
  tab_style(
    style = list(
      cell_fill(color  = "grey"),
      cell_text(color  = 'black', weight = "bold")),
    locations = cells_body(
      columns = everything(),
      rows = PARAMCD == "BMI"))



# Exercise step 6
advs |>
  gt() |>
  tab_header(title = "ADVS Listing") |>
  tab_footnote(footnote = "Confidential") |>
  cols_label(SUBJID = "Subject ID") |>
  tab_style(style = cell_borders(
    sides = "top",
    color = "blue"),
    locations = cells_body()) |>
  tab_style(style = cell_borders(
    sides = "right",
    color = "red"),
    locations = cells_body()) |>
  tab_style(
    style = cell_borders(
      weight = 2,
      sides  = "all",
      color  = "green"),
    locations = cells_title()) |>
  tab_style(
    style = cell_borders(
      weight = 2,
      sides  = "all",
      color  = "yellow"),
    locations = cells_footnotes()) |>
  tab_style(
    style = list(
      cell_fill(color  = "red"),
      cell_text(color  = 'white'),
      cell_text(weight = "bold")),
    locations = cells_body(
      columns = CHG,
      rows = CHG >= .1)) |>
  tab_style(
    style = list(
      cell_fill(color  = "grey"),
      cell_text(color  = 'black'),
      cell_text(weight = "bold")),
    locations = cells_body(
      columns = everything(),
      rows = PARAMCD == "BMI")) |>
  data_color(
    columns = AVAL,
    target_columns = AVAL,
    palette = "viridis")


