
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2024 Anova Groups All rights reserved

# Course: Clinical Tables with 'gt'
# Lesson: Introduction

# Packages & Functions on Display:
# - {gt 0.10.0}: gt_preview, gt, opt_interactive


# Setup -------------------------------------------------------------------
# Load Packages

# Exercise step 1
library(tidyverse)
library(gt)

addv <-
  rx_addv |>
  select(USUBJID, TRTA, AGE, SEX, PARAMCD, AVAL) |>
  filter(PARAMCD == "PDANYM")

# Exercise step 2
addv |>
  gt_preview()

# Exercise step 3
addv |>
  gt_preview(top_n = 5,
             bottom_n = 3,
             incl_rownums = FALSE)

# Exercise step 4
addv |>
  gt()

# Exercise step 5
# a. Try use_search
rx_addv |>
  gt() |>
  opt_interactive(
    use_search           = TRUE,
    use_filters          = FALSE,
    use_resizers         = FALSE,
    use_highlight        = FALSE,
    use_text_wrapping    = FALSE,
    use_page_size_select = FALSE)

# b. Try use_filters
rx_addv |>
  gt() |>
  opt_interactive(
    use_search           = FALSE,
    use_filters          = TRUE,
    use_resizers         = FALSE,
    use_highlight        = FALSE,
    use_text_wrapping    = FALSE,
    use_page_size_select = FALSE)

# c. Try use_resizers
rx_addv |>
  gt() |>
  opt_interactive(
    use_search           = FALSE,
    use_filters          = FALSE,
    use_resizers         = TRUE,
    use_highlight        = FALSE,
    use_text_wrapping    = FALSE,
    use_page_size_select = FALSE)

# d. Try use_highlight
rx_addv |>
  gt() |>
  opt_interactive(
    use_search           = FALSE,
    use_filters          = FALSE,
    use_resizers         = FALSE,
    use_highlight        = TRUE,
    use_text_wrapping    = FALSE,
    use_page_size_select = FALSE)

# e. Try use_text_wrapping
rx_addv |>
  gt() |>
  opt_interactive(
    use_search           = FALSE,
    use_filters          = FALSE,
    use_resizers         = FALSE,
    use_highlight        = FALSE,
    use_text_wrapping    = TRUE,
    use_page_size_select = FALSE)

# f. Try use_page_size_select
rx_addv |>
  gt() |>
  opt_interactive(
    use_search           = FALSE,
    use_filters          = FALSE,
    use_resizers         = FALSE,
    use_highlight        = FALSE,
    use_text_wrapping    = FALSE,
    use_page_size_select = TRUE)

