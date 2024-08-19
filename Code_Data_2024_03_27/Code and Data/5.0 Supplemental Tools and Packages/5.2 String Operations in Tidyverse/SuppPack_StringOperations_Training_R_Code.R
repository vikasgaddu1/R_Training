
# Anova Accel2R - Clinical R Training -----------------------------------

# Title: Tidyverse String Operations with stringr

# Packages & Functions on Display:
# - {stringr 1.4.0}: str_c, str_dup, str_length, str_split, str_glue, str_to_*,
#                   str_pad, str_trunc, str_wrap, str_trim, str_squish, word,
#                   str_extract, str_detect, str_replace, str_remove, str_starts,
#                   str_ends, str_which, str_subset
#
# - {scales  1.1.1}: number, dollar, percent, pvalue, scientific


# Setup -------------------------------------------------------------------

# Load Packages
library(tidyverse)

# Basic String Operations -------------------------------------------------

str_c("Treatment", 1)
str_c("Treatment", 1, sep = ": ")


# Value Recycling
str_c("Treatment", c("A", "B", "C"), sep = " ")
str_c(c("A", "B", "C"), "Treatment", sep = " ")


# Character Duplication
str_dup("-", times = 5)
str_dup("#", times = 80)

# Character Length
str_length("Treatment 1 is as effective as Treatment 2")


# Collapsing and Separating Strings ---------------------------------------

string_vec_1 <- str_c("Treatment", 1:3, sep = " ") %>% print()
string_vec_1 %>% length()


# Create Multiple Strings and then Collapse
string_vec_1c <- str_c("Treatment", 1:3, sep = " ", collapse = "; ") %>% print()
string_vec_1c %>% length()

# Collapse Existing Vector of Strings
str_flatten(string_vec_1, collapse = "; ")

# Split Existing Strings
str_split(string_vec_1c, pattern = "; ")
str_split(string_vec_1c, pattern = "; ") %>% unlist()


# Gluing Strings Together -------------------------------------------------

string_treatment <- str_c("Treatment ", 1:3)
string_status    <- sample(c("is", "is not"), size = 3, replace = TRUE) %>% print()

str_glue("As of {Sys.Date()}, studies show {string_treatment} {string_status} effective")


# Setting String Case  ----------------------------------------------------

string_vec_2 <- "TREATMENT 1 is as effective as TREATMENT 2"

str_to_lower(string_vec_2)
str_to_upper(string_vec_2)
str_to_title(string_vec_2)
str_to_sentence(string_vec_2)


# Controlling String Length -----------------------------------------------

str_length(string_vec_2)

str_pad(string_vec_2, width = 50, side = "right", pad = "-")
str_pad(string_vec_2, width = 50, side = "left",  pad = "-")
str_pad(string_vec_2, width = 50, side = "both",  pad = "-")

str_trunc(string_vec_2, width = 20)
str_trunc(string_vec_2, width = 20, side = "left")
str_trunc(string_vec_2, width = 25, side = "center")


string_long <-
  "According to a new study, treatment 1 is as or more effective than treatment 2 in treating chronic back pain"

str_wrap(string_long, width = 25) %>% cat()
str_wrap(string_long, width = 50) %>% cat()
str_wrap(string_long, width = 75) %>% cat()


# Removing Empty Space ----------------------------------------------------

string_vec_3 <- "  TREATMENT 1 is as   effective as TREATMENT 2  "

str_trim(string_vec_3, side = "right")
str_trim(string_vec_3, side = "left")
str_trim(string_vec_3, side = "both")

str_squish(string_vec_3)


# Pattern Matching --------------------------------------------------------

string_vec_4 <-
  c("TREATMENT 1 is as effective as TREATMENT 2",
    "TREATMENT 3 is not as effective as TREATMENT 2")

word(string_vec_4, start =  3, end = 4)
word(string_vec_4, start = -3, end = -1)

str_extract(string_vec_4, "is\\W\\w\\w+")

str_detect(string_vec_4, "is not")
str_detect(string_vec_4, "is not", negate = TRUE)

str_replace(    string_vec_4,  pattern = "TREATMENT", replacement = "ARM")
str_replace_all(string_vec_4,  pattern = "TREATMENT", replacement = "ARM")

str_remove(    string_vec_4, pattern = "TREATMENT")
str_remove_all(string_vec_4, pattern = "TREATMENT")


# Subsetting Strings ------------------------------------------------------

string_vec_5 <-
  c("Treatment 1 is as effective as treatment 2",
    "Analysis of treatment one suggests it is not as effective as third treatment")


# `Starts` / `Ends` returns logical value if match is found
str_starts(string_vec_5, "Treatment")
str_ends(string_vec_5, "treatment")


# 'Which' returns index of vector element that matches
str_which(string_vec_5, "is not")


# 'Subset' returns vector value that matches
str_subset(string_vec_5, "is not")


# String Formatting -------------------------------------------------------

library(scales)

# Convert Numeric to Character
number(123456)
number(123456, big.mark = ",")


# Round Numeric and Convert
number(123456.78910, big.mark = ",", accuracy = 0.01)
number(123456.78910, big.mark = ",", accuracy = 1000)
number(123456.78910, big.mark = ",", prefix = "~", suffix = " units")

# Shortcut Functions
dollar(123456.78910, big.mark = ",", accuracy = 0.01)
percent(0.12345, accuracy = 0.01)

pvalue(0.12345, add_p = TRUE)
pvalue(0.00012345, add_p = FALSE)
scientific(0.00012345)


# Advanced - Strings in a Pipe --------------------------------------------

data_report <-
  tribble(       ~trt, ~n,     ~label,   ~status,   ~pct,   ~pval,
          "treatment",  1,  "Headache", "is not", 0.4556, 0.00025,
          "treatment",  2, "Back Pain",     "is", 0.8521, 0.04500) %>%
  print()


# Create Strings and Collapse
data_report %>%
  summarise(single_label = str_c("group", n, "is studying", label,
                                 sep = " ",
                                 collapse = " and "))


# Concatenate and Format
data_format <-
  data_report %>%
  mutate(trt_n = str_c(trt, n, sep = " ") %>% str_to_title(),
         pct   = scales::percent(pct, accuracy = 0.1),
         pval  = scales::pvalue(pval, add_p = TRUE)) %>%
  print()


# Glue Strings Together
data_strings <-
  data_format %>%
  mutate(report = str_glue("Note: For {label}, evidence suggests {trt_n} {status} significantly
                            effective with a success rate of {pct} and {pval}
                            with a 95% confidence level.")) %>%
  print()


# Filter Values and Print
data_strings %>%
  filter(!str_detect(status, "is not")) %>%
  pull(report) %>%
  str_wrap(width = 25, indent = 1, exdent = 7) %>%
  cat()


# Documentation -----------------------------------------------------------

# Vignettes
vignette("stringr")
vignette("regular-expressions")

# Help Pages
help(str_c,       package = "stringr")
help(str_glue,    package = "stringr")
help(str_wrap,    package = "stringr")
help(str_split,   package = "stringr")
help(str_trunc,   package = "stringr")
help(str_detect,  package = "stringr")
help(str_extract, package = "stringr")

help(number, package = "scales")

## Website References
# - https://stringr.tidyverse.org
# - https://github.com/tidyverse/stringr
# - https://rstudio.com/resources/cheatsheets/


# Equivalent Operations ---------------------------------------------------

help(sub,       package = "base")
help(gsub,      package = "base")
help(grep,      package = "base")
help(trim,      package = "base")
help(nchar,     package = "base")
help(paste,     package = "base")
help(trimws,    package = "base")
help(strsplit, package = "base")
help(substring, package = "base")

# -------------------------------------------------------------------------
