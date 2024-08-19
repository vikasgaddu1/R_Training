
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2022 Anova Groups All rights reserved

# Title: Working with Data - Joining Data

# Packages & Functions on Display:
# - {base   4.2.0}: merge()
# - {dplyr  1.0.8}: inner_join(), full_join(), left_join(), right_join(), semi_join(), anti_join()
# - {tibble 3.1.6}: tribble()


# Setup -------------------------------------------------------------------

# Load Packages
library(tidyverse)


# Create Data
df_visittrt <-
  tribble(
    ~patient, ~visit,     ~trtdate,            ~trttime,
    1, 1, parse_date("2020/02/26"), parse_time("13:00"),
    1, 2, parse_date("2020/03/04"), parse_time("14:00"),
    1, 3, parse_date("2020/03/11"), parse_time("13:30")) %>%
  print()

df_ae <-
  tribble(
    ~patid, ~visitn, ~aeraw,        ~aedtstart,  ~aedtstop,   ~aeserious, ~aeongoing, ~soc_term,
    1, 1, "HEART PALPITATIONS",    "2020/02/18", "2020/02/18",  "NO", "NO", "Cardiac Disorders",
    1, 2, "HEART RACING",          "2020/02/25", "2020/02/25", "YES", "NO", "Cardiac Disorders",
    1, 2, "DEATH",                 "2020/02/26", "2020/02/26", "YES", "NO", "Cardiac Disorders",
    2, 1, "FEVER",                 "2020/02/19", "2020/02/19",  "NO", "NO", "General Disorders",
    2, 2, "HEART RATE ABNORMAL",   "2020/02/13", "2020/02/13", "YES", "NO", "Cardiac Disorders",
    2, 2, "ARM TINGLING",          "2020/02/13", "2020/02/13",  "NO", "NO", "Cardiac Disorders") %>%
  print()


# Join in Base R ----------------------------------------------------------

# Inner Join
merge(df_ae, df_visittrt, by.x = c("patid", "visitn"), by.y = c("patient", "visit"), all = F)


# Full Outer Join
merge(df_ae, df_visittrt, by.x = c("patid", "visitn"), by.y = c("patient", "visit"), all = T)


# Left Outer Join
merge(df_ae, df_visittrt, by.x = c("patid", "visitn"), by.y = c("patient", "visit"), all.x = T)


# Right Outer Join
merge(df_ae, df_visittrt, by.x = c("patid", "visitn"), by.y = c("patient", "visit"), all.y = T)



# Join in Tidyverse -------------------------------------------------------

# Mutating Joins: Adding Columns from Right Side Data to Left Side Data
inner_join(df_ae, df_visittrt, by = c("patid" = "patient", "visitn" = "visit"))
full_join( df_ae, df_visittrt, by = c("patid" = "patient", "visitn" = "visit"))
left_join( df_ae, df_visittrt, by = c("patid" = "patient", "visitn" = "visit"))
right_join(df_ae, df_visittrt, by = c("patid" = "patient", "visitn" = "visit"))


# Filter Joins:
# Semi Join: Remove rows from Left Side Data if no matching values in Right Side Data
# Anti Join: Determine which values in Left Side Data are not found in Right Side Data
semi_join(df_ae, df_visittrt, by = c("patid" = "patient", "visitn" = "visit"))
anti_join(df_ae, df_visittrt, by = c("patid" = "patient", "visitn" = "visit"))


# Documentation -----------------------------------------------------------

# Vignettes
vignette("two-table")

# Help Pages
help("mutate-joins")
help("filter-joins")

# Website References
# - https://r4ds.had.co.nz/relational-data.html
# - https://www.rstudio.com/resources/cheatsheets/

# -------------------------------------------------------------------------
