# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)
library(janitor)


# Exercise Step 2
dm <- tribble(
  ~subjid, ~screendate, ~sex, ~age, ~smoker, ~ae,
  1, as.Date("2022-11-01"), "M", 23, "Y", "aches.",
  2, as.Date("2022-11-03"), "F", 29, "Y", "pain",
  3, as.Date("2022-10-31"), "F", 28, "N", "aches",
  4, as.Date("2022-10-29"), "M", 31, "N", "nausea",
  5, as.Date("2022-11-01"), "F", 30, "N", "vomitting",
  6, as.Date("2022-11-04"), "M", 28, "N", "hallucinations",
  7, as.Date("2022-11-02"), "F", NA, "N", "pain",
  8, as.Date("2022-10-30"), "F", 27, "N", "cramps.",
  9, as.Date("2022-10-29"), "M", 30, "N", "aches.",
  10, as.Date("2022-11-01"), "F", 35, "N", "none"
)

# Exercise Step 3
table(dm$sex)
table(dm$smoker)
table(dm$sex, dm$smoker)


# Exercise Step 4
dm %>% 
  count(sex, smoker)


# Exercise Step 5
dm %>% 
  tabyl(sex, smoker) %>% 
  adorn_totals() %>%
  adorn_percentages() %>%
  adorn_pct_formatting() %>%
  adorn_ns() %>%
  adorn_title("Table of Sex by Smoker", placement = "top")
