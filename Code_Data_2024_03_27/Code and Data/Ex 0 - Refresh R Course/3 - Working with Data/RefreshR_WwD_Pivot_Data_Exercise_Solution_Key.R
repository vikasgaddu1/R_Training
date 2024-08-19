# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)

# Exercise Step 2
# Code to build tibble data frames
vs_horizontal <- tribble(
  ~patient, ~visit, ~pulse, ~bps, ~bpd, ~resp,
  1,        "Week_1", 78, 120, 78, 14,
  1,        "Week_2", 75, 121, 75, 15,
  2,        "Week_1", 68, 130, 85, 16,
  2,        "Week_2", 65, 132, 88, 17)

vs_vertical <- tribble(
  ~patient, ~visit, ~paramcd, ~aval,
  1,        "Week_1", "pulse", 78,
  1,        "Week_1", "bps", 120,
  1,        "Week_1", "bpd", 78,
  1,        "Week_1", "resp", 14,
  1,        "Week_2", "pulse", 75,
  1,        "Week_2", "bps", 121,
  1,        "Week_2", "bpd", 75,
  1,        "Week_2", "resp", 15,
  2,        "Week_1", "pulse", 68,
  2,        "Week_1", "bps", 130,
  2,        "Week_1", "bpd", 85,
  2,        "Week_1", "resp", 16,
  2,        "Week_2", "pulse", 65,
  2,        "Week_2", "bps", 132,
  2,        "Week_2", "bpd", 88,
  2,        "Week_2", "resp", 17)

# Exercise Step 3
vs_h_to_v <-
  vs_horizontal %>%
  pivot_longer(
    cols      = c("pulse", "bps", "bpd", "resp"),
    names_to  = "vs_measure",
    values_to = "vs_value")

vs_vertical == vs_h_to_v

# Exercise Step 4
vs_v_to_h <-
  vs_vertical %>%
  pivot_wider(
    names_from   = paramcd,
    values_from  = aval,
    id_cols      = c(patient, visit))

vs_horizontal == vs_v_to_h

