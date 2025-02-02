setwd("/cloud/project/Code_Data_2024_03_27/Code and Data/4.0 Tidyverse Data Manipulation")
library(tidyverse)
library(haven)
data_demo <-
  read_sas("_data/dm.sas7bdat")

data_clean <-
  data_demo %>%
  filter(ARM != "SCREEN FAILURE") %>% 
  mutate(RACE_F = factor(RACE, 
                         levels = c("ASIAN","WHITE", "BLACK OR AFRICAN AMERICAN",  "HISPANIC", "OTHER", "UNKNOWN"), 
                         labels = c("Asian", "White", "Black or African American", "Hispanic", "Other", "Unknown"),
                         exclude = NULL, ordered = TRUE)) 
  
data_total <- data_clean %>% 
  mutate(ARM = "Total")

data_all <- rbind(data_clean, data_total)

categorical_race_total <-
  data_all %>%
  group_by(ARM) %>% 
  count(RACE_F, .drop = FALSE) %>%
  mutate(var = "RACE",
         p = n / sum(n),
         Total = ifelse(n==0,sprintf("%5d",0),sprintf("%5d (%5.1f%%)", n, 100*p))) %>%
  rename(label = RACE_F) %>%
  select(ARM,var, label, Total) %>%
  print()


# Pivot Tables - Wide
categorical_summary <-
  categorical_race_total %>%
  pivot_wider(names_from   = ARM,
              values_from  = Total,
              names_sort   = TRUE,
              names_repair = "universal",
              values_fill  = "0") %>%
  print()

# gtsummary
library(gtsummary)
data_all %>% 
  select(ARM,RACE_F, AGE) %>%
  gtsummary::tbl_summary(by = ARM, statistic = list(all_continuous() ~ "{mean} ({sd})",
                                                     all_categorical() ~ "{n} ({p}%)"))


