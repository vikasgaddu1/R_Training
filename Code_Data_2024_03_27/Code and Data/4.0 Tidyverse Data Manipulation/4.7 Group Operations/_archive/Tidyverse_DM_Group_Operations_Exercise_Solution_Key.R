# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)

# Exercise Step 3
adae <- readRDS('_data/adae.rds')

# Exercise Step 4
adae_headache <-
  adae %>%
  select(SITEID, SUBJID, TRTA, AESTDY, AETERM) %>%
  filter(AETERM == "HEADACHE")

# Exercise Step 5
adae_headache %>%
  group_by(TRTA)

class(adae_headache)

# Exercise Step 7
adae_headache <-
  adae_headache %>%
  group_by(TRTA)

class(adae_headache)

# Exercise Step 9
# without sorting
adae_headache1st <-
  adae_headache %>%
  group_by(TRTA) %>%
  slice_head(n = 1)

adae_headache1st

# Exercise Step 9 continued
# with sorting
adae_headache1st <-
  adae_headache %>%
  group_by(TRTA) %>%
  arrange(TRTA, SUBJID, AESTDY) %>%
  slice_head(n = 1)

# notice how results change with sorting
adae_headache1st

# Exercise Step 11
adae_gb <-
  adae %>%
  select(TRTA, AEBODSYS, AETERM, SITEID, SUBJID, AESTDY) %>%
  group_by(TRTA, AEBODSYS, AETERM) %>%
  mutate(TRTA = ifelse(TRTA == "", "NO ARM", TRTA)) %>%
  arrange(TRTA, AEBODSYS, AETERM)

adae_gb

anyNA(adae_gb)

anyNA(adae_gb$AESTDY)

# Exercise Step 12
ae_stats <- adae_gb %>%
  summarize(
    count_subj_w_ae = n_distinct(SUBJID),
    min_time_to_event = min(AESTDY, na.rm = TRUE),
    ave_time_to_event = mean(AESTDY, na.rm = TRUE),
    max_time_to_event = max(AESTDY, na.rm = TRUE)
  ) %>%
  filter(count_subj_w_ae > 1) %>%
  arrange(desc(count_subj_w_ae))

ae_stats

