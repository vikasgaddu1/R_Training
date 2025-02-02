
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2020 Anova Groups All rights reserved

# Title: Subsetting and Sorting

# Packages & Functions on Display:
# - {dplyr 1.0.0}: slice, filter, select, rename, arrange, relocate


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
  , 1, 3, parse_date('2020-01-20'), "PRE",   99, 123, 78
  , 1, 3, parse_date('2020-01-20'), "POST",  99, 123, 78
  , 2, 1, parse_date('2020-01-07'), "PRE",  100, 107, 85
  , 2, 1, parse_date('2020-01-07'), "POST", 101, 109, 85
  , 2, 2, parse_date('2020-01-14'), "PRE",  111, 152, 98
  , 2, 2, parse_date('2020-01-14'), "POST", 110, 150, 99
  , 2, 3, parse_date('2020-01-21'), "PRE",   89, 117, 81
  , 2, 3, parse_date('2020-01-21'), "POST",  91, 120, 82
  , 3, 1, parse_date('2020-01-07'), "PRE",   96, 120, 74
  , 3, 1, parse_date('2020-01-07'), "PRE",   96, 120, 74
  , 3, 1, parse_date('2020-01-07'), "POST",  97, 122, 76
  , 3, 2, parse_date('2020-01-14'), "PRE",  118, 125, 75
  , 3, 2, parse_date('2020-01-14'), "POST", 119, 129, 79
  , 3, 2, parse_date('2020-01-14'), "POST", 119, 129, 79
  , 3, 4, parse_date('2020-01-28'), "PRE",   93, 111, 72
  , 3, 4, parse_date('2020-01-28'), "POST",  95, 115, 75
  , 6, 1, parse_date('2020-01-11'), "PRE",  345, 124, 81
  , 6, 1, parse_date('2020-01-11'), "POST",  91, 120, 80
  , 6, 2, parse_date('2020-01-19'), "PRE",  118, 115, 73
  , 6, 2, parse_date('2020-01-19'), "POST", 119, 116, 73
  , 7, 1, parse_date('2020-01-11'), "PRE",   93, 124, 81
  , 7, 1, parse_date('2020-01-11'), "PRE",   93, 124, 81
  , 7, 1, parse_date('2020-01-11'), "POST",  91, 120, 80
  , 7, 2, parse_date('2020-01-19'), "PRE",  118, 115, 73
  , 7, 2, parse_date('2020-01-19'), "POST", 119, 116, 73
  , 8, 1, parse_date('2020-01-11'), "PRE",   93, 124, 81
  , 8, 1, parse_date('2020-01-11'), "POST",  91, 120, 80
  , 8, 2, parse_date('2020-01-19'), "PRE",  118, 115, 73
  , 8, 2, parse_date('2020-01-19'), "POST", 119, 116, 73
  , 8, 2, parse_date('2020-01-19'), "POST", 119, 116, 73
  , 9, 1, parse_date('2020-01-11'), "PER",   93, 124, 81
  , 9, 1, parse_date('2020-01-11'), "POST",  91, 120, 80
  , 9, 2, parse_date('2020-01-19'), "PRE",  118, 115, 73
  , 9, 2, parse_date('2020-01-19'), "PRE",  118, 115, 73
  , 9, 2, parse_date('2020-01-19'), "POST", 119, 116, 73
  ,10, 1, parse_date('2020-01-11'), "PRE",   93, 124, 81
  ,10, 1, parse_date('2020-01-11'), "POST",  91, 120, 80
  ,10, 2, parse_date('2020-01-19'), "PRE",  118, 115, 73
  ,10, 2, parse_date('2020-01-19'), "POST", 119, 116, 73
  ,10, 3, parse_date('2020-01-19'), "POST", 119, 116, 73
)


# Filter by Row -----------------------------------------------------------

data_vitals %>% slice(30)
data_vitals %>% slice(30:40)
data_vitals %>% slice(-(10:40))

data_vitals %>% slice_head(n = 2)
data_vitals %>% slice_tail(n = 5)

data_vitals %>% slice_sample(n = 5)
data_vitals %>% slice_sample(prop = 0.10)

sort(unique(data_vitals$pulse))

data_vitals %>% slice_max(order_by = pulse, n = 2, with_ties = FALSE)
data_vitals %>% slice_min(order_by = pulse, n = 5, with_ties = FALSE)

# Most of the time we use without parameters to get max and min for a group.

# Documentation
help(slice, package = "dplyr")


# Filter by Condition -----------------------------------------------------

data_vitals %>% filter(timing == "PRE")
data_vitals %>% filter(!patient %in% c(1, 3, 5))
data_vitals %>% filter(datevisit < "2020-01-10")

# if has two characters so it uses && for element-wise comparison
# Combine Conditions
data_vitals %>% filter(timing == "PRE" & (pulse < 100 | pulse > 150))
data_vitals %>% filter(timing == "PRE", pulse < 100)


# Include Equations in Condition
data_vitals %>% filter(timing == "PRE", pulse == min(pulse))
data_vitals %>% filter(timing == "PRE", pulse < (0.95 * median(pulse)))


# Documentation
help(filter, package = "dplyr")


# Filter Distinct Values --------------------------------------------------

data_vitals %>% distinct()
data_vitals %>% distinct(patient)
data_vitals %>% distinct(patient, visit, .keep_all = TRUE)

# Documentation
help(distinct, package = "dplyr")


# Select Variables --------------------------------------------------------

# Select by Index or Name
data_vitals %>% select(5:last_col())
data_vitals %>% select(pulse:bps, 1)
data_vitals %>% select(!(pulse:bps))


# Rename and Include Variables
data_vitals %>% select(VSTN = visit, PTID = patient)


# Selection Criteria
data_vitals %>% select(everything())
data_vitals %>% select(contains("visit"))
data_vitals %>% select(starts_with("bp"))
data_vitals %>% select(pulse:last_col())

data_vitals %>% select(where(is.numeric))
data_vitals %>% select(!where(is.character))


# Pre-Defined Variable Selection
vector_of_varnames <- c("patient", "visit", "patient_number", "visit_number")

data_vitals %>% select(any_of(vector_of_varnames))
data_vitals %>% select(all_of(vector_of_varnames))


# Documentation
help(select, package = "dplyr")
help(where,  package = "tidyselect")
help(any_of, package = "tidyselect")


# Value Isolation ---------------------------------------------------------

# Return Variable as a Vector
data_vitals[["bps"]]
data_vitals %>% pull(bps)

# Return Single Value
data_vitals %>%
  filter(patient == 1) %>%
  slice_max(bps) %>%
  pull(bps)


# Documentation
help(pull, package = "dplyr")


# Rename Variables --------------------------------------------------------

# Rename by Column Index or Name
data_vitals %>% rename(VSTN = visit, PATID = 1)

name <- c("vikas")
toupper(name)
# Apply Function to All Names
uppercase_vars <- data_vitals %>% rename_with(toupper)
uppercase_vars %>% rename_with(.fn = tolower, .cols = PULSE:BPS)


# Documentation
help(rename,  package = "dplyr")
help(toupper, package = "base")


# Relocate Variables ------------------------------------------------------

data_vitals %>% relocate(c(datevisit,bpd), .before = 1)
data_vitals %>% relocate(datevisit, .before = visit)
data_vitals %>% relocate(datevisit, .after = last_col())


# Documentation
help(relocate, package = "dplyr")


# Arrange Rows ------------------------------------------------------------

data_vitals %>% arrange(pulse)
data_vitals %>% arrange(patient, -pulse)
data_vitals %>% arrange(patient, desc(datevisit))

# Documentation
help(arrange, package = "dplyr")


# Documentation -----------------------------------------------------------

# Vignettes
vignette("base" , package = "dplyr")
vignette("dplyr", package = "dplyr")

# Website References
# - https://dplyr.tidyverse.org
# - https://github.com/tidyverse/dplyr
# - https://rstudio.com/resources/cheatsheets/


# Equivalent Operations ---------------------------------------------------

help(head,      package = "utils")
help(sort,      package = "base")
help(subset,    package = "base")
help(sample,    package = "base")
help(sample_n,  package = "dplyr")
help(select_if, package = "dplyr")

# -------------------------------------------------------------------------
