# Anova Accel2R - Clinical R Training -----------------------------------
# 2021 Anova Groups All rights reserved

# Title: Solution Key

# Exercise Step 3
# Load Packages
library(tidyverse)
library(lubridate)
library(janitor)
library(haven)
library(sqldf)

# Exercise Step 4
# read in abc_crf_dm.sas7bdat and calculate age as of Jan 1, 1995 to use later.
abc_dm <-
  read_sas("data/abc_crf_dm.sas7bdat") %>%
  mutate(age = floor((as.Date("1995-01-01") - BIRTHDT)/365.25))

# read in abc_crf_vs.sas7bdat and abc_crf_ae.sas7bdat.
abc_vs <- read_sas("data/abc_crf_vs.sas7bdat")
abc_ae <- read_sas("data/abc_crf_aesr.sas7bdat")



# Create a function named keys_check which leverages tidydots to check for duplicates by
# passing in the data frame name and keys as parameters.
keys_check <- function(data2check, ...) {

data2check %>%
  get_dupes(...) %>%
  print()

}


# Test to see if there are any duplicate records in abc_dm using SUBJECT as the key.
result <-
  abc_dm %>%
  keys_check(SUBJECT)


# Also test it with the following two tibbles and function calls.
test1 <- tribble(~subjid, ~name,           ~sex,  ~age, ~arm,
                 100,  "Crowe, Autumn",  "F",   60,   "A",
                 100,  "Crowe, Autumn",  "F",   60,   "A",
                 200,  "Raven, Spring",  "M",   65,   "B")

result <-
  test1 %>%
  keys_check(subjid)

test2 <- tribble(~subjid, ~name,           ~sex,  ~age, ~arm,
                    100,  "Crowe, Autumn",  "F",   60,   "A",
                    100,  "Crowe, Autumn",  "F",   60,   "A",
                    200,  "Raven, Spring",  "M",   65,   "B")

result <-
  test2 %>%
  keys_check(subjid, name)


# Using the tabyl() function on the abc_ae data frame, create a listing of frequencies
# of the AETERM variable.
aeterms <-
  abc_ae %>%
  tabyl(AETERM)
aeterms


# List out the joined demographic(include variables SUBJECT, RACE, SEX) and
# vital signs(include variables SUBJECT, VISIT, PULSE) records for anyone that experienced an
# AETERM of "VERTIGO". Perform this check using the sqldf() function and then again using a tidyverse
# approach. When joining the demographic and vitals signs data use a left join.

# sqldf approach
vertigo_sql <-
  sqldf("select dm.SUBJECT, dm.RACE, dm.SEX, vs.VISIT, vs.PULSE
         from abc_dm dm left join
              abc_vs vs
         on dm.SUBJECT=vs.SUBJECT
         where dm.SUBJECT in (select distinct SUBJECT
                           from abc_ae
                           where AETERM = 'VERTIGO')")

# tidyverse approach
vertigo_ae <-
  abc_ae %>%
  select(SUBJECT, AETERM) %>%
  filter(AETERM == "VERTIGO") %>%
  distinct(SUBJECT, AETERM)

vertigo_tv <-
  abc_dm %>%
  select(SUBJECT, RACE, SEX) %>%
  left_join(abc_vs, by = "SUBJECT") %>%
  inner_join(vertigo_ae, by = "SUBJECT") %>%
  select(SUBJECT, RACE, SEX, VISIT, PULSE)

vertigo_sql == vertigo_tv


# List out the AE records for anyone that was over the age of 60 on January 1st, 1995.
over60 <-
  abc_dm %>%
  select(SUBJECT, age) %>%
  filter(age > 60) %>%
  left_join(abc_ae, by = "SUBJECT")
over60

