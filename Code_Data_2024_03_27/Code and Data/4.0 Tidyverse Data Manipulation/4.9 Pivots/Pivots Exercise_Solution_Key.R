# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key


# Pivot Long --------------------------------------------------------------

library(tidyverse)

# Exercise Step 3
labdata1 <- tribble(
  ~LabCode,        ~Baseline, ~Week1
  ,"Assay1",         45,         50
  ,"Assay2",         10,         12
)

labdata2 <- tribble(
  ~LabCode,     ~Visit,       ~LabValue
  ,"Assay1",    "Baseline",     45
  ,"Assay1",    "Week1",        50
  ,"Assay2",    "Baseline",     10
  ,"Assay2",    "Week1",        12
  )

# Exercise Step 4
# Using the `pivot()` function that you learned about in the video, transform
# `labdata1` into a data frame that is equivalent to `labdata2`. Name the
# data frame `labdata1_v`.
labdata1_v <-
  labdata1 %>%
  pivot_longer(
    cols       = c(Baseline, Week1),
    names_to   = "Visit",
    values_to  = "LabValue"
  )

# Exercise Step 5
# Inspect the results in the console to check your work. If you did not get
# all `TRUE` values in the console for each step, revisit your work.
labdata2 == labdata1_v
identical(labdata2, labdata1_v)

# Exercise Step 7
labdata3 <- tribble(
  ~Visit,        ~Assay1, ~Assay2
  ,"Baseline",      45,         10
  ,"Week1",         50,         12
)

# Exercise Step 8
# Using the `pivot()` function that you learned about in the video, transform
# `labdata3` into a data frame that is equivalent to `labdata2` from the
# earlier steps. Name the data frame `labdata3_v`.
labdata3_v <-
  labdata3 %>%
  pivot_longer(
    cols       = c(Assay1, Assay2),
    names_to   = "LabCode",
    values_to  = "LabValue"
  ) %>%
  select(LabCode, Visit, LabValue) %>%
  arrange(LabCode, Visit)

# Exercise Step 9
# Inspect the results in the console to check your work. If you did not get
# all "TRUE" values in the console for each step, revisit your work. You
# may have to `pipe` together more functions to make them identical.
# *Note: variable and sort order matters.*
labdata3_v == labdata2
identical(labdata3_v, labdata2)

# Pivot Wide --------------------------------------------------------------

# Exercise Step 4
# Using the `pivot()` function that you learned about in the video, transform
# `labdata2` into a data frame that is equivalent to `labdata1`. Name the
# data frame `labdata2_h`
labdata2_h <-
  labdata2 %>%
  pivot_wider(
    id_cols = c(LabCode),
    names_from = Visit,
    values_from = LabValue
  )

# Exercise Step 5
# Inspect the results in the console to check your work. If you did not get
# all "TRUE" values in the console for each step, revisit your work.
labdata2_h == labdata1
identical(labdata1, labdata2_h)

library(haven)

# Exercise Step 7
# Read in the SAS Data Set bbc_adam_adlb.sas7bdat from the course level directory.
# Only keep the variables SUBJID, SITEID, TRTA, AVISITN, PARCAT1, AVALC, PARAM, PARAMCD.
lab_bbc <- read_sas(
  '_data/bbc_adam_adlb.sas7bdat',
  col_select = c(SUBJID, SITEID, TRTA, AVISITN, PARCAT1, AVALC, PARAM, PARAMCD)
)

# Exercise Step 8
# Create a prep data set only keeping records based on the following criteria.
#  `PARAMCD` is equal to "K" and the `AVISITN` is not missing.
lab_bbc_prep_K <-
  lab_bbc %>%
  filter(is.na(AVISITN) == "FALSE" & PARAMCD == "K")

# Exercise Step 9
# Now use functions we have learned and do the following.
#  a. Group by `SITEID` and `TRTA`.
#  b. Alter `TRTA` replacing the space with an underscore. i.e. `ARM A`
#    becomes `ARM_A`.
#  c. Calculate the mean using the `summarize()` function.
#  d. Pivot wider creating a tibble that looks like the console output below.
lab_bbc_K_analysis <-
  lab_bbc_prep_K %>%
  mutate(TRTA = sub(" ", "_", TRTA)) %>%
  group_by(SITEID, TRTA) %>%
  summarize(MeanValue = mean(as.numeric(AVALC))) %>%
  pivot_wider(
    id_cols = c(SITEID),
    names_from = TRTA,
    values_from = MeanValue,
    names_repair = "universal"
  )

lab_bbc_K_analysis

