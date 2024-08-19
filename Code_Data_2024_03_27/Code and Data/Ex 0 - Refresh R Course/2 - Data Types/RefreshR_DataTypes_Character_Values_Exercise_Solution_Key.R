# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)

# Exercise Step 2
first <- c("George", "Samuel", "Booker", "George", "Martin")
middle <- c("Washington", "T.", "T.", "W.", "Luther")
last <- c("Carver", "Jackson", "Washington", "Bush", "King")

full_fml_paste <- 
  paste(first, middle, last) %>% 
  print()

full_fml_str   <- 
  str_c(first, middle, last, sep = " ") %>% 
  print()

full_lfm_paste <- 
  paste(last, ",", first, middle) %>% 
  print()

full_lfm_str   <- 
  str_c(last, ",", first, middle, sep = " ") %>% 
  print()


# Exercise step 3
nchar(middle)
str_length(middle)


# Exercise step 4
initials_substring <- 
  tolower(paste0(substring(first,  first = 1, last = 1), 
                 substring(middle, first = 1, last = 1),
                 substring(last,   first = 1, last = 1))) 
  
initials_str_sub <- 
  str_to_lower(str_c(str_sub(first,  start = 1, end = 1), 
                     str_sub(middle, start = 1, end = 1),
                     str_sub(last,   start = 1, end = 1))) 

# Exercise Step 5
library(haven)
cm <- 
  read_sas("./data/abc_crf_cm.sas7bdat") %>% 
  filter(SUBJECT == "01-052") %>% 
  distinct(SUBJECT, CMTRT, CMINDC) %>% 
  mutate(NEW_CMINDC = str_replace_all(CMINDC, "PAIN", "OUCHIE"),
         SENTENCE = str_c("Subject", SUBJECT, "took", CMTRT, 
                          "for", NEW_CMINDC, sep = " " ))
