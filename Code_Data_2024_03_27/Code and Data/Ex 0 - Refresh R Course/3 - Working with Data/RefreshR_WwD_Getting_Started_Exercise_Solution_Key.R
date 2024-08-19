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
    4, NA, 35, as.Date("1987-03-17")
  )

# Exercise Step 3
glimpse(demo)
nrow(demo)
ncol(demo)
colnames(demo)
attributes(demo)

# Exercise Step 4
print(demo)
View(demo)


# Exercise Step 5
demo_sorted <-
  demo %>% 
  arrange(sex, age) %>% 
  rename(gender = sex) %>% 
  relocate(gender, .after = last_col()) %>% 
  print()

