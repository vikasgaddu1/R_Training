# Load Packages
library(tidyverse)
library(haven)

# Exercise step 4
# Be sure your working directory is set to the course 5 level directory.
# use setwd() function or the session program menu.
setwd("/cloud/project/Code_Data_2024_03_27/Code and Data/5.0 Supplemental Tools and Packages")
# Exercise step 4.b
library(logr)
library(tidylog)

# Exercise step 4.c
# options("tidylog.display" = list(log_print))

# For Exercise step 5.b, uncomment the lines below.
options("tidylog.display" = list(log_print),
     "logr.on" = FALSE, "logr.notes" = FALSE)


log_open(file_name = "5.1 Introduction/log/intro_ex_4.log")


# Exercise step 4.d
# use sep() and put() functions throughout the 
# rest of the script where appropriate.

sep("Read in the formats")
source("5.1 Introduction/exercise-scripts/formats.R")


sep("Read in the data")
data_demo   <- 
  read_sas("_data/dm.sas7bdat") %>% 
  filter(ARM != "SCREEN FAILURE") %>% 
  put()

arm_pop <- 
  table(data_demo$ARM) %>% 
  put()

sep("Named lists for use in factor functions in sex and race data summary steps.")
sex_decode <- c("M" = "Male",
                "F" = "Female") %>% 
  put()

race_decode <- c("WHITE" = "White",
                 "BLACK OR AFRICAN AMERICAN" = "Black or African American",
                 "ASIAN" = "Asian",
                 "NATIVE AMERICAN" = "Native American",
                 "UNKNOWN" = "Unknown") %>% 
  put()


# Summary Table -----------------------------------------------------------

sep("Create the age summary")
demo_age <-
  data_demo %>%
  group_by(ARM) %>%
  summarise(across(.cols = AGE,
                   .fns = list(N      = ~ n_fmt(.),
                               Mean   = ~ mean_sd(mean(.), sd(.)),
                               Median = ~ median_fmt(median(.)),
                               `Q1 - Q3` = ~ quantile_range(quantile(., 0.25),
                                                            quantile(., 0.75)),
                               Range  = ~ range_fmt(range(.))
                   ))) %>%
  pivot_longer(-ARM,
               names_to  = c("var", "label"),
               names_sep = "_",
               values_to = "value") %>%
  pivot_wider(names_from = ARM,
              values_from = "value") %>% 
  put()


sep("Create the sex summary")
demo_sex <-
  data_demo %>%
  add_count(ARM, SEX,  name = "n_SEX") %>%
  select(ARM, SEX, n_SEX) %>%
  distinct() %>%
  pivot_longer(cols = c(SEX),
               names_to  = "var",
               values_to = "label") %>%
  pivot_wider(names_from  = ARM,
              values_from = n_SEX,
              values_fill = 0) %>%
  mutate(label = factor(label, levels = names(sex_decode),
                        labels = sex_decode),
         `ARM A` = cnt_pct(`ARM A`, arm_pop["ARM A"]),
         `ARM B` = cnt_pct(`ARM B`, arm_pop["ARM B"]),
         `ARM C` = cnt_pct(`ARM C`, arm_pop["ARM C"]),
         `ARM D` = cnt_pct(`ARM D`, arm_pop["ARM D"])) %>% 
  put()


sep("Create the race summary")
demo_race <-
  data_demo %>%
  add_count(ARM, RACE, name = "n_RACE") %>%
  select(ARM, RACE, n_RACE) %>%
  distinct() %>%
  pivot_longer(cols = RACE,
               names_to  = "var",
               values_to = "label") %>%
  pivot_longer(cols = n_RACE,
               names_to = "var_match",
               names_prefix = "n_",
               values_to = "N") %>%
  filter(var == var_match) %>%
  select(-var_match) %>%
  distinct() %>%
  pivot_wider(names_from  = ARM,
              values_from = N,
              values_fill = 0) %>%
  mutate(label = factor(label, levels = names(race_decode),
                        labels = race_decode),
         `ARM A` = cnt_pct(`ARM A`, arm_pop["ARM A"]),
         `ARM B` = cnt_pct(`ARM B`, arm_pop["ARM B"]),
         `ARM C` = cnt_pct(`ARM C`, arm_pop["ARM C"]),
         `ARM D` = cnt_pct(`ARM D`, arm_pop["ARM D"])) %>%
  arrange(var, label) %>% 
  put()


sep("Stack the summary data frames")
demo <- 
  bind_rows(demo_age, demo_sex, demo_race) %>% 
  put()


# Exercise step 4.e
log_close()
options("tidylog.display" = NULL)




