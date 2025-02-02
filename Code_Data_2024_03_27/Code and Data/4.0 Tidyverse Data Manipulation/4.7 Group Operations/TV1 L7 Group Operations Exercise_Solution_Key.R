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

adae_headache %>% is_grouped_df()

adae_headache %>% group_keys()

# Exercise Step 9
# without sorting
adae_headache1st <-
  adae_headache %>%
  group_by(TRTA) %>%
  slice_head(n = 1)

adae_headache1st

class(adae_headache1st)

# Exercise Step 9 continued
# with sorting
adae_headache1st <-
  adae_headache %>%
  group_by(TRTA) %>%
  arrange(TRTA, SUBJID, AESTDY) %>%
  slice_head(n = 1)

# notice how results change with sorting
adae_headache1st


# mutate & summarize ------------------------------------------------------

# Exercise Step 4
# Now that you know the
# group_by() function, how would you use it to get a table with counts
# for each Planned Treatment?
adae %>%
  select(SUBJID, TRTP) %>%
  group_by(TRTP) %>%
  distinct(SUBJID, TRTP) %>%
  summarize(n = n())

# Exercise Step 5
# Let's see now how many people stayed in the same treatment they were planned for.
adae %>%
  select(SUBJID, TRTP,TRTA) %>%
  group_by(TRTP,TRTA) %>%
  distinct(SUBJID, TRTP, TRTA) %>%
  summarize(n = n())

# Exercise Step 6
# Create a data frame named `adae_gb` from the `adae` data frame with the
# following requirements.
#  - Only keep the variables `TRTA`, `AEBODSYS`, `AETERM`, `SITEID`, `SUBJID`, `AESTDY`.
#  - Group by the variables `TRTA`, `AEBODSYS`, `AETERM`.
#  - Replace missing values for `TRTA` of `""` with `"NO ARM"`.
adae_gb <-
  adae %>%
  select(TRTA, AEBODSYS, AETERM, SITEID, SUBJID, AESTDY) %>%
  group_by(TRTA, AEBODSYS, AETERM) %>%
  mutate(TRTA = ifelse(TRTA == "", "NO ARM", TRTA)) %>%
  arrange(TRTA, AEBODSYS, AETERM)

adae_gb

# Exercise Step 7
check <- adae_gb %>% 
  filter(TRTA == "ARM D" & AETERM == "BODY ACHES")
ae_stats <-
  adae_gb %>%
   summarize(
    count_subj_w_ae   = n_distinct(SUBJID),
    min_time_to_event = min(AESTDY, na.rm = TRUE) ,
    ave_time_to_event = mean(AESTDY, na.rm = TRUE),
    max_time_to_event = max(AESTDY, na.rm = TRUE)
  ) %>%
  filter(count_subj_w_ae > 1) %>%
  arrange(-count_subj_w_ae)

ae_stats <-
  adae_gb %>%
  summarize(
    count_subj_w_ae   = n_distinct(SUBJID),
    min_time_to_event = ifelse(all(is.na(AESTDY)), NA, min(AESTDY, na.rm = TRUE)),
    ave_time_to_event = ifelse(all(is.na(AESTDY)), NA, mean(AESTDY, na.rm = TRUE)),
    max_time_to_event = ifelse(all(is.na(AESTDY)), NA, max(AESTDY, na.rm = TRUE))
  )%>%
  filter(count_subj_w_ae > 1) %>%
  arrange(-count_subj_w_ae)

ae_stats

# Group by Row ------------------------------------------------------------

library(tidyverse)

library(haven)
# Exercise Step 3
# Read in the SAS data set, **"bbc_adam_adlb.sas7bdat**, from the course level
# directory into a data frame named `bbc_adam`.
bbc_adam <- read_sas("_data/bbc_adam_adlb.sas7bdat")

colnames(bbc_adam)
names(bbc_adam)
varnames <- c("AGFLGU","ANL01FL") %>% 
  str_subset("FL$")
# Exercise Step 4
# There are variables in the data frame that are flags. They are denoted by `"FL"`.
# How many flag variables are there?
bbc_adam %>% colnames() %>% str_subset("FL$")

# Exercise Step 5
# Create a variable `flagchk` that counts the number of flags checked (`Y`)
# in each row. There are almost 12,000 records. You may want to sample the data
# frame (say, `n=100`) while you work out the code.
flagchk <-
  bbc_adam %>%
  slice_sample(n = 100) %>%
  rowwise() %>%
  mutate(flag = sum(c_across(ends_with("FL")) == "Y")) %>%
  select(flag)

# Exercise Step 6
# When your code works, summarize the number of flags checked for each row.
# Which function did you use? Why?
flagchk <- bbc_adam %>%
  rowwise() %>%
  mutate(flag = sum(c_across(contains("FL")) == "Y")) %>%
  select(flag)

summary(flagchk)
