# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)

# Exercise Step 3
demo_a <- tribble(
  ~study, ~inv, ~patient, ~sex
  ,"StudyA", 2000, 1, "M"
)

demo_b <- tribble(
  ~study, ~inv, ~patient, ~sex
  ,"StudyB", 2000, 1, "F"
)

demo_c <- tribble(
  ~study, ~inv, ~patient, ~sex
  ,"StudyC", 2000, 1, 2
)

# Exercise Step 4
bind_rows(demo_a, demo_b)

# Exercise Step 5
bind_rows(demo_a, demo_b, demo_c)

# Exercise Step 7
demo <- tribble(
  ~patient, ~sex
  ,1, "M"
  ,2, "F"
  ,1, "M"
)

otherdata <- tribble(
  ~patient, ~visit, ~other
  ,1, "S", "Normal"
  ,1, "B", "Normal"
  ,2, "B", "Normal"
  ,2, "1", "Normal"
  ,1, "1", "Abnormal"
  ,2, "S", "Abnormal"
)

inner_join(demo, otherdata, by = "patient")

# Exercise Step 9
demo <- tribble(
  ~patient, ~sex, ~other
  ,1, "M", "other value"
  ,2, "F", "other value"
)

otherdata <- tribble(
  ~patient, ~visit, ~other
  ,1, "S", "Normal"
  ,1, "B", "Normal"
  ,1, "1", "Abnormal"
  ,2, "S", "Abnormal"
  ,2, "B", "Normal"
  ,2, "1", "Normal"
)

inner_join(demo, otherdata, by = "patient")


# Exercise Step 12
library(haven)

dm_abc <- read_sas('data/dm_abc.sas7bdat',
                   col_select = c(STUDYID, SITEID, SUBJID, ARM, SEX, RACE, AGE))
dm_bbc <- read_sas('data/dm_bbc.sas7bdat',
                   col_select = c(STUDYID, SITEID, SUBJID, ARM, SEX, RACE, AGE))

ae_abc <- read_sas('data/ae_abc.sas7bdat',
                   col_select = c(STUDYID, USUBJID, AEBODSYS, AETERM, AESTDY))
ae_bbc <- read_sas('data/ae_bbc.sas7bdat',
                   col_select = c(STUDYID, USUBJID, AEBODSYS, AETERM, AESTDY))
# Exercise Step 13
ae_abc <-
  ae_abc %>%
  mutate(SITEID = substring(USUBJID,5,6),
         SUBJID = substring(USUBJID,8,11))

ae_bbc <-
  ae_bbc %>%
  mutate(SITEID = substring(USUBJID,5,6),
         SUBJID = substring(USUBJID,8,11))


# Exercise Step 14
dm_ae_abc_ij <-
  inner_join(dm_abc, ae_abc,
             by = c("STUDYID" = "STUDYID", "SITEID" = "SITEID", "SUBJID" = "SUBJID"))

# Exercise Step 15
dm_ae_abc_lj <-
  left_join(dm_abc, ae_abc,
            by = c("STUDYID" = "STUDYID", "SITEID" = "SITEID", "SUBJID" = "SUBJID"))

# Exercise Step 16
dm_ae_abc <-
  full_join(dm_abc, ae_abc,
            by = c("STUDYID" = "STUDYID", "SITEID" = "SITEID", "SUBJID" = "SUBJID"))

# Exercise Step 17
dm_ae_abc_aj <-
  anti_join(dm_abc, ae_abc,
            by = c("STUDYID" = "STUDYID", "SITEID" = "SITEID", "SUBJID" = "SUBJID"))


# Exercise Step 18
dm_ae_bbc <-
  full_join(dm_bbc, ae_bbc,
            by = c("STUDYID" = "STUDYID", "SITEID" = "SITEID", "SUBJID" = "SUBJID"))

# Exercise Step 19
dm_ae_both_studies <-
  bind_rows(dm_ae_abc, dm_ae_bbc) %>%
  mutate(AEBODSYS = ifelse(is.na(AEBODSYS), "No Adverse Events", AEBODSYS),
         AETERM = ifelse(is.na(AETERM), "No Adverse Events", AETERM))

# Exercise Step 20
had_adverse_events <-
  dm_ae_both_studies %>%
  filter(AETERM != "No Adverse Events") %>%
  distinct(STUDYID, SUBJID)

had_no_adverse_events <-
  anti_join(dm_ae_both_studies, had_adverse_events, by = c("STUDYID", "SUBJID")) %>%
  distinct(STUDYID, SUBJID)

# Exercise Step 21
dm_ae_stats <-
  dm_ae_both_studies %>%
  select(STUDYID, ARM, AEBODSYS, SUBJID, AGE, SEX) %>%
  group_by(STUDYID, ARM, AEBODSYS, SEX) %>%
  summarize(count_subj_w_ae = n_distinct(SUBJID),
            min_age = min(AGE, na.rm = TRUE),
            ave_age = mean(AGE, na.rm = TRUE),
            max_age = max(AGE, na.rm = TRUE)) %>%
  filter(count_subj_w_ae > 4 & AEBODSYS != "No Adverse Events") %>%
  arrange(STUDYID, SEX, desc(count_subj_w_ae))

dm_ae_stats

