# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

# Setup -------------------------------------------------------------------

# Load Packages
library(tidyverse)
library(haven)
library(logr)
library(reporter)
library(fmtr)
library(tidylog, warn.conflicts = FALSE)


# Attach loggers
options("tidylog.display" = list(log_print),
        "logr.on" = TRUE,
        "logr.notes" = FALSE)

# Open Log
log_path <- log_open("Table1_0")


# Prepare Data  ---------------------------------------------------------

# Write out log separator
sep("Read in dm data")

# Load Data
data_demo <- "_data/dm.sas7bdat" %>%
  read_sas() %>% filter(ARM != "SCREEN FAILURE")

# Duplicate the data and define the ARM variable as "Total"
data_demo_arm_total <-
  data_demo %>%
  mutate(ARM = 'Total')

# Stack the "by ARM" data with the "Total" ARM data
data_demo <-
  bind_rows(data_demo, data_demo_arm_total)

data_demo %>% glimpse() %>% put()

# Get ARM population counts
arm_pop <- count(data_demo, ARM) %>% deframe() %>% put()


# Age Summary Block -------------------------------------------------------

sep("Create summary statistics for age")

demo_age <-
  data_demo %>%
  group_by(ARM) %>%
  summarise(across(.cols = AGE,
                   .fns = list(N = ~ fmt_n(.),
                               `Mean (SD)` = ~ fmt_mean_sd(.),
                               Median = ~ fmt_median(.),
                               `Q1 - Q3` = ~ fmt_quantile_range(.),
                               Range  = ~ fmt_range(.)
                   ))) %>%
  pivot_longer(-ARM,
               names_to  = c("var", "label"),
               names_sep = "_",
               values_to = "value") %>%
  pivot_wider(names_from = ARM,
              values_from = "value") %>%
  mutate(var = "Age (yr)") %>%
  put()

age_block <- demo_age

# Age Group Block ----------------------------------------------------------

sep("Create frequency counts for Age Group")

# Create age categorization format
age_grp  <- value(condition(x >= 18 & x <= 40, "18 - 40 yr"),
                  condition(x >= 41 & x <= 64, "41 - 64 yr"),
                  condition(x >= 65, ">= 65 yr"))

data_demo$AGEG <- fapply(data_demo$AGE, age_grp)

# Get age group non-missing population counts
ageg_pop_df <- data_demo %>% filter(!is.na(AGE)) %>% count(ARM) %>% put()
ageg_pop <- ageg_pop_df %>% deframe() %>% put()

# Create age group N row
demo_ageg_pop <- data.frame("Age Group", "N", as.list(as.character(ageg_pop)))
names(demo_ageg_pop) <- c("var", "label", names(ageg_pop))
put(demo_ageg_pop)

# Create age group frequency counts
demo_ageg <-
  data_demo %>%
  select(ARM, AGEG) %>%
  group_by(ARM, AGEG) %>%
  summarize(n = n()) %>%
  pivot_wider(names_from = ARM,
              values_from = n,
              values_fill = 0) %>%
  transmute(var = "Age Group",
            label =  factor(AGEG, levels = labels(age_grp)),
            `ARM A` = fmt_cnt_pct(`ARM A`, ageg_pop["ARM A"]),
            `ARM B` = fmt_cnt_pct(`ARM B`, ageg_pop["ARM B"]),
            `ARM C` = fmt_cnt_pct(`ARM C`, ageg_pop["ARM C"]),
            `ARM D` = fmt_cnt_pct(`ARM D`, ageg_pop["ARM D"]),
            Total   = fmt_cnt_pct(Total,ageg_pop["Total"])) %>%
  arrange(label) %>%
  put()

# Combine into sex_block
ageg_block <- bind_rows(demo_ageg_pop, demo_ageg) %>% put()


# Sex Block ---------------------------------------------------------------

sep("Create frequency counts for SEX")

# Prepare decode
sex_decode <- c("M" = "Male",
                "F" = "Female")

# Get sex non-missing population counts
sex_pop_df <- data_demo %>% filter(!is.na(SEX)) %>% count(ARM) %>% put()
sex_pop <- sex_pop_df %>% deframe() %>% put()

# Create sex N row
demo_sex_pop <- data.frame("Sex", "N", as.list(as.character(sex_pop)))
names(demo_sex_pop) <- c("var", "label", names(sex_pop))
put(demo_sex_pop)

# Create sex frequency counts
demo_sex <-
  data_demo %>%
  select(ARM, SEX) %>%
  group_by(ARM, SEX) %>%
  summarize(n = n()) %>%
  pivot_wider(names_from = ARM,
              values_from = n,
              values_fill = 0) %>%
  transmute(var = "Sex",
            label =  factor(SEX, levels = names(sex_decode),
                            labels = sex_decode),
            `ARM A` = fmt_cnt_pct(`ARM A`, sex_pop["ARM A"]),
            `ARM B` = fmt_cnt_pct(`ARM B`, sex_pop["ARM B"]),
            `ARM C` = fmt_cnt_pct(`ARM C`, sex_pop["ARM C"]),
            `ARM D` = fmt_cnt_pct(`ARM D`, sex_pop["ARM D"]),
            Total   = fmt_cnt_pct(Total  , sex_pop["Total"])) %>%
  arrange(label) %>%
  put()

# Combine into sex_block
sex_block <- bind_rows(demo_sex_pop, demo_sex) %>% put()


# Race Block --------------------------------------------------------------

sep("Create frequency counts for RACE")

# Prepare decode
race_decode <- c("WHITE" = "White",
                 "BLACK OR AFRICAN AMERICAN" = "Black or African American",
                 "ASIAN" = "Asian",
                 "NATIVE AMERICAN" = "Native American",
                 "UNKNOWN" = "Unknown")

# Get race non-missing population counts
race_pop_df <- data_demo %>% filter(!is.na(RACE)) %>% count(ARM) %>% put()
race_pop <- race_pop_df %>% deframe() %>% put()

# Create race N row
demo_race_pop <- data.frame("Race", "N", as.list(as.character(race_pop))) %>% put()
names(demo_race_pop) <- c("var", "label", names(race_pop)) %>% put()

# Create sex frequency counts
demo_race <-
  data_demo %>%
  select(ARM, RACE) %>%
  group_by(ARM, RACE) %>%
  summarize(n = n()) %>%
  pivot_wider(names_from = ARM,
              values_from = n,
              values_fill = 0) %>%
  transmute(var = "Race",
            label =  factor(RACE, levels = names(race_decode),
                            labels = race_decode),
            `ARM A` = fmt_cnt_pct(`ARM A`, race_pop["ARM A"]),
            `ARM B` = fmt_cnt_pct(`ARM B`, race_pop["ARM B"]),
            `ARM C` = fmt_cnt_pct(`ARM C`, race_pop["ARM C"]),
            `ARM D` = fmt_cnt_pct(`ARM D`, race_pop["ARM D"]),
            Total   = fmt_cnt_pct(Total  , race_pop["Total"])) %>%
  arrange(label) %>%
  put()

race_block <- bind_rows(demo_race_pop, demo_race) %>% put()


# Final Data --------------------------------------------------------------

sep("Create combined data frame")

final <- bind_rows(age_block, ageg_block, sex_block, race_block) %>%
  put()


# Print Report (Separate Labels) -------------------------------------------

sep("Create and print report (Separate Labels)")

# Create Table
tbl <- create_table(final, first_row_blank = TRUE) %>%
  define(var, blank_after = TRUE, dedupe = TRUE, label = "") %>%
  define(label, label = "") %>%
  define(`ARM A`, align = "center", n = arm_pop["ARM A"]) %>%
  define(`ARM B`, align = "center", n = arm_pop["ARM B"]) %>%
  define(`ARM C`, align = "center", n = arm_pop["ARM C"]) %>%
  define(`ARM D`, align = "center", n = arm_pop["ARM D"]) %>%
  define(Total  , align = "center", n = arm_pop["Total"])

rpt <- create_report("output/Exercise1_Table1_0a.txt") %>%
  titles("Table 1.0a", "Demographics and Baseline Characteristics") %>%
  add_content(tbl)

write_report(rpt) %>% put()




# Print Report (Nested Labels) ------------------------------------------

sep("Create and print report (Nested Labels)")


tbl <- create_table(final, first_row_blank = TRUE) %>%
  stub(vars = c("var", "label")) %>%
  define(var, blank_after = TRUE, label_row = TRUE) %>%
  define(label, indent = .25) %>%
  define(`ARM A`, align = "center", n = arm_pop["ARM A"]) %>%
  define(`ARM B`, align = "center", n = arm_pop["ARM B"]) %>%
  define(`ARM C`, align = "center", n = arm_pop["ARM C"]) %>%
  define(`ARM D`, align = "center", n = arm_pop["ARM D"]) %>%
  define(Total,   align = "center", n = arm_pop["Total"])

rpt <- create_report("output/Exercise1_Table1_0b.txt") %>%
  titles("Table 1.0b", "Demographics and Baseline Characteristics") %>%
  add_content(tbl)

write_report(rpt) %>% put()



# Clean Up ----------------------------------------------------------------


log_close()

options("tidylog.display" = NULL)

