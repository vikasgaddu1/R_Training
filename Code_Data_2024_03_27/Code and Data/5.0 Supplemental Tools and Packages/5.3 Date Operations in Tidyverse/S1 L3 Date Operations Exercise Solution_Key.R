# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

# Basic Operations
# --------------------------------------------------------
# Exercise Step 2
# Load Packages
library(tidyverse)
library(lubridate)

# Exercise Step 3
x <- c("2010-01-02 03-04-55",
       "2009 arbitrary 1 non-decimal 6 chars 12 in between 1 !!! 6",
       "2023 when there were 6 months and 14 days but it was only 2 oclock in the morning at 15 and 0 seconds")
x

# Exercise Step 4
ymd_hms(x)

# Exercise Step 5
OlsonNames()
ymd_hms(x, tz = "Pacific/Pitcairn")



# Parts of Dates and Times ---------------------------------------------

# Exercise Step 2
# Load Packages
library(tidyverse)
library(lubridate)



# Exercise Step 3
# 1918 Spanish Flu Data
spaflu18_demog <-
  tribble(
    ~patient, ~dob, ~screen_date, ~sex, ~viral_load,
    1, "75-06-09", "19-05-05", "M", 120,
    2, "87-07-05", "19-05-01", "F", 119,
    3, "99-09-25", "19-05-02", "M", 145,
    4, "01-11-14", "19-05-01", "F", 130)

# Exercise Step 4
# Create a Date Time variable, `bday`, that is the date of birth.
# Use the `year()` function to see whether it interpreted the
# years correctly. Did it?
bday <- as_datetime(spaflu18_demog$dob)
year(bday)

# Exercise Step 5
# Use the `stats::update()` function to change the first year
# from `1975` to `1875`.
stats::update(bday[1],year=1875)

# Exercise Step 6
# Create a vector with the correct years,
#    `[1875, 1887, 1899, 1901]`.
# Use this vector and `stats::update()` to correct the entire
# `bday` vector at once.
cyrs <- c(1875, 1887, 1899, 1901)
stats::update(bday,year=cyrs)

# Periods and Durations -----------------------------------------

# Exercise Step 3
# 2020 COVID-19 Data
covid19_demog <-
  tribble(
    ~patient, ~dob, ~screen_date, ~sex, ~viral_load,
    1, "1975-04-09", "2020-05-05", "F", 114,
    2, "1987-02-03", "2020-12-05", "M", 145,
    3, "1999-10-29", "2020-03-07", "F", 151,
    4, "2001-01-14", "2020-07-02", "F", 175)

# Exercise Step 4
# Create a vector, `dob19`, that stores the dates of birth as date-time
# variables.
dob19 <- as_datetime(covid19_demog$dob)

# Exercise Step 5
# To see the difference between Periods and Durations in lubridate, create a
# period of 1 month, `p1m`, and a duration of 1 month, `d1m`. Add each of these
# to `dob19` and investigate the differences in the output. Can you tell why
# the outputs are different? Remember that Period adds one month regardless of
# of days. Duration adds 30 days.
p1m <- period("1 month")
d1m <- duration("1 month")

dob19 + p1m
dob19 + d1m

# Date and Time Intervals -------------------------------------------------

# Exercise Step 3
# Create the data frame from the 1918 Flu outbreak.
# 1918 Spanish Flu Data
spaflu18_demog <-
  tribble(
    ~patient, ~dob, ~screen_date, ~sex, ~viral_load,
    1, "75-06-09", "19-05-05", "M", 120,
    2, "87-07-05", "19-05-01", "F", 119,
    3, "99-09-25", "19-05-02", "M", 145,
    4, "01-11-14", "19-05-01", "F", 130)

# Exercise Step 4
# Create a vector, `scr_date`, that is a date-time version of the Covid 19
# Screen Date.
scr_date <- as_datetime(spaflu18_demog$screen_date)

# Exercise Step 5
# The outbreak of the flu went from about February 1918 to about April 1920.
# Create a date interval, `sp_flu`, that represents this time span.
# How many of the screening dates fall within that time span?
sp_flu <- interval(start = my("February 1918"), end = my("April 1920"))
scr_date %within% sp_flu

# Exercise Step 6
# You have seen that none of the screening dates fall within that interval.
# Look at the `scr_date` vector to see why. Modify the vector to accurately
# represent the dates. Now check whether the dates fall within the interval
# we created.

scr_date <- scr_date - period(100,"years")
scr_date %within% sp_flu

# Exercise Step 7
# Let's go back and fix the Spanish Flu database. For both dob and
# screen_date, if the year is 19 or less, we can assume it is 19xx,
# otherwise 18xx.
spaflu18 <-
  spaflu18_demog %>%
  mutate(dob = as_datetime(dob),
         dob = case_when(dob > 1919 ~ dob - period(100,"years"),
                         TRUE ~ dob),
         screen_date = as_datetime(screen_date) - period(100,"years"),
  ) %>% print()

# Exercise Step 8
# The researchers want to combine the Spanish Flu data frame, `spaflu18`,
# with the recent COVID19 vaccine study data. First, prepare the COVID19 data as
# needed, calling it covid19.
covid19 <-
  covid19_demog %>%
  mutate(dob = as_date(dob),
         screen_date = as_date(screen_date))

# Exercise Step 9
# Now we will prepare the data to give to the researchers. We do this with the
# following steps.
#  a. Calculate patient age. (There is more than one way to do this.)
#  b. Create age categories of "`< 20`" and "`>= 20`".
#  c. Combine the data.

allvirus <-
  bind_rows(spaflu18, covid19) %>%
  mutate(age = floor(interval(dob,screen_date)/period("years")),
         agecat = case_when(age < 20 ~ "< 20",
                            age >=20 ~ ">= 20",
                            TRUE ~ as.character(NA))
  )


# Use and Docs ------------------------------------------------------------

# Exercise Step 3
library('haven')
tv <- read_sas('_data/abc_crf_tv.sas7bdat', col_select = c(SUBJECT, VISIT, SVDT))

tv_day1 <-
  tv %>%
  filter(VISIT == 'day1') %>%
  mutate(day1 = SVDT) %>%
  select(SUBJECT, day1)

tv_prep <-
  left_join(tv, tv_day1, by = c("SUBJECT" = "SUBJECT")) %>%
  filter(VISIT != 'eoset') %>%
  mutate(expected_visit_day = case_when(VISIT == 'screen' ~ -7,
                                        VISIT == 'day1'   ~  1,
                                        VISIT == 'wk2'   ~  2*7,
                                        VISIT == 'wk4'   ~  4*7,
                                        VISIT == 'wk6'   ~  6*7,
                                        VISIT == 'wk8'   ~  8*7,
                                        VISIT == 'wk12'   ~  12*7,
                                        VISIT == 'wk16'   ~  16*7,
                                        ),
         actual_visit_day = SVDT - day1,
         visit_diff = abs(actual_visit_day - expected_visit_day)
         )

morethan7 <-
  tv_prep %>%
  filter(visit_diff > 7)

# Exercise Step 4
# Caution: This exercise is not trivial. It is tedious and will require focus
#  for at least an hour.
# You will have to examine, clean, impute, and summarize data.
# Read in the abc_crf_cm.sas7bdat, abc_crf_tv.sas7bdat, and
#  abc_crf_ds.sas7bdat SAS Data Sets.
# Find out the number of days subjects have been taking a medication(DRUGTERM)
#  for each indication(CMINDC).
# Use the following rules for incomplete dates in the cm data set.
#
# a.Before starting, there are cases where a missing value in CMSTYY, CMSTMON,
#  CMSTDD, CMENYY, CMENMON, CMENDD is represented by ".", "DASH", 86.
#  You will need to change these to NA.
#
# b.If a CMSTDT is completely missing, use the screen date (SVDT) from
#  abc_crf_tv.sas7bdat.
#
# c.If a CMSTDT is partially missing, use whatever parts are in the day, month,
#  and year variables for the start date to make it the earliest date possible.
#
# d.For cases where CMSTDT is missing, take the maximum of the imputed date and
#  the screen date.
#
# e.If a CMENDT is partially missing , make it the latest possible date based on
#  the partial information.
#
# f.For cases where the CMENDT is missing, use the minimum of the imputed end
#  date and the eoset date.
#
# g.An imputed CMSTDT cannot be earlier than the screen date and an imputed
#  CMENDT cannot be later than the eoset.
tv_screen <-
  tv %>%
  filter(VISIT == 'screen') %>%
  mutate(screen = SVDT) %>%
  select(SUBJECT,screen)

ds <- read_sas('data/abc_crf_ds.sas7bdat', col_select = c(SUBJECT, DSDT))

cm <-
  read_sas(
    'data/abc_crf_cm.sas7bdat',
    col_select = c(SUBJECT, VISIT, DRUGTERM, CMINDC,
                   CMSTDD, CMSTMON, CMSTYY, CMSTDT,
                   CMENDD, CMENMON, CMENYY, CMENDT))

unique(cm$CMSTDD)
unique(cm$CMSTMON)
unique(cm$CMSTYY)
unique(cm$CMENDD)
unique(cm$CMENMON)
unique(cm$CMENYY)

cm %>%
  filter(!is.na(CMENYY) & is.na(CMENMON) & is.na(CMENDD))


cm_prep <-
  cm %>%
  mutate(CMSTDD  = na_if(CMSTDD, 86),
         CMENDD  = na_if(CMENDD, 86),
         CMSTMON = na_if(CMSTMON, "DASH"),
         CMSTMON = na_if(CMSTMON, '.'),
         CMENMON = na_if(CMENMON, "DASH"),
         CMENMON = na_if(CMENMON, '.')) %>%
  mutate(CMSTDTi = case_when(!is.na(CMSTYY) &  is.na(CMSTMON) & is.na(CMSTDD) ~
                               as_date(str_c(CMSTYY, "-01-01")),
                             !is.na(CMSTYY) & !is.na(CMSTMON) & is.na(CMSTDD) ~
                               as_date(str_c(CMSTYY,CMSTMON,"01")))) %>%
  mutate(CMENDTi = case_when(!is.na(CMENYY) &  is.na(CMENMON) & is.na(CMENDD) ~
                               as_date(str_c(CMENYY,"-12-31")),
                             !is.na(CMENYY) & !is.na(CMENMON) & is.na(CMENDD) ~
                               ceiling_date(as_date(str_c(CMENYY,CMENMON,"01")), unit = "month") - days(1)))

cm_tv_ds <-
  left_join(cm_prep, tv_screen, by = c("SUBJECT" = "SUBJECT")) %>%
  left_join(ds, by = c("SUBJECT" = "SUBJECT")) %>%
# Use rowwise to so we can use min and max functions on a row.
  rowwise() %>%
# if CMSTDT is missing, use maximum of imputed date and screen date.
  mutate(CMSTDTnew = case_when(is.na(CMSTDT) ~ max(screen, CMSTDTi, na.rm=TRUE),
                               !is.na(CMSTDT) ~ CMSTDT),
# if CMENDT is missing, use minimum of imputed date and screen date.
         CMENDTnew = case_when(is.na(CMENDT) ~ min(DSDT, CMENDTi, na.rm=TRUE),
                               !is.na(CMENDT) ~ CMENDT))

cm_summ <-
  cm_tv_ds %>%
  group_by(SUBJECT, CMINDC, DRUGTERM) %>%
  summarize(start_date = min(CMSTDTnew),
            end_date = max(CMENDTnew)) %>%
  mutate(duration_days = as.numeric(end_date - start_date + 1))

# Exercise Step 5
# result for exercise.
cm_summ %>%
  filter(SUBJECT == '01-049' | SUBJECT == '02-111')

