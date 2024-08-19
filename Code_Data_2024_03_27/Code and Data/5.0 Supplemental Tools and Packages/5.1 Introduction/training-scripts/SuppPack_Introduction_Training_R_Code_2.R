# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Load Packages
library(tidyverse)
library(haven)
library(logr)
library(tidylog, warn.conflicts = FALSE)

source("./5.1 Introduction/formats.R")

# Attach loggers
options("tidylog.display" = list(log_print), 
        "logr.on" = TRUE,
        "logr.notes" = FALSE)

# Open Log
log_path <- log_open("sp_intro2")


# Prepare Data  ---------------------------------------------------------

# Write out log separator
sep("Read in dm data")

# Load Data
data_demo   <-  
  read_sas("_data/dm.sas7bdat") %>% filter(ARM != "SCREEN FAILURE") 

data_demo %>% glimpse() %>% put()

arm_pop <- table(data_demo$ARM)

arm_pop <- count(data_demo, ARM) %>% deframe()


# Summary Table -----------------------------------------------------------

sep("Create summary statistics for age")

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

sep("Create frequency counts for SEX")


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
  arrange(label) %>% 
  put()

sep("Create frequency counts for RACE")


demo_race <- 
  data_demo %>%
  add_count(ARM, RACE, name = "n_RACE") %>%
  select(ARM, RACE, n_RACE) %>%
  distinct() %>%
  pivot_longer(cols = RACE,
               names_to  = "var",
               values_to = "label") %>%
  pivot_wider(names_from  = ARM,
              values_from = n_RACE,
              values_fill = 0) %>%
  mutate(label = factor(label, levels = names(race_decode),
                        labels = race_decode),
         `ARM A` = cnt_pct(`ARM A`, arm_pop["ARM A"]),
         `ARM B` = cnt_pct(`ARM B`, arm_pop["ARM B"]),
         `ARM C` = cnt_pct(`ARM C`, arm_pop["ARM C"]),
         `ARM D` = cnt_pct(`ARM D`, arm_pop["ARM D"])) %>% 
  arrange(label) %>% 
  put()



sep("Create combined data frame")

demo <- bind_rows(demo_age, demo_sex, demo_race) %>% 
  put()


log_close()


options("tidylog.display" = NULL)

View(demo)



