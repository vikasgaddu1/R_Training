
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2020 Anova Groups All rights reserved

# Title: Joining Data

# Packages & Functions on Display:
# - {dplyr 1.0.0}: bind_rows, bind_cols, left_join, right_join, inner_join,
#                 full_join, semi_join, anti_join


# Setup -------------------------------------------------------------------

library(tidyverse)

# Function Pipeline -------------------------------------------------------
# Pipe Operator: %>%

# Use:
# - function(x, y)
# - x %>% function(y)

# Keyboard Shortcut:
# -     Mac:  Cmd + Shift + M
# - Windows: Ctrl + Shift + M


# Documentation
help("%>%", package = "magrittr")


# Load Data ---------------------------------------------------------------

data_demo <- demo_studyb <- tribble(
  ~study, ~inv, ~patient, ~visit, ~screendate, ~sex, ~race, ~dob, ~treatment
  ,"StudyB", 2000, 1, 0, parse_date('2020-02-19'), "M", "White",            parse_date('1986-01-11'), "Active"
  ,"StudyB", 2000, 2, 0, parse_date('2020-02-19'), "F", "African American", parse_date('1987-07-01'), "Placebo"
)


data_vistrt <- tribble(
  ~patient, ~visit, ~trtdate, ~trttime
  ,1, 1, parse_date("2020/02/26"), parse_time("13:00")
  ,1, 2, parse_date("2020/03/04"), parse_time("14:00")
  ,1, 3, parse_date("2020/03/11"), parse_time("13:30")
)


data_ae <- tribble(
  ~PATID, ~VISTN, ~aeraw,        ~aedtstart,  ~aedtstop,   ~aeserious, ~aeongoing, ~soc_term
  ,1, 1, "HEART PALPITATIONS",    "2020/02/18", "2020/02/18",  "NO", "NO", "Cardiac Disorders"
  ,1, 2, "HEART RACING",          "2020/02/25", "2020/02/25", "YES", "NO", "Cardiac Disorders"
  ,1, 2, "DEATH",                 "2020/02/26", "2020/02/26", "YES", "NO", "Cardiac Disorders"
  ,2, 1, "FEVER",                 "2020/02/19", "2020/02/19",  "NO", "NO", "General Disorders"
  ,2, 2, "HEART RATE ABNORMAL",   "2020/02/13", "2020/02/13", "YES", "NO", "Cardiac Disorders"
  ,2, 2, "ARM TINGLING",          "2020/02/13", "2020/02/13",  "NO", "NO", "Cardiac Disorders"
)


# Adding a Single Row or Column -------------------------------------------

data_demo %>%
  add_row(patient = 3, visit = 0)

data_demo %>%
  add_column(status = c(1, 0))


# Merging and Appending Data ----------------------------------------------

# Binding Rows - Must have equivalent number of columns
data_demo_pat_1 <- slice(data_demo, 1) %>% print()
data_demo_pat_2 <- slice(data_demo, 2) %>% print()

bind_rows(data_demo_pat_1, data_demo_pat_2)
bind_rows(data_demo_pat_1, data_demo_pat_2, data_demo_pat_1, data_demo_pat_2)


# Binding Columns - Must have equivalent number of rows
data_demo_subset_1 <- select(data_demo, 1:2) %>% print()
data_demo_subset_2 <- select(data_demo, 3:4) %>% print()
data_demo_subset_3 <- select(data_demo, 5:6) %>% print()
data_demo_subset_4 <- select(data_demo, 7:9) %>% print()

data_demo_subset_1 %>%
  bind_cols(data_demo_subset_2,
            data_demo_subset_3,
            data_demo_subset_4)


# Joining Data ------------------------------------------------------------

# --- Mutating Joins: Adding Columns from Right Side Data to Left Side Data
left_join( data_ae, data_vistrt, by = c("PATID" = "patient", "VISTN" = "visit"))
right_join(data_ae, data_vistrt, by = c("PATID" = "patient", "VISTN" = "visit"))
inner_join(data_ae, data_vistrt, by = c("PATID" = "patient", "VISTN" = "visit"))
full_join( data_ae, data_vistrt, by = c("PATID" = "patient", "VISTN" = "visit"))


# --- Filter Joins:
# Semi Join: Remove rows from Left Side Data if no matching values in Right Side Data
# Anti Join: Determine which values in Left Side Data are not found in Right Side Data

semi_join(data_ae, data_vistrt, by = c("PATID" = "patient", "VISTN" = "visit"))
anti_join(data_ae, data_vistrt, by = c("PATID" = "patient", "VISTN" = "visit"))


# Documentation -----------------------------------------------------------

# Vignettes
vignette("two-table", package = "dplyr")

# Help Pages - Primary
help("bind",         package = "dplyr")
help("mutate-joins", package = "dplyr")
help("filter-joins", package = "dplyr")

# Help Pages - Secondary
help("expand",   package = "tidyr")
help("complete", package = "tidyr")
help("crossing", package = "tidyr")

# Website References
# https://rstudio.com/resources/cheatsheets/
# https://dplyr.tidyverse.org/reference/join.html


# Equivalent Operations ---------------------------------------------------

help(rbind, package = "base")
help(cbind, package = "base")
help(merge, package = "base")

# -------------------------------------------------------------------------

