
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2020 Anova Groups All rights reserved

# Title: Group Operations

# Packages & Functions on Display:
# - {dplyr 1.0.0}: group_by, ungroup, group_keys, rowwise, c_across,
#                 slice, mutate, summarize


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

data_vitals <- tribble(
  ~patient, ~visit, ~datevisit, ~timing, ~pulse, ~bpd ,~bps
  , 1, 1, parse_date('2020-01-06'), "PRE",   98, 118, 80
  , 1, 1, parse_date('2020-01-06'), "POST", 100, 120, 81
  , 1, 2, parse_date('2020-01-13'), "POST", 120, 112, 79
  , 1, 2, parse_date('2020-01-13'), "PRE",  120, 112, 79
  , 1, 3, parse_date('2020-01-20'), "PRE",   95, 122, 78
  , 1, 3, parse_date('2020-01-20'), "POST",  99, 123, 78
  , 2, 1, parse_date('2020-01-07'), "PRE",  100, 107, 85
  , 2, 1, parse_date('2020-01-07'), "POST", 101, 109, 85
  , 2, 2, parse_date('2020-01-14'), "PRE",  111, 152, 98
  , 2, 2, parse_date('2020-01-14'), "POST", 110, 150, 99
  , 2, 3, parse_date('2020-01-21'), "PRE",   89, 117, 81
  , 2, 3, parse_date('2020-01-21'), "POST",  91, 120, 82
  , 3, 1, parse_date('2020-01-07'), "PRE",   96, 120, 74
  , 3, 1, parse_date('2020-01-07'), "POST",  97, 122, 76
  , 3, 2, parse_date('2020-01-14'), "PRE",  118, 125, 75
  , 3, 2, parse_date('2020-01-14'), "POST", 119, 129, 79
  , 3, 4, parse_date('2020-01-28'), "PRE",   93, 111, 72
  , 3, 4, parse_date('2020-01-28'), "POST",  95, 115, 75
  , 6, 1, parse_date('2020-01-11'), "PRE",  345, 124, 81
  , 6, 1, parse_date('2020-01-11'), "POST",  91, 120, 80
  , 6, 2, parse_date('2020-01-19'), "PRE",  118, 115, 73
  , 6, 2, parse_date('2020-01-19'), "POST", 119, 116, 73
  , 7, 1, parse_date('2020-01-11'), "PRE",   93, 124, 81
  , 7, 1, parse_date('2020-01-11'), "POST",  91, 120, 80
  , 7, 2, parse_date('2020-01-19'), "PRE",  118, 115, 73
  , 7, 2, parse_date('2020-01-19'), "POST", 119, 116, 73
  , 8, 1, parse_date('2020-01-11'), "PRE",   93, 124, 81
  , 8, 1, parse_date('2020-01-11'), "POST",  91, 120, 80
  , 8, 2, parse_date('2020-01-19'), "PRE",  118, 115, 73
  , 8, 2, parse_date('2020-01-19'), "POST", 119, 116, 73
  , 9, 1, parse_date('2020-01-11'), "PER",   93, 124, 81
  , 9, 1, parse_date('2020-01-11'), "POST",  91, 120, 80
  , 9, 2, parse_date('2020-01-19'), "PRE",  118, 115, 73
  , 9, 2, parse_date('2020-01-19'), "POST", 119, 116, 73
  ,10, 1, parse_date('2020-01-11'), "PRE",   93, 124, 81
  ,10, 1, parse_date('2020-01-11'), "POST",  91, 120, 80
  ,10, 2, parse_date('2020-01-19'), "PRE",  118, 115, 73
  ,10, 2, parse_date('2020-01-19'), "POST", 119, 116, 73
)


# Set Group Variables -----------------------------------------------------

data_grouped <-
  data_vitals %>%
  group_by(timing)

data_grouped
data_grouped %>% class()
data_grouped %>% is.grouped_df()

data_grouped %>% groups()
data_grouped %>% n_groups()
data_grouped %>% group_keys()

data_grouped %>% ungroup()


# Documentation
help(groups,   package = "dplyr")
help(group_by, package = "dplyr")


# Subset by Group ---------------------------------------------------------

# First Record for Each Patient
data_vitals %>%
  group_by(patient) %>%
  slice_head(n = 1)

# Minimum Record for Each Patient
data_vitals %>%
  group_by(patient) %>%
  slice_min(order_by = pulse, n = 1)

# Select Random Records for Each Patient
data_vitals %>%
  group_by(patient) %>%
  slice_sample(n = 2)


# Documentation
help(slice, package = "dplyr")


# Mutate by Group ---------------------------------------------------------

data_means <-
  data_vitals %>%
  mutate(overall_mean = mean(pulse)) %>%
  group_by(patient) %>%
  mutate(patient_mean = mean(pulse)) %>%
  print()

# Group Keys Carry Over
data_means %>%
  select(overall_mean, patient_mean)


# Documentation
help(mutate, package = "dplyr")


# Summarize by Group ------------------------------------------------------

data_vitals %>%
  group_by(visit) %>%
  summarize(count_date = n_distinct(datevisit),
            first_date = min(datevisit),
            last_date  = max(datevisit))

# Count Shortcut
data_vitals %>% count(visit)
data_vitals %>% count(visit, timing, sort = TRUE)


# Group by Row ------------------------------------------------------------

data_vitals %>%
  group_by(patient) %>%
  mutate(sum_vertical = sum(pulse))

data_vitals %>%
  rowwise() %>%
  mutate(sum_horizontal = sum(pulse, bpd, bps))

# Advanced Column Selection
data_vitals %>%
  rowwise() %>%
  mutate(mean_horizontal = mean(c_across(pulse:bps)))

data_vitals %>%
  rowwise() %>%
  mutate(sd_horizontal = sd(c_across(where(is.numeric))))


# Documentation
help(rowwise,  package = "dplyr")
help(c_across, package = "dplyr")


# Documentation -----------------------------------------------------------

# Vignettes
vignette("grouping", package = "dplyr")
vignette("rowwise",  package = "dplyr")
vignette("colwise",  package = "dplyr")

# Website References
# https://dplyr.tidyverse.org
# https://github.com/tidyverse/dplyr
# https://rstudio.com/resources/cheatsheets/

# Equivalent Operations ---------------------------------------------------

help(sample_n, package = "dplyr")
help(split,    package = "base")
help(rowSums,  package = "base")
help(rowMeans, package = "base")

# -------------------------------------------------------------------------
