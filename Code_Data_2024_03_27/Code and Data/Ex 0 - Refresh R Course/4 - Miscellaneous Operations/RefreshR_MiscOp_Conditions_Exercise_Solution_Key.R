# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)

# Exercise Step 2
dm <- tribble(
  ~subjid, ~screendate, ~sex, ~age, ~smoker, ~ae_visit_comment,
  1, as.Date("2022-11-01"), "M", 23, "Y", "Subject experienced headaches.",
  2, as.Date("2022-11-03"), "F", 29, "Y", "Subject experienced pain in joints.",
  3, as.Date("2022-10-31"), "F", 28, "N", "Subject experienced aches in neck.",
  4, as.Date("2022-10-29"), "M", 31, "N", "Subject experienced nausea.",
  5, as.Date("2022-11-01"), "F", 30, "N", "Subject experienced vomitting.",
  6, as.Date("2022-11-04"), "M", 28, "N", "Subject experienced hallucinations.",
  7, as.Date("2022-11-02"), "F", NA, "N", "Subject experienced general pain.",
  8, as.Date("2022-10-30"), "F", 27, "N", "Subject experienced muscle cramps.",
  9, as.Date("2022-10-29"), "M", 30, "N", "Subject experienced headaches.",
  10, as.Date("2022-11-01"), NA, 30, "N", "Subject had no adverse effects."
)


# Exercise Step 3
dm_ex3 <-
  dm %>% 
  mutate(aches_pains = case_when(str_detect(ae_visit_comment, "ache") == TRUE | 
                                 str_detect(ae_visit_comment, "pain") == TRUE    ~ "Y",
                                 TRUE ~ "N"))




# Exercise Step 4
dm_message <-
  dm %>%
  rowwise() %>% 
  mutate(message_all = case_when(all(sex == "M", smoker == "Y", age < 25) ~
                                     "Male smoker under 25 years old",
                                 all(sex == "F", smoker == "Y", age < 30) ~
                                     "Female smoker under 30 years old",
                                 TRUE ~ "Everyone else"),
         message_any = case_when(any(sex == "M", smoker == "Y", age < 25) ~
                                   "Male or smoker or under 25 years old",
                                 any(sex == "F", smoker == "Y", age < 30) ~
                                   "Female or smoker or under 30 years old",
                                 TRUE ~ "Everyone else"))
