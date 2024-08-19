# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

# Introduction to Joins ---------------------------------------------------

library(tidyverse)

# Exercise Step 3
# Run the following code to define demographic data for three different studies.
# Note the differences in the data structures.
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
# Combine the rows for `demo_a` and `demo_b`. Any problems?
bind_rows(demo_a, demo_b)

# Exercise Step 5
# Now combine the rows for all three data frames. Does that work?
bind_rows(demo_a, demo_b, demo_c)

# Exercise Step 6
# Write code that would allow you to combine the rows for all three data frames.
# Can you do it in one piped statement?
demo <-
  demo_c %>%
  mutate(sex = ifelse(sex == 1, "M", "F")) %>%
  bind_rows(demo_a, demo_b) %>%
  arrange(study) %>%
  print()

# Tidyverse Joins ---------------------------------------------------------

# Exercise Step 3
# Run the following code to define a `demo` and `otherdata` data set.
# Notice the variable `other` exists in both the `demo` and `otherdata` data set.
# Examine the resulting data after the join in the console.
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

# Exercise Step 4
# Join these two data sets by patient. What are your conclusions about
# “many to many” joins? i.e. Repeats of by values in more than one
# data set during a join.
inner_join(demo, otherdata, by = "patient")

# Exercise Step 5
# Run the following code to define a demo and otherdata data set.
# Notice the variable other exists in both the demo and otherdata data set.
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

# Exercise Step 6
# Join these two data sets by patient. Examine the resulting data after
# the join in the console. How does R handle the same "non-by" variable existing
# in both data sets during a join?
inner_join(demo, otherdata, by = "patient")


# Exercise Step 8
# Using the read_sas() function from the haven package, read in the following
# data sets from your course level directory and save into data frames
# [dm_abc](dm_abc.sas7bdat), [dm_bbc](dm_bbc.sas7bdat), [ae_abc](ae_abc.sas7bdat),
# and [ae_bbc](ae_bbc.sas7bdat) respectfully.
#  a. dm_abc.sas7bdat (use the col_select parameter and only keep the variables:
#    STUDYID, SITEID, SUBJID, ARM, SEX, RACE, AGE).
#  b. dm_bbc.sas7bdat (use the col_select parameter and only keep the variables:
#    STUDYID, SITEID, SUBJID, ARM, SEX, RACE, AGE).
#  c. ae_abc.sas7bdat (use the col_select parameter and only keep the variables:
#    STUDYID, USUBJID, AEBODSYS, AETERM, AESTDY).
#  d. ae_bbc.sas7bdat (use the col_select parameter and only keep the variables:
#    STUDYID, USUBJID, AEBODSYS, AETERM, AESTDY).
library(haven)

dm_abc <- read_sas('_data/dm_abc.sas7bdat',
                   col_select = c(STUDYID, SITEID, SUBJID, ARM, SEX, RACE, AGE))
dm_bbc <- read_sas('_data/dm_bbc.sas7bdat',
                   col_select = c(STUDYID, SITEID, SUBJID, ARM, SEX, RACE, AGE))

ae_abc <- read_sas('_data/ae_abc.sas7bdat',
                   col_select = c(STUDYID, USUBJID, AEBODSYS, AETERM, AESTDY))
ae_bbc <- read_sas('_data/ae_bbc.sas7bdat',
                   col_select = c(STUDYID, USUBJID, AEBODSYS, AETERM, AESTDY))

# Exercise Step 9
# Using the USUBJID variable in each of the ae_abc and ae_bbc data frames,
# create variables SITEID and SUBJID that are consistent with those variables
# in the dm_abc and dm_bbc data frames.
ae_abc <-
  ae_abc %>%
  mutate(SITEID = substring(USUBJID,5,6),
         SUBJID = substring(USUBJID,8,11))

ae_bbc <-
  ae_bbc %>%
  mutate(SITEID = substring(USUBJID,5,6),
         SUBJID = substring(USUBJID,8,11))


# Exercise Step 10
# Combine dm_abc and ae_abc by STUDYID, SITEID, and SUBJID only keeping
# records if the by variable values occur in both data frames.
dm_ae_abc_ij <-
  inner_join(dm_abc, ae_abc,
             by = c("STUDYID" = "STUDYID", "SITEID" = "SITEID", "SUBJID" = "SUBJID"))

# Exercise Step 11
# Combine dm_abc and ae_abc by STUDYID, SITEID, and SUBJID only keeping records
# if the by variable values occur in the dm data frame.
dm_ae_abc_lj <-
  left_join(dm_abc, ae_abc,
            by = c("STUDYID" = "STUDYID", "SITEID" = "SITEID", "SUBJID" = "SUBJID"))

# Exercise Step 12
# Combine dm_abc and ae_abc by STUDYID, SITEID, and SUBJID keeping records regardless
# of which data frame the by variable values occur in.
dm_ae_abc <-
  full_join(dm_abc, ae_abc,
            by = c("STUDYID" = "STUDYID", "SITEID" = "SITEID", "SUBJID" = "SUBJID"))

dm_ae_bbc <-
  full_join(dm_bbc, ae_bbc,
            by = c("STUDYID" = "STUDYID", "SITEID" = "SITEID", "SUBJID" = "SUBJID"))


# Exercise Step 13
# Create a list of SUBJID values that are in dm_abc but not in ae_abc.
dm_ae_abc_aj <-
  anti_join(dm_abc, ae_abc,
            by = c("STUDYID" = "STUDYID", "SITEID" = "SITEID", "SUBJID" = "SUBJID"))


# Exercise Step 14
# Create a data frame named dm_ae_both_studies combining the dm_ae_abc, dm_ae_bbc.
dm_ae_both_studies <-
  bind_rows(dm_ae_abc, dm_ae_bbc)


# Exercise Step 15
# Clean up the AEBODSYS and AETERM variables by replacing the NA values
# with "No Adverse Events".
dm_ae_both_studies <-
  dm_ae_both_studies %>%
  mutate(AEBODSYS = ifelse(is.na(AEBODSYS), "No Adverse Events", AEBODSYS),
         AETERM = ifelse(is.na(AETERM), "No Adverse Events", AETERM))

# Exercise Step 16
# Create a list of SUBJID values that did experience an adverse event and a list
# that did not experience any adverse events.
had_adverse_events <-
  dm_ae_both_studies %>%
  filter(AETERM != "No Adverse Events") %>%
  distinct(STUDYID, SUBJID)

had_no_adverse_events <-
  anti_join(dm_ae_both_studies, had_adverse_events, by = c("STUDYID", "SUBJID")) %>%
  distinct(STUDYID, SUBJID)

# Exercise Step 17
# Using group_by(STUDYID, ARM, AEBODSYS, SEX), summarize(), and other ,dplyr
# functions we have learned about, create the following listing.
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

