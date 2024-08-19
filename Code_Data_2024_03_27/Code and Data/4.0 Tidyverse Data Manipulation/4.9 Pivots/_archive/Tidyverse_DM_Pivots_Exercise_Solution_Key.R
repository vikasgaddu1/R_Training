# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

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
labdata1_v <-
  labdata1 %>%
  pivot_longer(
    cols       = c(Baseline, Week1),
    names_to   = "Visit",
    values_to  = "LabValue"
  )

# Exercise Step 5
labdata2 == labdata1_v
identical(labdata2, labdata1_v)

# Exercise Step 7
labdata2_h <-
  labdata2 %>%
  pivot_wider(
    id_cols = c(LabCode),
    names_from = Visit,
    values_from = LabValue
  )

# Exercise Step 8
labdata2_h == labdata1
identical(labdata1, labdata2_h)


# Exercise Step 10
labdata3 <- tribble(
   ~Visit,        ~Assay1, ~Assay2
  ,"Baseline",      45,         10
  ,"Week1",         50,         12
)

# Exercise Step 11
labdata3_v <-
  labdata3 %>%
  pivot_longer(
    cols       = c(Assay1, Assay2),
    names_to   = "LabCode",
    values_to  = "LabValue"
  ) %>%
  select(LabCode, Visit, LabValue) %>%
  arrange(LabCode, Visit)

# Exercise Step 12
labdata3_v == labdata2
identical(labdata3_v, labdata2)


library(haven)

# Exercise Step 14
# Read in the SAS Data Set bbc_adam_adlb.sas7bdat from the course level directory.
# Only keep the variables SUBJID, SITEID, TRTA, AVISITN, PARCAT1, AVALC, PARAM, PARAMCD.
lab_bbc <- read_sas(
  'data/bbc_adam_adlb.sas7bdat'
  ,
  col_select = c(SUBJID, SITEID, TRTA, AVISITN, PARCAT1, AVALC, PARAM, PARAMCD)
)

# Exercise Step 15
lab_bbc_prep_K <-
  lab_bbc %>%
  filter(is.na(AVISITN) == "FALSE" & PARAMCD == "K")

# Exercise Step 16
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

