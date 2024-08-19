
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2022 Anova Groups All rights reserved

# Title: Working with Data - Pivot Data

# Packages & Functions on Display:
# - {dplyr  1.0.8}: pivot_wider(), pivot_longer()
# - {tibble 3.1.6}: tribble()


# Setup -------------------------------------------------------------------

# Load Packages
library(tidyverse)

# Create Data
df_lab_w <-
  tribble(
    ~lab_code, ~visit,    ~lab_value,
    "Assay1",  "Baseline", 45,
    "Assay1",  "Week1",    50,
    "Assay2",  "Baseline", 10,
    "Assay2",  "Week1",    12) %>%
  print()

df_lab_l <-
  tribble(
    ~Visit,     ~Assay1, ~Assay2,
    "Baseline", 45,      10,
    "Week1",    50,      12) %>%
  print()


# Pivot in Base R ---------------------------------------------------------

# There are no easy-to-use equivalent operations in base R

# Pivot in Tidyverse ------------------------------------------------------

df_lab_w %>% pivot_wider(names_from = visit, values_from = lab_value)


df_lab_w %>%
  pivot_wider(
    names_from   = visit,
    values_from  = lab_value,
    id_cols      = lab_code,  # Useful when there are many ID cols
    names_prefix = "time_")   # Used to modify the newly created column names


df_lab_l %>%
  pivot_longer(
    cols      = contains("Assay"),
    names_to  = "assay_number",
    values_to = "assay_value")


# Documentation -----------------------------------------------------------

# Vignettes
vignette("pivot")

# Help Pages
help("pivot_longer")
help("pivot_wider")

# Website References
# - https://r4ds.had.co.nz/tidy-data.html#pivoting
# - https://www.rstudio.com/resources/cheatsheets/

# -------------------------------------------------------------------------
