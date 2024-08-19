# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)
library(haven)
library(labelled)


# Read in raw Demographic data from SAS Data Sets for studies ABC and BBC
dm_abc <- read_sas('data/abc_crf_dm.sas7bdat', col_select = c(STUDYID, SUBJECT))
dm_bbc <- read_sas('data/bbc_crf_dm.sas7bdat', col_select = c(STUDYID, SUBJECT))

# Read in raw Vital Signs data from SAS Data Sets for studies ABC and BBC
pe_abc <- read_sas('data/abc_crf_pe.sas7bdat')
pe_bbc <- read_sas('data/bbc_crf_pe.sas7bdat')

# Combine and prepare demographic data
dm_prep <-
  bind_rows(dm_abc, dm_bbc) %>%
  mutate(patid = as.numeric(substring(SUBJECT,4,6)),
         BlindCode = ifelse(patid %% 2 == 0, "Placebo","Active")) %>%
  select(-patid)


# pelabels <- unlist(var_label(pe_abc))
#
# pel <-
#  as_tibble(pelabels, rownames = "PEAbbr")

pe_prep <-
  bind_rows(pe_abc, pe_bbc) %>%
  select(STUDYID, SUBJECT, VISIT, contains("RES")) %>%
  pivot_longer(cols = contains("RES"),
               names_to = c("PE_Item_Abbr"),
               values_to = "Answer") %>%
  mutate(AnswerC = case_when(Answer == 0 ~ "Normal",
                             Answer == 1 ~ "Abnormal",
                             Answer == 2 ~ "Not Done"),
         PE_Item = case_when(PE_Item_Abbr == "ABRES"   ~ "Abdomen",
                             PE_Item_Abbr == "CARES"   ~ "Cardiovascular",
                             PE_Item_Abbr == "DERMRES" ~ "Skin, excluding Psoriasis",
                             PE_Item_Abbr == "EXRES"   ~ "Extremities",
                             PE_Item_Abbr == "GARES"   ~ "General Appearance",
                             PE_Item_Abbr == "HERES"   ~ "HEENT/Neck",
                             PE_Item_Abbr == "MURES"   ~ "Muskuloskeletal",
                             PE_Item_Abbr == "NARES"   ~ "Nails",
                             PE_Item_Abbr == "NERES"   ~ "Neurological",
                             PE_Item_Abbr == "PURES"   ~ "Pulmonary"
         ))

dmpe <-
  left_join(dm_prep, pe_prep, by = c("STUDYID" = "STUDYID", "SUBJECT" = "SUBJECT"))

# Exercise Step 7
dmpe %>%
  count(BlindCode, AnswerC)


