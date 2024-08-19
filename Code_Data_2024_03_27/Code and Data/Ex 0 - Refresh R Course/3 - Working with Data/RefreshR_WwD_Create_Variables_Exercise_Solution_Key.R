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
demo2 <-
  demo %>% 
  mutate(study = "Study A",
         sex_full = ifelse(sex == "M", "Male", "Female"),
         century  = ifelse(dob <= as.Date("2000-01-01"), "1900", "2000"),
         dog_age = age*7,
         about_me = str_glue("I am a {sex_full} and am {age} years old."))

# Exercise Step 4
demo3 <-
  demo %>% 
  transmute(study = "Study A",
            sex_full = ifelse(sex == "M", "Male", "Female"),
            century  = ifelse(dob <= as.Date("2000-01-01"), "1900", "2000"),
            dog_age = age*7,
            about_me = str_glue("I am a {sex_full} and am {age} years old."),
            patient_id)

# Exercise Step 5
demo4 <-
  demo %>% 
  transmute(patient_id,
            age,
            age_bucket = case_when(age < 35 ~ "< 35",
                                   age >=35 & age <=40 ~ "35-40",
                                   age > 40 ~ "Over 40",
                                   TRUE ~ as.character(NA)))
