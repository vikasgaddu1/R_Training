
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2020 Anova Groups All rights reserved

# Title: Data Summaries

# Packages & Functions on Display:
# - {dplyr 1.0.0}: summarize, across, n, n_distinct, first, last, nth, any


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

data_labs <- tribble(
  ~patient, ~visit, ~alb,   ~alp,   ~alt, ~bili
  ,1,         1,     4.3,    47,     19,  "NEGATIVE"
  ,1,         2,     5.1,    49,     21,  "TRACE"
  ,1,         3,     4.1,    48,     22,  "NEGATIVE"
  ,2,         1,     4.3,    47,     19,  "NEGATIVE"
  ,2,         2,     5.1,    49,     21,  "NEGATIVE"
  ,2,         3,     4.1,    48,     22,  "NEGATIVE"
  ,3,         1,     4.3,    45,     19,  "NEGATIVE"
  ,3,         2,     4.5,    40,     21,  NA
  ,3,         4,     4.2,    41,     22,  "TRACE"
  ,4,         1,     4.2,    48,     19,  "NEGATIVE"
  ,4,         2,     4.1,    48,     21,  "NEGATIVE"
  ,4,         3,     4.1,    48,     22,  "NEGATIVE"
  ,5,         1,     4.9,    48,     19,  "NEGATIVE"
  ,5,         2,     5.0,    45,     21,  "NEGATIVE"
  ,5,         3,     4.8,    44,     22,  "NEGATIVE"
  ,6,         1,     4.9,    48,     19,  "NEGATIVE"
  ,6,         2,     5.0,    45,     21,  "NEGATIVE"
  ,6,         3,     4.8,    44,     22,  "NEGATIVE"
  ,7,         1,     4.9,    48,     19,  "NEGATIVE"
  ,7,         2,     5.0,    45,     NA,  "NEGATIVE"
  ,7,         3,     4.8,    44,     22,  "NEGATIVE"
  ,8,         1,     4.9,    48,     19,  "NEGATIVE"
  ,8,         2,     5.0,    45,     21,  "NEGATIVE"
  ,8,         3,     4.8,    44,     22,  "NEGATIVE"
  ,9,         1,     4.9,    48,     19,  "NEGATIVE"
  ,9,         2,     5.0,    45,     21,  "NEGATIVE"
  ,9,         3,     4.8,    44,     22,  "NEGATIVE"
  ,10,        1,     4.9,    48,     19,  "TRACE"
  ,10,        2,     5.0,    45,     21,  "TRACE"
  ,10,        3,     4.8,    44,     22,  "TRACE"
)



# Data Summaries ----------------------------------------------------------

# Base R: Summary
summary(data_labs)
summary(data_labs$alb)


# Tidyverse: Summarize Always Reduces Row Count
# Synonyms: `summarise()` / `summarize()`
data_labs %>%
  summarise(N      = n(),
            Mean   = mean(alb),
            Min    = min(alb),
            Median = median(alb),
            Max    = max(alb))


# Analysis Functions ------------------------------------------------------

# Any vectorized function that returns a single value per vector will work
n_distinct(data_labs$bili)

data_labs %>%
  summarise(bili_distinct = n_distinct(bili),
            bili_first    = first(bili),
            bili_last     = last(bili),
            bili_5th      = nth(bili, 5),
            any_missing   = any(is.na(bili)),
            sum_missing   = sum(is.na(bili)))


# Most functions that return multiple values per vector will also work
range(1:10)
quantile(1:10)

data_labs %>%
  summarise(range_label = c("min", "max"),
            range_value = range(alb))


data_labs %>%
  summarise(quantile_label = c("20%", "50%", "80%"),
            quantile_value = quantile(alb, probs = c(0.20, 0.50, 0.80)))


# Advanced Summarize Helpers ----------------------------------------------
# Using selection helpers: where, starts_with, ends_with, contains

data_labs %>%
  summarize(across(.cols = c(patient, visit),
                   .fns  = n_distinct))


data_labs %>%
  summarize(across(.cols = where(is.numeric),
                   .fns  = mean))


# Custom Summary Variable Names
data_labs %>%
  summarize(across(.cols  = starts_with("al"),
                   .fns   = mean,
                   .names = "avg_{col}"))


# With List of Functions
function_list <- list("avg" = mean, "std" = sd)

data_labs %>%
  summarize(across(.cols  = starts_with("al"),
                   .fns   = function_list,
                   .names = "{fn}_{col}"))


# Finer Control: Tilde (~); Dot (.)
data_labs %>%
  summarize(across(.cols = where(is.numeric),
                   .fns  = ~ mean(., na.rm = TRUE)))


# Documentation -----------------------------------------------------------

# Vignettes
vignette("dplyr",   package = "dplyr")
vignette("colwise", package = "dplyr")

# Help Pages - Primary Functions
help("across",    package = "dplyr")
help("summarise", package = "dplyr")
help("language",  package = "tidyselect")

# Help Pages - Secondary Functions
help("any",         package = "base")
help("nth",         package = "dplyr")
help("n_distinct",  package = "dplyr")
help("starts_with", package = "tidyselect")

# Website References
# https://dplyr.tidyverse.org
# https://github.com/tidyverse/dplyr
# https://rstudio.com/resources/cheatsheets/

# Equivalent Functions ----------------------------------------------------

help(summary,      package = "base")
help(aggregate,    package = "stats")
help(summarise_if, package = "dplyr")

# -------------------------------------------------------------------------

