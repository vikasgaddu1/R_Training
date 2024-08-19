# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)

# Exercise Step 2
# Code to build tibble data frames
demo <-
  tribble(
    ~study, ~patient, ~sex, ~dob,
    "Study A", 1, "M", parse_date('1988-08-12'),
    "Study A", 2, "F", parse_date('1984-02-02'),
    "Study B", 11, "M", parse_date('1986-01-11'),
    "Study B", 12, "F", parse_date('1987-07-01'))

trt <-
  tribble(
    ~study, ~patient, ~blindcode,
    "Study A", 1, "TRT A",
    "Study A", 3, "TRT B",
    "Study B", 11, "TRT A",
    "Study B", 13, "TRT B"
  )


# Exercise Step 3
ij_merge <-
  merge(demo, trt, by.x = c("study", "patient"), 
                   by.y = c("study", "patient"), 
                   all = F)

lj_merge <-
  merge(demo, trt, by.x = c("study", "patient"), 
                   by.y = c("study", "patient"), 
                   all.x = T)

rj_merge <-
  merge(demo, trt, by.x = c("study", "patient"), 
        by.y = c("study", "patient"), 
        all.y = T)

fj_merge <-
  merge(demo, trt, by.x = c("study", "patient"), 
                   by.y = c("study", "patient"), 
                   all = T)


# Exercise Step 4
ij_join <-
  inner_join(demo, trt, 
             by = c("study" = "study", 
                    "patient" = "patient"))

lj_join <-
  left_join(demo, trt, 
             by = c("study" = "study", 
                    "patient" = "patient"))


rj_join <-
  right_join(demo, trt, 
             by = c("study" = "study", 
                    "patient" = "patient"))


fj_join <-
  full_join(demo, trt, 
            by = c("study" = "study", 
                   "patient" = "patient"))

# Filter Joins:
# Semi Join: Remove rows from Left Side Data if no matching values in Right Side Data
# Anti Join: Determine which values in Left Side Data are not found in Right Side Data
sj_join <-
  semi_join(demo, trt, 
            by = c("study" = "study", 
                   "patient" = "patient"))

aj_join <-
  anti_join(demo, trt,
            by = c("study" = "study", 
                   "patient" = "patient"))

