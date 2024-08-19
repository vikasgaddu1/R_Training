# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)

# Exercise Step 2
# Code to build tibble data frame
demo <- 
  tribble(
    ~patient_id, ~sex, ~age, ~dob,
    1, "M", 34, as.Date("1988-02-02"),
    2, "F", 32, as.Date("1990-07-04"),
    3, "F", NA, NA,
    4, NA, 35, as.Date("1987-03-17"),
    5, "M", 34, as.Date("1988-04-01"),
    6, "F", 39, as.Date("1983-12-31"),
    7, "M", 44, as.Date("1978-12-24"),
    8, "F", 56, as.Date("1966-10-31"),
    9, "F", 25, as.Date("1997-05-05"),
    10, "M", 33, as.Date("1989-01-01"),
    11, "M", 19, as.Date("2003-12-25")
    )

# Exercise Step 3
demo3 <-
  demo %>% 
  select(patient_id, age)

# Exercise Step 4
demo4 <- 
  demo %>% 
  select(contains("e"))


# Exercise Step 5
demo5 <-
  demo %>% 
  filter(sex == "M")

# Exercise Step 6
demo6 <-
  demo %>% 
  filter(sex == "F" & age < 30)

# Exercise Step 7
demo7 <-
  demo %>% 
  filter(sex == "F" | age < 30)

# Exercise Step 8
demo8 <-
  demo %>% 
  slice_tail(n = 3) %>% 
  select(patient_id, age)

