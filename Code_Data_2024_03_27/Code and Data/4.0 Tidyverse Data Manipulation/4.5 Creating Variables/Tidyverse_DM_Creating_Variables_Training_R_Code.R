
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2020 Anova Groups All rights reserved

# Title: Creating Variables

# Packages & Functions on Display:
# - {dplyr 1.0.0}: mutate, transmute, across, lead, lag, ntile, dense_rank, case_when


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
  ,2,         2,     5.1,    NA,     21,  "NEGATIVE"
  ,2,         3,     4.1,    48,     22,  "NEGATIVE"
  ,3,         1,     4.3,    45,     19,  "NEGATIVE"
  ,3,         2,     4.2,    40,     21,  ""
  ,3,         4,     4.2,    41,     22,  "TRACE"
  ,4,         1,     4.2,    48,     19,  "NEGATIVE"
  ,4,         2,     4.1,    48,     21,  "NEGATIVE"
  ,4,         3,     4.1,    48,     22,  "NEGATIVE"
  ,5,         1,     4.9,    48,     19,  "NEGATIVE"
  ,5,         2,     5.0,    45,     21,  "NEGATIVE"
  ,5,         3,     4.8,    44,     NA,  "NEGATIVE"
  ,6,         1,     4.9,    48,     19,  "NEGATIVE"
  ,6,         2,     5.0,    45,     21,  "NEGATIVE"
  ,6,         3,     4.8,    44,     22,  "NEGATIVE"
  ,7,         1,     4.9,    48,     19,  ""
  ,7,         2,     5.0,    45,     21,  "NEGATIVE"
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


# Creating New Variables in Base R ----------------------------------------

data_labs_2 <- data_labs

data_labs_2$new_variable <- data_labs$alb + (data_labs$alb / data_labs$alt) ^ 2

data_labs_2


# Creating New Variables with Mutate --------------------------------------
# Notice no $ or " " variable names, because mutate creates internal environment

# Constant Variables
data_labs %>%
  mutate(var_number = 999,
         var_char   = "Unknown",
         var_mean   = mean(alb),
         var_exists = alt)


# Derived Variables
data_labs %>%
  mutate(var_equation = alb + (alp / alt)^2,
         var_diff     = alb - mean(alb))


# Overwrite Existing Variables
data_labs %>%
  mutate(bili    = factor(bili, levels = c("NEGATIVE", "TRACE", "")),
         patient = as.character(patient))


# Self-Referential Mutate
data_labs %>%
  mutate(new_1 = alt < 20,
         new_2 = ifelse(new_1 == TRUE, "LT20", "GT20"))


# Conditional Mutate
data_labs %>%
  mutate(new_condition = case_when(bili == "NEGATIVE" & alt == 19 ~ "N-19",
                                   bili == "TRACE"    & alt == 21 ~ "T-21"))


# Replacing Missing Values ------------------------------------------------

data_labs %>%
  mutate(new_recode = ifelse(bili == "", NA, bili))

data_labs %>%
  mutate(new_recode = dplyr::na_if(bili, ""))

data_labs %>%
  mutate(new_alb = tidyr::replace_na(alp, 999))


# Other Operations --------------------------------------------------------

# Lead / Lag
data_labs %>%
  mutate(previous_value = lag(bili),
         next_value     = lead(bili))


# Value Ranks
data_labs %>%
  mutate(rank_alb  = dense_rank(alb),
         ntile_alb = ntile(alb, n = 5)) %>%
  arrange(rank_alb)


# Cumulative Functions
data_labs %>%
  mutate(var_cusum  = cumsum(alb),
         var_cumean = cummean(alb))


# String Functions
data_labs %>%
  mutate(string_1 = paste("Patient:", patient),
         string_2 = str_c("Visit: ", visit))


# Control Variable Location -----------------------------------------------

# Before Specific Variable
data_labs %>%
  mutate(var_diff = alb - mean(alb),
         .before = 1)


# After Specific Variable
data_labs %>%
  mutate(var_diff = alb - mean(alb),
         .after = patient)


# Create New Variables and Drop Others
data_labs %>%
  transmute(patient_id = str_c(patient, visit, sep = "-"),
            round_alb  = round(alb, digits = 2))


# Mutate Advanced Helpers -------------------------------------------------
# Using selection helpers: where, everything, starts_with, ends_with, contains

data_labs %>%
  mutate(across(.cols = patient:visit, .fns = as.factor))

data_labs %>%
  mutate(across(.cols = everything(), .fns = as.character))


# Finer Control: Tilde (~) and Dot (.)
data_labs %>%
  mutate(across(.cols = where(is.numeric),
                .fns = ~ . - mean(., na.rm = TRUE)))


# Documentation -----------------------------------------------------------

# Vignettes
vignette("base" ,   package = "dplyr")
vignette("dplyr",   package = "dplyr")
vignette("colwise", package = "dplyr")

# Help Pages - Primary Functions
help(mutate,    package = "dplyr")
help(across,    package = "dplyr")
help(where,     package = "tidyselect")
help(language,  package = "tidyselect")

# Help Pages - Secondary Functions
help(na_if,     package = "dplyr")
help(cumall,    package = "dplyr")
help(cumsum,    package = "base")
help(ranking,   package = "dplyr")
help(lead-lag,  package = "dplyr")
help(case_when, package = "dplyr")

# Website References
# https://dplyr.tidyverse.org
# https://github.com/tidyverse/dplyr
# https://rstudio.com/resources/cheatsheets/


# Equivalent Functions ----------------------------------------------------

help(mutate_if, package = "dplyr")

# -------------------------------------------------------------------------

