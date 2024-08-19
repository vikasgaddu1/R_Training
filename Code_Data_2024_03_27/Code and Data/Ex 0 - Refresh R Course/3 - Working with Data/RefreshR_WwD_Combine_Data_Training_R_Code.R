
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2022 Anova Groups All rights reserved

# Title: Working with Data - Combine and Append Data

# Packages & Functions on Display:
# - {base   4.2.0}: rbind(), cbind()
# - {dplyr  1.0.8}: bind_cols(), bind_rows()
# - {tibble 3.1.6}: tibble(), tribble(), add_column(), add_rows()


# Setup -------------------------------------------------------------------

# Load Packages
library(tidyverse)


# Create Data
df_demo <-
  tribble(
    ~study, ~inv, ~patient, ~visit, ~screendate, ~sex, ~race, ~dob, ~treatment,
    "Study B", 2000, 1, 0, parse_date('2020-02-19'), "M", "White",            parse_date('1986-01-11'), "Active",
    "Study B", 2000, 2, 0, parse_date('2020-02-19'), "F", "African American", parse_date('1987-07-01'), "Placebo") %>%
  print()


# Combine in Base R -------------------------------------------------------
# New columns and rows need to have the exact same number of values as the data
# you are combining with

new_col <- 0:1
new_row <-
  data.frame(
    study = "Study A", inv = NA, patient = 3, visit = NA, screendate = NA, sex = NA,
    race = NA, dob = NA, treatment = "Active") %>%
  print()

cbind(df_demo, status = new_col)
rbind(df_demo, new_row)


# Combine in Tidyverse ----------------------------------------------------
# Only new columns are required to have identical number of values


# Adding One Column/Row
df_demo %>% add_column(status = new_col)
df_demo %>% add_row(study = "Study A", patient = 3, treatment = "Active")


# Adding Many Columns/Rows
new_df_cols <- tibble(status = c(1, 0)) %>% print()
new_df_rows <- tibble(study = "Study A", patient = 3, treatment = "Active") %>% print()

df_demo %>% bind_cols(new_df_cols)
df_demo %>% bind_rows(new_df_rows)


df_demo %>% bind_cols(new_df_cols) %>% bind_rows(new_df_rows)


# Easy to combine many datasets
df_demo %>% bind_cols(new_df_cols, new_df_cols, new_df_cols, new_df_cols)
df_demo %>% bind_rows(new_df_rows, new_df_rows, new_df_rows, new_df_rows)



# Documentation -----------------------------------------------------------

# Help Pages
help("cbind")
help("bind_rows")

# Website References
# - https://www.rstudio.com/resources/cheatsheets/

# -------------------------------------------------------------------------
