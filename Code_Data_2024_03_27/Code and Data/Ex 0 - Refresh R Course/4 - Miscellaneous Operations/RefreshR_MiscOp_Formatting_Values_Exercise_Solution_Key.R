# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

# Load Packages
library(fmtr)
library(scales)
library(tidyverse)


# Exercise Step 2
dm <- tribble(
  ~subjid, ~screendate, ~sex, ~age, ~smoker,
  1, as.Date("2022-11-01"), "M", 23, "Y",
  2, as.Date("2022-11-03"), "F", 29, "Y",
  3, as.Date("2022-10-31"), "F", 28, "N",
  4, as.Date("2022-10-29"), "M", 31, "N",
  5, as.Date("2022-11-01"), "F", 30, "N",
  6, as.Date("2022-11-04"), "M", 28, "N",
  7, as.Date("2022-11-02"), "F", NA, "N",
  8, as.Date("2022-10-30"), "F", 27, "N",
  9, as.Date("2022-10-29"), "M", 30, "N",
  10, as.Date("2022-11-01"), NA, 30, "N" 
  ) 

stats <- tribble(
  ~test_var, ~test_result, ~prob,
  "sex", 10.3, .001,
  "age", -5.4, .3,
  "smoker", 20007, .6
)
  
test_var_map <- c("sex"    = "Sex of Subject", 
                  "age"    = "Age of Subject", 
                  "smoker" = "Subject a Smoker Y/N")

# Exercise Step 3
stats_f <-
  stats %>% 
  mutate(test_var_f = fapply(test_var, test_var_map),
         test_result_f = number(test_result, big.mark = ",", accuracy = .01),
         prob_f = pvalue(prob, accuracy = .01))

