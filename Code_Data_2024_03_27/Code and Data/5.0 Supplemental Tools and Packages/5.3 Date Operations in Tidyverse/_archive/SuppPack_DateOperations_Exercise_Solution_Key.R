# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key


# Setup -------------------------------------------------------------------

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


# 2020 COVID-19 Data
covid19_demog <-
  tribble(
    ~patient, ~dob, ~screen_date, ~sex, ~viral_load,
    1, "1975-04-09", "2020-05-05", "F", 114,
    2, "1987-02-03", "2020-12-05", "M", 145,
    3, "1999-10-29", "2020-03-07", "F", 151,
    4, "2001-01-14", "2020-07-02", "F", 175)

# if two digit year from spanish flu data is 19 or less then assume
# the year is 19xx. Otherwise, 18xx.
spaflu18 <-
  spaflu18_demog %>%
  mutate(dob = case_when(as.numeric(substring(dob, 1, 2)) <= 19 ~ paste0("19", dob),
                         TRUE ~ paste0("18", dob)),
         screen_date = paste0("19", screen_date),
         dob = as_date(dob),
         screen_date = as_date(screen_date))

covid19 <-
  covid19_demog %>%
  mutate(dob = as_date(dob),
         screen_date = as_date(screen_date))

allvirus <-
  bind_rows(spaflu18, covid19) %>%
  mutate(age = floor(as.numeric((screen_date - dob))/365.25),
         agecat = case_when(age < 20 ~ "< 20",
                            age >=20 ~ ">= 20",
                            TRUE ~ as.character(NA))
  )

# Exercise Step 4
# Consider three different methods for calculating age and compare the results on the small data set below.
# a.(Screen Date - Date of Birth) / 365.25.
#
# b.The way you calculate age in your head.
#
# i.Take difference in years.
#
# ii.Figure out if the screen date is before or after the date of birth in the screen date year.
#   If not subtract one.
#
# c.The formula from the video.
agedata <-
  tribble(
~subjid, ~date_of_birth, ~screen_date,
1,       "1980-09-10", "2010-09-10",
2,       "1980-09-09", "2010-09-10",
3,       "1980-09-11", "2010-09-10"
  )


age_calcs_df <-
  agedata %>%
  mutate(date_of_birth = as_date(date_of_birth),
         screen_date = as_date(screen_date),
         method_a = floor(as.numeric((screen_date - date_of_birth))/365.25),
         method_b = ifelse((month(date_of_birth) > month(screen_date)) |
                          ((month(date_of_birth) == month(screen_date)) & (day(date_of_birth) > day(screen_date))),
                           year(screen_date) - year(date_of_birth) - 1,
                           year(screen_date) - year(date_of_birth)),
         age_int = interval(date_of_birth, screen_date),
         method_c = floor(age_int / period("years")))


# Exercise Step 6
library('haven')
tv <- read_sas('data/abc_crf_tv.sas7bdat', col_select = c(SUBJECT, VISIT, SVDT))

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

# Exercise Step 7
# Caution: This exercise is not trivial. It is tedious and will require focus for at least an hour.
# You will have to examine, clean, impute, and summarize data.
# Read in the abc_crf_cm.sas7bdat, abc_crf_tv.sas7bdat, and abc_crf_ds.sas7bdat SAS Data Sets.
# Find out the number of days subjects have been taking a medication(DRUGTERM) for each indication(CMINDC).
# Use the following rules for incomplete dates in the cm data set.
#
# a.Before starting, there are cases where a missing value in CMSTYY, CMSTMON, CMSTDD, CMENYY, CMENMON, CMENDD
#  is represented by ".", "DASH", 86. You will need to change these to NA.
#
# b.If a CMSTDT is completely missing, use the screen date (SVDT) from abc_crf_tv.sas7bdat.
#
# c.If a CMSTDT is partially missing, use whatever parts are in the day, month, and year variables
#  for the start date to make it the earliest date possible.
#
# d.For cases where CMSTDT is missing, take the maximum of the imputed date and the screen date.
#
# e.If a CMENDT is partially missing , make it the latest possible date based on the partial information.
#
# f.For cases where the CMENDT is missing, use the minimum of the imputed end date and the eoset date.
#
# g.An imputed CMSTDT cannot be earlier than the screen date and an imputed CMENDT cannot be later than
#  the eoset.
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

# Exercise Step 8
# result for exercise.
cm_summ %>%
  filter(SUBJECT == '01-049' | SUBJECT == '02-111')

