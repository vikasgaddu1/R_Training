
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2022 Anova Groups All rights reserved

# Title: Data Types - Character Values

# Packages & Functions on Display:
# - {base    4.2.0}: paste(), paste0(), sprintf(), nchar(), toupper()
#                   substring(), as.numeric(), as.character(), grepl(), sub(),
#                   gsub(), trimws(), ifelse()
#
# - {stringr 1.4.0}: str_c(), str_flatten(), str_glue(), str_length(), str_to_upper()
#                   str_sub(), str_detect(), str_replace(), str_replace_all(),
#                   str_remove(), str_remove_all(), str_trim(), str_squish(),
#                   word(),
#
# - {dplyr   1.0.8}: mutate(), select()


# Setup -------------------------------------------------------------------
# The 'stringr' package from the tidyverse will help you remember what fns do

library(tidyverse)

# Character Values --------------------------------------------------------

vec_str <- "Carbohydrate tolerance analyses (incl diabetes)"

# Concatenation -----------------------------------------------------------

paste("HLT Term:", vec_str)                 # Includes a space separator
paste0("HLT Term:", vec_str)                # Uses no separators

str_c("HLT Term:", vec_str)                 # Uses no separators
str_c("HLT Term:", vec_str, sep = " ")      # Includes a space separator


# Concatenation Recycling
paste("Study", 1:5, vec_str)
str_c("Study", 1:5, vec_str, sep = " ")


# Collapse vector of strings into single string
LETTERS
paste("Study", LETTERS, collapse = " and ")
str_c("Study", LETTERS, sep = " ") %>% str_flatten(" and ")


# Insert strings into text
label_1 <- "carbohydrate tolerance"

sprintf("Study 1: %s (Incl. Diabetes)", label_1)
str_glue("Study 1: {label_1 %>% str_to_title()} (Incl. Diabetes)")



# String Operations -------------------------------------------------------

# Count the number of characters
vec_str %>% nchar()
vec_str %>% str_length()


# Control capitalization
vec_str %>% toupper()      # Also: tolower()
vec_str %>% str_to_upper() # Also: str_to_lower(), str_to_title(), str_to_sentence()

# Subset a string
vec_str %>% substring(first = 10, last = 15)
vec_str %>% str_sub(start = 10, end = 15)


# Convert From/To Character
"1200" %>% as.numeric()
1200  %>% as.character()


# Detect characters
grepl("toler", vec_str)               # Can't be used in pipe format
str_detect(vec_str, "toler")



# Replacement -------------------------------------------------------------

sub("a", "AAA", vec_str)               # Can't be used in pipe format
gsub("a", "AAA", vec_str)

vec_str %>% str_replace("a", "AAA")
vec_str %>% str_replace_all("a", "AAA")

vec_str %>% str_remove("a")
vec_str %>% str_remove_all("a")


# Remove Whitespaces
trimws("  Study  A  ")
str_trim("  Study  A  ")
str_squish("  Study  A  ")



# String Operations in a Tidyverse Pipeline -------------------------------

df_ae <- read_rds("data/df_ae.rds")

df_ae %>%
  select(subject, hlt_term) %>%
  mutate(
    v1 = hlt_term %>% word(1),
    v2 = ifelse(
      test = hlt_term %>% str_to_lower() %>% str_detect("aches"),
      yes  = "aches",
      no   = "no aches"),
    v3 = str_glue("Subject {subject} has {v2}"))


# Documentation -----------------------------------------------------------

# Vignettes
vignette("stringr")
vignette("regular-expressions")

# Help Pages
help("character")

# Website References
# - https://stringr.tidyverse.org/
# - https://r4ds.had.co.nz/strings.html
# - https://www.rstudio.com/resources/cheatsheets/

# -------------------------------------------------------------------------
