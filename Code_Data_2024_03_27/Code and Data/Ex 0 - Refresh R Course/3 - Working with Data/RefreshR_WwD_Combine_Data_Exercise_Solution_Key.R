# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Create a tibble data frame named demo with the following variables and values:
#   study: "Study B"
# inv: 2000
# patient: 1 and 2
# sex: "M" and "F"
# dob: "1986-01-11" and "1987-07-01"
# Then, create another tibble data frame named demo_add with the following variables and values:
#   study: "Study B"
# inv: 2000
# patient: 3
# sex: "F"
# dob: "1984-10-30"
# Next, combine the rows of demo and demo_add into a new tibble data frame named demo_2.
# Finally, create a vector trt with the values "Placebo", "Active", and NA, and bind 
# it as a new column named ARM to demo_2 to create a new tibble data frame named demo_all.

# Title: Solution Key

library(tidyverse)

# Exercise Step 2
# Create a tibble data frame
# Define a variable named study, inv, patient, sex and dob with values as follows
# 

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
