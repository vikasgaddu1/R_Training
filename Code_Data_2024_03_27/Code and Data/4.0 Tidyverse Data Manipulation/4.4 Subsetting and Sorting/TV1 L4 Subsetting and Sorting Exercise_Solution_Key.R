# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key


# Filtering Intro ---------------------------------------------------------
# Load the Tidyverse package.
library(tidyverse)

# Exercise Step 4
# Read in the adae rds file from the course _data directory.
adae <- readRDS('_data/adae.rds')

# Exercise Step 5
# Select the first 10 records of `adae`. There are two ways to do this.
# What are they?
adae %>% slice(1:10)

# or
adae %>% slice_head(n = 10)

# Exercise Step 6
# Trim down the data frame to just the variables `SUBJID`, `AETERM`, and
# any variable containing the letters `DT`. Also take a 70% random sample of
# the data frame `adae`. Name the resulting data frame `adae_ss`.
adae_ss <-
  adae[c('SUBJID','AETERM','TRTSDT','TRTEDT','AESTDTC','ASTDT','ASTDTF',
         'AEENDTC','AENDT','AENDTF')] %>%
  slice_sample(prop = 0.7)

# Filtering with conditions -----------------------------------------------

# Exercise Step 3
# Run the code that sets your working directory to the course level directory
# and reads in the adae.rds file. Then create the adae_ss data frame.
# Do not sample the data frame.
library(tidyverse)

adae <- readRDS('_data/adae.rds')

adae_ss <-
  adae[c('SUBJID','AETERM','TRTSDT','TRTEDT','AESTDTC','ASTDT','ASTDTF',
         'AEENDTC','AENDT','AENDTF')]

# Exercise Step 4
# Filter the `adae_ss` data frame to show only records with a date of
# first exposure to treatment in November 2006 and "reported term
# for the adverse event" equal to be *RASH*. Name the result rash_ss_record
rash_ss_record <- adae_ss %>%
  filter((TRTSDT > "2006-10-31" & TRTSDT < "2006-11-30") & AETERM == "RASH")
rash_ss_record

# Exercise Step 5
# Assign the Subject ID for the patient to the variable rash_subj. Subset the result so
# that it is not a tibble. Why do we do that? Think about the next step.
rash_subj <- rash_ss_record$SUBJID[1]
rash_subj

# Exercise Step 6
# With the Subject ID, subset the `adae` data frame to determine what ARM the RASH subject is in.
rash_records <- adae %>%
  filter(SUBJID == rash_subj)
rash_records$TRTP[1]

# Selecting Variables -----------------------------------------------------

library(tidyverse)

# Exercise Step 3
# Run the code that sets your working directory to the course level directory
# and creates the data frame named adae.
adae <- readRDS('_data/adae.rds')

# Exercise Step 4
# Earlier you created a data frame named `adae_ss` with just the variables `SUBJID`, `AETERM`, and
# any variable containing the letters `DT`. Redo that step but now using the select() function
# and the contains() function. Do not sample the data this time.
adae_ss <-
  select(adae, "SUBJID", 'AETERM', contains("DT"))

# Exercise Step 5
# We also used results from filtering adae_ss to determine the Subject ID
# for the patient who had the *RASH* in November 2006. The process was a little clunky.
# Use the `select()` function to isolate the SUBJID variable.
rash_ss_record <-
  adae_ss %>%
  filter((TRTSDT > "2006-10-31" & TRTSDT < "2006-11-30") & AETERM == "RASH") %>%
  select(SUBJID)

# Exercise Step 6
# In a similar way, improve the code to find the ARM that that subject is in.
# Note that the logical statement in the filter cannot use a tibble.
# How can you convert `rash_subj` to a class that will work?

class(rash_ss_record)

# change to a vector so we can use in the filter function.
rash_subj <- as_vector(rash_ss_record)
class(rash_subj)

rash_records <- adae %>%
  filter(SUBJID == rash_subj) %>%
  select(TRTP) %>% slice_head(n = 1)

rash_records

# Other Operations --------------------------------------------------------

# Exercise Step 3
# Run the code that sets your working directory to the course level directory
# and creates the data frame named adae.
library(tidyverse)

adae <- readRDS('_data/adae.rds')

# Exercise Step 4
# Let's go back to the task of determining the Subject ID from the data frame
# adae_ss for the patient who had the RASH in November 2006. Earlier our result
# was a tibble and we had to use the as_vector() function. Now that we know
# the `pull()` function, how can you make that code simpler?
rash_subj <-
  adae_ss %>%
  filter((TRTSDT > "2006-10-31" & TRTSDT < "2006-11-30") & AETERM == "RASH") %>%
  pull(SUBJID)

# Exercise Step 5
# In a similar way, improve the code to find the ARM that that subject is in.
rash_records <-
  adae %>%
  filter(SUBJID == rash_subj) %>%
  pull(TRTP) %>% unique()

rash_records

# Exercise Step 6
# create variables days_duration = TRTEDT - TRTSDT and ae_duration = AEENDTC - AESTDTC
adae_ss$days_duration <- adae_ss$TRTEDT - adae_ss$TRTSDT

adae_ss$ae_duration <-
  as.Date(adae_ss$AEENDTC) - as.Date(adae_ss$AESTDTC)

# Exercise Step 7
# Pipe the following operations together
# 1) relocate the duration variables you just calculated to be right after
#   the variables used in the calculations.
# 2) filter the data to only include records with adverse events that last more
#   than 10 days
# 3) sort the data by SUBJID and descending ae_duration.
adae_ss <- adae_ss %>%
  relocate(days_duration, .after = TRTEDT) %>%
  relocate(ae_duration, .after = AEENDTC) %>%
  filter(ae_duration > 10) %>%
  arrange(SUBJID, desc(ae_duration))

# Exercise Step 8
# Create a new data frame from `adae` called `ae_list` containing distinct
# values for the variables `AEBODSYS`, `AEHLGT`, `AEHLT`, `AETERM`.
#
# a. Relocate and sort by the variables in the order they are listed above.
# b. Write the resulting data frame out to an `xlsx` file in the course directory.
ae_list <-
  adae %>%
  distinct(AEBODSYS, AEHLGT, AEHLT, AETERM) %>%
  relocate(AEBODSYS, AEHLGT, AEHLT, AETERM) %>%
  arrange(AEBODSYS, AEHLGT, AEHLT, AETERM)

library(writexl)
write_xlsx(ae_list,
           path = "adae_aelist.xlsx")
