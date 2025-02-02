
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2020 Anova Groups All rights reserved

# Title: Transposing Data with Pivots

# Packages & Functions on Display:
# - {tidyr 1.1.0}: pivot_wider, pivot_longer


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

data_labrange <- tribble(
  ~labname,                 ~labcode, ~range_low, ~range_high
  ,"Alkaline Phosphate",       "ALP",       45.0,         115
  ,"Alanine Aminotransferase", "ALT",       10.0,          45
  ,"Albumin",                  "ALB",        3.5,           5
)


# Transpose to Longer Format ----------------------------------------------
# Using selection helpers: where, everything, starts_with, ends_with, contains

data_labrange %>%
  pivot_longer(cols      = c(range_low, range_high),
               names_to  = "PARAM",
               values_to = "VALUE")

# Adjust Names
data_labrange %>%
  pivot_longer(cols         = range_low:range_high,
               names_to     = "PARAM",
               values_to    = "VALUE",
               names_prefix = "range_")


# Separate Into Multiple Columns
data_labrange %>%
  pivot_longer(cols      = contains("range"),
               names_to  = c("PARAM_1", "PARAM_2"),
               names_sep = "_",
               values_to = "VALUE")



# Transpose to Wider Format -----------------------------------------------

data_labrange %>%
  pivot_wider(names_from  = labcode,
              values_from = range_low)


# Sort New Columns Alphabetically
data_labrange %>%
  pivot_wider(names_from  = labcode,
              values_from = range_low,
              names_sort  = TRUE)


# Fill in Missing Values
data_labrange %>%
  pivot_wider(names_from  = labcode,
              values_from = range_low,
              values_fill = 0)


# Apply Function to New Values
data_labrange %>%
  pivot_wider(names_from  = labcode,
              values_from = range_low,
              values_fn   = list(range_low = as.character))


# Pivot Multiple Values
data_labrange %>%
  pivot_wider(names_from   = labcode,
              values_from  = c(range_low, range_high),
              names_sep    = " ")


# Ensure Correct Name Syntax
data_labrange %>%
  pivot_wider(names_from   = labcode,
              values_from  = c(range_low, range_high),
              names_sep    = " ",
              names_repair = "universal")


# Pipeline of Pivots ------------------------------------------------------

data_labrange %>%
  pivot_longer(cols = -contains("lab"),
               names_to = "Range",
               names_prefix = "range_") %>%
  pivot_wider(names_from = contains("lab"),
              names_repair = "universal")


# Documentation -----------------------------------------------------------

# Vignettes
vignette("pivot", package = "tidyr")

# Help Pages
help("pivot_longer", package = "tidyr")
help("pivot_wider",  package = "tidyr")

# Website References
# https://tidyr.tidyverse.org/
# https://github.com/tidyverse/tidyr/
# https://rstudio.com/resources/cheatsheets/


# Equivalent Operations ---------------------------------------------------

help("t",      package = "base")
help("melt",   package = "reshape2")
help("cast",   package = "reshape2")
help("recast", package = "reshape2")
help("gather", package = "tidyr")
help("spread", package = "tidyr")

# -------------------------------------------------------------------------
