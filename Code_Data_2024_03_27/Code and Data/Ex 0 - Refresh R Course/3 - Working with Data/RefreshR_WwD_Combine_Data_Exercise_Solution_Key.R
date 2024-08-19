# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)

# Exercise Step 2
# Code to build tibble data frames
demo <-
  tribble(
    ~study, ~inv, ~patient, ~sex, ~dob,
    "Study B", 2000, 1, "M", parse_date('1986-01-11'),
    "Study B", 2000, 2, "F", parse_date('1987-07-01'))

demo_add <- 
  tribble(
    ~study, ~inv, ~patient, ~sex, ~dob,
  "Study B", 2000, 3, "F", parse_date('1984-10-30'))

trt <- c("Placebo", "Active", NA)

# Exercise Step 3
demo_2 <-
  bind_rows(demo, demo_add)

# Exercise Step 4
demo_all <-
  bind_cols(demo_2, ARM = trt)
